*&---------------------------------------------------------------------*
*& VERTEX Debug Lab -- synthetic pricing and settlement benchmark
*& Import with abapGit, execute ZVERTEX_DEBUG_LAB and select a scenario.
*&---------------------------------------------------------------------*
REPORT zvertex_debug_lab.

TYPES: BEGIN OF ty_context,
         shipment_id      TYPE char10,
         transport_type   TYPE char4,
         country_from     TYPE land1,
         country_to       TYPE land1,
         weight_kg        TYPE decfloat34,
         volume_m3        TYPE decfloat34,
         distance_km      TYPE decfloat34,
         hazardous        TYPE abap_bool,
         delay_days       TYPE i,
         amount           TYPE decfloat34,
         currency         TYPE waers,
         fuel_amount      TYPE decfloat34,
         customs_amount   TYPE decfloat34,
         discount_amount  TYPE decfloat34,
         tax_amount       TYPE decfloat34,
       END OF ty_context,
       BEGIN OF ty_step,
         step_no TYPE i,
         name    TYPE char30,
       END OF ty_step,
       tt_steps TYPE STANDARD TABLE OF ty_step WITH EMPTY KEY,
       BEGIN OF ty_log,
         step    TYPE char30,
         amount  TYPE decfloat34,
         text    TYPE string,
       END OF ty_log,
       tt_log TYPE STANDARD TABLE OF ty_log WITH EMPTY KEY.

PARAMETERS p_clean RADIOBUTTON GROUP sc DEFAULT 'X'.
PARAMETERS p_prec  RADIOBUTTON GROUP sc.
PARAMETERS p_state RADIOBUTTON GROUP sc.
PARAMETERS p_pipe  RADIOBUTTON GROUP sc.
PARAMETERS p_multi RADIOBUTTON GROUP sc.

CLASS lcl_log DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS add IMPORTING iv_step TYPE char30 iv_amount TYPE decfloat34 iv_text TYPE string.
    METHODS display.
  PRIVATE SECTION.
    DATA mt_log TYPE tt_log.
ENDCLASS.

CLASS lcl_scenario DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_id TYPE char12.
    METHODS precision_bug RETURNING VALUE(rv_bug) TYPE abap_bool.
    METHODS state_bug     RETURNING VALUE(rv_bug) TYPE abap_bool.
    METHODS pipeline_bug  RETURNING VALUE(rv_bug) TYPE abap_bool.
    METHODS id            RETURNING VALUE(rv_id) TYPE char12.
  PRIVATE SECTION.
    DATA mv_id TYPE char12.
ENDCLASS.

CLASS lcl_data_provider DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS get_shipment IMPORTING io_scenario TYPE REF TO lcl_scenario
                         RETURNING VALUE(rs_context) TYPE ty_context.
ENDCLASS.

INTERFACE lif_pricing_strategy.
  METHODS calculate_base CHANGING cs_context TYPE ty_context.
ENDINTERFACE.

CLASS lcl_price_road DEFINITION FINAL.
  PUBLIC SECTION.
    INTERFACES lif_pricing_strategy.
ENDCLASS.

CLASS lcl_pricing_factory DEFINITION FINAL.
  PUBLIC SECTION.
    CLASS-METHODS create IMPORTING iv_transport TYPE char4
                         RETURNING VALUE(ro_strategy) TYPE REF TO lif_pricing_strategy.
ENDCLASS.

INTERFACE lif_modifier.
  METHODS apply CHANGING cs_context TYPE ty_context
                IMPORTING io_scenario TYPE REF TO lcl_scenario io_log TYPE REF TO lcl_log.
  METHODS name RETURNING VALUE(rv_name) TYPE char30.
ENDINTERFACE.

CLASS lcl_mod_fuel DEFINITION FINAL.
  PUBLIC SECTION. INTERFACES lif_modifier. ENDCLASS.
CLASS lcl_mod_customs DEFINITION FINAL.
  PUBLIC SECTION. INTERFACES lif_modifier. ENDCLASS.
CLASS lcl_mod_hazard DEFINITION FINAL.
  PUBLIC SECTION. INTERFACES lif_modifier. ENDCLASS.
CLASS lcl_mod_discount DEFINITION FINAL.
  PUBLIC SECTION. INTERFACES lif_modifier. ENDCLASS.
CLASS lcl_mod_tax DEFINITION FINAL.
  PUBLIC SECTION. INTERFACES lif_modifier. ENDCLASS.

CLASS lcl_config_generator DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS pipeline IMPORTING io_scenario TYPE REF TO lcl_scenario RETURNING VALUE(rt_steps) TYPE tt_steps.
ENDCLASS.

