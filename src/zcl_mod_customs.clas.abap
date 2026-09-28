CLASS zcl_mod_customs DEFINITION PUBLIC FINAL CREATE PUBLIC. PUBLIC SECTION. INTERFACES zif_calc_modifier. ENDCLASS.
CLASS zcl_mod_customs IMPLEMENTATION.
  METHOD zif_calc_modifier~apply.
    SELECT tax_rate, requires_clearance
      FROM zlog_geo_matrix
      WHERE country_from IN ( @cs_context-country_from, '*' )
        AND country_to IN ( @cs_context-country_to, '*' )
      ORDER BY country_from DESCENDING, country_to DESCENDING
      INTO @DATA(ls_geo) UP TO 1 ROWS.
    ENDSELECT.
    IF sy-subrc = 0 AND ls_geo-requires_clearance = abap_true.
      cs_context-customs_amount = cs_context-amount * CONV decfloat34( ls_geo-tax_rate ).
      cs_context-amount = cs_context-amount + cs_context-customs_amount.
    ENDIF.
    io_log->add( iv_step = me->zif_calc_modifier~name( ) iv_amount = cs_context-amount iv_text = 'Customs duty from geo matrix' ).
  ENDMETHOD.
  METHOD zif_calc_modifier~name. rv_name = 'ZCL_MOD_CUSTOMS'. ENDMETHOD.
ENDCLASS.
