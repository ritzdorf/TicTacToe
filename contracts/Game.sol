pragma solidity ^0.4.24;
 
import "./Winner.sol";

contract Game is Winner {

   uint8 internal whichPlayer = 1;
   uint8 internal moveCount = 0;
   uint256 playTime = 0;


   event gameOver(
       address Winner,
       string message
   );

   event Error(string mistake); // is emitted if sb. won the gameOver

   function checkTime() public {
       if (!endGame && now > playTime + 10 minutes) {
           if (whichPlayer == PlayerA) {
               winner(PlayerB);
           }
           if (whichPlayer == PlayerB) {
               winner(PlayerA);
           }
       }
   }
	
	
	constructor(address _KantiToken) public {
	        KantiToken = ERC20Interface(_KantiToken);
   }
	

   function statusInit()  view public returns (uint8) {
       return playerDefined;

   }

   function whoseTurn() view public returns (uint8) {
       if (whichPlayer == 1) {
           return 1;
       }
       else {
           return 2;
       }
   }

   function checkWinner () view public returns (uint8) {
       if (endGame) {
           return helpWinner;
       }
       else {
           return 0;
       }
   }

	function whoAmI() view public returns (uint8) {
       if (PlayerA == msg.sender) {
           return 1;
       }
       else if (PlayerB == msg.sender) {
           return 2;
       }
       else{
           return 0;
       }
   }

   function getTime() view public returns (uint256) {
       return playTime;
   }


   function Play(uint8 i, uint8 k) public {
       require(playerDefined == 2);
       uint8 playerValue = playerSymbol[msg.sender];

       if (whichPlayer == playerValue) {
           if (fields[i-1][k-1] == 0) {

               fieldChange (i, k, playerSymbol[msg.sender]);

               if (msg.sender == PlayerA) {
                   whichPlayer = 2;
               }
               else {
                   whichPlayer = 1;
               }

               moveCount ++;
               playTime = now;
               //PlayerB is allowed to play now
               //checking if PlayerA has won:
               if (wonGameColumnk(playerValue, k) == true) {
                   winner(msg.sender);
               }
               if (wonGameRowi(playerValue, i) == true) {
                   winner(msg.sender);
               }
               if (wonGameDiagonal(playerValue) == true) {
                   winner(msg.sender);
               }
               if (moveCount == 9) {
                   winnerNobody();
               }
           }
           else {
               emit Error("field is already occupied");
           }
       }

       else {
           emit Error("it's not your turn yet");
       }

   } //function which is called by PlayerA to choose field i,k



   function reset() internal {
       endGame = true;
       playerDefined = 0;
       PlayerA = 0x0000000000000000000000000000000000000000;
       PlayerB = 0x0000000000000000000000000000000000000000;
       whichPlayer = 1;
       moveCount = 0;
   }

   function winner(address checkWinnerId) internal {
       emit gameOver(checkWinnerId, "has won the Game");

		if(!KantiToken.transfer(checkWinnerId, uint256(200000000000000000))) revert();
		
       if (checkWinnerId == PlayerA) {
           helpWinner = 1;
       }

       else {
           helpWinner = 2;
       }
       reset();

   }


   function winnerNobody() internal {
       helpWinner = 3;
		if(!KantiToken.transfer(PlayerA, uint256(100000000000000000))) revert();
		if(!KantiToken.transfer(PlayerB, uint256(100000000000000000))) revert();

       reset();
   }

}
