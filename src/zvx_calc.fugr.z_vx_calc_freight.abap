FUNCTION z_vx_calc_freight.
*"----------------------------------------------------------------------
*"*"Local Interface:
*"  IMPORTING
*"     REFERENCE(IV_TRANSPORT) TYPE  CHAR4
*"     REFERENCE(IS_CONTEXT) TYPE  ZIF_CALC_TYPES=>TY_CONTEXT
*"     REFERENCE(IT_STEPS) TYPE  ZIF_CALC_TYPES=>TT_STEPS
*"     REFERENCE(IV_RATE) TYPE  I DEFAULT 2
*"  EXPORTING
*"     REFERENCE(EV_AMOUNT) TYPE  DECFLOAT34
*"     REFERENCE(ET_LOG) TYPE  ZIF_CALC_TYPES=>TT_LOG
*"  CHANGING
*"     REFERENCE(CV_NOTE) TYPE  STRING
*"----------------------------------------------------------------------
* VERTEX debugger test: every kind of parameter the transpiler screen offers - a simple value,
* a structure, a table, an optional value with a DEFAULT, CHANGING, and a table as a result.
  DATA ls_log TYPE zif_calc_types=>ty_log.

  ev_amount = is_context-weight_kg * is_context-distance_km * iv_rate / 1000.
  IF iv_transport = 'AIR'.
    ev_amount = ev_amount * 3.
  ENDIF.

  LOOP AT it_steps INTO DATA(ls_step).
    ls_log-step = ls_step-name.
    ls_log-amount = ev_amount.
    ls_log-text = |step { ls_step-step_no }|.
    APPEND ls_log TO et_log.
    ev_amount = ev_amount + 1.
  ENDLOOP.

  cv_note = |{ cv_note } { iv_transport }: { ev_amount }|.
ENDFUNCTION.
