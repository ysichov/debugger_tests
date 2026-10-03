*&---------------------------------------------------------------------*
*& Deterministic scenario and Customizing generator for VERTEX Debug Lab
*&---------------------------------------------------------------------*
REPORT zvertex_demo_setup.

PARAMETERS p_clean RADIOBUTTON GROUP sc DEFAULT 'X'.
PARAMETERS p_pipe  RADIOBUTTON GROUP sc.
PARAMETERS p_multi RADIOBUTTON GROUP sc.
PARAMETERS p_reset AS CHECKBOX DEFAULT 'X'.

START-OF-SELECTION.
  DATA(lv_scenario) = COND char12( WHEN p_pipe = abap_true THEN 'PIPELINE'
                                    WHEN p_multi = abap_true THEN 'MULTI'
                                    ELSE 'CLEAN' ).

  IF p_reset = abap_true.
    DELETE FROM zlog_pipeline WHERE scenario_id = @lv_scenario.
    DELETE FROM zlog_rule WHERE scenario_id = @lv_scenario.
    DELETE FROM zlog_shipment WHERE scenario_id = @lv_scenario.
  ENDIF.

  " Correct sequence: discount must reduce the VAT base.
  DATA lt_pipeline TYPE STANDARD TABLE OF zlog_pipeline WITH EMPTY KEY.
  lt_pipeline = VALUE #( ( scenario_id = lv_scenario step_no = '010' modifier_class = 'ZCL_MOD_FUEL' )
                         ( scenario_id = lv_scenario step_no = '020' modifier_class = 'ZCL_MOD_CUSTOMS' )
                         ( scenario_id = lv_scenario step_no = '030' modifier_class = 'ZCL_MOD_HAZARD' )
                         ( scenario_id = lv_scenario step_no = '040' modifier_class = 'ZCL_MOD_DISCOUNT' )
                         ( scenario_id = lv_scenario step_no = '050' modifier_class = 'ZCL_MOD_TAX' ) ).
  IF lv_scenario = 'PIPELINE' OR lv_scenario = 'MULTI'.
    " Intentional config defect: code remains correct, only table data is corrupt.
    lt_pipeline = VALUE #( ( scenario_id = lv_scenario step_no = '010' modifier_class = 'ZCL_MOD_FUEL' )
                           ( scenario_id = lv_scenario step_no = '020' modifier_class = 'ZCL_MOD_CUSTOMS' )
                           ( scenario_id = lv_scenario step_no = '030' modifier_class = 'ZCL_MOD_HAZARD' )
                           ( scenario_id = lv_scenario step_no = '040' modifier_class = 'ZCL_MOD_TAX' )
                           ( scenario_id = lv_scenario step_no = '050' modifier_class = 'ZCL_MOD_DISCOUNT' ) ).
  ENDIF.
  MODIFY zlog_pipeline FROM TABLE @lt_pipeline.

  MODIFY zlog_shipment FROM @( VALUE #( scenario_id = lv_scenario shipment_id = '4712'
    transport_type = 'ROAD' country_from = 'CN' country_to = 'DE' weight_kg = '1200'
    volume_m3 = '8.5' distance_km = '1287' pricing_date = '20260901'
    hazardous = COND #( WHEN lv_scenario = 'STATE' OR lv_scenario = 'MULTI' THEN abap_true ELSE abap_false )
    delay_days = 4 currency = 'EUR' ) ).

  " Baseline data; MULTI deliberately adds a second active ROAD tariff (overlap).
  DELETE FROM zlog_base_tariff WHERE transport_type = 'ROAD' AND country_from = 'CN' AND country_to = 'DE'.
  INSERT zlog_base_tariff FROM @( VALUE #( transport_type = 'ROAD' country_from = 'CN' country_to = 'DE'
                                           valid_from = '20260101' valid_to = '20260531' price_per_unit = '5.00' currency = 'EUR' ) ).
  INSERT zlog_base_tariff FROM @( VALUE #( transport_type = 'ROAD' country_from = 'CN' country_to = 'DE'
                                           valid_from = '20260601' valid_to = '20271231' price_per_unit = '5.42' currency = 'EUR' ) ).
  IF lv_scenario = 'MULTI'.
    MODIFY zlog_base_tariff FROM @( VALUE #( transport_type = 'ROAD' country_from = 'CN' country_to = 'DE'
                                             valid_from = '20260101' valid_to = '20261231' price_per_unit = '10.00' currency = 'USD' ) ).
  ENDIF.

  " Route matrix demonstrates direct match and wildcard fallback data.
  MODIFY zlog_geo_matrix FROM @( VALUE #( country_from = 'CN' country_to = 'DE'
                                          tax_rate = '0.12' requires_clearance = abap_true ) ).
  MODIFY zlog_geo_matrix FROM @( VALUE #( country_from = 'CN' country_to = '*'
                                          tax_rate = '0.08' requires_clearance = abap_true ) ).
  MODIFY zlog_geo_matrix FROM @( VALUE #( country_from = '*' country_to = '*'
                                          tax_rate = '0.03' requires_clearance = abap_false ) ).

  " Deterministic indices and exchange data, ready for the next modifiers.
  MODIFY zlog_fuel_rate FROM @( VALUE #( valid_from = '20260101' fuel_index = '187.36'
                                         base_index = '172.00' coefficient = '1.00' ) ).
  MODIFY zlog_exchange FROM @( VALUE #( from_currency = 'USD' to_currency = 'EUR'
                                        valid_from = '20260101' rate = '0.9200' ) ).
  MODIFY zlog_rule FROM TABLE @( VALUE #( ( scenario_id = lv_scenario rule_id = '100'
    priority = '010' field_name = 'HAZARDOUS' action = 'MULTIPLY' action_value = '1.08' )
    ( scenario_id = lv_scenario rule_id = '110' priority = '020' field_name = 'VOLUME' action = 'DISCOUNT' action_value = '0.07' )
    ( scenario_id = lv_scenario rule_id = '120' priority = '030' field_name = 'AMOUNT' action = 'TAX' action_value = '0.19' ) ) ).

  WRITE: / |Scenario { lv_scenario } generated.|,
         / |Pipeline rows: { lines( lt_pipeline ) }; tariffs, geo, fuel, exchange and rules are ready.|.
