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



--get latest trekking that number was chosen
match (t:Trekking {value:1374}) 
with t
match (n:Number)
with t,n
match (t2:Trekking)--(n)
where t2.value <t.value
return t.value, n.value, t.value-max(t2.value)+1


--get prediction for each number based on number of times delta happened in the past:
match (t:Trekking {value:1374}) 
with t
match (n:Number)
with t,n
match (t2:Trekking)--(n)
where t2.value <t.value
with t.value as trekking, n.value as number, t.value-max(t2.value)+1 as latest
match (:Number{value:number})--(t3:Trekking)
with trekking, number,  latest, count( t3) as total
match (:Number{value:number})--(t4:Trekking)-[r]-(t5:Trekking)--(:Number{value:number})
where r.value = latest and t4.value<t5.value
and t5.value < t.value
return trekking, number, latest, count(t4), total, count(t4)/toFloat(total) order by number

--merge prediction for a trekking
match (t:Trekking {value:1374}) 
with t
match (n:Number)
with t,n
match (t2:Trekking)--(n)
where t2.value <t.value
with t, n, t.value-max(t2.value)+1 as latest
match (n)--(t3:Trekking)
where t3.value < t.value
with t, n,  latest, count( t3) as total
match (n)--(t4:Trekking)-[r]-(t5:Trekking)--(n)
where r.value = latest and t4.value<t5.value
and t5.value < t.value
with t, n, latest, total, count(t4)/toFloat(total) as prediction
MERGE (t6:Trekking {value:t.value+1})
MERGE (t)-[:NEXT]->(t6)
MERGE (t6)-[:PREDICTION {value:prediction}]-(n) 

CALL apoc.periodic.iterate('match (t:Trekking) where t.value >1000 return t','
match (n:Number)
with t,n
match (t2:Trekking)--(n)
where t2.value <t.value
with t, n, t.value-max(t2.value)+1 as latest
match (n)--(t3:Trekking)
where t3.value < t.value
with t, n,  latest, count( t3) as total
match (n)--(t4:Trekking)-[r]-(t5:Trekking)--(n)
where r.value = latest and t4.value<t5.value
and t5.value < t.value
with t, n, latest, total, count(t4)/toFloat(total) as prediction
MERGE (t6:Trekking {value:t.value+1})
MERGE (t)-[:NEXT]->(t6)
MERGE (t6)-[:PREDICTION {value:prediction}]-(n)',
{batchSize:1, iterateList:false}) 


-- hoeveel van de getrokken, zijn nu best prediction
match (t:Trekking)-[p:PREDICTION]-()
with t, max (p.value) as best
match (y:Number)-[p1:PREDICTION]-(t)-[:DRAWN]-(y)
where p1.value = best
return t.value, y.value, p1.value order by t.value

--best of 5
match (t:Trekking)-[p:PREDICTION]-()
with t, p.value as predictions order by predictions desc
with t, collect (predictions) as best
match (y:Number)-[p1:PREDICTION]-(t)-[:DRAWN]-(y)
where p1.value in best[0..5]
return t.value, y.value, p1.value order by t.value

-- overview
match (n:Number)-[:DRAWN]-(t:Trekking)-[p:PREDICTION]-(n)
return t.value, n.value, p.value order by t.value desc


--is there a trekking that resembles very much at another trekking? calculate similarity based on predictions
match (t1:Trekking {value:1021} )-[p:PREDICTION]-(n:Number)
with t1, p.value as prediction1 order by prediction1
with t1, collect (prediction1) as vector1
with t1, vector1
match (t2:Trekking {value:1304})-[p2:PREDICTION]-(n2:Number)
with t1, vector1, t2, p2.value as prediction2
with t1, vector1,  t2.value as t2, collect (prediction2) as vector2
return t1.value, t2,  gds.alpha.similarity.cosine(vector1, vector2) AS similarity



match (t:Trekking)-[p:PREDICTION]-(n:Number) 
with t, n, max (p.value) as best
match (n)-[p1:PREDICTION]-(t)-[:DRAWN]-(n)
where p1.value = best
return t.value, n.value, p1.value order by t.value

match (t:Trekking)-[p:PREDICTION]-(n:Number) 
return t, n, max (p.value) as best
match (y:Number)-[p1:PREDICTION]-(t)-[:DRAWN]-(y)
where p1.value = best
return t.value, y.value, p1.value order by t.value

match (t:Trekking {value:1376} )-[r]-(n:Number) return t.value,n.value,collect(type(r)), collect (r.value)

--cosine similarity
match (t1:Trekking {value:1021} )-[p:PREDICTION]-(n:Number)
with t1, p.value as prediction1 order by prediction1
with t1, collect (prediction1) as vector1
with t1, vector1
match (t2:Trekking {value:1304})-[p2:PREDICTION]-(n2:Number)
with t1, vector1, t2, p2.value as prediction2
with t1, vector1,  t2.value as t2, collect (prediction2) as vector2
return t1.value, t2,  gds.alpha.similarity.cosine(vector1, vector2) AS similarity