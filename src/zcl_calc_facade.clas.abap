CLASS zcl_calc_facade DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION. METHODS run IMPORTING iv_scenario TYPE char12.
  PRIVATE SECTION. METHODS modifier_for IMPORTING iv_name TYPE char30 RETURNING VALUE(ro_modifier) TYPE REF TO zif_calc_modifier.
ENDCLASS.
CLASS zcl_calc_facade IMPLEMENTATION.
  METHOD modifier_for.
    CASE iv_name.
      WHEN 'ZCL_MOD_FUEL'. ro_modifier = NEW zcl_mod_fuel( ).
      WHEN 'ZCL_MOD_CUSTOMS'. ro_modifier = NEW zcl_mod_customs( ).
      WHEN 'ZCL_MOD_HAZARD'. ro_modifier = NEW zcl_mod_hazard( ).
      WHEN 'ZCL_MOD_DISCOUNT'. ro_modifier = NEW zcl_mod_discount( ).
      WHEN 'ZCL_MOD_TAX'. ro_modifier = NEW zcl_mod_tax( ).
    ENDCASE.
  ENDMETHOD.
  METHOD run.
    DATA(lo_log) = NEW zcl_calc_log( ).
    DATA(ls_context) = NEW zcl_calc_data_provider( )->get_shipment( iv_scenario ).
    DATA(lo_strategy) = zcl_pricing_factory=>create( ls_context-transport_type ).
    lo_strategy->calculate_base( CHANGING cs_context = ls_context ).
    lo_log->add( iv_step = 'BASE_PRICE' iv_amount = ls_context-amount iv_text = 'ROAD strategy result' ).
    DATA(lt_steps) = NEW zcl_calc_config_repo( )->get_pipeline( iv_scenario ).
    LOOP AT lt_steps INTO DATA(ls_step).
      DATA(lo_modifier) = modifier_for( ls_step-name ).
      IF lo_modifier IS BOUND. lo_modifier->apply( EXPORTING iv_scenario = iv_scenario io_log = lo_log CHANGING cs_context = ls_context ). ENDIF.
    ENDLOOP.
    WRITE: / 'Shipment', ls_context-shipment_id, 'final amount:', ls_context-amount, ls_context-currency.
    ULINE. lo_log->display( ).
  ENDMETHOD.
ENDCLASS.
