INTERFACE zif_calc_modifier PUBLIC.
  METHODS apply IMPORTING iv_scenario TYPE char12 io_log TYPE REF TO zcl_calc_log CHANGING cs_context TYPE zif_calc_types=>ty_context.
  METHODS name RETURNING VALUE(rv_name) TYPE char30.
ENDINTERFACE.
