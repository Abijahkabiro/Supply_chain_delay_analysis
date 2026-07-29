# Supply Chain Delay Analysis

Designed and delivered an end-to-end Business Intelligence solution that transformed 180,519 supply chain orders into executive insights on delivery performance, operational risk, and carrier accountability. Built the solution using SQL Server, Power BI, and Google Sheets to help operations leaders understand where delays occur, which shipping modes are failing, and which routes require immediate escalation.

Focused on enabling better operational decisions rather than simply reporting late deliveries. Used data profiling, analytical modelling, and exception reporting to provide decision-makers with the visibility needed to prioritize corrective action based on evidence instead of assumptions.

**Author:** Abijah Kabiro | Business Intelligence Analyst | Nairobi, Kenya

**Technology Stack:** SQL Server • SSMS • Power BI • DAX • Google Sheets

**Dataset:** [DataCo Smart Supply Chain Dataset](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis) 180,519 orders across 23 regions and 50 product categories spanning January 2015 to January 2018.

**Project Focus:** Supply Chain Analytics • Operational Performance • Exception Reporting • Business Intelligence

---

## Business Context

A global e-commerce supply chain was experiencing persistent delivery delays across multiple regions and shipping modes. Although operations teams could see that deliveries were arriving late, they lacked the analytical visibility to understand where the problem was concentrated, which shipping modes were responsible, and what actions would have the highest business impact.

Without this visibility, delay management remained reactive. Operations teams were firefighting individual complaints rather than addressing the structural causes driving a network-wide performance failure.

Built this analytical solution to bridge that gap by transforming raw transaction data into actionable business intelligence. Rather than simply measuring the late delivery rate, the solution enables operations leaders to identify the root causes, monitor performance by route and shipping mode, and act on a structured weekly exception report every Monday morning.

---

## Business Objectives

Designed the analytical solution to answer eight operational business questions that support delivery performance management and carrier accountability.

### 1. Overall Delivery Performance

Establish the network-wide performance baseline.

- What is the overall on-time delivery rate across all orders?
- How many orders arrived late and what is the financial value at risk?

### 2. Shipping Mode Analysis

Identify which carrier tiers are failing.

- Which shipping mode has the highest late delivery rate?
- How does average delay vary across shipping modes?
- Why is Same Day shipping invisible in the performance data?

### 3. Regional Performance

Determine whether delays are geographic or structural.

- Which regions experience the most delivery delays?
- Is the range of regional performance narrow enough to suggest a systemic issue?

### 4. Product Category Risk

Identify which categories drive the highest volume of late deliveries.

- Which product categories have the highest late rates?
- Which categories drive the highest absolute volume of late deliveries?

### 5. Financial Impact

Quantify the business cost of late deliveries.

- What is the profit impact of late deliveries compared to on-time deliveries?
- Does the profit split between late and on-time orders reflect the volume split?

### 6. Route-Level Risk

Identify the specific routes requiring immediate operational attention.

- Which region and shipping mode combinations present the greatest risk?
- Which routes are consistently underperforming across multiple weeks?

### 7. Seasonal Patterns

Determine whether delays follow a predictable seasonal pattern.

- Is there a Q4 peak season effect on delivery delays?
- Does the monthly late rate trend show any actionable pattern?

### 8. Weekly Exception Reporting

Deliver an operational tool for Monday morning reviews.

- Which routes should be escalated to carriers this week?
- Which routes are at WARNING level and require monitoring?

---

## Business Value

Delivered a Business Intelligence solution that enables stakeholders to:

- Monitor delivery performance through executive-level KPIs updated from the source database.
- Identify the specific carrier tiers and routes generating the greatest operational risk.
- Escalate performance failures to carriers using evidence-based exception reporting.
- Understand whether delays are structural or seasonal, which changes the recommended response.
- Prioritize corrective action by volume of late orders rather than late rate alone.
- Support carrier contract renegotiations with analytical evidence rather than operational instinct.

---

## Solution Architecture

