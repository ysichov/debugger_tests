CLASS zcl_calc_data_provider DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION. METHODS get_shipment IMPORTING iv_scenario TYPE char12 RETURNING VALUE(rs_context) TYPE zif_calc_types=>ty_context.
  PRIVATE SECTION. CLASS-DATA mv_last_hazard TYPE abap_bool.
ENDCLASS.
CLASS zcl_calc_data_provider IMPLEMENTATION.
  METHOD get_shipment.
    rs_context = VALUE #( shipment_id = '4712' transport_type = 'ROAD' country_from = 'CN' country_to = 'DE'
                          weight_kg = '1200' volume_m3 = '8.5' distance_km = '1287' delay_days = 4 currency = 'EUR' ).
    IF iv_scenario = 'STATE' OR iv_scenario = 'MULTI'.
      " BUG02: static state leaked from an earlier shipment.
      mv_last_hazard = abap_true. rs_context-hazardous = mv_last_hazard.
    ENDIF.
  ENDMETHOD.
ENDCLASS.
