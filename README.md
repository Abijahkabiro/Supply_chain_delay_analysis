# Supply Chain Delay Analysis

Designed and delivered an end-to-end Business Intelligence solution that transformed 180,519 supply chain orders into executive insights on delivery performance, operational risk, and carrier accountability. Built this analytical solution to bridge that gap by transforming raw transaction data into actionable business intelligence.
Focused on enabling better operational decisions rather than simply reporting late deliveries. Used data profiling, analytical modelling, and exception reporting to provide decision-makers with the visibility needed to prioritize corrective action based on evidence instead of assumptions.

**Author:** Abijah Kabiro | Business Intelligence Analyst | Nairobi, Kenya

**Technology Stack:** SQL Server • SSMS • Power BI • DAX • Google Sheets

**Project Focus:** Supply Chain Analytics • Operational Performance • Exception Reporting • Business Intelligence

---

## Business Context

The project examines how supply chain performance patterns can reveal early indicators of operational risk. A global e-commerce supply chain was experiencing persistent delivery delays across multiple regions and shipping modes. Although operations teams could see that deliveries were arriving late, they lacked the analytical visibility to understand where the problem was concentrated, which shipping modes were responsible, and what actions would have the highest business impact.

Without this visibility, delay management remained reactive. Operations teams were firefighting individual complaints rather than addressing the structural causes driving a network-wide performance failure.

Built this analytical solution to bridge that gap by transforming raw transaction data into actionable business intelligence. Rather than simply measuring the late delivery rate, the solution enables operations leaders to identify the root causes, monitor performance by route and shipping mode, and act on a structured weekly exception report every Monday morning.

---

## Business Objectives

Designed the analytical solution to answer 8 operational business questions that support delivery performance management and carrier accountability.

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
Raw CSV Data Source
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

Designed the solution as a structured Business Intelligence workflow that prioritizes data quality, analytical consistency, and scalable reporting. Each stage builds on the previous one, creating a traceable analytics pipeline that preserves raw source data while delivering trusted operational insights for decision-makers.

---

## Phase 1: Data Ingestion

Loaded the DataCo Supply Chain dataset into SQL Server using the Import Flat File wizard in SSMS. Rather than accepting the wizard defaults, I configured all columns to allow nulls during import to prevent ETL failures caused by sparse geographic fields such as Latitude and Longitude. This approach ensured the full dataset could be ingested before any data quality assessment began.

Validated the load against expected record counts before proceeding to profiling.

| Dataset | Records |
|---|---:|
| Raw orders loaded | 180,519 |
| Unique orders | 65,752 |
| Average line items per order | 2 |

---

## Phase 2: Data Quality Profiling

Before writing any analysis queries, I ran 9 structured profiling checks to establish a measurable baseline for data quality. Rather than correcting issues immediately, identified, quantified, and documented every issue to ensure subsequent cleaning decisions were driven by evidence rather than assumptions.

This discipline prevented incorrect results from being built on unchecked data and ensured every analytical decision could be traced back to a specific finding.

| Quality Check | Finding |
|---|---|
| Data grain | One row represents one order line item, not one unique order |
| Null values | Zero nulls in all key analytical columns |
| Duplicate orders | 65,752 unique Order IDs from 180,519 rows confirms legitimate multi-item orders |
| Date range | January 2015 to January 2018, consistent with expected scope |
| Data types | Days_for_shipping_real and Days_for_shipment_scheduled imported as tinyint, causing arithmetic overflow on delay calculations |
| Same Day scheduling | All 9,737 Same Day orders have scheduled delivery days of zero, making delay measurement impossible |
| Zero delivery day rows | 14,817 rows with zero delivery days concentrated in PENDING, CANCELED, and SUSPECTED_FRAUD statuses |
| Geographic nulls | 114 rows with null Latitude and Longitude values, excluded from geographic analysis |
| Hidden spaces | No leading or trailing spaces found in categorical columns |

---

## Phase 3: Data Cleaning and Standardization

Applied targeted fixes to the 2 issues that would have produced incorrect analytical results if left unresolved. Rather than applying blanket cleaning rules, I investigated each issue individually to understand the root cause before deciding on the appropriate resolution.

