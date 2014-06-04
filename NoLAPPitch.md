# NoLAP elevator pitch (for Eliot)

This document introduces NoLAP by beginning with how competitors deal with XBRL data, like filings of US companies to the SEC, shows the limits of traditional approaches, and shows why and how NoLAP goes beyond these limits.

Let's take a skyscraper's elevator for 5 minutes. It's worth it.

## Components, tables, Excel and OLAP

Traditionally, the set of all SEC filings is treated as a set of components. For example, a component is Coca Cola's
balance sheet for Q1 2014. Another component is the statement of income of Amazon for FY 2013.

Each of these components is a dense table with few dimensions. Typically just 2, sometimes 3 or 4.
Typically:

- one of the dimensions is the name of the reported concept (assets, liabilities, etc) and there's 1 to 100 of them.
- another is the period, there are typically 1 to 4 of them.

|             | 2013 | 2014 |
|-------------|------|------|
| Assets      |  2B$ | 4B$  |
| Liabilities |  1B$ | 2B$  |

You can quickly calculate that, hence, a component's table typically has between 1 and 400 cells. Let's say 4,000 to account
for one or two extra dimensions.

### Excel

4,000 cells. Nothing Excel can't do.
Each one of these components can be exported in a csv format like so

| Concept     | Period | Value | Unit |
|-------------|--------|-------|------|
| Assets      | 2013   | 2     | B$   |
| Assets      | 2014   | 4     | B$   |
| Liabilities | 2013   | 1     | B$   |
| Liabilities | 2014   | 2     | B$   |

on top of which Excel allows you to pivot,
slice and dice with these 2, 3 or 4 dimensions.

However, you're stuck in a filing. You can't compare across components, let alone across fiscal years or companies. Why?
Typically because the dimensions are different, but the names of the reported concepts can also vary even if they mean
the same thing.

### OLAP

Since it's a hypercube, this data can also be stored in an OLAP store. For example, in ROLAP, you would have a couple of
tables organized in a snowflake:

- One table with the list of concepts.
- One table with the list of periods.
- And a central table that references each of the first two, together with a value for each set of foreign keys.

## NoLAP's business value

Let's go back to the SEC filings example.

People want to compare across periods. They want to know whether Google is growing.

People want to compare across companies. They want to know whether Samsung is catching up with Apple
and when it might take over.

In order to do such comparisons, you need to "merge" all the hypercubes (say, Apple's balance sheet and Samsung's balance sheet, for the years 2013 and 2014) and do something useful with this data in Excel.

### One single, big big big hypercube

With NoLAP, we go the whole way. We merge all SEC components' hypercubes to a single one. All of them.

How big is this hypercube? To give you an idea, just looking at the DOW 30 (that's barely 0.5% of the filings),
you have 811 dimensions, and in average each of these has 38 values. That's a hypercube of 38^811 cells. That's a 1 followed by like 1200 zeros.

1000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

By orders of magnitude more than atoms in the universe. Of course, this hypercube is extremely sparse -- otherwise it would be physically infeasible to store it.

If you attempt to store this hypercube in a ROLAP database, you'll quickly reach limits: 800 dimension tables, and a central table with 800+ columns -- with plenty of empty cells: 99.5% of empty cells. Worse: if you want to now go ahead and import all filings, not only will be cumbersome to create new tables and migrate the central one, but this will make your SQL database explode.

### NoSQL is a perfect fit for sparseness

Somehow, sparseness marries incredibly well with NoSQL.

1. NoSQL means *heteroneous* data. That's perfect: for each cell, you only need to specify the dimensions it lives in. Different cells can have different dimensions. *The big hypercube is just one single NoSQL collection of heterogeneous cells*, like


    {
      Concept: "Assets",
      Period: "2014",
      Value: "4",
      Unit: "B$"
    }


2. NoSQL means *arborescent* data. That's perfect: dimension values (example: concepts) are organized in hierarchies. For example, current assets and noncurrent assets are children of assets. A hypercube's metadata, like, say, Coca Cola's balance sheet for FY 2014, can be stored in a single document. *No need to join* acros any tables, everything is in the document.

### On the fly hypercubes

Given one hypercube documents (see point 2 above), you can, with a single query, get all the cells and export them to Excel. In other words, you support no less than traditional approaches. With indexes on the most used dimensions (like compound key indices on MongoDB), performance allows you to do this in real time. In "Web site visiting" real time, i.e., below the treshold acceptable by human visitors.

However, since these hypercubes documents are completely uncorrelated to the huge collection of cells, nothing prevents you from *designing your own hypercubes*, live, on the fly, and querying the fact collection.

What kind of own hypercube? Well, for example, let's take these three dimensions:

1. Concepts: assets, income and revenues
2. Companies: Samsung, Apple
3. Periods: FY 2013, FY 2014

That's it. Query the big collection, get the cells, export in Excel. Here you are. It took you maybe 1 minute to design the hypercube and 5 seconds to export as a csv. You're already adding formulas and getting to the meat, while a user of a traditional approach will have exported 4 csv files, one for each filing, and is still copying and pasting cells around, trying to merge them manually into a single Excel spreadsheet.

