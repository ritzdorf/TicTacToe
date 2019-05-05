pragma solidity ^0.4.24;
 
import "./Fields.sol";
import "./ERC20Interface.sol";

contract User is Fields {

   ERC20Interface internal KantiToken;

   address internal PlayerA;
   address internal PlayerB;
   mapping (address => uint8) internal playerSymbol;

   uint8 internal playerDefined = 0;

   function DefineUsers() public {
       require(endGame == true);
       require(PlayerB == 0x0000000000000000000000000000000000000000);
		
       if (PlayerA == 0x0000000000000000000000000000000000000000) {
           PlayerA = msg.sender;
           playerSymbol[PlayerA] = 1;
           playerDefined = 1;
			// check if tranfer allowed by sender
			if(!(KantiToken.allowance(msg.sender, this) > 0)) revert('Transfer not allowed!');
           //check if the transaction was received
			if(!KantiToken.transferFrom(msg.sender, this, uint256(100000000000000000))) revert('Transfer aborded!');
           // init fields
           for (uint8 i=0; i<=2; i++) {
               for (uint8 k=0; k<=2; k++) {
                   fields[i][k] = 0;
               }
           }
       }
       else if (PlayerA != msg.sender) {
           PlayerB = msg.sender;
           playerSymbol[PlayerB] = 2;
           playerDefined = 2;
           endGame = false;
			// check if tranfer allowed by sender
			if(!(KantiToken.allowance(msg.sender, this) > 0)) revert('Transfer not allowed!');
			//check if the transaction was received
           if(!KantiToken.transferFrom(msg.sender, this, uint256(100000000000000000))) revert('Transfer aborded!');
       }
		// revert will abord the function

   }

//needs a lock, so functions can't be called while game is still going on

   function getPlayerA() view public returns (address) {
       return PlayerA;
   }

   function getPlayerB() view public returns (address) {
       return PlayerB;
   }

}




