# Technical design

## Current executable slice

```text
PricingFacade
  ├─ DataProvider (legacy state boundary)
  ├─ PricingFactory → RoadPricing strategy
  └─ ConfigGenerator → dynamic modifier pipeline
       ├─ Fuel
       ├─ Customs
       ├─ Hazard
       ├─ Discount
       └─ Tax
```

`LCL_LOG` records the amount after every business operation, giving VERTEX an explicit expected flow to visualize.

## DDIC Customizing layer

| Table | Purpose | Debug failure mode |
| --- | --- | --- |
| `ZLOG_BASE_TARIFF` | Rate and validity interval | overlapping records |
| `ZLOG_GEO_MATRIX` | route customs rate and fallback | missing wildcard fallback |
| `ZLOG_PIPELINE` | modifier class order | tax before discount |
| `ZLOG_FUEL_RATE` | fuel index by date | wrong rate or date |
| `ZLOG_RULE` | priority business actions | erroneous priority |
| `ZVERTEX_EXPECT_STEP` | expected value per scenario step | planned automated first divergence |

## Invariants for future automated tests

- A clean scenario must never retain state from a previous shipment.
- A pipeline must execute discount before VAT.
- Monetary percentages retain full precision until the display/persistence boundary.
- Configuration selection must be deterministic where validity ranges overlap.