```text
Raw CSV Source Data
      │
      ▼
SQL Server Staging
      │
      ▼
Data Quality Profiling (9 checks)
      │
      ▼
Data Cleaning and Standardization
      │
      ▼
SQL Analytical Layer (8 queries)
      │
      ▼
Google Sheets Reporting Layer
      │
      ▼
Power BI Executive Dashboard
```

Each stage builds on the previous one, creating a traceable analytics pipeline that preserves raw source data while delivering trusted operational insights for decision-makers.

---

## Phase 1: Data Ingestion

Loaded the DataCo Supply Chain dataset into SQL Server using the Import Flat File wizard in SSMS. Configured all columns to allow nulls during import to prevent ETL failures caused by sparse geographic fields.

Validated the load against expected record counts before proceeding to profiling.

| Dataset | Records |
|---|---:|
| Raw orders | 180,519 |
| Unique orders | 65,752 |
| Average items per order | 2 |

---

## Phase 2: Data Quality Profiling

Before writing any analysis queries, ran 9 structured profiling checks to establish a measurable baseline for data quality.

Rather than correcting issues immediately, identified, quantified, and documented every issue to ensure subsequent cleaning decisions were driven by evidence.

| Quality Check | Finding |
|---|---|
| Data grain | One row represents one order line item, not one order |
| Null values | Zero nulls in all key analytical columns |
| Duplicate orders | 65,752 unique Order IDs from 180,519 rows confirms multi-item orders |
| Date range | January 2015 to January 2018, consistent with expected scope |
| Data types | Days_for_shipping_real and Days_for_shipment_scheduled imported as tinyint, causing arithmetic overflow errors |
| Same Day scheduling | All 9,737 Same Day orders have scheduled delivery days of zero, making delay measurement impossible |
| Zero delivery day rows | 14,817 rows with zero delivery days concentrated in PENDING, CANCELED, and SUSPECTED_FRAUD statuses |
| Bad values | Latitude and Longitude contained sparse values with 114 nulls, excluded from analysis |
| Hidden spaces | No leading or trailing spaces found in categorical columns |

Profiling first ensured every cleaning decision was measurable, traceable, and aligned with the analytical objectives.

---

## Phase 3: Data Cleaning and Standardization

Applied targeted fixes to the two issues that would have produced incorrect analytical results if left unresolved.

| Issue | Root Cause | Resolution |
|---|---|---|
| tinyint overflow on delay calculation | Delivery day columns imported as tinyint which cannot hold negative numbers | Ran ALTER TABLE to convert both columns from tinyint to INT |
| Same Day excluded from delay analysis | All Same Day orders have scheduled delivery days of zero | Excluded from delay analysis and documented as a system configuration issue |
| 14,817 unshipped orders | PENDING, CANCELED, PROCESSING and SUSPECTED_FRAUD orders have zero actual delivery days | Applied master cleaning filter to all queries: WHERE Days_for_shipping_real > 0 AND Days_for_shipment_scheduled > 0 |

After cleaning, the analytical dataset contained:

- **170,782** validated order rows
- **3** measurable shipping modes (Same Day excluded)
- **23** regions
- **50** product categories

---

## Phase 4: SQL Analysis

Wrote 8 analytical queries in SQL Server, each designed to answer one specific business question. Applied the master cleaning filter consistently across all queries to ensure analytical accuracy.

### Key Findings

**Overall delivery performance**
57.8% of all validated orders arrived late. More than one in every two orders failed to meet the promised delivery date. The delay problem is a network-wide operating norm, not an isolated incident.

**Shipping mode performance**
First Class shipping recorded a 100% late delivery rate across 27,814 orders in every region with zero on-time deliveries anywhere. The cause is a systematic mismatch between the promised delivery window of 1 day and the actual delivery time of 2 days. This is a carrier SLA issue, not a logistics failure. Standard Class, the cheapest option, was the most reliable at 39.8% late.

