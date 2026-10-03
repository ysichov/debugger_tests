CLASS zcl_calc_data_provider DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS get_shipment
      IMPORTING iv_scenario TYPE char12
      RETURNING VALUE(rs_context) TYPE zif_calc_types=>ty_context.
ENDCLASS.
CLASS zcl_calc_data_provider IMPLEMENTATION.
  METHOD get_shipment.
    SELECT SINGLE shipment_id, transport_type, country_from, country_to, weight_kg, volume_m3,
                  distance_km, pricing_date, hazardous, delay_days, currency
      FROM zlog_shipment
      WHERE scenario_id = @iv_scenario
      INTO CORRESPONDING FIELDS OF @rs_context.
  ENDMETHOD.
ENDCLASS.
