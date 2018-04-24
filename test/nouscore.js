const Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const NousCore = artifacts.require("NousCore.sol");
const NousTokenTest = artifacts.require("NousTokenTest.sol");
const ActionManager = artifacts.require("ActionManager.sol");
const ActionDb = artifacts.require("ActionDb.sol");
const PermissionsDb = artifacts.require("PermissionsDb.sol");

const testInitialParams = {
  action: "ActionAddAction",
  methodParam: "execute(bytes32, addr)",
  data: ["ActionSetActionPermission", "0x1"]
}

function callToFunction(param = testInitialParams) {
  let str = web3.utils.sha3(param.methodParam).substr(0,10);
  web3.utils.hexToBytes('0x000000ea');
}


contract('NousCore', async function (accounts) {

  let nousTokenInstance;
  let NOUSCoreInstance;
  let ActionManagerInstance;
  let ActionDbInstance;
  let PermissionsDbInstance;

  const initialParams = {

  };

  beforeEach(async function () {
    nousTokenInstance = await NousTokenTest.new();

    //deploy
    NOUSCoreInstance = await NousCore.new(nousTokenInstance.address);
    ActionManagerInstance = await ActionManager.new();
    ActionDbInstance = await ActionDb.new();

    NOUSCoreInstance.addContract("ActionManager", ActionManagerInstance.address);
    NOUSCoreInstance.addContract("ActionDb", ActionDbInstance.address);

    //assert.equal(ActionManagerInstance.address, await NOUSCoreInstance.contracts("action_manager"));

    //console.log("ActionManagerInstance.address", ActionManagerInstance.address);

    //console.log("action_manager", await NOUSCoreInstance.contracts("action_manager"));
    //console.log("action_db", await NOUSCoreInstance.contracts("action_db"));
    console.log("owner", await NOUSCoreInstance.owner.call());


   //let res = await NOUSCoreInstance.addContract("action_manager", ActionManagerInstance.address);
   //console.log("res", res);
  });

  it("Test Deploy all nous core contracts ", async function () {

    //console.log("ActionDbInstance.getAction()", await ActionDbInstance.getAction("ActionAddAction"));

    assert.equal(ActionManagerInstance.address, await NOUSCoreInstance.contracts("ActionManager"));
    assert.equal(ActionDbInstance.address, await NOUSCoreInstance.contracts("ActionDb"));

    //console.log("await NOUSCoreInstance.contracts(\"action_db\")", await NOUSCoreInstance.contracts("ActionDb"));


    let actionManagerAddress =  await NOUSCoreInstance.contracts("ActionManager");
    let permAddr = new PermissionsDb(accounts[0]);

    //console.log("web3.sha3(\"execute()\").substr(0,10)", web3.utils.sha3("execute()").substr(0,10));

    //ActionManager.at(actionManagerAddress)
    //let res = await ActionManagerInstance.test("ActionAddAction", web3.utils.sha3("execute()").substr(0,10));
    //console.log("res", res);

    let res = await ActionManagerInstance.execute("ActionAddAction", web3.utils.sha3("execute()").substr(0,10));
    console.log("res", res);

    //assert.equal()
    // console.log("action_manager", await NOUSCoreInstance.contracts("action_manager"));
    // console.log("action_db", await NOUSCoreInstance.contracts("action_db"));
    // console.log("owner", await NOUSCoreInstance.owner.call());
  });



});
