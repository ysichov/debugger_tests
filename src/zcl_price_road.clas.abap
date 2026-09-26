CLASS zcl_price_road DEFINITION PUBLIC FINAL CREATE PUBLIC. PUBLIC SECTION. INTERFACES zif_pricing_strategy. ENDCLASS.
CLASS zcl_price_road IMPLEMENTATION.
  METHOD zif_pricing_strategy~calculate_base.
    DATA(lv_chargeable_weight) = cs_context-weight_kg + 2 * 25.
    cs_context-amount = lv_chargeable_weight * '5.42' * cs_context-distance_km / 1000.
  ENDMETHOD.
ENDCLASS.
