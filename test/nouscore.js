const Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const NousCore = artifacts.require("NousCore.sol");
const NousTokenTest = artifacts.require("NousTokenTest.sol");
const ActionManager = artifacts.require("ActionManager.sol");
const ActionDb = artifacts.require("ActionDb.sol");
const PermissionsDb = artifacts.require("PermissionsDb.sol");
const TemplatesDb = artifacts.require("TemplatesDb.sol");
const FundDb = artifacts.require("FundDb.sol");
//actions
const ActionRemoveAction = artifacts.require("ActionRemoveAction.sol");
const ActionLockActions = artifacts.require("ActionLockActions.sol");
const ActionUnlockActions = artifacts.require("ActionUnlockActions.sol");
const ActionSetUserPermission = artifacts.require("ActionSetUserPermission.sol");
const ActionSetActionPermission = artifacts.require("ActionSetActionPermission.sol");
const ActionCreateOpenEndedFund = artifacts.require("ActionCreateOpenEndedFund.sol");
const ActionAddTemplates = artifacts.require("ActionAddTemplates.sol");
//temlates
const TemplateConstructorOpenEndedFund = artifacts.require("TemplateConstructorOpenEndedFund.sol");


function getSignature(self) {
  return `${self.function}(${self.params.join()})`;
}

/*const actionsParams = {
  "ActionAddAction" : {
    interface: "",
    function: "execute",
    signature: function() {return getSignature(this)},
    params: ["bytes32", "address"],
  },
}*/

const actionsParams = {
  "ActionAddAction" : {
    interface: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        type: "bytes32",
        name: "name"
      },
      {
        type: "address",
        name: "addr"
      }
    ]
  },
  "ActionRemoveAction" : {
    interface: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        type: "bytes32",
        name: "name"
      }
    ]
  },
  "ActionLockActions" : {
    interface: "",
    type: "function",
    name: "execute",
    inputs: []
  },
  "ActionUnlockActions" : {
    interface: "",
    type: "function",
    name: "execute",
    inputs: []
  },
  "ActionSetUserPermission" : {
    interface: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        type: "address",
        name: "addr"
      },
      {
        type: "uint8",
        name: "perm"
      },
    ]
  },
  "ActionSetActionPermission" : {
    interface: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        type: "bytes32",
        name: "name"
      },
      {
        type: "uint8",
        name: "perm"
      },
    ]
  },

  "ActionCreateOpenEndedFund" : {
    interface: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        type: "address",
        name: "_owner"
      },
      {
        type: "string",
        name: "_fundName"
      },
      {
        type: "bytes32",
        name: "_fundType"
      },
    ]
  },
  "ActionAddTemplates" : {
    interface: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        type: "bytes32[]",
        name: "_names"
      },
      {
        type: "address[]",
        name: "_addrs"
      },
      {
        type: "bool[]",
        name: "_overwrite"
      },
    ]
  },
};

const templates = {
  TemplateConstructorOpenEndedFund: {
    interface: "",
    overwrite: false
  }
}

function getActionCallDataManual(_signature, _params, _data) {
  let bytes = web3.eth.abi.encodeFunctionSignature(_signature);
  if (_params.length) {
    bytes += web3.eth.abi.encodeParameters(_params, _data).slice(2);
  }
  return bytes;
}

function getFunctionCallData({name, inputs = []}, _data = null) {
  return web3.eth.abi.encodeFunctionCall({
    name: name,
    type: 'function',
    inputs: inputs,
  }, _data);
}

contract('NousCore', async function (accounts) {

  let instanceList = {
    //"name" : "instance"
  }

  let nousTokenInstance;
  let NOUSCoreInstance;
  let ActionManagerInstance;

  beforeEach(async function () {
    nousTokenInstance = await NousTokenTest.new();

    //deploy
    ActionManagerInstance = instanceList["ActionManager"] =  await ActionManager.new();
    instanceList["ActionDb"] = await ActionDb.new();
    instanceList["PermissionsDb"] = await PermissionsDb.new(accounts[0]);

    //NOUS
    instanceList["TemplatesDb"] = await TemplatesDb.new();
    instanceList["FundDb"] = await FundDb.new();

    //Construc Doug Contract
    NOUSCoreInstance = await NousCore.new(
      nousTokenInstance.address,
      Object.keys(instanceList),
      Object.keys(instanceList).map(_name => instanceList[_name].address)
    );
  });

  async function createAllActions() {
    await Object.keys(actionsParams).forEach(async item => {
      actionsParams[item].interface = await eval(`${item}.new()`);
      //console.log("actionsParams[item].interface.address", actionsParams[item].interface.address);
      await createAddAction(item);
      //console.log("await instanceList[\"ActionDb\"].getAction(item)", await instanceList["ActionDb"].getAction(item));
      assert.equal(actionsParams[item].interface.address, await instanceList["ActionDb"].getAction(item));
    });
  }

  async function createAddAction(newActionName) {

    let data = [web3.utils.toHex(newActionName), actionsParams[newActionName].interface.address];
    let structure = actionsParams["ActionAddAction"];
    let bytes = getFunctionCallData(structure, data);

    await ActionManagerInstance.execute("ActionAddAction", bytes);
  }

  it("Validate Deploy all nous core contracts ", async function () {
    Object.keys(instanceList).forEach(async (_name) => {
      assert.equal(instanceList[_name].address,  await NOUSCoreInstance.contracts(_name));
    });
  });

  it("Add contracts to Action Manager", async function() {

    await createAllActions();
    Object.keys(actionsParams).forEach(async item => {
      //console.log("item", item);
      //assert.equal(actionsParams[item].interface.address, await instanceList["ActionDb"].getAction(item));
    })

    //console.log("ActionAddAction", await instanceList["ActionDb"].actions.call("ActionAddAction"));
    //console.log("actionsParams[newActionName].signature", actionsParams["ActionAddAction"].signature());

    /*Object.keys(actionsParams).forEach(async item => {
      actionsParams[item].interface = await eval(`${item}.new()`);
      //console.log("actionsParams[item].interface.address", actionsParams[item].interface.address);
      await createAddAction(item);
      //console.log("await instanceList[\"ActionDb\"].getAction(item)", await instanceList["ActionDb"].getAction(item));
      assert.equal(actionsParams[item].interface.address, await instanceList["ActionDb"].getAction(item));
    });*/

    //await createAddAction("ActionSetActionPermission");
  });

  it("Action Create New Fund", async () => {
    await createAllActions();

    await Promise.all(Object.keys(templates).forEach(async (item) => {
      templates[item].interface = await eval(`${item}.new()`);
      console.log("templates[item].interface.address", templates[item].interface.address);
    }));

    let _tplNames = web3.utils.toHex(Object.keys(templates));
    let _tplAddrs = Object.keys(templates).forEach(item => item.interface.address);
    let _tplOwerWr = Object.keys(templates).forEach(item => item.overwrite);

    let data = [_tplNames, _tplAddrs, _tplOwerWr];
    let structure = actionsParams["ActionAddTemplates"];
    let bytes = getFunctionCallData(structure, data);
    await ActionManagerInstance.execute("ActionAddTemplates", bytes);

    //let bytes = getFunctionCallData(structure, data);

    // let data = [accounts[1], "Fund TEST TRAST", web3.utils.toHex("Open Ended")];
    // structure = actionsParams["ActionCreateOpenEndedFund"];
    // bytes = getFunctionCallData(structure, data);
    //
    // await ActionManagerInstance.execute("ActionCreateOpenEndedFund", bytes);

  });
});
