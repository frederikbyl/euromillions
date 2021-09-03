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
' MERGE (previous1:Number {value:$previous1}) '   +
' MERGE (previous2:Number {value:$previous2}) '   +
' MERGE (previous3:Number {value:$previous3}) '   +
' MERGE (previous4:Number {value:$previous4}) '   +
' MERGE (previous5:Number {value:$previous5}) '   +
' MERGE (previous1)<-[r1:FOLLOWED_BY]-(number1)' +

' ON CREATE SET r1.value = 1 ' +
' ON MATCH SET r1.value = r1.value +1 '+
' MERGE (previous1)<-[r2:FOLLOWED_BY]-(number2)' +
' ON CREATE SET r2.value = 1 ' +
' ON MATCH SET r2.value = r2.value +1 '+
' MERGE (previous1)<-[r3:FOLLOWED_BY]-(number3)' +
' ON CREATE SET r3.value = 1 ' +
' ON MATCH SET r3.value = r3.value +1 '+
' MERGE (previous1)<-[r4:FOLLOWED_BY]-(number4)' +
' ON CREATE SET r4.value = 1 ' +
' ON MATCH SET r4.value = r4.value +1 '+
' MERGE (previous1)<-[r5:FOLLOWED_BY]-(number5)' +
' ON CREATE SET r5.value = 1 ' +
' ON MATCH SET r5.value = r5.value +1 '+

' MERGE (previous1)<-[r6:FOLLOWED_BY]-(number1)' +
' ON CREATE SET r6.value = 1 ' +
' ON MATCH SET r6.value = r6.value +1 '+
' MERGE (previous1)<-[r7:FOLLOWED_BY]-(number2)' +
' ON CREATE SET r7.value = 1 ' +
' ON MATCH SET r7.value = r7.value +1 '+
' MERGE (previous1)<-[r8:FOLLOWED_BY]-(number3)' +
' ON CREATE SET r8.value = 1 ' +
' ON MATCH SET r8.value = r8.value +1 '+
' MERGE (previous1)<-[r9:FOLLOWED_BY]-(number4)' +
' ON CREATE SET r9.value = 1 ' +
' ON MATCH SET r9.value = r9.value +1 '+
' MERGE (previous1)<-[r10:FOLLOWED_BY]-(number5)' +
' ON CREATE SET r10.value = 1 ' +
' ON MATCH SET r10.value = r10.value +1 '+

' MERGE (previous2)<-[r11:FOLLOWED_BY]-(number1)' +
' ON CREATE SET r11.value = 1 ' +
' ON MATCH SET r11.value = r11.value +1 '+
' MERGE (previous2)<-[r12:FOLLOWED_BY]-(number2)' +
' ON CREATE SET r12.value = 1 ' +
' ON MATCH SET r12.value = r12.value +1 '+
' MERGE (previous2)<-[r13:FOLLOWED_BY]-(number3)' +
' ON CREATE SET r13.value = 1 ' +
' ON MATCH SET r13.value = r13.value +1 '+
' MERGE (previous2)<-[r14:FOLLOWED_BY]-(number4)' +
' ON CREATE SET r14.value = 1 ' +
' ON MATCH SET r14.value = r14.value +1 '+
' MERGE (previous2)<-[r15:FOLLOWED_BY]-(number5)' +
' ON CREATE SET r15.value = 1 ' +
' ON MATCH SET r15.value = r15.value +1 '+

' MERGE (previous3)<-[r16:FOLLOWED_BY]-(number1)' +
' ON CREATE SET r16.value = 1 ' +
' ON MATCH SET r16.value = r16.value +1 '+
' MERGE (previous3)<-[r17:FOLLOWED_BY]-(number2)' +
' ON CREATE SET r17.value = 1 ' +
' ON MATCH SET r17.value = r17.value +1 '+
' MERGE (previous3)<-[r18:FOLLOWED_BY]-(number3)' +
' ON CREATE SET r18.value = 1 ' +
' ON MATCH SET r18.value = r18.value +1 '+
' MERGE (previous3)<-[r19:FOLLOWED_BY]-(number4)' +
' ON CREATE SET r19.value = 1 ' +
' ON MATCH SET r19.value = r19.value +1 '+
' MERGE (previous3)<-[r20:FOLLOWED_BY]-(number5)' +
' ON CREATE SET r20.value = 1 ' +
' ON MATCH SET r20.value = r20.value +1 '+

' MERGE (previous4)<-[r21:FOLLOWED_BY]-(number1)' +
' ON CREATE SET r21.value = 1 ' +
' ON MATCH SET r21.value = r21.value +1 '+
' MERGE (previous4)<-[r22:FOLLOWED_BY]-(number2)' +
' ON CREATE SET r22.value = 1 ' +
' ON MATCH SET r22.value = r22.value +1 '+
' MERGE (previous4)<-[r23:FOLLOWED_BY]-(number3)' +
' ON CREATE SET r23.value = 1 ' +
' ON MATCH SET r23.value = r23.value +1 '+
' MERGE (previous4)<-[r24:FOLLOWED_BY]-(number4)' +
' ON CREATE SET r24.value = 1 ' +
' ON MATCH SET r24.value = r24.value +1 '+
' MERGE (previous4)<-[r25:FOLLOWED_BY]-(number5)' +
' ON CREATE SET r25.value = 1 ' +
' ON MATCH SET r25.value = r25.value +1 '+

' MERGE (previous5)<-[r26:FOLLOWED_BY]-(number1)' +
' ON CREATE SET r26.value = 1 ' +
' ON MATCH SET r26.value = r26.value +1 '+
' MERGE (previous5)<-[r27:FOLLOWED_BY]-(number2)' +
' ON CREATE SET r27.value = 1 ' +
' ON MATCH SET r27.value = r27.value +1 '+
' MERGE (previous5)<-[r28:FOLLOWED_BY]-(number3)' +
' ON CREATE SET r28.value = 1 ' +
' ON MATCH SET r28.value = r28.value +1 '+
' MERGE (previous5)<-[r29:FOLLOWED_BY]-(number4)' +
' ON CREATE SET r29.value = 1 ' +
' ON MATCH SET r29.value = r29.value +1 '+
' MERGE (previous5)<-[r30:FOLLOWED_BY]-(number5)' +
' ON CREATE SET r30.value = 1 ' +
' ON MATCH SET r30.value = r30.value +1 '+
' RETURN number1' ;

let rawdata = fs.readFileSync('data/fullhistory.json');
let history = JSON.parse(rawdata);


print();
/*
let session = driver.session();
let result = process().then(()=>{
    session.close();
    driver.close();
    console.log("Done");
});
*/

async function process() {
    let previous1=-1;
    let previous2=-1;
    let previous3=-1;
    let previous4=-1;
    let previous5=-1;
    for (let trekking of history[0].result.Items) {
        var str = trekking.DrawnNumbers.split(":");
        var res = str[0].split(",");
        if(previous1>0) {
            const params = {
                number1: res[0],
                number2: res[1],
                number3: res[2],
                number4: res[3],
                number5: res[4],
                previous1: previous1,
                previous2: previous2,
                previous3: previous3,
                previous4: previous4,
                previous5: previous5,
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
        
        previous1 = res[0];
        previous2 = res[1];
        previous3 = res[2];
        previous4 = res[3];
        previous5 = res[4];

    }
}
  


async function print() {
    
    for (let trekking of history[0].result.Items) {
        var str = trekking.DrawnNumbers.split(":");
        var res = str[0].split(",");
        console.log(res);
    
    }
}
  