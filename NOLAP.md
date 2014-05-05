# NoSQL Online Analytical Processing (NoLAP)

## Introduction (OLAP)
OLAP is a very popular framework for business reporting. The data is structured in cubes (or hypercubes) that can have any number of dimensions (region, customer, fiscal year, fiscal period, ...). Each cell of this hypercube contains a number called a measure, which is associated with the dimension values that this cell corresponds to. OLAP is very powerful for three major kinds of operations:

- *Roll-up* aggregations (sum the sales numbers over a region, compute the average salary of a department, ...)
- *Drill-down* (the opposite of roll-up: start with the sales numbers over America, look at how they are distributed between South and Norh America, then between USA and Canada, etc)
- *Slice and dice* (select only data for Europe, and present the sales numbers with one region in each column and one product in each row, etc).

One of the major strengths of OLAP is that aggregations can be pre-computed (deciding which ones is not trivial though), leading to a significant improvement over a classical SQL database. Also, it provides a very generic schema and architecture that fits many use cases.

OLAP cubes are commonly accessed via so-called pivot tables, which are UIs that make it easy for a human to browse an OLAP cube with each of the above three navigation paradigms.

## OLAP flavors
There are several ways to implement an OLAP engine.

- *MOLAP*. The data is stored in an optimized and compressed way. A range of queries are precomputed in advance. The main weakness of MOLAP is that it does not scale up well with the number of dimensions.
- *ROLAP*. The data is stored in relational tables: for each hypercube, there is one table that stores all measures along with dimension values (foreign keys). These foreign keys point to separate tables -- one table for each dimension -- that contain more data about each dimension value. Its main weakness is the table explosion as soon as there are many dimensions, and the need to create new tables for each hypercube. Also, SQL queries tend to become complex because information from various tables needs to be joined together.
- *NoLAP*. This is the new flavor we are introducing here (see next paragraph).

## Why and how NoLAP is different
NoLAP is a new flavor of OLAP that extends the OLAP paradigm to benefit from NoSQL' s gain in flexibility.

NoLAP removes certain limitations of traditional OLAP and enables the exchange of both measures and metadata between different business systems (as JSON, XML or CSV).

NoLAP is vastly inspired by XBRL, which is a global standard for business reporting.

