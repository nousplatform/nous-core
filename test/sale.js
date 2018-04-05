const Sale = artifacts.require("./Sale.sol");
const SampleCrowdsaleToken = artifacts.require("./SampleCrowdsaleToken.sol");
const moment = require("moment");

const _nousToken = "0x6142836bbc33a159f2503c132f255caa049392e0";
const tokenDecimals = 18;

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
  ];

  const bonusInitialParams = [
    {
      _startTimestamp: moment().format("X"),
      _endTimestamp: moment().add(1, 'days').format("X"),
      _type: 0
    },
    {
      _id: 1,
      _startTimestamp: moment().add(2, 'days').format("X"),
      _endTimestamp: moment().add(3, 'days').format("X"),
      _type: 0
    }
  ]

  const bonusPricingInitialParams = [
    {
      _bonusID: 1,
      _priceRateID: 0, // id 1
      _minPrice: 1,
      _maxPrice: 10,
      _bonusRate: 2
    },{
      _bonusID: 1,
      _priceRateID: 1, // for update id 1
      _minPrice: 1,
      _maxPrice: 20,
      _bonusRate: 3
    },
  ]

  let saleInstance;
  let tokenInstance;

  //create new smart contract instance before each test method
  beforeEach(async function () {
    tokenInstance = await SampleCrowdsaleToken.new(...Object.values(tokenInitialParams));
    saleInstance = await Sale.new(...Object.values(saleInitialParams), tokenInstance.address);
    await tokenInstance.transferOwnership(saleInstance.address);
  });

  it("Set params sale agent", async function () {
    let validateObj = Object.values(saleAgentInitialParams[0]);
    await saleInstance.setParamsSaleAgent(...validateObj);
    let _params = await saleInstance.getSaleAgents();

    for (let i = 0; i < validateObj.length; i++) {
      for (let el = 0; el < _params[i].length; el++) {
        let result;

        if (_params[i][el].e >= 10) {
          result = _params[i][el].toNumber() / Math.pow(10, tokenDecimals);
        }
        else {
          result = _params[i][el].toNumber();
        }
        assert.equal(validateObj[i], result);
      }
    }
  });

  it("Finish mining", async function() {
    await saleInstance.finalise();
    assert.equal(await saleInstance.finalizeICO.call(), true, "Ico finalize");
    assert.equal(await tokenInstance.mintingFinished.call(), true, "Token is finalize");
  });

  it("Testing CRUD bonuses", async function() {

    function validate(result, validateParams, num) {
      for (let i = 0; i < validateParams.length; i++) {
        assert.equal(result[i][num].toNumber(), validateParams[i]);
      }
    }

    let validateParams = Object.values(bonusInitialParams[0]);
    await saleInstance.addBonus(...validateParams);
    let result = await saleInstance.getAllPeriodsBonuses.call();
    validate(result, validateParams, 0);

     validateParams = Object.values(bonusInitialParams[1]);
     await saleInstance.updateBonus(...validateParams);
     result = await saleInstance.getAllPeriodsBonuses.call();
     validateParams.shift();

     validate(result, validateParams, 0);
     await saleInstance.deleteBonus(1);
     result = await saleInstance.getAllPeriodsBonuses.call();
     assert.equal(result[0].length, 0, "Not Delete");
     assert.ok(true);
  });

  it("Add bonus pricing ", async function () {
    //await saleInstance.addUpdateBonusPricing(...validateParams);

  });

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



