*&---------------------------------------------------------------------*
*& Include Z_INCL_TEST_C01 - the local class's IMPLEMENTATION
*&---------------------------------------------------------------------*
CLASS lcl_app IMPLEMENTATION.
  METHOD main.
    DO 5 TIMES.
      IF is_even( sy-index ) = abap_true.
        add( sy-index ).
      ENDIF.
    ENDDO.
    PERFORM show_total.
  ENDMETHOD.

  METHOD is_even.
    rv_even = xsdbool( iv_value MOD 2 = 0 ).
  ENDMETHOD.

  METHOD add.
    gv_total = gv_total + iv_value.
  ENDMETHOD.
ENDCLASS.
