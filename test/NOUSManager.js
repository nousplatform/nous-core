
const NOUSManager = artifacts.require("NOUSManager.sol");


contract('NOUSManager', async function (accounts) {

  let NOUSManagerInstance;

  const initialParams = {

  };

  beforeEach(async function () {
    NOUSManagerInstance = await NOUSManager.new();

  });



});
