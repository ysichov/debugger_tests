*&---------------------------------------------------------------------*
*& Report Z_CALLS_TEST
*&---------------------------------------------------------------------*
*& The Calls diagram of START-OF-SELECTION must show exactly:
*&   FORM LOCAL_FORM, FORM SHORT_FORM in Z_CALLS_TEST_FORMS,
*&   FORM LONG_FORM in Z_CALLS_TEST_FORMS, FUNCTION CONVERT_DATE_TO_INTERNAL,
*&   LCL_HELPER->RUN.
*& Offset/length access and inline FIELD-SYMBOL( ) / DATA( ) are no calls.
*&---------------------------------------------------------------------*
REPORT z_calls_test.

CLASS lcl_helper DEFINITION.
  PUBLIC SECTION.
    METHODS run IMPORTING iv_text TYPE csequence.
ENDCLASS.

DATA: gv_text  TYPE c LENGTH 20 VALUE 'ABCDEFGHIJKLMNOPQRST',
      gv_name  TYPE c LENGTH 20 VALUE 'NAME',
      gv_short TYPE c LENGTH 4,
      gv_date  TYPE d,
      gt_lines TYPE STANDARD TABLE OF string WITH EMPTY KEY.

START-OF-SELECTION.
  " Offset/length access - no calls.
  gv_short = gv_text(4).
  gv_short = gv_text+2(3).
  WRITE / gv_name(10).
  gt_lines = VALUE #( ( `one` ) ( `two` ) ).
  gv_short = gv_name+1(2).

  " Inline declarations - no calls.
  LOOP AT gt_lines ASSIGNING FIELD-SYMBOL(<lv_line>).
    WRITE / <lv_line>.
  ENDLOOP.
  DATA(lv_count) = lines( gt_lines ).
  WRITE / lv_count.

  " Calls.
  PERFORM local_form.
  PERFORM short_form(z_calls_test_forms) USING gv_text.
  PERFORM long_form IN PROGRAM z_calls_test_forms USING gv_text.
  CALL FUNCTION 'CONVERT_DATE_TO_INTERNAL'
    EXPORTING
      date_external = '01.01.2026'
    IMPORTING
      date_internal = gv_date
    EXCEPTIONS
      OTHERS        = 1.
  NEW lcl_helper( )->run( gv_text(5) ).

CLASS lcl_helper IMPLEMENTATION.
  METHOD run.
    WRITE / iv_text.
  ENDMETHOD.
ENDCLASS.

FORM local_form.
  WRITE / 'local'.
ENDFORM.
