
const NousCore = artifacts.require("NousCore.sol");
const NousTokenTest = artifacts.require("NousTokenTest.sol");
const ActionManager = artifacts.require("ActionManager.sol");


contract('NousCore', async function (accounts) {

  let nousTokenInstance;
  let NOUSCoreInstance;
  let ActionManagerInstance;

  const initialParams = {

  };

  beforeEach(async function () {
    nousTokenInstance = await NousTokenTest.new();

    //deploy
    NOUSCoreInstance = await NousCore.new(nousTokenInstance.address);
    ActionManagerInstance = await ActionManager.new();
    console.log("ActionManagerInstance.address", ActionManagerInstance.address);

    //NOUSCoreInstance.addContract("action_manager", ActionManagerInstance.address);


  });

  it("Test Deploy all nous core contracts ", async function () {

  });



});