CLASS lcl_pricing_facade DEFINITION FINAL.
  PUBLIC SECTION.
    METHODS run IMPORTING io_scenario TYPE REF TO lcl_scenario.
  PRIVATE SECTION.
    METHODS modifier_for IMPORTING iv_name TYPE char30 RETURNING VALUE(ro_modifier) TYPE REF TO lif_modifier.
ENDCLASS.

CLASS lcl_log IMPLEMENTATION.
  METHOD add.
    APPEND VALUE #( step = iv_step amount = iv_amount text = iv_text ) TO mt_log.
  ENDMETHOD.
  METHOD display.
    LOOP AT mt_log INTO DATA(ls_log).
      WRITE: / ls_log-step, 35 ls_log-amount, 60 ls_log-text.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_scenario IMPLEMENTATION.
  METHOD constructor. mv_id = iv_id. ENDMETHOD.
  METHOD precision_bug. rv_bug = xsdbool( mv_id = 'PRECISION' OR mv_id = 'MULTI' ). ENDMETHOD.
  METHOD state_bug.     rv_bug = xsdbool( mv_id = 'STATE' OR mv_id = 'MULTI' ). ENDMETHOD.
  METHOD pipeline_bug.  rv_bug = xsdbool( mv_id = 'PIPELINE' OR mv_id = 'MULTI' ). ENDMETHOD.
  METHOD id. rv_id = mv_id. ENDMETHOD.
ENDCLASS.

CLASS lcl_data_provider IMPLEMENTATION.
  METHOD get_shipment.
    " Deliberately models a legacy FM with a process-global cache.
    STATICS sv_last_hazard TYPE abap_bool.
    rs_context = VALUE #( shipment_id = '4712' transport_type = 'ROAD'
                          country_from = 'CN' country_to = 'DE'
                          weight_kg = '1200' volume_m3 = '8.5' distance_km = '1287'
                          delay_days = 4 currency = 'EUR' ).
    IF io_scenario->state_bug( ) = abap_true.
      " BUG02: shipment 4712 is non-hazardous, but stale state leaks from 4711.
      sv_last_hazard = abap_true.
      rs_context-hazardous = sv_last_hazard.
    ENDIF.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_price_road IMPLEMENTATION.
  METHOD lif_pricing_strategy~calculate_base.
    DATA(lv_chargeable_weight) = cs_context-weight_kg + 2 * 25.
    cs_context-amount = lv_chargeable_weight * '5.42' * cs_context-distance_km / 1000.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_pricing_factory IMPLEMENTATION.
  METHOD create.
    CASE iv_transport.
      WHEN 'ROAD'. ro_strategy = NEW lcl_price_road( ).
      WHEN OTHERS. ro_strategy = NEW lcl_price_road( ). " Demo default; add AIR/SEA strategies later
    ENDCASE.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_mod_fuel IMPLEMENTATION.
  METHOD lif_modifier~apply.
    DATA(lv_percent) = CONV decfloat34( '0.08736' ).
    IF io_scenario->precision_bug( ) = abap_true.
      " BUG01: rounding a rate before multiplying causes an amplified downstream error.
      lv_percent = CONV decfloat34( '0.09' ).
    ENDIF.
    cs_context-fuel_amount = cs_context-amount * lv_percent.
    cs_context-amount = cs_context-amount + cs_context-fuel_amount.
    io_log->add( iv_step = me->lif_modifier~name( ) iv_amount = cs_context-amount iv_text = 'Fuel surcharge applied' ).
  ENDMETHOD.
  METHOD lif_modifier~name. rv_name = 'ZCL_MOD_FUEL'. ENDMETHOD.
ENDCLASS.

CLASS lcl_mod_customs IMPLEMENTATION.
  METHOD lif_modifier~apply.
    cs_context-customs_amount = cs_context-amount * CONV decfloat34( '0.12' ).
    cs_context-amount = cs_context-amount + cs_context-customs_amount.
    io_log->add( iv_step = me->lif_modifier~name( ) iv_amount = cs_context-amount iv_text = 'CN -> DE customs duty' ).
  ENDMETHOD.
  METHOD lif_modifier~name. rv_name = 'ZCL_MOD_CUSTOMS'. ENDMETHOD.
ENDCLASS.

