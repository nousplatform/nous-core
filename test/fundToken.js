//const web3 = require("web3");

var SampleCrowdsaleToken = artifacts.require("./SampleCrowdsaleToken.sol");

const _nousToken = "0x6142836bbc33a159f2503c132f255caa049392e0";

contract('Token', function (accounts) {

  const owner = accounts[0];
  const swindler = accounts[9];
  const user_1 = {address: accounts[1], balance: 0};
  const user_2 = {address: accounts[2], balance: 0};
  const user_3 = {address: accounts[3], balance: 0};

  const tokenInitialParams = {
    _name: "FundTKN",
    _symbol: "FTK",
    _decimals: 18
  }

  let tokenInstance;

  let initialBalances = [1000, 2000, 150, 500];

  //create new smart contract instance before each test method
  beforeEach(async function() {
    tokenInstance = await SampleCrowdsaleToken.new(...Object.values(tokenInitialParams));
  });

  it("Owner Mining tokens. Total supply cap.", async function () {

    await tokenInstance.mint(user_1.address, initialBalances[0], {from: owner});
    assert.equal((await tokenInstance.balanceOf(user_1.address)).toNumber(), user_1.balance += initialBalances[0], "Owner is first mining user_1 1000");

    await tokenInstance.mint(user_1.address, initialBalances[1], {from: owner});
    assert.equal((await tokenInstance.balanceOf(user_1.address)).toNumber(), user_1.balance += initialBalances[1], "Owner is second mining user_1 1000");

    await tokenInstance.mint(user_2.address, initialBalances[2], {from: owner});
    assert.equal((await tokenInstance.balanceOf(user_2.address)).toNumber(), user_2.balance += initialBalances[2], "Owner is second mining user_2 1000");

    await tokenInstance.mint(user_3.address, initialBalances[3], {from: owner});

    assert.equal((await tokenInstance.totalSupply.call()).toNumber(), initialBalances.reduce(function(a,b){return(a+b)}), "Total supply");
  });

  it("Swindler mining tokens", async function() {
    try {
      await tokenInstance.mint(user_2.address, initialBalances[0], {from: swindler});
    } catch(e) {
      assert.ok(true, "Swindler not mining tokens");
    }
    return false;
  });

  it("Initial Pausable tokens and transfer token", async function() {
    assert.equal(await tokenInstance.paused.call(), true, "initial paused");

    try {
      await tokenInstance.transfer(user_3.address, initialBalances[3], {from: user_1.address});
    } catch (e) {
      assert.ok(true);
    }

    return false;
  });

  it("Unpaused tokens transfer token", async function() {
    await tokenInstance.mint(user_1.address, initialBalances[0], {from: owner});
    await tokenInstance.mint(user_1.address, initialBalances[1], {from: owner});
    await tokenInstance.mint(user_2.address, initialBalances[2], {from: owner});

    await tokenInstance.unpause();
    assert.equal(await tokenInstance.paused.call(), false, "unpaused");

    try {
      await tokenInstance.transfer(user_3.address, initialBalances[3], {from: user_1.address});
    } catch (e) {
      //console.log("111", 111);
      assert.ok(true, e);
    }

    user_3.balance += initialBalances[3];
    user_1.balance -= initialBalances[3];

    assert.equal((await tokenInstance.balanceOf(user_3.address)).toNumber(), user_3.balance, "Transfer to user 3");
    assert.equal((await tokenInstance.balanceOf(user_1.address)).toNumber(), user_1.balance, "Transfer from user 1");
  });


  it("Finish mining. Try mining. Paused token and once unpaused", async function () {
    await tokenInstance.unpause();
    await tokenInstance.finishMinting();
    assert.equal(await tokenInstance.paused.call(), true, "paused");

    await tokenInstance.unpause();
    assert.equal(await tokenInstance.paused.call(), false, "not paused");

    try {
      await tokenInstance.pause();
      assert.fail();
    } catch (e) {
      assert.ok(true);
    }

    try {
      await tokenInstance.mint(user_1, 100);
      assert.fail();
    } catch (e) {
      assert.ok(true, "mining is not");
    }
  });

  it("Investors counter", async function() {
    await tokenInstance.mint(user_1.address, initialBalances[0], {from: owner});
    await tokenInstance.mint(user_1.address, initialBalances[1], {from: owner});
    await tokenInstance.mint(user_2.address, initialBalances[2], {from: owner});
    assert.equal((await tokenInstance.totalInvestors()).toNumber(), 2);

    await tokenInstance.mint(user_3.address, initialBalances[2], {from: owner});
    assert.equal((await tokenInstance.totalInvestors()).toNumber(), 3);
  });


});





