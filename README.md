# Supply Chain Delay Analysis

Identifying delivery delay patterns, high-risk routes, and operational bottlenecks using SQL Server, Power BI and Google Sheets.

**Author:** Abijah Kabiro | Data Analyst | Nairobi, Kenya  
**Tools:** SQL Server · Power BI · Google Sheets  
**Dataset:** [DataCo Smart Supply Chain Dataset](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis) — 180,519 orders  
**Project Type:** Supply Chain Analytics · Operational Performance Analysis

**Live Google Sheets Report:** [View the Supply Chain Delay Analysis](https://docs.google.com/spreadsheets/d/11WScYkRSGapPfTlJoQ433jA0oXYXpSJQXd4qfvKiixY/edit?usp=sharing)

---

## Business Context

On-time delivery is one of the most important performance indicators in supply chain operations. Persistent delivery delays increase operating costs, reduce customer satisfaction, and create downstream planning challenges for operations teams.

This project analyses over 180,000 supply chain transactions to understand where delays occur, which shipping modes are most affected, and which routes require immediate operational attention.

The goal was not just to report that deliveries were late. The goal was to identify where the problem lives, why it exists, and what an operations team should do about it.

---

## Business Questions

The analysis was built around 8 business questions, each answered by a dedicated SQL query:

1. What is the overall on-time delivery rate across the entire dataset?
2. Which shipping mode has the highest late delivery rate and by how much?
3. Which regions experience the most delivery delays?
4. Which product categories have the highest late rates and the highest volume of late orders?
5. What is the profit impact of late deliveries compared to on-time deliveries?
6. Which specific region and shipping mode combinations present the greatest operational risk?
7. Is there a seasonal pattern to delivery delays across months and quarters?
8. Which routes need escalation this week based on current performance thresholds?

---

## Project Approach

**Phase 1 — Business Understanding**  
Started by defining the business problem and identifying the key performance indicators before writing any SQL. Documented the analytical questions upfront so every query had a clear purpose tied to a business decision.

**Phase 2 — Data Profiling and Cleaning**  
Ran 9 profiling checks before touching the data. Found two significant issues: the delivery day columns were imported as tinyint which caused arithmetic overflow errors during delay calculations, and Same Day shipping had scheduled delivery days of zero making performance measurement impossible. Resolved both issues and documented every decision before moving to analysis.

**Phase 3 — SQL Analysis**  
Wrote 8 queries in SQL Server, each answering one specific business question. Applied a master cleaning filter to every query to exclude 14,817 unshipped orders with zero delivery days.

**Phase 4 — Reporting Layer**  
Built a structured reporting layer in Google Sheets to translate SQL outputs into a format that operations teams can review and act on quickly. The workbook includes KPI summaries, delay analysis by shipping mode and product category, and a weekly exception report with CRITICAL, WARNING and MONITOR flags.

**Phase 5 — Dashboard**  
Built an interactive Power BI dashboard connected to the SQL Server database covering overall delivery performance, delay rates by shipping mode and category, regional distribution, monthly trends and operational exception reporting.

---

## Key Findings

**1. Delivery delays are a network-wide problem**  
57.8% of all orders arrived late after applying the data cleaning filter. This is not a problem in one region or one category. Every region sits between 52.6% and 62.2% late, a range of only 10 percentage points across 23 regions. The delay problem is structural, not geographic.

**2. First Class shipping has a 100% late delivery rate**  
Across 27,814 First Class orders in every region, not a single order arrived on time. The cause is a systematic mismatch between the promised delivery window of 1 day and the actual delivery time of 2 days. This is a carrier SLA issue, not a logistics failure. The fix is contractual, not operational.

**3. The cheapest shipping option is the most reliable**  
Standard Class shipping recorded a 39.8% late rate, significantly better than First Class at 100% and Second Class at 79.7%. Customers paying more for faster shipping are receiving worse delivery outcomes than customers who chose the budget option.

**4. Same Day shipping is invisible in the data**  
All Same Day orders have a scheduled delivery time of zero days in the system, making it impossible to measure whether they arrived on time or late. This is a system configuration issue. The recommendation is to record Same Day scheduled delivery as 1 day so performance can be measured.

**5. Cleats drives the highest volume of late deliveries**  
Golf Bags and Carts has the highest late rate at 68.3% but only 60 orders. Cleats has 23,198 orders with 13,443 arriving late. For operations teams focused on customer impact, Cleats is the higher priority category.

**6. Late deliveries still generate profit but the indirect cost is significant**  
Late delivery orders generated $2,145,747 in profit, representing 57% of total profit. This mirrors the volume split and shows that late orders are not unprofitable in themselves. The real financial risk is indirect: customer dissatisfaction, reduced repeat purchases and 7,754 cancelled orders representing revenue never captured.

**7. No seasonal pattern exists**  
Every month from January 2015 to January 2018 sits between 56.1% and 59.9% late, a range of 3.8 percentage points. The delays are not driven by peak season demand. Capacity planning for Q4 will not solve this problem. Fixing the carrier contracts will.

**8. Central Asia Second Class is the worst non-First Class route**  
Outside of First Class, Central Asia Second Class recorded a 90.6% late rate with an average delay of 2.21 days. Canada Standard Class was the best performing route at 30.4% late with an average of -0.27 days meaning orders consistently arrived early.

---

## Dashboard Preview

![Supply Chain Performance Dashboard](Power%20BI/Supply%20Chain%20Performance%20Dashboard.png)

---

## Errors Encountered

Real projects hit real problems. These were the issues found and how they were resolved.

| Error | Cause | Fix |
|---|---|---|
| Import wizard rejected nulls | Latitude and Longitude had empty cells | Ticked Allow Nulls for all columns in the Import Flat File wizard |
| Invalid column names | SQL Server renamed columns during import, replacing spaces with underscores | Ran INFORMATION_SCHEMA.COLUMNS query to get exact column names |
| Arithmetic overflow on tinyint | Delivery day columns imported as tinyint which cannot hold negative numbers | Ran ALTER TABLE to convert both columns from tinyint to INT |
| Percentages over 100% | Mixed COUNT(DISTINCT) and SUM at different data grains in the same calculation | Changed denominator to COUNT(*) so both sides count at row level |
| Invalid alias in ORDER BY | SQL Server evaluates ORDER BY before SELECT aliases are resolved | Repeated the full CASE WHEN logic in the ORDER BY clause |
| Same Day missing from results | All Same Day orders have scheduled days of 0, filtered by cleaning filter | Investigated root cause and documented as a system configuration issue |

---

## Recommendations

**1. Review the First Class carrier contract**  
A 100% late rate across every region means the current service level agreement does not reflect what the carrier is actually delivering. Either renegotiate the promised delivery window or suspend First Class until the agreement is corrected.

**2. Reassess the shipping strategy for premium orders**  
Standard Class at 39.8% late outperforms both First Class and Second Class. While that rate is still too high, redirecting high-value orders to Standard Class while the premium tier issues are investigated would reduce customer complaints from the customers who matter most.

**3. Automate the weekly exception report**  
Schedule the exception query as a SQL Agent Job that emails CRITICAL-flagged routes to operations leads every Monday before their weekly review. This converts the analysis from a one-time project into a recurring operational tool.

**4. Investigate the 7,754 cancelled orders**  
The dataset contains 7,754 cancelled orders representing 4.3% of total orders. Understanding whether these cancellations are customer-initiated due to delay frustration or business-initiated due to fulfilment failures would quantify the revenue impact and change the priority of the recommendations.

**5. Fix the Same Day system configuration**  
Record Same Day scheduled delivery as 1 day instead of 0 so performance can be measured accurately and included in future analysis.

---

## Project Files

```
supply-chain-delay-analysis/
│
├── powerbi/
│   └── Supply_Chain_Delay_Analysis.pbix
│   └── dashboard_background.png
│   └── Supply_Chain_Performance_Dashboard.png
│   └── screenshots/
│
├── sheets/
│   └── screenshots/
│
├── sql/
│   └── supply_chain_analysis_queries.sql
│   └── screenshots/
│
└── README.md
```

---

## DAX Measures Used in Power BI

```
Late Rate = DIVIDE(SUM([Is_Late]), COUNT([Is_Late]), 0)

Avg Delay Days = AVERAGEX(
    FILTER(DataCoSupplyChainDataset,
        [Days_for_shipping_real] > 0 &&
        [Days_for_shipment_scheduled] > 0),
    [Delay_Days])

Total Late Orders = CALCULATE(
    COUNT([Is_Late]),
    [Is_Late] = 1,
    [Days_for_shipping_real] > 0,
    [Days_for_shipment_scheduled] > 0)

Total Orders Analysed = CALCULATE(
    COUNT([Order_Id]),
    [Days_for_shipping_real] > 0,
    [Days_for_shipment_scheduled] > 0)
```

---

## How to Reproduce

1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis)
2. Import `DataCoSupplyChainDataset.csv` into SQL Server via SSMS. Tick Allow Nulls for all columns on Page 4 of the Import Flat File wizard
3. Run the ALTER TABLE commands to convert tinyint columns to INT (see sql file for details)
4. Run queries from `supply_chain_analysis_queries.sql` in order
5. Open Power BI and connect to your SQL Server instance or use the pbix file directly
6. Open the Google Sheets link above to view the operational reporting workbook

---

## Skills Demonstrated

- SQL analysis and data profiling
- Data cleaning and transformation
- KPI development and measurement
- Operational reporting in Google Sheets
- Power BI dashboard development
- Supply chain analytics
- Business insight generation
- Stakeholder focused reporting

---

## About This Project

Built by **Abijah Kabiro**, a data analyst based in Nairobi, Kenya with four years of experience in supply chain and logistics analytics. This project focused on real operational datasets and outputs that business teams can actually use, not just dashboards for visual effect.

**Connect:** [LinkedIn](https://www.linkedin.com/in/abijahkabiro/) · [Medium](https://medium.com/@abijahkabiro) · [Portfolio](https://abijahkabiro.github.io)