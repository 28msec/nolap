import module namespace facts = "http://xbrl.io/modules/bizql/facts";
import module namespace hypercubes = "http://xbrl.io/modules/bizql/hypercubes";

let $hypercube := hypercubes:user-defined-hypercube({
    "xbrl:Period": {
        Domain: [ "1996-01-02T00:00:00Z" ]
    },
    "tpch:LineNumber": {},
    "xbrl:Concept": {
        Domain: ["tpch:LineItemShipDate","tpch:LineItemReturnFlag","tpch:LineItemLineStatus",
                 "tpch:LineItemQuantity","tpch:LineItemExtendedPrice","tpch:LineItemDiscount","tpch:LineItemTax"]
    }
})
let $covered-aspects := ($facts:CONCEPT, $facts:UNIT)
let $lineitems :=
    for $facts in hypercubes:facts($hypercube)[position() lt 10] 
    group by $canonical-filter-string := facts:canonically-serialize-object($facts.$facts:ASPECTS, $covered-aspects)
    return {
        linenumber: $facts[1]."tpch:LineNumber",
        shipdate: $facts[$$.$facts:ASPECTS.$facts:CONCEPT eq "tpch:LineItemShipDate"].Value,
        returnflag: $facts[$$.$facts:ASPECTS.$facts:CONCEPT eq "tpch:LineItemReturnFlag"].Value,
        linestatus: $facts[$$.$facts:ASPECTS.$facts:CONCEPT eq "tpch:LineItemLineStatus"].Value,
        quantity: $facts[$$.$facts:ASPECTS.$facts:CONCEPT eq "tpch:LineItemQuantity"].Value,
        extprice : $facts[$$.$facts:ASPECTS.$facts:CONCEPT eq "tpch:LineItemExtendedPrice"].Value,
        discount: $facts[$$.$facts:ASPECTS.$facts:CONCEPT eq "tpch:LineItemDiscount"].Value,
        tax :$facts[$$.$facts:ASPECTS.$facts:CONCEPT eq "tpch:LineItemTax"].Value
    }
for $lineitem in $lineitems
group by $returnflag := $lineitem.returnflag,
         $linestatus := $lineitem.linestatus
order by $returnflag, $linestatus
return {
    returnflag : $returnflag,
    linestatus : $linestatus,
    sum_qty : sum($lineitem.quantity),
    sum_base_price : sum($lineitem.extprice),
    sum_disc_price : sum($lineitem ! ($$.extprice * (1 - $$.discount))),
    sum_charge : sum($lineitem ! ($$.extprice * (1 - $$.discount) * (1 + $$.tax))),
    avg_qty : avg($lineitem.quantity),
    avg_extendedprice : avg($lineitem.extprice),
    avg_disc : avg($lineitem.discount),
    count_order : count($lineitem)
}