| Shipping Mode | Total Orders | Late Orders | Late Rate | Avg Delay Days |
|---|---:|---:|---:|---:|
| First Class | 27,814 | 27,814 | 100.0% | 1.00 |
| Second Class | 35,216 | 28,078 | 79.7% | 1.99 |
| Standard Class | 107,752 | 42,851 | 39.8% | 0.00 |

**Regional performance**
All 23 regions sit between 52.6% and 62.2% late, a range of only 10 percentage points. Central Africa recorded the highest late rate at 62.2% and Canada the lowest at 52.6%. The narrow range confirms the delay problem is structural, not geographic. Fixing one region would not move the needle.

**Financial impact**
Late delivery orders generated $2,145,747 in profit, representing 57% of total profit. This mirrors the volume split and confirms that late orders are not unprofitable in themselves. The real financial risk is indirect through customer dissatisfaction, reduced repeat purchases, and 7,754 cancelled orders representing revenue never captured.

**Seasonal patterns**
Every month from January 2015 to January 2018 sits between 56.1% and 59.9% late, a range of 3.8 percentage points. No Q4 peak season effect was found. The delay problem is structural and will not be resolved through seasonal capacity planning.

**Route-level risk**
Central Asia Second Class recorded the highest non-First Class late rate at 90.6% with an average delay of 2.21 days. Canada Standard Class was the best performing route at 30.4% late with orders consistently arriving 0.27 days early on average.

---

## Dashboard Preview

![Supply Chain Performance Dashboard](Power%20BI/Supply%20Chain%20Performance%20Dashboard.png)

---

## Phase 5: Google Sheets Reporting Layer

Built a four-tab Google Sheets workbook to translate SQL outputs into stakeholder-ready reports accessible without SQL Server access.

| Tab | Purpose |
|---|---|
| Dashboard Summary | Headline KPIs, key findings, and top recommendations for non-technical stakeholders |
| Delay by Shipping Mode | Performance breakdown by carrier tier with colour-coded risk indicators |
| Weekly Exception Report | CRITICAL, WARNING, and MONITOR flags with pre-written action checklist for Monday operations reviews |
| Delay by Category | 50 product categories ranked by late rate with key insights section |

