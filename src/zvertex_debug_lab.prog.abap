REPORT zvertex_debug_lab.

PARAMETERS p_clean RADIOBUTTON GROUP sc DEFAULT 'X'.
PARAMETERS p_prec  RADIOBUTTON GROUP sc.
PARAMETERS p_state RADIOBUTTON GROUP sc.
PARAMETERS p_pipe  RADIOBUTTON GROUP sc.
PARAMETERS p_multi RADIOBUTTON GROUP sc.

START-OF-SELECTION.
  DATA(lv_scenario) = COND char12( WHEN p_prec = abap_true THEN 'PRECISION'
                                    WHEN p_state = abap_true THEN 'STATE'
                                    WHEN p_pipe = abap_true THEN 'PIPELINE'
                                    WHEN p_multi = abap_true THEN 'MULTI'
                                    ELSE 'CLEAN' ).
  NEW zcl_calc_facade( )->run( iv_scenario = lv_scenario ).
