
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
    //ActionManagerInstance = await ActionManager.new();
    //console.log("ActionManagerInstance.address", ActionManagerInstance.address);

    console.log("action_manager", await NOUSCoreInstance.contracts("action_manager"));
    console.log("action_db", await NOUSCoreInstance.contracts("action_db"));
    console.log("owner", await NOUSCoreInstance.owner.call());


   //let res = await NOUSCoreInstance.addContract("action_manager", ActionManagerInstance.address);
   //console.log("res", res);


  });

  it("Test Deploy all nous core contracts ", async function () {
    let permAddr = ""///;
    let actionManagerAddress = await NOUSCoreInstance.contracts("action_manager");
    await ActionManager.at(actionManagerAddress).execute("ActionAddAction", (bytes4(sha3("execute(bytes32, address)")), "action_set_action_permission", permAddr));

    //assert.equal()
    // console.log("action_manager", await NOUSCoreInstance.contracts("action_manager"));
    // console.log("action_db", await NOUSCoreInstance.contracts("action_db"));
    // console.log("owner", await NOUSCoreInstance.owner.call());
  });



});
