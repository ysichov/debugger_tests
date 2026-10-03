CLASS zcl_calc_log DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS add
      IMPORTING iv_step TYPE char30
                iv_amount TYPE decfloat34
                iv_text TYPE string.
    METHODS display.
  PRIVATE SECTION.
    DATA mt_log TYPE zif_calc_types=>tt_log.
ENDCLASS.
CLASS zcl_calc_log IMPLEMENTATION.
  METHOD add.
    APPEND VALUE #( step = iv_step amount = iv_amount text = iv_text ) TO mt_log.
  ENDMETHOD.
  METHOD display.
    LOOP AT mt_log INTO DATA(ls_log).
      WRITE: / ls_log-step, 35 ls_log-amount, 60 ls_log-text.
    ENDLOOP.
  ENDMETHOD.
ENDCLASS.
