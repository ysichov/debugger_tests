CLASS zcl_mod_hazard DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_calc_modifier.
ENDCLASS.
CLASS zcl_mod_hazard IMPLEMENTATION.
  METHOD zif_calc_modifier~apply.
    SELECT action_value FROM zlog_rule
      WHERE scenario_id = @iv_scenario AND field_name = 'HAZARDOUS' AND action = 'MULTIPLY'
      ORDER BY priority INTO @DATA(lv_factor) UP TO 1 ROWS.
    ENDSELECT.
    IF sy-subrc = 0 AND cs_context-hazardous = abap_true.
      cs_context-amount = cs_context-amount * CONV decfloat34( lv_factor ).
    ENDIF.
    io_log->add( iv_step = me->zif_calc_modifier~name( ) iv_amount = cs_context-amount iv_text = 'Hazard cargo decision' ).
  ENDMETHOD.
  METHOD zif_calc_modifier~name.
    rv_name = 'ZCL_MOD_HAZARD'.
  ENDMETHOD.
ENDCLASS.
