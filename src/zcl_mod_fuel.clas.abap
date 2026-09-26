CLASS zcl_mod_fuel DEFINITION PUBLIC FINAL CREATE PUBLIC. PUBLIC SECTION. INTERFACES zif_calc_modifier. ENDCLASS.
CLASS zcl_mod_fuel IMPLEMENTATION.
  METHOD zif_calc_modifier~apply.
    DATA(lv_percent) = CONV decfloat34( '0.08736' ).
    IF iv_scenario = 'PRECISION' OR iv_scenario = 'MULTI'. lv_percent = CONV decfloat34( '0.09' ). ENDIF.
    cs_context-fuel_amount = cs_context-amount * lv_percent. cs_context-amount = cs_context-amount + cs_context-fuel_amount.
    io_log->add( iv_step = me->zif_calc_modifier~name( ) iv_amount = cs_context-amount iv_text = 'Fuel surcharge applied' ).
  ENDMETHOD.
  METHOD zif_calc_modifier~name. rv_name = 'ZCL_MOD_FUEL'. ENDMETHOD.
ENDCLASS.
