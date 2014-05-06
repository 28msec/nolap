# NoSQL Online Analytical Processing (NoLAP)

NoLAP is a new flavor of OLAP that extends the OLAP paradigm to benefit from NoSQL' s gain in flexibility.

Here are the top 3 reasons for using NoLAP.

## Hypercubes on the fly
With OLAP, you have to define the shape of your hypercubes in advance. Once the data is in there, you are stuck to that schema.
With NoLAP, while you may have some hypercubes in advance and store them in the database, you do not have to. This is consistent with NoSQL where you are not obliged to have schemas upfront or at all.
At runtime, you can bring your own hypercube (or even a complete report schema) and retrieve the facts on the fly - all in real time.
 
## High-dimensional data (curse of dimensionality)
The "curse of dimensionality" is often used as a blanket excuse for not dealing with high-dimensional data. 
With NoLAP, you can efficiently work with such data.
For example, MOLAP (and also ROLAP because of its table explosion) do not scale up well with the number of dimensions.
With NoLAP, it does not matter how many dimensions you have.
Because of NoSQL's heterogeneity, there is virtually zero performance penalty.
You can even add more as you add new measures and hypercubes.


## Exchanging cubes and metadata between data silos
There is no global standard for OLAP.
This makes it hard to exchange highly dimensional data between "silos".
NoLAP hypercubes follow the rules specified by the eXtensible Business Reporting Language (XBRL).
This allows for exchanging data using XBRL between systems easily.

## Links:

- NoLAP in detail: https://github.com/28msec/nolap/blob/master/NOLAP.md
- TPC-H an example implementation of NoLAP: https://github.com/28msec/nolap/blob/master/TPC-H.md
- The biggest NoLAP database, yet: http://secxbrl.info