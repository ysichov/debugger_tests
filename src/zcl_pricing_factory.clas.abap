CLASS zcl_pricing_factory DEFINITION PUBLIC FINAL CREATE PRIVATE.
  PUBLIC SECTION. CLASS-METHODS create IMPORTING iv_transport TYPE char4 RETURNING VALUE(ro_strategy) TYPE REF TO zif_pricing_strategy.
ENDCLASS.
CLASS zcl_pricing_factory IMPLEMENTATION.
  METHOD create. ro_strategy = NEW zcl_price_road( ). ENDMETHOD.
ENDCLASS.
