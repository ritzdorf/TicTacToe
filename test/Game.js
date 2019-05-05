const KantiCoin = artifacts.require("KantiCoin");
const Game = artifacts.require("Game");

// Add a shortcut
const BN = web3.utils.BN;

// Number of Decimals
const decimals = 18;

// Used Name
const name = "KantiCoin";

// Used Symbol
const symbol = "KANTI";

contract('Game', (accounts) => {
  it('start a game', async () => {
    // Use 2 players.
    const playerOne = accounts[0];
    const playerTwo = accounts[1];

    const kantiCoinInstance = await KantiCoin.new(100, name, symbol, {from: accounts[0]});
    // Create game
    const game = await Game.new(kantiCoinInstance.address);

    // Transfer some tokens to the second account
    const amount = toTokenWei(3);
    await kantiCoinInstance.transfer(playerTwo, amount, { from: playerOne});

    // Make allowances
    await kantiCoinInstance.approve(game.address, amount, { from: playerOne});
    await kantiCoinInstance.approve(game.address, amount, { from: playerTwo});

    await game.DefineUsers({from: playerOne});
    await game.DefineUsers({from: playerTwo});

    const idOne = await game.whoAmI.call({from: playerOne});
    assert.equal(idOne, 1, "The id of playerOne is not correct.");

    const idTwo = await game.whoAmI.call({from: playerTwo});
    assert.equal(idTwo, 2, "The id of playerTwo is not correct.");

  });


  // Converts a "normal" number of tokens to the correct number including decimals
  function toTokenWei(num){
    // Compute 10**decimals
    let multiplier = new BN(10).pow(new BN(decimals));
    // Compute the number of Wei 
    return new BN(num).mul(multiplier); 
  }

});
