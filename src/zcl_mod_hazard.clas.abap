CLASS zcl_mod_hazard DEFINITION PUBLIC FINAL CREATE PUBLIC. PUBLIC SECTION. INTERFACES zif_calc_modifier. ENDCLASS.
CLASS zcl_mod_hazard IMPLEMENTATION.
  METHOD zif_calc_modifier~apply.
    IF cs_context-hazardous = abap_true. cs_context-amount = cs_context-amount * CONV decfloat34( '1.08' ). ENDIF.
    io_log->add( iv_step = zif_calc_modifier~name( ) iv_amount = cs_context-amount iv_text = 'Hazard cargo decision' ).
  ENDMETHOD.
  METHOD zif_calc_modifier~name. rv_name = 'ZCL_MOD_HAZARD'. ENDMETHOD.
ENDCLASS.
