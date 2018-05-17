const Web3 = require("web3");
var web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));

const NousCore = artifacts.require("NousCore.sol");
const NousTokenTest = artifacts.require("NousTokenTest.sol");
const ActionManager = artifacts.require("ActionManager.sol");
const ActionDb = artifacts.require("ActionDb.sol");
const PermissionDb = artifacts.require("PermissionDb.sol");
const TemplatesDb = artifacts.require("TemplatesDb.sol");
const ProjectDb = artifacts.require("ProjectDb.sol");
//actions
const ActionRemoveAction = artifacts.require("ActionRemoveAction.sol");
const ActionLockActions = artifacts.require("ActionLockActions.sol");
const ActionUnlockActions = artifacts.require("ActionUnlockActions.sol");
const ActionSetUserRole = artifacts.require("ActionSetUserRole.sol");
const ActionSetActionPermission = artifacts.require("ActionSetActionPermission.sol");
const ActionCreateOpenEndedFund = artifacts.require("ActionCreateOpenEndedFund.sol");
const ActionAddTemplates = artifacts.require("ActionAddTemplates.sol");
const ActionAddAction = artifacts.require("ActionAddAction.sol");
const ActionAddUser = artifacts.require("ActionAddUser.sol");
const ActionAddActions = artifacts.require("ActionAddActions.sol");

const ActionCreateCompOEFund1 = artifacts.require("ActionCreateCompOEFund1.sol");
const ActionCreateCompOEFund2 = artifacts.require("ActionCreateCompOEFund2.sol");
const ActionCreateCompOEFund3 = artifacts.require("ActionCreateCompOEFund3.sol");
const ActionCreateActionsOEFund1 = artifacts.require("ActionCreateActionsOEFund1.sol");
const ActionCreateActionsOEFund2 = artifacts.require("ActionCreateActionsOEFund2.sol");

//temlates
const TPLConstructorOpenEndedFund = artifacts.require("TPLConstructorOpenEndedFund.sol");
const TPLActionManager = artifacts.require("TPLActionManager.sol");
const TPLOpenEndedSaleDb = artifacts.require("TPLOpenEndedSaleDb.sol");
const TPLOpenEndedToken = artifacts.require("TPLOpenEndedToken.sol");
const TPLProjectActionDb = artifacts.require("TPLProjectActionDb.sol");
const TPLProjectPermissionDb = artifacts.require("TPLProjectPermissionDb.sol");
const TPLSnapshotDb = artifacts.require("TPLSnapshotDb.sol");
const TPLWalletDb = artifacts.require("TPLWalletDb.sol");

const TPLComponentsOEFund1 = artifacts.require("TPLComponentsOEFund1.sol");
const TPLComponentsOEFund2 = artifacts.require("TPLComponentsOEFund2.sol");
const TPLComponentsOEFund3 = artifacts.require("TPLComponentsOEFund3.sol");
const TPLActionsOEFundStep1 = artifacts.require("TPLActionsOEFundStep1.sol");
const TPLActionsOEFundStep2 = artifacts.require("TPLActionsOEFundStep2.sol");

let OWNER = "0x719a22E179bb49a4596eFe3BD6F735b8f3b00AF1";
//OWNER = "0x1a0816d178bfc9ad3a59b372a3270eb7e82dd1f4";

const NOUSTOKEN = "0x2d968cf3d354c891081610b65e0b83d5073a82e3";

let contractList = {
  //"name" : "instance"
}

let nousTokenInstance;
let NOUSCoreInstance;
let ActionManagerInstance;

