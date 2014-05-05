import module namespace components = "http://xbrl.io/modules/bizql/components";
import module namespace hypercubes = "http://xbrl.io/modules/bizql/hypercubes";
import module namespace facts = "http://xbrl.io/modules/bizql/facts";
import module namespace csv = "http://zorba.io/modules/json-csv";

csv:serialize(
    let $component := components:components()[$$.Role = "http://www.tpc.org/tpch/customers"]
    let $hypercube := hypercubes:hypercubes-for-components($component)
    for $fact in facts:facts-for({
        Filter: {
            "Profiles.TPC-H.tpch:Nation": [ "PERU", "GERMANY" ]
        },
        Hypercube: $hypercube
    })
    return {|
        $fact.Aspects,
        { Value : $fact.Value }
    |}
)
