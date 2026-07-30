Project 1 of my data analytics portfolio is live.

Supply Chain Delay Analysis — 180,519 orders, 3 years of data, SQL Server, Power BI and Google Sheets.

The headline finding: 57.8% of all deliveries arrived late. More than 1 in every 2 orders.

But the number that stopped me was this: First Class shipping — the premium option — has a 100% late rate. Across 27,814 orders. In every region. Zero on-time deliveries anywhere in the world.

Meanwhile Standard Class, the cheapest option, was the most reliable at 39.8% late.

Customers paying more were getting the worst service in the network.

A few other things the data showed:

— No seasonal pattern exists. Every month from 2015 to 2018 sits between 56% and 60% late. This is not a peak season problem. It is a structural one.

— The delay problem is not geographic. All 23 regions sit within a 10 percentage point range. Fixing one region would not move the needle.

— Same Day shipping is invisible in the data. All Same Day orders have scheduled delivery days of zero in the system, making performance measurement impossible. A system configuration issue worth fixing.

The most important output was not the dashboard. It was a weekly exception report that flags routes as CRITICAL, WARNING or MONITOR so an operations team knows exactly what to escalate on Monday morning.

Full project on GitHub — SQL queries, Power BI dashboard and live Google Sheets report linked below.

What I learned building this: the business question comes before the tool. Every query I wrote existed to answer one specific operational question. If it could not be traced back to a business question, it did not belong in the analysis.

Project 2 is next: Bank Customer Churn Analysis using Python.

GitHub: https://github.com/Abijahkabiro/Supply_chain_delay_analysis

Google Sheets Report: https://docs.google.com/spreadsheets/d/11WScYkRSGapPfTlJoQ433jA0oXYXpSJQXd4qfvKiixY/edit?usp=sharing

#DataAnalytics #SQL #PowerBI #SupplyChain #PortfolioProject #GoogleSheets #DataStorytelling
