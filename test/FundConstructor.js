const FundConstructor = artifacts.require("FundConstructor.sol");

contract('FundConstructor', async function (accounts) {

  let fundConstructorInstance;

  const initialParams = {

  };

  beforeEach(async function () {
    fundConstructorInstance = await FundConstructor.new();

  });


})
