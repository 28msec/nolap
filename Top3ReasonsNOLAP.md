# Top 3 Reasons Why You Should Start Using NoLAP

## Hypercubes on the fly
With OLAP, you have to define the shape of your hypercubes in advance. Once the data is in there, you are stuck to that schema.
With NoLAP, while you may have some hypercubes in advance and store them in the database, you do not have to. This is consistent with NoSQL where you are not obliged to have schemas upfront or at all.
At runtime, you can bring your own hypercube (or even a complete report schema) and retrieve the facts on the fly - all in real time.

## No table explosion
With the ROLAP paradigm, you need a table for each hypercube to store the measures. Additionally, you need one table for each hypercube and one table for each dimension to store the metadata.
With NoLAP, all you need is a single collection of measures (facts). And you might also want a single collection of components containing the hypercubes that are known in advance.
This is because NoSQL heterogeneity allows you to store facts with different dimension structures at the same place.
This is also because NoSQL's arborescence allows you to store the entire metadata (dimensions, ...) of a hypercube in a single object or tree.

## Dimension cardinality scale up
MOLAP (and also ROLAP because of its table explosion) do not scale up well with the number of dimensions.
With NoLAP, it does not matter how many dimensions you have.
There is very little performance penalty, because of NoSQL's heterogeneity.
You can even add more as you add new measures and hypercubes.