const actionsParams = {
  "ActionAddAction" : {
    address: "",
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
  "ActionAddActions" : {
    address: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        type: "bytes32[]",
        name: "names"
      },
      {
        type: "address[]",
        name: "addrs"
      }
    ]
  },
  "ActionRemoveAction" : {
    address: "",
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
    address: "",
    type: "function",
    name: "execute",
    inputs: []
  },
  "ActionUnlockActions" : {
    address: "",
    type: "function",
    name: "execute",
    inputs: []
  },
  "ActionSetUserRole" : {
    address: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        type: "address",
        name: "_addr"
      },
      {
        type: "bytes32",
        name: "_role"
      }
    ]
  },
  "ActionAddUser" : {
    address: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        type: "address",
        name: "_addr"
      },
      {
        type: "bytes32",
        name: "_name"
      },
      {
        type: "bytes32",
        name: "_role"
      }
    ]
  },
  "ActionSetActionPermission" : {
    address: "",
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
    address: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        "name": "_owner",
        "type": "address"
      },
      {
        "name": "_fundName",
        "type": "string"
      },
      {
        "name": "_fundType",
        "type": "string"
      },
      {
        "name": "_contractNames",
        "type": "bytes32[]"
      },
      {
        "name": "_contractAddrs",
        "type": "address[]"
      },
      {
        "name": "_overWr",
        "type": "bool[]"
      }
    ],
  },
  "ActionAddTemplates" : {
    address: "",
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
  "ActionCreateActionsOEFund1" : {
    address: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        "name": "_owner",
        "type": "address"
      }
    ],
  },
  "ActionCreateActionsOEFund2" : {
    address: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        "name": "_owner",
        "type": "address"
      }
    ],
  },
  "ActionCreateCompOEFund1" : {
    address: "",
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
  "ActionCreateCompOEFund2" : {
    address: "",
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
  "ActionCreateCompOEFund3" : {
    address: "",
    type: "function",
    name: "execute",
    inputs: [
      {
        "name": "_owner",
        "type": "address"
      },
      {
        "name": "_nousToken",
        "type": "address"
      },
      {
        "name": "_name",
        "type": "string"
      },
      {
        "name": "_symbol",
        "type": "string"
      }
    ],
  },
};

const templates = {
  TPLConstructorOpenEndedFund: {
    interface: "",
    overwrite: false
  },
  /*TPLActionManager: {
    interface: "",
    overwrite: false
  },
  TPLOpenEndedSaleDb: {
    interface: "",
    overwrite: false
  },
  TPLOpenEndedToken: {
    interface: "",
    overwrite: false
  },
  TPLProjectActionDb: {
    interface: "",
    overwrite: false
  },
  TPLProjectPermissionDb: {
    interface: "",
    overwrite: false
  },
  TPLSnapshotDb: {
    interface: "",
    overwrite: false
  },
  TPLWalletDb: {
    interface: "",
    overwrite: false
  },*/
  TPLComponentsOEFund1: {
    interface: "",
    overwrite: false
  },
  TPLComponentsOEFund2: {
    interface: "",
    overwrite: false
  },
  TPLComponentsOEFund3: {
    interface: "",
    overwrite: false
  },
  TPLActionsOEFundStep1: {
    interface: "",
    overwrite: false
  },
  TPLActionsOEFundStep2: {
    interface: "",
    overwrite: false
  }
}

function getFunctionCallData({name, inputs = []}, _data = null) {
  return web3.eth.abi.encodeFunctionCall({
    name: name,
    type: 'function',
    inputs: inputs,
  }, _data);
}

async function actionManagerQuery(actionName, data) {
  let structure = actionsParams[actionName];
  let bytes = getFunctionCallData(structure, data);
  console.log("bytes", actionName, bytes);


  await ActionManagerInstance.execute(actionName, bytes);
}

async function createAddAction(newActionName) {
  let data = [web3.utils.toHex(newActionName), actionsParams[newActionName].address];
  await actionManagerQuery("ActionAddAction", data);
}

async function createAddActions(data) {
  //let data = [web3.utils.toHex(newActionName), actionsParams[newActionName].address];
  await actionManagerQuery("ActionAddActions", data);
}

module.exports = async function(deployer) {
  await deployer.deploy(TPLComponentsOEFund3);
  ActionManagerInstance = ActionManager.at("0x463dd281b953e89bd0ae0a0918289dfd80de8dbc");
  await actionManagerQuery("ActionAddTemplates", [[web3.utils.toHex("TPLComponentsOEFund3")],[TPLComponentsOEFund3.address],[true]]);
return;
/*
  console.log("-----==========CREATE DEPLOY TEMPLATES==========-----");
  //deploy templates
  for (let item in templates) {
    templates[item].interface = await eval(`${item}.new()`);
    console.log(`${item}: `, templates[item].interface.address);
  }

  console.log("-----==========ADD TEMPLATES==========-----");
  // add templates
  let _tplName = Object.keys(templates).map(item => web3.utils.toHex(item));
  let _tplAddr = Object.keys(templates).map(item => templates[item].interface.address);
  let _tplOwerW = Object.keys(templates).map(item => templates[item].overwrite);

  let dat = [_tplName, _tplAddr, _tplOwerW];

  ActionManagerInstance = ActionManager.at("0xe0b292985d35e38ee4a4689f973973374ac48512");
  await actionManagerQuery("ActionAddTemplates", dat);

  console.log("\n");
  return;*/

  //
  // await deployer.deploy(TemplatesDb);
  // const doug = NousCore.at("0x51a80300715b542e02eda50eba28030a1ac06773");
  // doug.addContract("TemplatesDb", TemplatesDb.address);
  // return;

  // //ActionAddTemplates execute(bytes32[] _names, address[] _addrs, bool[] _overwrite)
  // ActionManagerInstance = ActionManager.at("0xe0b292985d35e38ee4a4689f973973374ac48512");
  // let _data = [[web3.utils.toHex("TPLComponentsOEFund1")],[TPLComponentsOEFund1.address],[true]]
  // actionManagerQuery("ActionAddTemplates", _data);

  //return;

  //await deployer.deploy(NousTokenTest);
  //console.log("nousTokenInstance.address", NousTokenTest.address);

  //return;
  console.log("-----=====DEPLOY NOUS CONTRACT=====-----");
  //deploy

  ActionManagerInstance = await ActionManager.new();
  //await deployer.deploy(ActionManager);
  contractList["ActionManager"] = ActionManagerInstance.address;
  console.log("ActionManager", ActionManagerInstance.address);


  await deployer.deploy(ActionDb);
  contractList["ActionDb"] = ActionDb.address;

  //let permInstance = await PermissionDb.new(OWNER);

  await deployer.deploy(PermissionDb, OWNER);
  contractList["PermissionDb"] = PermissionDb.address;
  //console.log("permInstance.address", permInstance.address);
  //console.log("PermissionDb.getUser(OWNER)", await permInstance.getUser(OWNER));

  await deployer.deploy(TemplatesDb);
  contractList["TemplatesDb"] = TemplatesDb.address;

  await deployer.deploy(ProjectDb);
  contractList["ProjectDb"] = ProjectDb.address;


  console.log("-----==========ADD FUND CONTRACT TO DOUG==========-----");
  //Contracts Doug Contract
  await deployer.deploy(NousCore,
    //NousTokenTest.address,
    NOUSTOKEN,
    Object.keys(contractList),
    Object.keys(contractList).map(_name => contractList[_name])
  );

  console.log("-----==========DEPLOY ACTIONS FOR ACTION MANAGER==========-----");
  for (let item in actionsParams) {
      actionsParams[item].address = (await eval(`${item}.new()`)).address;
      console.log(`${item}: `, actionsParams[item].address);
  }

  let _actionNames = Object.keys(actionsParams).map(item => web3.utils.toHex(item));
  //console.log("_actionNames", _actionNames);
  let _actionAddr =  Object.keys(actionsParams).map(item => actionsParams[item].address);

  console.log("_actionAddr", [_actionNames, _actionAddr]);

  await createAddActions([_actionNames, _actionAddr]);

  console.log("-----==========CREATE DEPLOY TEMPLATES==========-----");
  //deploy templates
  for (let item in templates) {
    templates[item].interface = await eval(`${item}.new()`);
    console.log(`${item}: `, templates[item].interface.address);
  }

  console.log("-----==========ADD TEMPLATES==========-----");
  // add templates
  let _tplNames = Object.keys(templates).map(item => web3.utils.toHex(item));
  let _tplAddrs = Object.keys(templates).map(item => templates[item].interface.address);
  let _tplOwerWr = Object.keys(templates).map(item => templates[item].overwrite);

  let data = [_tplNames, _tplAddrs, _tplOwerWr];
  await actionManagerQuery("ActionAddTemplates", data);

  console.log("\n");
  console.log("-----==========CONTRACT NOUS CORE==========-----");

  //console.log("nousToken: ", nousTokenInstance.address);
  console.log("NousCore: ", NousCore.address);
  console.log("ActionManager: ", ActionManagerInstance.address);
  console.log("ActionDb: ", ActionDb.address);
  console.log("PermissionDb: ", PermissionDb.address);
  console.log("TemplatesDb: ", TemplatesDb.address);
  console.log("ProjectDb: ", ProjectDb.address);

  console.log("");
  console.log("-----==========ACTION ADDRESSES==========-----");
  for (let item in actionsParams) {
    console.log(`${item}: `, actionsParams[item].address);
  }

  console.log("");
  console.log("-----==========TEMPLATES ADDRESSES==========-----");
  for (let item in templates) {
    console.log(`${item}: `, templates[item].interface.address);
  }

};







//
