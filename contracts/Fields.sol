pragma solidity ^0.4.24;
 
contract Fields {
   //if someone wants to choose a field, we need to make sure that it isn't occupied yet
   // i describes the row, k the column

   uint8 [3][3] internal fields;
   bool internal endGame = true; // true means game has already ended (default Value is true)
   string internal winnerOfGame = "";

   function fieldChange (uint8 i, uint8 k, uint8 value) internal { //not sure if I used enum correctly here
       fields[i-1][k-1] = value;
   } //this function is called when sb. wants to choose a field

   function getFieldValue(uint8 i, uint8 k) view public returns (uint8) {
       return fields[i-1][k-1];
   }

   function getAllFieldValues() view public returns (uint256) {
       uint8 i;
       uint8 k;
       uint256 result=0;
       uint256 position=0;
       for (i=0; i<=2; i++) {
           for (k=0; k<=2; k++) {
               result = result + (fields[i][k] * (10**position));
               position++;
           }
       }

       return result;
   }


}

