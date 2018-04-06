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
      _endTimestamp: moment().add(5, 's').format("X"),
      _type: 0
    },
    {
      _id: 1,
      _startTimestamp: moment().add(2, 'days').format("X"),
      _endTimestamp: moment().add(3, 'days').format("X"),
      _type: 0
    },
    {
      _startTimestamp: moment().add(3, 'days').format("X"),
      _endTimestamp: moment().add(4, 'days').format("X"),
      _type: 1
    }
  ]

  const bonusPricingInitialParams = [
    {
      _bonusID: 1,
      _priceRateID: 0, // id 1
      _minPrice: 1,
      _maxPrice: 10,
      _bonusRatePercent: 10
    },{
      _bonusID: 1,
      _priceRateID: 1, // for update id 1
      _minPrice: 1,
      _maxPrice: 10,
      _bonusRatePercent: 20
    },{
      _bonusID: 1,
      _priceRateID: 0, // for update id 1
      _minPrice: 10,
      _maxPrice: 30,
      _bonusRatePercent: 50
    },

  ]

  let saleInstance;
  let tokenInstance;

  function validate(result, validateParams, num) {
    for (let i = 0; i < validateParams.length; i++) {
      //console.log("result[i][num].toNumber()", result[i][num].toNumber());
      assert.equal( validateParams[i], result[i][num].toNumber());
    }
  }

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

    // add first
    let validateParams = Object.values(bonusInitialParams[0]);
    await saleInstance.addBonus(...validateParams);
    let result = await saleInstance.getAllPeriodsBonuses.call();
    validate(result, validateParams, 0);

    //update firs
    validateParams = Object.values(bonusInitialParams[1]);
    await saleInstance.updateBonus(...validateParams);
    result = await saleInstance.getAllPeriodsBonuses.call();
    validateParams.shift();
    validate(result, validateParams, 0);

    //add second
    validateParams = Object.values(bonusInitialParams[2]);
    await saleInstance.addBonus(...validateParams);
    result = await saleInstance.getAllPeriodsBonuses.call();
    validate(result, validateParams, 1);

    // delete first
    await saleInstance.deleteBonus(1);
    result = await saleInstance.getAllPeriodsBonuses.call();
    assert.equal(result[0].length, 1, "Not Delete");

    assert.ok(true);
  });

  it("Add bonus pricing ", async function () {

    await saleInstance.addBonus(...Object.values(bonusInitialParams[0]));
    let validateParams = Object.values(bonusPricingInitialParams[0]);

    //set first percent
    await saleInstance.addUpdateBonusPricing(...validateParams);
    let result = await saleInstance.getAllBonusesForPeriod(1);
    validate(result, validateParams.slice(2), 0);

    //update first params
    validateParams = Object.values(bonusPricingInitialParams[1]);
    await saleInstance.addUpdateBonusPricing(...validateParams);
    result = await saleInstance.getAllBonusesForPeriod(1);
    validate(result, validateParams.slice(2), 0);

    //add second params
    validateParams = Object.values(bonusPricingInitialParams[2]);
    await saleInstance.addUpdateBonusPricing(...validateParams);
    result = await saleInstance.getAllBonusesForPeriod(1);
    validate(result, validateParams.slice(2), 1);

    assert.ok(true);
  });

  it("Get bonus rate", async function() {
    await saleInstance.addBonus(...Object.values(bonusInitialParams[0]));
    console.log("bonusInitialParams[0]", bonusInitialParams[0]);


    let validateParams = Object.values(bonusPricingInitialParams[0]);
    console.log("validateParams", validateParams);


    //set first percent
    await saleInstance.addUpdateBonusPricing(...validateParams);
    let result = await saleInstance.getAllBonusesForPeriod(1);
    validate(result, validateParams.slice(2), 0);

    //add second params
    validateParams = Object.values(bonusPricingInitialParams[2]);
    await saleInstance.addUpdateBonusPricing(...validateParams);
    result = await saleInstance.getAllBonusesForPeriod(1);
    validate(result, validateParams.slice(2), 1);

    const params = [
      {
        amount: 20,
        rate: 5
      }
    ];

    let bonuse = new Promise((resolve, reject) => {

      setTimeout(() => {
        // переведёт промис в состояние fulfilled с результатом "result"
        resolve(saleInstance.testGetBonusRate(...Object.values(params[0])));
      }, 2000);

    });

    let b = await bonuse;
    let summ = params[0].amount * params[0].rate;

    assert.equal(150, b.toNumber(), "Bonus is not correct ");
    console.log("bonus", b.toNumber());

  })





});



