CLASS zcl_mod_customs DEFINITION PUBLIC FINAL CREATE PUBLIC. PUBLIC SECTION. INTERFACES zif_calc_modifier. ENDCLASS.
CLASS zcl_mod_customs IMPLEMENTATION.
  METHOD zif_calc_modifier~apply.
    cs_context-customs_amount = cs_context-amount * CONV decfloat34( '0.12' ). cs_context-amount = cs_context-amount + cs_context-customs_amount.
    io_log->add( iv_step = me->zif_calc_modifier~name( ) iv_amount = cs_context-amount iv_text = 'CN -> DE customs duty' ).
  ENDMETHOD.
  METHOD zif_calc_modifier~name. rv_name = 'ZCL_MOD_CUSTOMS'. ENDMETHOD.
ENDCLASS.
