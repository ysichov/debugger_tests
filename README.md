# VERTEX Debug Lab — ABAP Pricing Engine

A compact, intentionally imperfect ABAP debugging benchmark for the VERTEX Smart Debugger. It models a cross-border logistics settlement and produces a traceable value history rather than a CRUD workflow.

## Quick start

1. Import this repository with abapGit into package `Z_CALC_RIG` and activate the DDIC objects. The root package metadata is stored in `src/package.devc.xml`; choose `Z_CALC_RIG` as the target package when creating the repository in abapGit.
2. Run `ZVERTEX_DEMO_SETUP`, choose one of the five labelled scenarios and leave **Reset selected scenario** checked to recreate its Customizing. Prepare each scenario before running it. The generator also restores the shared tariff, route, fuel and exchange data, so prepare and run a scenario before preparing the next one.
3. Run `ZVERTEX_DEBUG_LAB` with the same scenario and inspect the execution timeline.

The demo has real client-dependent `ZLOG_*` Customizing tables. The setup report is deterministic and can reset and recreate a scenario without manual SM30 maintenance. Runtime values are read from those tables: shipment input, base tariff, fuel index, geo matrix, pipeline and business rules.

## Scenarios

| Scenario | Intentional defect | Likely first divergent step |
| --- | --- | --- |
| `CLEAN` | None | — |
| `PRECISION` | Fuel rate is rounded before multiplication | `ZCL_MOD_FUEL` |
| `STATE` | Shipment Customizing marks the cargo hazardous | `ZCL_MOD_HAZARD` |
| `PIPELINE` | Customising executes VAT before discount | pipeline configuration |
| `MULTI` | All three defects together | Depends on the dependency path |

The setup and execution reports offer the same five scenarios. Each scenario has its own shipment, pipeline and rules. Customizing fields have English Dictionary descriptions and field labels.

Discount applies to the amount excluding any VAT already recorded in `TAX_AMOUNT`. In `CLEAN`, the discount reduces the VAT base. In `PIPELINE`, VAT runs first and remains overstated after the discount. This makes the final amount differ as well as the intermediate tax and discount amounts. For the generated data, the calculated reference totals are approximately **11,302.00 EUR** for `CLEAN` and **11,437.83 EUR** for `PIPELINE`, a difference of **135.82 EUR**. These are arithmetic reference values, not a recorded SAP run.

## Debugging story

`ZVERTEX_DEBUG_LAB` invokes a data provider, Strategy/Factory base-price calculation, and a dynamically-configured modifier pipeline. Each step appends a calculation log. The important investigation is not merely *where the final number changed*, but why it changed: base price → fuel → customs → hazard → discount → VAT.

The executable report is deliberately thin. The engine lives in global objects: `ZCL_CALC_FACADE`, `ZCL_CALC_CONFIG_REPO`, `ZCL_CALC_DATA_PROVIDER`, `ZCL_PRICING_FACTORY`, `ZCL_PRICE_ROAD` and the `ZCL_MOD_*` pipeline classes. Shared contracts are `ZIF_CALC_TYPES`, `ZIF_PRICING_STRATEGY` and `ZIF_CALC_MODIFIER`.

## Function module

Function group `ZVX_CALC` holds `Z_VX_CALC_FREIGHT`, a test of running a function module on its own: every kind of parameter at once - a simple value (`IV_TRANSPORT`), a structure (`IS_CONTEXT`, `ZIF_CALC_TYPES=>TY_CONTEXT`), a table (`IT_STEPS`), an optional value with a DEFAULT (`IV_RATE`, 2), CHANGING (`CV_NOTE`) and a table as a result (`ET_LOG`). The freight is weight × distance × rate / 1000, tripled for `AIR`, plus one per step; each step adds a log row. With weight 1200, distance 500, `AIR` and two steps it is 3602.

## Calls diagram

`Z_CALLS_TEST` checks what VERTEX's Calls diagram takes for a call. Its `START-OF-SELECTION` has offset/length access (`gv_text(4)`, `gv_text+2(3)`, `gv_name(10)`), inline declarations (`FIELD-SYMBOL(<lv_line>)`, `DATA(lv_count)`) and a built-in function (`lines( )`) - none of them is a call. The calls are `PERFORM local_form`, the external forms of the subroutine pool `Z_CALLS_TEST_FORMS` in both notations (`PERFORM short_form(z_calls_test_forms)` and `PERFORM long_form IN PROGRAM z_calls_test_forms`), the function module `CONVERT_DATE_TO_INTERNAL` and `LCL_HELPER->RUN`. With Methods and depth 2 the diagram shows exactly these five, both external forms resolved in `Z_CALLS_TEST_FORMS`.
