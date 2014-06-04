# NoLAP one pager

## Components, tables, Excel and OLAP

Traditionally, the set of all SEC filings is treated as a set of components. For example, a component is Coca Cola's
balance sheet for Q1 2014. Another component is the statement of income of Amazon for FY 2013.

Each of these components is a dense table with few dimensions. Typically just 2, sometimes 3 or 4.
Typically:

- one of the dimensions is the name of the reported concept (assets, revenues, etc) and there's 1 to 100 of them.
- another is the period, there are typically 1 to 4 of them.

You can quickly calculate that, hence, a component's table typically has between 1 and 400 cells. Let's say 4,000 to account
for one or two extra dimensions.

### Excel

4,000 cells. Nothing Excel can't do.
Each one of these components can be exported in a csv format on top of which Excel allows you to pivot,
slice and dice with these 2, 3 or 4 dimensions.

However, you're stuck in a filing. You can't compare across components, let alone across fiscal years or companies. Why?
Typically because the dimensions are different, but the names of the reported concepts can also vary even if they mean
the same thing.

### OLAP

Since it's a hypercube, this data can also be stored in an OLAP store. For example, in ROLAP, you would have a couple of
tables organized in a snowflake. One table with the list of concepts. One table with the list of periods. And a central table
that references each of the first two, together with a value for each set of foreign keys.

## NoLAP's business value
