#!/usr/bin/env node
'use strict';

const fs = require('fs');
const neo4j = require('neo4j-driver');

console.log( "€€€€€€€€€€ Loading euromillions data to Neo4j €€€€€€€€€!" );

var driver = neo4j.driver('bolt://localhost', neo4j.auth.basic('neo4j', 'euromillions'));

const query = 
' MERGE (number1:Number {value:$number1}) '   +
' MERGE (number2:Number {value:$number2}) '   +
' MERGE (number3:Number {value:$number3}) '   +
' MERGE (number4:Number {value:$number4}) '   +
' MERGE (number5:Number {value:$number5}) '   +
' MERGE (trekking:Trekking {value:$trekking}) ' +
' MERGE (number1)-[:DRAWN]->(trekking) '+
' MERGE (number2)-[:DRAWN]->(trekking) '+
' MERGE (number3)-[:DRAWN]->(trekking) '+
' MERGE (number4)-[:DRAWN]->(trekking) '+
' MERGE (number5)-[:DRAWN]->(trekking) '+
' RETURN number1' ;

let rawdata = fs.readFileSync('data/numbers.json');
let history = JSON.parse(rawdata);


print();

let session = driver.session();
let result = process().then(()=>{
    session.close();
    driver.close();
    console.log("Done");
});


async function process() {

    for (let trekking of history[0].result.Items) {
        var str = trekking.DrawnNumbers.split(":");
        var drawNumber = trekking.DrawNumber;
        console.log(str);
        var res = str[0].split(",");
        
            const params = {
                number1: res[0],
                number2: res[1],
                number3: res[2],
                number4: res[3],
                number5: res[4],
                trekking: drawNumber
            };
    
            await session
                .run(
                    query,
                    params
                )
                .then((result) => {
                    console.log("Saved");
                    return result;
                })
                .catch(error => {
                    console.log("Processing ERROR " + error);
    
                });
        
        

    }
}
  


async function print() {
    
    for (let trekking of history[0].result.Items) {
        var str = trekking.DrawnNumbers.split(":");
        var res = str[0].split(",");
        console.log(res);
    
    }
}
  