# When More Than Half Your Deliveries Are Late, the Data Has Something to Say

## I built a supply chain delay analysis as my first data analytics portfolio project. Here is what the data revealed and what it taught me about doing analytics work that actually matters.

---

*5 minute read*

---

## The Question That Started Everything

Before opening SQL Server, before writing a single query, I sat down and asked one question:

What would an operations manager actually need to know on a Monday morning?

Not what looks impressive in a portfolio. Not what shows off the most SQL functions. What does someone running a supply chain operation need to see when they walk into their weekly review meeting?

That question shaped every decision I made in this project.

---

## The Dataset

180,519 orders. Three years of data. 23 regions. 4 shipping modes. 50 product categories.

The dataset came from DataCo, a global e-commerce supply chain. Each row represented one order line item with columns for order date, scheduled delivery date, actual delivery date, shipping mode, product category and order region.

On paper it looked straightforward. In practice it was messier than expected.

---

## What I Found Before Writing a Single Analysis Query

Before touching any analysis I ran 9 data profiling checks. This is not optional. It is the difference between building on solid ground and building on sand.

Two problems came up immediately.

The first was a data type issue. The delivery day columns had been imported as tinyint, a data type that can only hold values between 0 and 255. The moment I tried to subtract actual delivery days from scheduled delivery days to calculate delay, SQL Server crashed. A delivery that arrived early produced a negative number and tinyint cannot store negative numbers. I fixed it permanently by converting both columns to INT using ALTER TABLE before running any analysis.

The second was Same Day shipping. Every Same Day order had a scheduled delivery time of zero days in the system. You cannot measure whether an order arrived on time or late when the target is zero. I excluded Same Day from the delay analysis and flagged it as a system configuration recommendation. The system should record Same Day as 1 scheduled day, not 0.

Both issues are documented. Both decisions are explained. When an interviewer asks how I cleaned the data I do not say "I removed nulls and fixed some errors." I walk through exactly what I found, why it mattered and what I decided to do about it.

---

## The Headline Number

After cleaning: 57.8% of all deliveries arrived late.

More than one in every two orders failed to meet the promised delivery date. Across three years of data. Across every region and every shipping mode.

That number alone tells you this is not a problem in one corner of the business. It is the operating norm of the network.

---

## The Finding That Stopped Me

When I broke down delays by shipping mode, First Class shipping showed a 100% late rate.

Not 90%. Not 95%. One hundred percent. Across 27,814 orders. In every single region. Zero on-time deliveries anywhere in the world.

The cause became clear quickly. First Class shipping is always scheduled for 1 day and always delivers in 2 days. Every time. Without exception. This is not a carrier performance problem. It is a systematic mismatch between what the business promises customers and what the carrier has apparently agreed to deliver.

The fix is not operational. It is contractual.

What made this finding even more striking was what came next. Standard Class shipping, the cheapest option available, was the most reliable at 39.8% late. Customers paying more for faster delivery were receiving a worse experience than customers who chose the budget option.

---

## What the Regional Analysis Revealed

I expected to find delay hotspots. Specific regions where logistics challenges explained the poor performance.

That is not what the data showed.

All 23 regions sit between 52.6% and 62.2% late. A range of only 10 percentage points. Central Africa is worst at 62.2%. Canada is best at 52.6%. But the narrow range is the actual finding. No region is performing well. No region is dramatically worse than the others.

The delay problem is not geographic. It is structural. Fixing one region would not move the needle. The problem is in the shipping mode contracts.

---

## The Seasonal Pattern That Did Not Exist

Before running the monthly trend analysis I had a hypothesis. Q4, peak season, October through December, would show higher delay rates driven by increased demand and constrained carrier capacity.

The data did not support this at all.

Every month from January 2015 to January 2018 sits between 56.1% and 59.9% late. A range of 3.8 percentage points across 37 months. December performs mid-range every year.

This matters for the recommendations. If the problem were seasonal, the fix would be capacity planning. Since it is not seasonal, capacity planning would not help. The fix is structural changes to carrier SLAs.

Following the data even when it contradicts your hypothesis is what separates analysis from confirmation bias.

---

## The Output That Mattered Most

The dashboard is not the most important output of this project.

The most important output is the weekly exception report.

Every Monday morning an operations team can open one table and immediately see which routes are flagged CRITICAL, which are WARNING and which are MONITOR. CRITICAL means late rate above 80% and requires escalation to the carrier within 48 hours. WARNING means between 60% and 80% and requires close monitoring. MONITOR means below 60%.

Below the table is a pre-written action checklist. The team does not need to interpret the data and decide what to do. The decisions are already structured into the report.

This is what analytics work should produce. Not charts for their own sake. Outputs that operations teams can act on.

---

## What This Project Taught Me

Three things.

First, profiling before analysis is not optional. Both of the problems I found, the tinyint issue and the Same Day scheduling issue, would have produced wrong results silently if I had not checked first. Wrong results presented with confidence are the most dangerous output in analytics.

Second, the business question comes before the tool. I did not open SQL Server and start querying. I wrote the business questions first. Every query in this project exists to answer one of those questions. If a query cannot be traced back to a business question it should not be in the analysis.

Third, the output determines the value. A technically perfect analysis that nobody uses is worthless. The exception report format, the Google Sheets reporting layer, the Power BI dashboard with conditional formatting, all of these were designed around what an operations team would actually open on a Monday morning. That design thinking is what makes the difference between a portfolio project and a business tool.

---

## The Full Project

The complete project including all SQL queries, the Power BI dashboard, the Google Sheets report and full documentation is on GitHub.

**GitHub:** [Supply Chain Delay Analysis](https://github.com/Abijahkabiro/Supply_chain_delay_analysis)

**Google Sheets Report:** [Live Report](https://docs.google.com/spreadsheets/d/11WScYkRSGapPfTlJoQ433jA0oXYXpSJQXd4qfvKiixY/edit?usp=sharing)

Project 2 is next: Bank Customer Churn Analysis using Python, built to rebuild lapsed Python skills while answering a real retention question.

If you are building your own analytics portfolio and want to swap notes, find me on LinkedIn.

---

*Tools used: Microsoft SQL Server, Power BI, Google Sheets*  
*Dataset: DataCo Smart Supply Chain for Big Data Analysis (Kaggle)*

---

**Tags:** `Data Analytics` `Supply Chain` `SQL` `Power BI` `Portfolio Project` `Google Sheets` `Data Storytelling` `Operations Analytics`
