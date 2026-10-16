*&---------------------------------------------------------------------*
*& Report Z_TRANSPILER_TEST
*&---------------------------------------------------------------------*
*&
*&---------------------------------------------------------------------*
REPORT Z_TRANSPILER_TEST.


data a type i.
data b type i.

a = 5.

b  = 3.

a = a + b.

add 1 to a.

do 25 times.
  add sy-index to b.
enddo.

subtract 1 from b.
