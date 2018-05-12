const Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const NousCore = artifacts.require("NousCore.sol");
const NousTokenTest = artifacts.require("NousTokenTest.sol");
const ActionManager = artifacts.require("ActionManager.sol");
const ActionDb = artifacts.require("ActionDb.sol");
const PermissionDb = artifacts.require("PermissionDb.sol");
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
const ActionAddAction = artifacts.require("ActionAddAction.sol");

const ActionCreateCompOpenEndedFund = artifacts.require("ActionCreateCompOpenEndedFund.sol");
//temlates
const TPLConstructorOpenEndedFund = artifacts.require("TPLConstructorOpenEndedFund.sol");
const TPLComponentsOpenEndedFund = artifacts.require("TPLComponentsOpenEndedFund.sol");



/*function getSignature(self) {
  return `${self.function}(${self.params.join()})`;
}

const actionsParams = {
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
  "ActionCreateCompOpenEndedFund" : {
    interface: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        "name": "_nousManager",
        "type": "address"
      },
      {
        "name": "_owner",
        "type": "address"
      }
    ],
  },
};

const templates = {
  TPLConstructorOpenEndedFund: {
    interface: "",
    overwrite: false
  },
  TPLComponentsOpenEndedFund: {
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
    ActionManagerInstance = instanceList["ActionManager"] = await ActionManager.new();
    instanceList["ActionDb"] = await ActionDb.new();
    instanceList["PermissionDb"] = await PermissionDb.new(accounts[0]);

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
    for (let item in actionsParams) {
      actionsParams[item].interface = await eval(`${item}.new()`);
      await createAddAction(item);
      //console.log(item, actionsParams[item].interface.address);

      assert.equal(actionsParams[item].interface.address, await instanceList["ActionDb"].getAction(item));
    }
  }

  async function createAddAction(newActionName) {

    let data = [web3.utils.toHex(newActionName), actionsParams[newActionName].interface.address];
    let structure = actionsParams["ActionAddAction"];
    let bytes = getFunctionCallData(structure, data);

    await ActionManagerInstance.execute("ActionAddAction", bytes);
  }

  async function actionManagerQuery(actionNmae, data) {
    let structure = actionsParams[actionNmae];
    let bytes = getFunctionCallData(structure, data);

    await ActionManagerInstance.execute(actionNmae, bytes);
  }

  /*it("Validate Deploy all nous core contracts. Add to doug manager. ", async function () {
    Object.keys(instanceList).forEach(async (_name) => {
      assert.equal(instanceList[_name].address,  await NOUSCoreInstance.contracts(_name));
    });
  });*/

  /*it("Add all action contracts and add to Action Manager", async function() {
    await createAllActions();
  });*/

  it("Add Action templates. Action Create New Fund", async () => {
    await createAllActions();
    //let tpls = Object.keys(templates);

    // create instance templates
    for ( let item in templates ) {
      templates[item].interface = await eval(`${item}.new()`);
      /*let data = [[web3.utils.toHex(item)], [templates[item].interface.address], [templates[item].overwrite]];
      console.log(data);

      await actionManagerQuery("ActionAddTemplates", data);
      console.log("item", templates[item].interface.address);*/
    }

    // add templates
    let _tplNames = Object.keys(templates).map(item => web3.utils.toHex(item));
    let _tplAddrs = Object.keys(templates).map(item => templates[item].interface.address);
    let _tplOwerWr = Object.keys(templates).map(item => templates[item].overwrite);

    let data = [_tplNames, _tplAddrs, _tplOwerWr];
    //console.log("data", data);


    await actionManagerQuery("ActionAddTemplates", data);

    //console.log("11", await instanceList["TemplatesDb"].template("TPLConstructorOpenEndedFund", 0));

    //validate add templates
    for ( let item in templates ) {
      assert.equal(templates[item].interface.address, (await instanceList["TemplatesDb"].template(item, 0))[0], "Instance list not equal templates Db");
    }


    //Crate new fund
    data = [ActionManagerInstance.address, accounts[0]];
    await actionManagerQuery("ActionCreateCompOpenEndedFund", data);



    // data = [accounts[0], "Test Trast", web3.utils.toHex("Open Ended fund")];
    // console.log("data", data);
    //
    // await actionManagerQuery("ActionCreateOpenEndedFund", data);
    //
    // assert.equal(1, (await instanceList["FundDb"].getAllFunds()).length);

    //let bytes = getFunctionCallData(structure, data);

    // let data = [accounts[1], "Fund TEST TRAST", web3.utils.toHex("Open Ended")];
    // structure = actionsParams["ActionCreateOpenEndedFund"];
    // bytes = getFunctionCallData(structure, data);
    //
    // await ActionManagerInstance.execute("ActionCreateOpenEndedFund", bytes);

  });
});