CLASS lcl_mod_hazard IMPLEMENTATION.
  METHOD lif_modifier~apply.
    IF cs_context-hazardous = abap_true.
      cs_context-amount = cs_context-amount * CONV decfloat34( '1.08' ).
    ENDIF.
    io_log->add( iv_step = me->lif_modifier~name( ) iv_amount = cs_context-amount iv_text = 'Hazard cargo decision' ).
  ENDMETHOD.
  METHOD lif_modifier~name. rv_name = 'ZCL_MOD_HAZARD'. ENDMETHOD.
ENDCLASS.

CLASS lcl_mod_discount IMPLEMENTATION.
  METHOD lif_modifier~apply.
    cs_context-discount_amount = cs_context-amount * CONV decfloat34( '0.07' ).
    cs_context-amount = cs_context-amount - cs_context-discount_amount.
    io_log->add( iv_step = me->lif_modifier~name( ) iv_amount = cs_context-amount iv_text = 'GOLD volume discount' ).
  ENDMETHOD.
  METHOD lif_modifier~name. rv_name = 'ZCL_MOD_DISCOUNT'. ENDMETHOD.
ENDCLASS.

CLASS lcl_mod_tax IMPLEMENTATION.
  METHOD lif_modifier~apply.
    cs_context-tax_amount = cs_context-amount * CONV decfloat34( '0.19' ).
    cs_context-amount = cs_context-amount + cs_context-tax_amount.
    io_log->add( iv_step = me->lif_modifier~name( ) iv_amount = cs_context-amount iv_text = 'VAT applied' ).
  ENDMETHOD.
  METHOD lif_modifier~name. rv_name = 'ZCL_MOD_TAX'. ENDMETHOD.
ENDCLASS.

CLASS lcl_config_generator IMPLEMENTATION.
  METHOD pipeline.
    DATA(lv_config_scenario) = COND char12(
      WHEN io_scenario->pipeline_bug( ) = abap_true THEN io_scenario->id( ) ELSE 'CLEAN' ).
    " The pipeline is now a real Customizing dependency, not an in-memory mock.
    SELECT step_no, modifier_class AS name
      FROM zlog_pipeline
      WHERE scenario_id = @lv_config_scenario
      ORDER BY step_no
      INTO CORRESPONDING FIELDS OF TABLE @rt_steps.
  ENDMETHOD.
ENDCLASS.

CLASS lcl_pricing_facade IMPLEMENTATION.
  METHOD modifier_for.
    CASE iv_name.
      WHEN 'ZCL_MOD_FUEL'.     ro_modifier = NEW lcl_mod_fuel( ).
      WHEN 'ZCL_MOD_CUSTOMS'.  ro_modifier = NEW lcl_mod_customs( ).
      WHEN 'ZCL_MOD_HAZARD'.   ro_modifier = NEW lcl_mod_hazard( ).
      WHEN 'ZCL_MOD_DISCOUNT'. ro_modifier = NEW lcl_mod_discount( ).
      WHEN 'ZCL_MOD_TAX'.      ro_modifier = NEW lcl_mod_tax( ).
    ENDCASE.
  ENDMETHOD.
  METHOD run.
    DATA(lo_log) = NEW lcl_log( ).
    DATA(lo_provider) = NEW lcl_data_provider( ).
    DATA(ls_context) = lo_provider->get_shipment( io_scenario ).
    DATA(lo_strategy) = lcl_pricing_factory=>create( ls_context-transport_type ).
    lo_strategy->calculate_base( CHANGING cs_context = ls_context ).
    lo_log->add( iv_step = 'BASE_PRICE' iv_amount = ls_context-amount iv_text = 'ROAD strategy result' ).
    DATA(lt_steps) = NEW lcl_config_generator( )->pipeline( io_scenario ).
    LOOP AT lt_steps INTO DATA(ls_step).
      DATA(lo_modifier) = modifier_for( ls_step-name ).
      lo_modifier->apply( EXPORTING io_scenario = io_scenario io_log = lo_log CHANGING cs_context = ls_context ).
    ENDLOOP.
    WRITE: / 'Shipment', ls_context-shipment_id, 'final amount:', ls_context-amount, ls_context-currency.
    ULINE. lo_log->display( ).
  ENDMETHOD.
ENDCLASS.

START-OF-SELECTION.
  DATA(lv_scenario) = COND char12( WHEN p_prec = abap_true THEN 'PRECISION'
                                    WHEN p_state = abap_true THEN 'STATE'
                                    WHEN p_pipe = abap_true THEN 'PIPELINE'
                                    WHEN p_multi = abap_true THEN 'MULTI'
                                    ELSE 'CLEAN' ).
  NEW lcl_pricing_facade( )->run( NEW lcl_scenario( lv_scenario ) ).
