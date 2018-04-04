const Sale = artifacts.require("./Sale.sol");
const SampleCrowdsaleToken = artifacts.require("./SampleCrowdsaleToken.sol");
const moment = require("moment");

const _nousToken = "0x6142836bbc33a159f2503c132f255caa049392e0";

contract('Sale', function (accounts) {

  const saleInitialParams = {
    _owner: accounts[0],
    _totalSupplyCap: 100000,
    _retainedByCompany: 100,
    _walletAddress: accounts[9],
    _nousToken: _nousToken
  }

  const tokenInitialParams = {
    _name: "FundTKN",
    _symbol: "FTK",
    _decimals: 18
  }

  const saleAgentInitialParams = [
    {
      _tokensLimit: 1000,
      _minDeposit: 1,
      _maxDeposit: 100,
      _startTime: moment().format("X"),
      _endTime: moment().add(7, 'days').format("X"),
      _rate: 5
    }
  ]

  let saleInstance;
  let tokenInstance;

  //create new smart contract instance before each test method
  beforeEach(async function() {
    tokenInstance = await SampleCrowdsaleToken.new(...Object.values(tokenInitialParams));
    saleInstance = await Sale.new(...Object.values(saleInitialParams), tokenInstance.address);
    await tokenInstance.transferOwnership(saleInstance.address);
  });

  it("Set params sale agent", async function() {
    await saleInstance.setParamsSaleAgent(...Object.values(saleAgentInitialParams[0]));
    let getParams = await saleInstance.getSaleAgents.call();
    for (let i = 0; i < getParams.length; i++) {

      for (let el = 0; el < getParams[i].length; el++) {
        console.log("w", getParams[i][el].toNumber());
      }
    }

  })

  /*it("Validate token address", async function () {
    assert.equal(await saleInstance.tokenAddress.call(), tokenInstance.address, "sets is");
    try {
      await saleInstance.setParams(accounts[9]);
      assert.fail();
    } catch (e) {
      assert.ok(true);
    }
  });*/



  /*it("Re sets token address for mining tokens.", async function () {
    try {
      await saleInstance.constructor(tokenInstance.address, {from: accounts[1]});
      return false;
    } catch(e) {
      assert.ok(true);
    }
  });*/

  /*it("Sets params for sale agent", async function() {
    //saleInstance.
  })*/


});



