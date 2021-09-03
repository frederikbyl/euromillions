match (n)-[r]->(m) 
where n.value in [ '9', '14', '21', '32', '44' ]
with n.value as nvalue, m.value +" "+r.value as mvalue, toInteger(r.value) as rvalue
ORDER BY rvalue desc
return nvalue,collect (distinct mvalue)

match (n)-[r]->(m) 
where n.value in [ '9', '14', '21', '32', '44' ]
with n.value as nvalue, m.value +" "+r.value as mvalue, toInteger(r.value) as rvalue
ORDER BY mvalue 
return nvalue,collect (distinct mvalue)


--stream to gephi
match path = (m)-[r]->(n)
WITH path 
with collect(path) as paths
call apoc.gephi.add(null,'workspace1', paths) yield nodes, relationships, time
return nodes, relationships, time




--4 recurring over 2 trekkingen
match (t1:Trekking)
match (t1)--(n1:Number)
match (t1)--(n2:Number)
where n1.value < n2.value
with t1,n1,n2
match (t1)--(n3:Number)
where n1.value < n3.value and  n2.value < n3.value
with t1,n1,n2,n3
match (t1)--(n4:Number)
where n1.value < n4.value and  n2.value < n4.value and  n3.value < n4.value
with t1,n1,n2,n3,n4
match (n1)--(t2:Trekking)--(n2), (n3)--(t2)--(n4)
where t1.value < t2.value
return t1.value, t2.value, n1.value,n2.value,n3.value,n4.value

-- most selected numbers
match (n:Number)--(t:Trekking)
return distinct n, count (t) as occ order by occ desc

--nummers die dikwijls in opeenvolgende trekkingen worden getrokken
match (t1:Trekking)--(n:Number)--(t2:Trekking) where t1.value = t2.value + 1 return distinct  n.value, count (n) as occ order by occ desc


--hoeveel trekking voor een getal terug wordt getrokken
match (n:Number)--(t:Trekking)
with n,t
match (t2:Trekking)--(n)
where t2.value < t.value
with max(t2.value) as currentMax,n,t
match (t3:Trekking)--(n)
where t3.value = currentMax
merge (t)<-[:NEXT{value:t.value-t3.value}]-(t3)

match (n:Number)--(t:Trekking)-[r]-(t2:Trekking)--(n)
where n.value = 4  and t.value > t2.value
return t.value, t2.value, r.value order by t.value desc

--per nummer gaan kijken wat de kans is dat hij nu getrokken wordt op basis van de laatste keer dat hij getrokken is.
-- hoe lang is het geleden dat die getrokken is, hoeveel is het verschil met de laatste trekking en als hij nu gaat getrokken worden. 
-- hoeveel percent is dat ten opzichte van alle getrokken: 

match (n:Number)--(t:Trekking)-[r]-(t2:Trekking)--(n)
where n.value =1  and t.value > t2.value
return  distinct r.value, count (t.value) as occ order by occ desc

match (n:Number)
with n
match (t:Trekking)--(n)
return distinct n.value as number, 1372-max (t.value) order by number


match (n:Number)--(t:Trekking)
return distinct n.value as number, count (t)


--5 hoogste van hoeveel trekkingen ertussen zitten totdat een getal opnieuw getrokken wordt
match (n1:Number)
with n1
match (n:Number)--(t:Trekking)-[r]-(t2:Trekking)--(n)
where n.value = n1.value 
and t.value > t2.value
with  distinct r.value as value, count (t.value) as occ, n.value as number order by occ desc
return  number,collect (value) order by number


--wat gebeurt er als een cijfer binnen de 2 trekkingen terug getrokken is?
match (n:Number)-[rr1]-(t1:Trekking)-[r:NEXT]-(t2:Trekking)-[rr2]-(n)
where r.value = 2 
return t1,t2,r,rr1,rr2,n




--voeg nieuwe trekking toe 
MERGE (number1:Number {value:24}) 
MERGE (number2:Number {value:27}) 
MERGE (number3:Number {value:28}) 
MERGE (number4:Number {value:29}) 
MERGE (number5:Number {value:42}) 
MERGE (trekking:Trekking {value:1376}) 
MERGE (number1)-[:DRAWN]->(trekking) 
MERGE (number2)-[:DRAWN]->(trekking) 
MERGE (number3)-[:DRAWN]->(trekking) 
MERGE (number4)-[:DRAWN]->(trekking) 
MERGE (number5)-[:DRAWN]->(trekking) 
RETURN number1' ;


match (n:Number)--(t:Trekking)
where t.value=1376
with n,t
match (t2:Trekking)--(n)
where t2.value < t.value
with max(t2.value) as currentMax,n,t
match (t3:Trekking)--(n)
where t3.value = currentMax
merge (t)<-[:NEXT{value:t.value-t3.value}]-(t3)