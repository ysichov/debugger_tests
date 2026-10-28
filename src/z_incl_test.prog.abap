*&---------------------------------------------------------------------*
*& Report Z_INCL_TEST
*&---------------------------------------------------------------------*
*& A local class defined in one include (TOP) and implemented in another
*& (C01), a form in a third (F01). Object Navigator opens each method in
*& Z_INCL_TEST_C01; a breakpoint set in an include stops there. The run
*& writes 6 (2 + 4).
*&---------------------------------------------------------------------*
REPORT z_incl_test.

INCLUDE z_incl_test_top.
INCLUDE z_incl_test_c01.
INCLUDE z_incl_test_f01.

START-OF-SELECTION.
  lcl_app=>main( ).
