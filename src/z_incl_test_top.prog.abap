*&---------------------------------------------------------------------*
*& Include Z_INCL_TEST_TOP - the local class's DEFINITION and global data
*&---------------------------------------------------------------------*
CLASS lcl_app DEFINITION.
  PUBLIC SECTION.
    CLASS-METHODS main.
  PRIVATE SECTION.
    CLASS-METHODS:
      is_even IMPORTING iv_value TYPE i RETURNING VALUE(rv_even) TYPE abap_bool,
      add IMPORTING iv_value TYPE i.
ENDCLASS.

DATA gv_total TYPE i.