Documented every cleaning decision with its root cause and reasoning so the analytical choices are fully traceable and reproducible.

| Issue | Root Cause | Resolution |
|---|---|---|
| Arithmetic overflow on delay calculation | Delivery day columns imported as tinyint which cannot hold negative numbers | Converted both columns from tinyint to INT |
| Same Day excluded from delay analysis | All Same Day orders have scheduled delivery days of zero | Excluded from delay analysis and documented as a system configuration issue |
| 14,817 unshipped orders in dataset | PENDING, CANCELED, PROCESSING and SUSPECTED_FRAUD orders have zero actual delivery days | Applied master cleaning filter to all queries excluding rows where either delivery day column equals zero |

Validated the analytical dataset after cleaning to confirm data integrity before proceeding to analysis.

| Metric | Value |
|---|---:|
| Validated order rows | 170,782 |
| Measurable shipping modes | 3 |
| Regions included | 23 |
| Product categories | 50 |
| Unresolved data quality issues | 0 |

---

## Phase 4: SQL Analysis

Wrote 8 analytical queries in SQL Server, each designed to answer one specific business question. Applied the master cleaning filter consistently across all queries to ensure analytical accuracy and comparability of results across different cuts of the data.

### Key Findings

**Overall delivery performance**

57.8% of all validated orders arrived late. More than 1 in every 2 orders failed to meet the promised delivery date. The scale of the problem confirmed early in the analysis that this was not an isolated issue affecting specific routes or periods but a network-wide operating norm requiring structural intervention.

**Shipping mode performance**

First Class shipping recorded a 100% late delivery rate across 27,814 orders in every region with zero on-time deliveries anywhere in the network. Investigating the root cause revealed a systematic mismatch between the promised delivery window of 1 day and the actual carrier delivery time of 2 days. This is a carrier SLA issue rather than a logistics execution failure, which changes the recommended response entirely. Standard Class, the cheapest available option, performed best at 39.8% late.

| Shipping Mode | Total Orders | Late Orders | Late Rate | Avg Delay Days |
|---|---:|---:|---:|---:|
| First Class | 27,814 | 27,814 | 100.0% | 1.00 |
| Second Class | 35,216 | 28,078 | 79.7% | 1.99 |
| Standard Class | 107,752 | 42,851 | 39.8% | 0.00 |

**Regional performance**

Analysed performance across all 23 regions and found every region sits between 52.6% and 62.2% late, a range of only 10 percentage points. Central Africa recorded the highest late rate at 62.2% and Canada the lowest at 52.6%. The narrow range across geographically diverse regions confirmed the delay problem is structural rather than geographic. Addressing individual regional logistics would not move network-wide performance.

**Financial impact**

Late delivery orders generated 57% of total profit, mirroring the volume split. Late orders are not unprofitable in themselves. The real financial risk is indirect through customer dissatisfaction, reduced repeat purchase rates, and 7,754 cancelled orders representing revenue that was never captured.

**Seasonal patterns**

Tested the hypothesis that Q4 peak season drives higher delays directly against the data. Every month from January 2015 to January 2018 sits between 56.1% and 59.9% late, a range of only 3.8 percentage points across 37 months. The delay problem is structural and will not be resolved through seasonal capacity planning.

**Route-level risk**

Central Asia Second Class recorded the highest non-First Class late rate at 90.6% with an average delay of 2.21 days. Canada Standard Class performed best at 30.4% late with orders consistently arriving 0.27 days ahead of schedule on average.

---

## Phase 5: Google Sheets Reporting Layer

Built a 4-tab Google Sheets workbook to translate SQL outputs into stakeholder-ready reports accessible without requiring SQL Server access. Designed the workbook to serve as an operational reporting layer that operations teams could open, interpret, and act on without analytical support.

