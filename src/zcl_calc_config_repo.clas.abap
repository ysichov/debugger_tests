CLASS zcl_calc_config_repo DEFINITION PUBLIC FINAL CREATE PUBLIC.
  PUBLIC SECTION. METHODS get_pipeline IMPORTING iv_scenario TYPE char12 RETURNING VALUE(rt_steps) TYPE zif_calc_types=>tt_steps.
ENDCLASS.
CLASS zcl_calc_config_repo IMPLEMENTATION.
  METHOD get_pipeline.
    DATA(lv_config_scenario) = COND char12( WHEN iv_scenario = 'PIPELINE' OR iv_scenario = 'MULTI' THEN iv_scenario ELSE 'CLEAN' ).
    SELECT step_no, modifier_class AS name FROM zlog_pipeline WHERE scenario_id = @lv_config_scenario ORDER BY step_no INTO CORRESPONDING FIELDS OF TABLE @rt_steps.
  ENDMETHOD.
ENDCLASS.
