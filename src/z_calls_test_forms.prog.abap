*&---------------------------------------------------------------------*
*& Subroutine pool Z_CALLS_TEST_FORMS
*&---------------------------------------------------------------------*
*& Forms Z_CALLS_TEST calls from outside: PERFORM short_form(...) and
*& PERFORM long_form IN PROGRAM ...
*&---------------------------------------------------------------------*
PROGRAM z_calls_test_forms.

FORM short_form USING pv_text TYPE csequence.
  WRITE / pv_text(3).
ENDFORM.

FORM long_form USING pv_text TYPE csequence.
  WRITE / pv_text+1(3).
ENDFORM.
