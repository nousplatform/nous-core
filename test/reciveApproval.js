const moment = require("moment");
const BigNumber = require('bignumber.js');

const Sale = artifacts.require("./Sale.sol");
const NousTokenTest = artifacts.require("./NousTokenTest.sol");
const SampleCrowdsaleToken = artifacts.require("./SampleCrowdsaleToken.sol");


contract('Sale', function (accounts) {



  let saleInstance;
  let tokenInstance;
  let nousTokenInstance;

  const saleInitialParams = {
    _owner: accounts[0],
    _totalSupplyCap: 100000,
    _retainedByCompany: 100,
    _walletAddress: accounts[9],
    //_nousToken: _nousToken
  };

  const saleAgentInitialParams = [{
      _tokensLimit: 1000,
      _minDeposit: 1,
      _maxDeposit: 100,
      _startTime: moment().subtract(1, 'days').format("X"),
      _endTime: moment().add(7, 'days').format("X"),
      _rate: 5
    }
  ];

  const tokenInitialParams = {
    _name: "FundTKN",
    _symbol: "FTK",
    _decimals: 18
  };

  let initialBalances = [1000 * Math.pow(10, 18), 2000 * Math.pow(10, 18) , 150 * Math.pow(10, 18), 500 * Math.pow(10, 18)];

  const user_1 = {address: accounts[1], balance: 0};
  const user_2 = {address: accounts[2], balance: 0};
  const user_3 = {address: accounts[3], balance: 0};

  //create new smart contract instance before each test method
  beforeEach(async function () {
    nousTokenInstance = await NousTokenTest.new();
    saleInitialParams._nousToken = nousTokenInstance.address; // добавить ноус токен адрес

    tokenInstance = await SampleCrowdsaleToken.new(...Object.values(tokenInitialParams));
    saleInstance = await Sale.new(...Object.values(saleInitialParams), tokenInstance.address);

    await tokenInstance.transferOwnership(saleInstance.address);
  });

  it("Test receive approval ", async function () {

    let validateObj = Object.values(saleAgentInitialParams[0]);
    await saleInstance.setParamsSaleAgent(...validateObj);
    let _paramsSale = await saleInstance.getSaleAgents();
    console.log("_paramsSale", _paramsSale);

    await nousTokenInstance.mint(user_1.address, initialBalances[0], {from: accounts[0]});
    user_1.balance = initialBalances[0];
    await nousTokenInstance.mint(user_2.address, initialBalances[1], {from: accounts[0]});
    user_2.balance = initialBalances[1];
    await nousTokenInstance.mint(user_3.address, initialBalances[2], {from: accounts[0]});
    user_3.balance = initialBalances[2];

    assert.equal(user_1.balance, (await nousTokenInstance.balanceOf(user_1.address, {from: accounts[0]})).toNumber(), "Owner is first mining user_1 1000");

    let sum = 99 * Math.pow(10, 18);

    await nousTokenInstance.approveAndCall(saleInstance.address, sum, {from: user_1.address});

    assert.equal(sum, (await nousTokenInstance.balanceOf(accounts[9])).toNumber(), "balance token is current");
    assert.equal(sum * saleAgentInitialParams[0]._rate, (await tokenInstance.balanceOf(user_1.address)).toNumber(), "balance token is current");

    //console.log("test", test);

  });



});
