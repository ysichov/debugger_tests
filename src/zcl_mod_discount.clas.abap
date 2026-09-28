CLASS zcl_mod_discount DEFINITION PUBLIC FINAL CREATE PUBLIC. PUBLIC SECTION. INTERFACES zif_calc_modifier. ENDCLASS.
CLASS zcl_mod_discount IMPLEMENTATION.
  METHOD zif_calc_modifier~apply.
    SELECT action_value FROM zlog_rule
      WHERE scenario_id = @iv_scenario AND field_name = 'VOLUME' AND action = 'DISCOUNT'
      ORDER BY priority INTO @DATA(lv_percent) UP TO 1 ROWS.
    ENDSELECT.
    IF sy-subrc = 0.
      cs_context-discount_amount = cs_context-amount * CONV decfloat34( lv_percent ).
      cs_context-amount = cs_context-amount - cs_context-discount_amount.
    ENDIF.
    io_log->add( iv_step = me->zif_calc_modifier~name( ) iv_amount = cs_context-amount iv_text = 'GOLD volume discount' ).
  ENDMETHOD.
  METHOD zif_calc_modifier~name. rv_name = 'ZCL_MOD_DISCOUNT'. ENDMETHOD.
ENDCLASS.