The measures are stored in just a single collection (called facts). The facts collection is the only requirement. Optionally (but you don' t have to), you may also have a second collection that contains hypercube metadata (called components).

In addition to its very low schema footprint (only two NoSQL collections if not just one), NoLAP provides two further points of business value:
- *Bring your own hypercubes on the fly*. You can dynamically build hypercubes and populate them with the associated facts in real time.
- *Dimension cardinality scale-up*. It does not matter whether you have one, ten, one million or one billion dimensions. Thanks to NoSQL' s heterogeneity, NoLAP supports them.

## NoLAP as a multi-dimensional spreadsheet
Each NoLAP hypercube can be seen as a spreadsheet or pivot table which is semantic oriented rather than presentation oriented. The facts are 'glued' together using business rules and other semantic-oriented relations (a bit like Excel formulas). NoLAP brings online analytical processing and business intelligence to NoSQL databases, such as the open source database MongoDB.

Unlike classical spreadsheets though, the business logics can be completely decoupled from viewing. Slicing and dicing happens on the server, against the entire data set (which can be GBs or TBs of data). The results can then be viewed in an Excel spreadsheet, consumed by a BI tool, or displayed as a Web site.

## Implementations
The biggest implementation of NoLAP so far is a complete database of [U.S. public company financial information]( http://secxbrl.info). The database contains information (yearly and quarterly reports, i.e., 10-K and 10-Q documents) submitted to the SEC using the global standard XBRL syntax. The resulting NoLAP database contains roughly 60 mio. facts and defines around 4 mio. (static) hypercubes on those facts.

## Key NoLAP Advantages
In addition to the three main advantages mentioned above, NoLAP provides the following ones:

- *Removes hypercube rigidity*. NoLAP lets users generate their own hypercubes, or OLAP cubes on the fly. This is referred to as open cubes.
- *Complex computation support*. NoLAP overcomes the limited computation support of OLAP (mainly roll ups) by supporting
other common types of computation-type relations such as a roll forward (changes between two periods), adjustment (difference between an originally stated and restated amount), variance (difference between two reporting scenarios).
- *Go faster to the market*. Schema changes (e.g. adding new dimensions) can be added on the fly which means that no IT is required for such cases.
- *Exchanging cubes and metadata between data silos*. NoLAP hypercube follows the rules specified by the extensible Business Reporting Language (XBRL). This allows for exchanging data using XBRL between systems easily.
- *Using synonyms to accommodate for different terminologies or schema changes*. Because NoLAP allows for the specification of open hypercubes, synonyms of certain concepts can be used to specify the hypercube.

## NoLAP Terminology
A NoLAP hypercube follows the rules specified by XBRL, XBRL Dimensions, and XBRL Formula and also following the spirit of the XBRL Abstract Model 2.0. While these technical specifications articulate the rules followed by NoLAP, the following is an informal (terminology) overview understandable to anyone familiar with OLAP and OLAP cubes.

### Hypercube
A hypercube is used to combine facts which go together for some specific (often structural) reason. A hypercube is the same as an OLAP cube, although the term is more accurate. A cube, in geometry, has three dimensions whereas a hypercube can have any number of dimensions. (Other terms for hypercube are table, matrix, array.) A hypercube can be considered a generalization of an "n"-dimensional electronic spreadsheet where "n" is the number of dimensions.

### Dimension
A dimension describes and distinguishes a fact. A fact has a set of dimensions. A dimension or distinguishing aspect provides information necessary to describe or characterize a fact or distinguish one fact from another fact. A fact may have one or many distinguishing dimensions. (Other terms for dimension are axis, aspect, characteristic.) The set of dimensions for a fact usually correspond to the primary key of that fact.

### Non-distinguishing Dimension
This is a property of a fact that does not distinguish a fact from another fact, but that nevertheless can be used for filtering facts.

### Member
A member is a possible value of a dimension. Members of a dimension tend to be cohesive and share a certain common nature. A domain is a set of members belonging to a dimension (often there is only one per dimension).

### Primary Items
Primary items are concepts which can be reported by an entity which can contain a value. Primary items may also contain Abstract concepts which can never report values but rather are used to help organize the set of primary items.
### Concept
A concept originally refers to a business reporting concept which can be reported as a fact within a report. However, because of the complexity and modularity of the XBRL specification, concepts (which correspond to XML Schema Element Declarations) also include hypercubes, dimensions, members, tuples, items, etc. If you refer to a concept that can be reported, then "Primary item" is more precise and should be used instead.

### Fact
A fact is a single, observable piece of information of the sort which can be contained within a report. Facts are contextualized for unambiguous interpretation or analysis by one or more distinguishing Dimensions. A fact has a value property. If a fact value is numeric, the fact value has two properties which help the user interpret the numeric fact value: units and rounding (accuracy, decimals). A fact may have zero or many parenthetical explanations (parenthetical comments) which provide additional descriptive information related to the fact.

### Business rule
A business rule is a formal and implementable expression of some user requirement or constraint.

## NoLAP Data Model
With NoSQL technologies, NoLAP can be stored in an way that is optimized for hypercube querying. NoSQL technologies (like MongoDB) extend the relational model by replacing flat, homogeneous tables with heterogeneous, arborescent data. These properties are leveraged by the NoLAP data model.

The NoLAP data model has been widely inspired by the XBRL Abstract Model 2.0. A UML diagram for the actual model is available [here](https://secxbrl.zendesk.com/hc/en-us/article_attachments/200504520/XBRL.io_-_Data_Model_-_Conceptual_Data_Model.png)

The data model contains two main types of (relational) entities: facts and components. 

### Facts

According to the definition above, a fact is a single, observable, piece of information of the sort that can be contained within a report. For example, the name of a customer, the account balance of a customer, or the status of a particular order. Here is an example, of a fact in its JSON representation suitable for storing in a NoSQL database such as MongoDB.

```json
    {
      Aspects: {
        "xbrl:Concept": "tpch:OrderStatus",
        "xbrl:Entity": "Customer#000036901",
        "xbrl:Period": ISODate("1996-01-02T00:00:00Z"),
        "xbrl:Unit": "pure",
        "tpch:OrderKey": 1
      },
      Type: "String",
      Value: "O"
    }
```
    
This fact is the status of an order “O” (xbrl:Concept) with key 1. The order was placed by a particular customer (*xbrl:Entity*) on an order date (*xbrl:Period*). The type of the value is string and there is no particular unit for the value.

Because of the flexibility of the JSON data model (aka flexible schema), each fact can have a different set of aspects. This brings two main advantages:

1. It allows for storing all facts in a single collection. This allows for arbitrary hypercubes to be specified on any subset of the collection (e.g. all the customers or all the orders with their line items). This property is referred to as open hypercube.

2. New data potentially introducing new dimensions can be added to the existing collection. Doing so doesn’t require to update the schema of the database. All existing queries (and reports) will continue working.

### Components

Components are metadata on top of the facts. They are used to describe a particular view on the huge set of facts. Specifically, a component describes a hypercube (set of concepts). Moreover, it can describe how concepts should be presented to the user or describe calculation relationships between the concepts.

Unlike in OLAP where dimension and hypercube metadata is spread over zillions of tables, hypercubes and components are available in a single, arborescent piece.

For example, a component could describe hypercube of all the customer information. As a result, a user can retrieve a so called fact table for all the customer information contained in the database. Such a fact table can be used to build pivot tables on the data.

This is how such a component can look like. See how the arborescent capabilities of SQL allow a standalone representation of a hypercube, its dimension and their allowed values.

```json
    {
      "_id" : "53666983D07EB839D4D86D70", 
      "Archive" : null, 
      "Role" : "http://www.tpc.org/tpch/customers", 
      "Label" : "Customers", 
      "Networks" : [  ], 
      "Hypercubes" : {
        "xbrl:DefaultHypercube" : {
          "Name" : "xbrl:DefaultHypercube", 
          "Label" : "XBRL Implicit non-dimensional Hypercube", 
          "Aspects" : {
            "xbrl:Concept" : {
              "Name" : "xbrl:Concept", 
              "Label" : "Implicit XBRL Concept Dimension", 
              "Domains" : {
                "xbrl:ConceptDomain" : {
                  "Name" : "xbrl:ConceptDomain", 
                  "Label" : "Implicit XBRL Concept Domain", 
                  "Members" : {
                    "tpch:CustomerName" : {
                      "Name" : "tpch:CustomerName", 
                      "Label" : "Customer name"
                    }, 
                    "tpch:CustomerAddress" : {
                      "Name" : "tpch:CustomerAddress", 
                      "Label" : "Customer address"
                    }, 
                    "tpch:CustomerNation" : {
                      "Name" : "tpch:CustomerNation", 
                      "Label" : "Customer nation"
                    }, 
                    "tpch:CustomerRegion" : {
                      "Name" : "tpch:CustomerRegion", 
                      "Label" : "Customer region"
                    }, 
                    "tpch:CustomerPhone" : {
                      "Name" : "tpch:CustomerPhone", 
                      "Label" : "Customer phone"
                    }, 
                    "tpch:CustomerAccountBalance" : {
                      "Name" : "tpch:AccountBalance", 
                      "Label" : "Customer account balance"
                    }, 
                    "tpch:CustomerMarketSegment" : {
                      "Name" : "tpch:CustomerMarketSegment", 
                      "Label" : "Customer market segment"
                    }, 
                    "tpch:CustomerComment" : {
                      "Name" : "tpch:CustomerComment", 
                      "Label" : "Customer comment"
                    }
                  }
                }
              }
            }, 
            "xbrl:Period" : {
              "Name" : "xbrl:Period", 
              "Label" : "Implicit XBRL Period Dimension"
            }, 
            "xbrl:Entity" : {
              "Name" : "xbrl:Entity", 
              "Label" : "Implicit XBRL Entity Dimension"
            }, 
            "xbrl:Unit" : {
              "Name" : "xbrl:Unit", 
              "Label" : "Implicit XBRL Unit Dimension", 
              "Default" : "xbrl:NonNumeric"
            }
          }
        }
      }
    }
```

Another example of a component is the list of all orders and a set of information of the corresponding line items. Such a component can be used to build an order report for a particular customer.

### Reports
Reports can be created using report schemas. Report schemas look very much like components (i.e., the above snippet), except that they can be created on the fly. A report schema typically embeds a hypercube, some concept-synonym mappings and possibly some business rules to compute new facts, as well as an arborescent view of concepts or dimension members that can be used for human-friendly display.

### Server-side pivoting
Queries can be performed using hypercubes, but there is an even more generic way of querying the facts pool, using the XBRL Table Linkbase Specification.

While a hypercube only filters for facts (roll up, drill down) and outputs them in a raw form called a fact table, table linkbases allow fine-tuning to slide. dice and finally nicely present the data to a human user.

A *definition model* can be used to draw the skeleton of a table (a classical spreadsheet like Excel if you want).

A *table model* can then be created out of a definition model and component metadata, which automatically adds all concepts from that component, for examples.

Finally, a *layout model* can be created by populating the table model with facts.

The layout model can then be exported to Excel via the Web, or displayed as HTML. All the logics happens on the server. Why would you import GBs of data to your computer and compute on a single machine, when hundreds or thousands of machines in the cloud can do the job for you in a second instead of a day, and for the same price?




