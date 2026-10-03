CLASS zcl_price_road DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    INTERFACES zif_pricing_strategy.
ENDCLASS.
CLASS zcl_price_road IMPLEMENTATION.
  METHOD zif_pricing_strategy~calculate_base.
    SELECT price_per_unit, currency
      FROM zlog_base_tariff
      WHERE transport_type = @cs_context-transport_type
        AND country_from = @cs_context-country_from
        AND country_to = @cs_context-country_to
        AND valid_from <= @cs_context-pricing_date
        AND valid_to >= @cs_context-pricing_date
      ORDER BY valid_from DESCENDING
      INTO @DATA(ls_tariff) UP TO 1 ROWS.
    ENDSELECT.
    IF sy-subrc <> 0.
      RETURN.
    ENDIF.
    cs_context-amount = cs_context-weight_kg * CONV decfloat34( ls_tariff-price_per_unit ) * cs_context-distance_km / 1000.
    cs_context-currency = ls_tariff-currency.
  ENDMETHOD.
ENDCLASS.
