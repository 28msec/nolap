import module namespace facts = "http://xbrl.io/modules/bizql/facts";
import module namespace hypercubes = "http://xbrl.io/modules/bizql/hypercubes";

for $facts in facts:facts-for({
    Filter: {
        "Profiles.TPC-H.tpch:Nation": [ "PERU", "GERMANY" ]
    },
    Hypercube: hypercubes:dimensionless-hypercube({
        Concepts: ["tpch:CustomerName"]
    })
})
group by $nation := $facts.Profiles."TPC-H"."tpch:Nation"
return {
    nation: $nation,
    num-customers : count($facts)
}