CLASS zcl_mod_tax DEFINITION PUBLIC FINAL CREATE PUBLIC. PUBLIC SECTION. INTERFACES zif_calc_modifier. ENDCLASS.
CLASS zcl_mod_tax IMPLEMENTATION.
  METHOD zif_calc_modifier~apply.
    cs_context-tax_amount = cs_context-amount * CONV decfloat34( '0.19' ). cs_context-amount = cs_context-amount + cs_context-tax_amount.
    io_log->add( iv_step = me->zif_calc_modifier~name( ) iv_amount = cs_context-amount iv_text = 'VAT applied' ).
  ENDMETHOD.
  METHOD zif_calc_modifier~name. rv_name = 'ZCL_MOD_TAX'. ENDMETHOD.
ENDCLASS.
