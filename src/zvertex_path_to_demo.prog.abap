REPORT zvertex_path_to_demo.

PARAMETERS p_express AS CHECKBOX DEFAULT 'X'.
PARAMETERS p_hazard  AS CHECKBOX DEFAULT 'X'.
PARAMETERS p_remote  AS CHECKBOX DEFAULT 'X'.
PARAMETERS p_fragile AS CHECKBOX DEFAULT 'X'.
PARAMETERS p_peak    AS CHECKBOX DEFAULT 'X'.
PARAMETERS p_member  AS CHECKBOX.
PARAMETERS p_weekend AS CHECKBOX.

START-OF-SELECTION.
  DATA(lv_base_amount) = CONV decfloat34( '1000.00' ).
  DATA(lv_amount) = lv_base_amount.

  DATA lv_route_score TYPE i.
  DATA lv_route_band TYPE string.
  DATA lv_eta_days TYPE i.
  DATA lv_handling_code TYPE string.
  DATA lv_dispatch_note TYPE string.
  DATA lv_audit_text TYPE string.

  IF p_remote = abap_true.
    lv_route_score = 70.
    lv_eta_days = 5.
    IF p_express = abap_true.
      lv_route_score = lv_route_score + 15.
      lv_eta_days = lv_eta_days - 2.
      IF p_weekend = abap_true.
        lv_route_score = lv_route_score + 8.
      ELSE.
        lv_route_score = lv_route_score + 3.
      ENDIF.
    ELSE.
      lv_route_score = lv_route_score - 10.
      lv_eta_days = lv_eta_days + 1.
    ENDIF.
  ELSE.
    lv_route_score = 25.
    lv_eta_days = 2.
    IF p_express = abap_true.
      lv_eta_days = lv_eta_days - 1.
    ENDIF.
  ENDIF.

  IF lv_route_score > 85.
    lv_route_band = 'PRIORITY'.
  ELSEIF lv_route_score > 55.
    lv_route_band = 'STANDARD'.
  ELSE.
    lv_route_band = 'LOCAL'.
  ENDIF.

  IF p_express = abap_true.
    lv_amount = lv_amount * 1.15.
    IF p_hazard = abap_true.
      lv_amount = lv_amount + 80.00.
      IF p_remote = abap_true.
        lv_amount = lv_amount * 1.20.
        IF p_weekend = abap_true.
          lv_handling_code = 'WEEKEND'.
          IF p_member = abap_true.
            lv_dispatch_note = 'Member weekend dispatch'.
          ELSE.
            IF p_peak = abap_true.
              lv_dispatch_note = 'Peak weekend dispatch'.
            ELSE.
              lv_dispatch_note = 'Weekend dispatch'.
            ENDIF.
          ENDIF
        ELSE.
          lv_handling_code = 'STANDARD'.
          IF p_fragile = abap_true.
            lv_dispatch_note = 'Fragile handling'.
          ELSE.
            lv_dispatch_note = 'Regular handling'.
          ENDIF
        ENDIF.
        IF p_fragile = abap_true.
          lv_amount = lv_amount + 35.00.
          IF p_peak = abap_true.
            lv_amount = lv_amount * 1.30.
          ELSE.
            lv_amount = lv_amount + 12.00.
          ENDIF.
        ELSE.
          lv_amount = lv_amount * 1.05.
        ENDIF.
      ELSE.
        lv_amount = lv_amount + 25.00.
      ENDIF.
    ELSE.
      lv_amount = lv_amount * 1.08.
      IF p_member = abap_true.
        lv_amount = lv_amount - 50.00.
      ELSE.
        lv_amount = lv_amount + 18.00.
      ENDIF.
    ENDIF.
  ELSE.
    IF p_hazard = abap_true.
      lv_amount = lv_amount + 80.00.
      IF p_remote = abap_true.
        lv_amount = lv_amount * 1.20.
      ELSE.
        lv_amount = lv_amount + 25.00.
      ENDIF.
    ELSE.
      lv_amount = lv_amount * 1.08.
    ENDIF.
  ENDIF.

  IF p_peak = abap_true AND lv_route_score > 80.
    lv_audit_text = 'Peak priority route'.
  ELSEIF p_weekend = abap_true AND lv_eta_days < 3.
    lv_audit_text = 'Weekend local dispatch'.
  ELSEIF p_member = abap_true.
    lv_audit_text = 'Member shipment'.
  ELSE.
    lv_audit_text = 'Regular shipment'.
  ENDIF.

  IF p_weekend = abap_true.
    lv_amount = lv_amount + 40.00.
  ENDIF.
  IF p_member = abap_true AND lv_amount > 1200.00.
    lv_amount = lv_amount * 0.95.
  ENDIF.
  IF p_peak = abap_true AND lv_amount > 1500.00.
    lv_amount = lv_amount + 65.00.
  ENDIF.

  WRITE: / |Route score: { lv_route_score } ({ lv_route_band })|,
         / |Estimated days: { lv_eta_days }|,
         / |Handling: { lv_handling_code } - { lv_dispatch_note }|,
         / |Audit: { lv_audit_text }|,
         / |Base amount: { lv_base_amount } EUR|,
         / |Calculated amount: { lv_amount } EUR|.
