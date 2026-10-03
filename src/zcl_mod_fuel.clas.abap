CLASS zcl_mod_fuel DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_calc_modifier.
ENDCLASS.
CLASS zcl_mod_fuel IMPLEMENTATION.
  METHOD zif_calc_modifier~apply.
    SELECT fuel_index, base_index, coefficient
      FROM zlog_fuel_rate
      WHERE valid_from <= @cs_context-pricing_date
      ORDER BY valid_from DESCENDING
      INTO @DATA(ls_rate) UP TO 1 ROWS.
    ENDSELECT.
    IF sy-subrc <> 0 OR ls_rate-base_index = 0.
      RETURN.
    ENDIF.
    DATA(lv_percent) = CONV decfloat34( ls_rate-fuel_index - ls_rate-base_index ) / CONV decfloat34( ls_rate-base_index ) * CONV decfloat34( ls_rate-coefficient ).
    IF iv_scenario = 'PRECISION' OR iv_scenario = 'MULTI'.
      lv_percent = round( val = lv_percent dec = 2 ).
    ENDIF.
    cs_context-fuel_amount = cs_context-amount * lv_percent.
    cs_context-amount = cs_context-amount + cs_context-fuel_amount.
    io_log->add( iv_step = me->zif_calc_modifier~name( ) iv_amount = cs_context-amount iv_text = 'Fuel surcharge applied' ).
  ENDMETHOD.
  METHOD zif_calc_modifier~name.
    rv_name = 'ZCL_MOD_FUEL'.
  ENDMETHOD.
ENDCLASS.
