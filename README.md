# VERTEX Debug Lab — ABAP Pricing Engine

A compact, intentionally imperfect ABAP debugging benchmark for the VERTEX Smart Debugger. It models a cross-border logistics settlement and produces a traceable value history rather than a CRUD workflow.

## Quick start

1. Import this repository with abapGit into a development package and activate the DDIC objects.
2. Run `ZVERTEX_DEMO_SETUP` to generate a baseline or corrupted Customizing scenario.
3. Run `ZVERTEX_DEBUG_LAB` with the same scenario and inspect the execution timeline.

The demo has real client-dependent `ZLOG_*` Customizing tables. The setup report is deterministic and can reset and recreate a scenario without manual SM30 maintenance.

## Scenarios

| Scenario | Intentional defect | Likely first divergent step |
| --- | --- | --- |
| `CLEAN` | None | — |
| `PRECISION` | Fuel rate is rounded before multiplication | `ZCL_MOD_FUEL` |
| `STATE` | Legacy provider leaks `STATICS` hazard state | `ZCL_MOD_HAZARD` |
| `PIPELINE` | Customising executes VAT before discount | pipeline configuration |
| `MULTI` | All three defects together | Depends on the dependency path |

## Debugging story

`ZVERTEX_DEBUG_LAB` invokes a data provider, Strategy/Factory base-price calculation, and a dynamically-configured modifier pipeline. Each step appends a calculation log. The important investigation is not merely *where the final number changed*, but why it changed: base price → fuel → customs → hazard → discount → VAT.

The code is structured as an importable proof-of-concept. The next iteration can replace `LCL_CONFIG_GENERATOR` with repository classes over `ZLOG_*` DDIC tables and add the remaining scenarios: validity overlap, geo fallback, currency date, unit conversion, rule priority and overwritten `sy-subrc`.
