CLASS zcl_mod_discount DEFINITION PUBLIC FINAL CREATE PUBLIC. PUBLIC SECTION. INTERFACES zif_calc_modifier. ENDCLASS.
CLASS zcl_mod_discount IMPLEMENTATION.
  METHOD zif_calc_modifier~apply.
    cs_context-discount_amount = cs_context-amount * CONV decfloat34( '0.07' ). cs_context-amount = cs_context-amount - cs_context-discount_amount.
    io_log->add( iv_step = zif_calc_modifier~name( ) iv_amount = cs_context-amount iv_text = 'GOLD volume discount' ).
  ENDMETHOD.
  METHOD zif_calc_modifier~name. rv_name = 'ZCL_MOD_DISCOUNT'. ENDMETHOD.
ENDCLASS.
