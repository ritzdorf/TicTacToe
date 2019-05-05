const KantiCoin = artifacts.require("KantiCoin");

// Add a shortcut
const BN = web3.utils.BN;

// Number of Decimals
const decimals = 18;

// Used Name
const name = "KantiCoin";

// Used Symbol
const symbol = "KANTI";

contract('KantiCoin', (accounts) => {
  it('should put 100 KantiCoin in the first account', async () => {
    const kantiCoinInstance = await KantiCoin.new(100, name, symbol, {from: accounts[0]});
    const balance = await kantiCoinInstance.balanceOf.call(accounts[0]);
    let expectedBalance = toTokenWei(100);

    // Use equality function of BN
    assert(balance.valueOf().eq(expectedBalance), "The account did not receive the correct token balance. Expected " + expectedBalance.toString() + ", but got: " + balance.valueOf().toString());
  });


  it('should use the right symbol', async () => {
    const kantiCoinInstance = await KantiCoin.new(100, name, symbol, {from: accounts[0]});
    const usedSymbol = await kantiCoinInstance.symbol.call();

    assert.equal(usedSymbol, symbol, "The symbol was set correctly.");
  });


  it('should use the right name', async () => {
    const kantiCoinInstance = await KantiCoin.new(100, name, symbol, {from: accounts[0]});
    const usedName = await kantiCoinInstance.name.call();

    assert.equal(usedName, name, "The name was set correctly.");
  });


  it('should send coins correctly', async () => {
    const kantiCoinInstance = await KantiCoin.new(100, name, symbol, {from: accounts[0]});

    // Use 2 accounts.
    const accountOne = accounts[0];
    const accountTwo = accounts[1];

    // Get initial balances of first and second account.
    const accountOneStartingBalance = await kantiCoinInstance.balanceOf.call(accountOne);
    const accountTwoStartingBalance = await kantiCoinInstance.balanceOf.call(accountTwo);

    // Make transaction from first account to second.
    const amount = toTokenWei(10);
    await kantiCoinInstance.transfer(accountTwo, amount, { from: accountOne });

    // Get balances of first and second account after the transactions.
    const accountOneEndingBalance = await kantiCoinInstance.balanceOf.call(accountOne);
    const accountTwoEndingBalance = await kantiCoinInstance.balanceOf.call(accountTwo);

    assert(accountOneEndingBalance.eq(accountOneStartingBalance.sub(amount)), "Amount wasn't correctly taken from the sender");
    assert(accountTwoEndingBalance.eq(accountTwoStartingBalance.add(amount)), "Amount wasn't correctly sent to the receiver");
  });

  // Converts a "normal" number of tokens to the correct number including decimals
  function toTokenWei(num){
    // Compute 10**decimals
    let multiplier = new BN(10).pow(new BN(decimals));
    // Compute the number of Wei 
    return new BN(num).mul(multiplier); 
  }

});