**Live Report:** [View the Supply Chain Delay Analysis](https://docs.google.com/spreadsheets/d/11WScYkRSGapPfTlJoQ433jA0oXYXpSJQXd4qfvKiixY/edit?usp=sharing)

---

## Phase 6: Power BI Dashboard

Built an interactive Power BI dashboard connected to the SQL Server database, enabling operations teams to monitor delivery performance dynamically with filters applied by region, shipping mode, and category.

### DAX Measures

```dax
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

## Business Recommendations

The analysis identified five actions that would reduce delivery delays and improve carrier accountability.

### 1. Audit the First Class Carrier Contract

First Class shipping has a 100% late rate across every region with zero on-time deliveries across 27,814 orders.

**Recommendation:** Initiate an immediate review of the First Class carrier SLA. The current promised delivery window of 1 day does not reflect actual carrier performance. Either renegotiate the contract to reflect a 2-day window or suspend First Class until performance is corrected.

### 2. Redirect High-Value Orders to Standard Class

Standard Class at 39.8% late significantly outperforms both First Class and Second Class. Customers paying premium prices are receiving the worst delivery outcomes in the network.

**Recommendation:** Redirect high-value orders to Standard Class while First Class and Second Class performance issues are under investigation. Communicate the change to customers to manage expectations.

### 3. Automate the Weekly Exception Report

The manual production of exception reports creates unnecessary analytical overhead and delays operational response time.

**Recommendation:** Schedule the exception query as a SQL Agent Job that emails CRITICAL-flagged routes to operations leads every Monday before the weekly review meeting. This converts the analysis from a one-time project into a recurring operational tool.

### 4. Investigate the 7,754 Cancelled Orders

The dataset contains 7,754 cancelled orders representing 4.3% of total orders. Cancellation reasons were not available in the dataset.

**Recommendation:** Segment cancelled orders by customer tenure, order value, and shipping mode to determine whether cancellations are delay-driven or fulfilment-driven. The answer changes the priority of the corrective actions above.

### 5. Fix the Same Day System Configuration

All Same Day orders have scheduled delivery days of zero, making it impossible to measure whether they arrived on time or late.

**Recommendation:** Update the system configuration to record Same Day scheduled delivery as 1 day. This will enable Same Day performance to be included in future exception reporting.

---

## Data Quality Management

Data quality management formed a core component of the analytical solution rather than a preprocessing activity.

| Issue | Volume | Root Cause | Resolution |
|---|---:|---|---|
| tinyint overflow | 2 columns | Import wizard assigned tinyint to delivery day columns | ALTER TABLE to convert to INT |
| Import null rejection | 114 rows | Wizard set geographic columns as NOT NULL by default | Enabled Allow Nulls in import wizard |
| Invalid column names | 53 columns | SQL Server replaced spaces with underscores during import | INFORMATION_SCHEMA query to retrieve actual column names |
| Percentage over 100% | Calculation error | Mixed COUNT(DISTINCT) and SUM at different data grains | Changed denominator to COUNT(*) for consistent grain |
| Invalid alias in ORDER BY | Query error | SQL Server evaluates ORDER BY before SELECT aliases | Repeated CASE WHEN logic in ORDER BY clause |
| Same Day missing from results | 9,737 rows | Scheduled days of zero filtered by master cleaning filter | Investigated root cause and excluded with documentation |

---

## Running the Project

### SQL Server

1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis).
2. Import `DataCoSupplyChainDataset.csv` into SQL Server using the Import Flat File wizard. Enable Allow Nulls for all columns on Page 4 of the wizard.
3. Run the ALTER TABLE commands to convert tinyint columns to INT (documented in the SQL file).
4. Execute queries from `sql/supply_chain_analysis_queries.sql` in order.

### Power BI

1. Open `powerbi/Supply_Chain_Delay_Analysis.pbix`.
2. Update the SQL Server connection to your local instance.
3. Refresh the dataset.
4. Review the dashboard across all visual sections.

---

## Repository Structure

```text
supply-chain-delay-analysis/
│
├── README.md
├── sql/
│   └── supply_chain_analysis_queries.sql
│   └── screenshots/
├── powerbi/
│   └── Supply_Chain_Delay_Analysis.pbix
│   └── Supply_Chain_Performance_Dashboard.png
│   └── dashboard_background.png
│   └── screenshots/
└── sheets/
    └── screenshots/
```

---

## Business Intelligence Capabilities Demonstrated

- Business problem definition and requirements analysis
- Data ingestion and quality profiling
- Data cleaning and standardization
- SQL analytics across 8 business questions
- KPI design and operational reporting
- Exception reporting with automated risk flagging
- Power BI semantic modeling and DAX
- Google Sheets reporting layer design
- Dashboard design for operational decision support
- Business insight generation and executive recommendations

---

## Related Content

A detailed walkthrough of the project including the business context, analytical approach, SQL implementation, Power BI development, and business recommendations is available on Medium.

**Read the full article:** https://medium.com/@abijahkabiro/when-more-than-half-your-deliveries-are-late-the-data-has-something-to-say-7bc40d995d18

---

## About the Author

**Abijah Kabiro** is a Business Intelligence Analyst who designs end-to-end analytical solutions that transform operational data into trusted business insights. With four years of experience across supply chain, logistics, and fintech, the work combines SQL Server, Power BI, and dimensional modelling to support performance improvement and evidence-based decision-making.

Specialising in the complete Business Intelligence lifecycle from understanding business problems and preparing data to designing analytical models, developing executive dashboards, and delivering recommendations that improve operational performance.

## Connect

- **Portfolio:** https://abijahkabiro.github.io
- **LinkedIn:** https://linkedin.com/in/abijahkabiro
- **GitHub:** https://github.com/Abijahkabiro
- **Medium:** https://medium.com/@abijahkabiro