| Tab | Purpose |
|---|---|
| Dashboard Summary | Headline KPIs, key findings, and top recommendations for non-technical stakeholders |
| Delay by Shipping Mode | Performance breakdown by carrier tier with colour-coded risk indicators |
| Weekly Exception Report | CRITICAL, WARNING, and MONITOR flags with a pre-written action checklist for Monday operations reviews |
| Delay by Category | 50 product categories ranked by late rate with key insights highlighting the highest risk and highest volume categories |

**Live Report:** [View the Supply Chain Delay Analysis](https://docs.google.com/spreadsheets/d/11WScYkRSGapPfTlJoQ433jA0oXYXpSJQXd4qfvKiixY/edit?usp=sharing)

---

# Dashboard Preview

## Page 1: Performance Overview

Designed for supply chain leaders who need an immediate view of delivery performance across the full order base.

The dashboard presents executive KPIs including total orders analysed, total late orders, overall late rate, and average delay days. It combines these metrics with a late rate breakdown by shipping mode, late rate analysis by product category, and a regional map showing where delivery delays are concentrated geographically.

A three-tier colour system (red for critical, amber for elevated, green for acceptable) is applied consistently across the dashboard to make operational risk visible at a glance rather than requiring users to interpret every individual metric.

Its primary purpose is to help decision-makers understand the scale of the delay problem, identify where risk is concentrated, and determine which areas require deeper investigation.

![Page 1: Performance Overview](powerbi/Performance_Overview.png)

---

## Page 2: Trends and Operational Priorities

This page moves from identifying operational issues to prioritizing corrective action.

A monthly trend analysis establishes whether delivery delays are increasing, decreasing, or remaining structurally consistent over time. The Top Repeat Offender Routes table then breaks performance down by region and shipping mode, ranked by total late order volume rather than late rate alone.

This approach highlights the routes creating the greatest operational impact. Several routes may share a 100% late rate, but the business consequence differs significantly depending on how many orders and customers are affected.

The dashboard also includes a delivery status breakdown that reframes the full order population into outcome categories, helping stakeholders distinguish between orders performing as expected and orders requiring intervention.

One of the most important findings was the difference between rate and volume. First Class recorded a 100% late delivery rate, but Standard Class generated the highest number of late orders because of its significantly larger order volume. This distinction changed the recommended response from focusing only on the worst-performing percentage to addressing the areas creating the greatest operational impact. 

The objective is to help operations teams prioritize corrective action based on measurable business impact rather than isolated performance percentages.

![Page 2: Trends and Operational Priorities](powerbi/Trends_and_Alerts.png)

---

## Business Recommendations

The analysis identified 5 actions that would reduce delivery delays and strengthen carrier accountability.

### 1. Audit the First Class Carrier Contract

First Class shipping has a 100% late rate across every region with zero on-time deliveries across 27,814 orders. The gap between the promised delivery window and actual performance is consistent and universal, pointing to a contractual miscommunication rather than an operational failure.

**Recommendation:** Initiate an immediate review of the First Class carrier SLA. Either renegotiate the contract to reflect a realistic delivery window or suspend First Class as a customer-facing option until carrier performance is corrected.

### 2. Redirect High-Value Orders to Standard Class

Standard Class at 39.8% late significantly outperforms both First Class and Second Class. Customers paying premium prices are receiving the worst delivery outcomes in the network, creating disproportionate churn risk among the highest-value customer segment.

**Recommendation:** Redirect high-value orders to Standard Class while First Class and Second Class performance issues are under investigation. Communicate the change to affected customers to manage expectations and reduce complaint volumes.

### 3. Automate the Weekly Exception Report

The exception report structure built in this analysis provides operations teams with exactly the visibility they need to act quickly on underperforming routes. Producing it manually each week creates unnecessary overhead and delays the operational response.

**Recommendation:** Schedule the exception query as a SQL Agent Job that delivers CRITICAL-flagged routes to operations leads every Monday before the weekly review meeting. This converts the analysis from a one-time project into a recurring operational tool that requires no manual intervention.

### 4. Investigate the 7,754 Cancelled Orders

The dataset contains 7,754 cancelled orders representing 4.3% of total orders. Cancellation reasons were not available in the dataset, which means the financial impact of delay-driven cancellations cannot currently be quantified.

**Recommendation:** Segment cancelled orders by customer tenure, order value, and shipping mode to determine whether cancellations are delay-driven or fulfilment-driven. The answer materially changes the priority of the corrective actions above.

### 5. Fix the Same Day System Configuration

All Same Day orders have scheduled delivery days of zero, making it impossible to measure whether they arrived on time or late. A significant portion of the network is currently operating outside any performance measurement framework.

**Recommendation:** Update the system configuration to record Same Day scheduled delivery as 1 day. This will enable Same Day performance to be included in future exception reporting and carrier accountability conversations.

---

## Data Quality Management

Data quality management formed a core component of the analytical solution rather than a preprocessing activity. Identified, measured, and resolved 6 categories of issues before analysis began. Validated every transformation using before-and-after record counts to ensure changes were measurable, traceable, and reproducible.

| Issue | Volume | Root Cause | Resolution |
|---|---:|---|---|
| Arithmetic overflow on delay calculation | 2 columns | Import wizard assigned tinyint to delivery day columns | Converted to INT using ALTER TABLE |
| Import null rejection | 114 rows | Wizard set geographic columns as NOT NULL by default | Enabled Allow Nulls in import wizard settings |
| Invalid column names after import | 53 columns | SQL Server replaced spaces with underscores during import | Used INFORMATION_SCHEMA to retrieve actual column names |
| Percentage calculation over 100% | Calculation error | Mixed COUNT DISTINCT and SUM at different data grains | Changed denominator to COUNT for consistent grain |
| Invalid alias in ORDER BY | Query error | SQL Server evaluates ORDER BY before SELECT aliases resolve | Repeated CASE WHEN logic directly in ORDER BY clause |
| Same Day missing from results | 9,737 rows | Scheduled days of zero removed by master cleaning filter | Investigated root cause, excluded with full documentation |

The final analytical dataset contained 170,782 validated order rows, 3 measurable shipping modes, 23 regions, and 50 product categories with zero unresolved data quality issues affecting analytical accuracy.

---

## Running the Project

### SQL Server

1. Download the dataset from [Kaggle](https://www.kaggle.com/datasets/shashwatwork/dataco-smart-supply-chain-for-big-data-analysis).
2. Import the CSV file into SQL Server using the Import Flat File wizard. Enable Allow Nulls for all columns on Page 4 of the wizard before completing the import.
3. Run the ALTER TABLE statements to convert the tinyint delivery day columns to INT before executing any analysis queries.
4. Execute the queries from the SQL file in order. Each query is labelled with the business question it answers.

### Power BI

1. Open the Power BI file from the powerbi folder.
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

- Business problem definition and requirements structuring
- Data ingestion and staging
- Data quality profiling across 9 structured checks
- Data cleaning and standardization with full documentation
- SQL analytics across 8 business questions
- KPI design and operational performance measurement
- Exception reporting with automated risk flagging
- Power BI semantic modelling and DAX measure development
- Google Sheets operational reporting layer design
- Executive dashboard design for operational decision support
- Business insight generation and executive recommendations

---

## Related Content

A detailed walkthrough of the project including the business context, analytical approach, SQL implementation, Power BI development, and business recommendations is available on Medium.

**Read the full article:** https://medium.com/@abijahkabiro/when-more-than-half-your-deliveries-are-late-the-data-has-something-to-say-7bc40d995d18

---

## About the Author

I am **Abijah Kabiro**, a Business Intelligence Analyst who designs end-to-end analytical solutions that transform operational data into trusted business insights. With 4 years of experience across supply chain, logistics, and fintech, my work combines SQL Server, Power BI, and dimensional modelling to support performance improvement and evidence-based decision-making.

I specialise in the complete Business Intelligence lifecycle from understanding business problems and preparing data to designing analytical models, developing executive dashboards, and delivering recommendations that improve operational performance.

## Connect

- **Portfolio:** https://abijahkabiro.github.io
- **LinkedIn:** https://linkedin.com/in/abijahkabiro
- **GitHub:** https://github.com/Abijahkabiro
- **Medium:** https://medium.com/@abijahkabiro
