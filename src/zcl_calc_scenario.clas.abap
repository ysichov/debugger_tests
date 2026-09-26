CLASS zcl_calc_scenario DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION.
    METHODS constructor IMPORTING iv_id TYPE char12.
    METHODS id RETURNING VALUE(rv_id) TYPE char12.
    METHODS has_precision_bug RETURNING VALUE(rv_yes) TYPE abap_bool.
    METHODS has_state_bug RETURNING VALUE(rv_yes) TYPE abap_bool.
    METHODS has_pipeline_bug RETURNING VALUE(rv_yes) TYPE abap_bool.
  PRIVATE SECTION. DATA mv_id TYPE char12.
ENDCLASS.
CLASS zcl_calc_scenario IMPLEMENTATION.
  METHOD constructor. mv_id = iv_id. ENDMETHOD.
  METHOD id. rv_id = mv_id. ENDMETHOD.
  METHOD has_precision_bug. rv_yes = xsdbool( mv_id = 'PRECISION' OR mv_id = 'MULTI' ). ENDMETHOD.
  METHOD has_state_bug. rv_yes = xsdbool( mv_id = 'STATE' OR mv_id = 'MULTI' ). ENDMETHOD.
  METHOD has_pipeline_bug. rv_yes = xsdbool( mv_id = 'PIPELINE' OR mv_id = 'MULTI' ). ENDMETHOD.
ENDCLASS.
