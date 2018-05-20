const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const fs = require('fs');

var OWNER = "0x719a22E179bb49a4596eFe3BD6F735b8f3b00AF1";
OWNER = "0x863c777bc9c6ab7fca73c998eba43f272ec00b46";

const NOUSTOKEN = "0xe237b4A6D1cD77013C52dae8656ceC5620140490";

const NousCore = artifacts.require("NousCore.sol");
const NousTokenTest = artifacts.require("NousTokenTest.sol");
const ActionManager = artifacts.require("ActionManager.sol");
const ActionDb = artifacts.require("ActionDb.sol");
const PermissionDb = artifacts.require("PermissionDb.sol");
const TemplatesDb = artifacts.require("TemplatesDb.sol");
const ProjectDb = artifacts.require("ProjectDb.sol");
const Doug = artifacts.require("Doug.sol");
const NousActionManager = artifacts.require("NousActionManager.sol");

//actions
const ActionRemoveAction = artifacts.require("ActionRemoveAction.sol");
const ActionLockActions = artifacts.require("ActionLockActions.sol");
const ActionUnlockActions = artifacts.require("ActionUnlockActions.sol");
const ActionSetUserRole = artifacts.require("ActionSetUserRole.sol");
const ActionSetActionPermission = artifacts.require("ActionSetActionPermission.sol");
const ActionAddAction = artifacts.require("ActionAddAction.sol");
const ActionAddUser = artifacts.require("ActionAddUser.sol");
const ActionAddActions = artifacts.require("ActionAddActions.sol");
const ActionAddContract = artifacts.require("ActionAddContract.sol");
const ActionRemoveContract = artifacts.require("ActionRemoveContract.sol");
//project actions
const ActionProjectDeployer = artifacts.require("ActionProjectDeployer.sol");
const ActionAddTemplates = artifacts.require("ActionAddTemplates.sol");

//temlates
const TPLOpenEndedSaleDb = artifacts.require("TPLOpenEndedSaleDb.sol");
const TPLOpenEndedToken = artifacts.require("TPLOpenEndedToken.sol");
const TPLProjectActionManager = artifacts.require("TPLProjectActionManager.sol");
const TPLProjectConstructor = artifacts.require("TPLProjectConstructor.sol");
const TPLSnapshotDb = artifacts.require("TPLSnapshotDb.sol");
const TPLWalletDb = artifacts.require("TPLWalletDb.sol");

const ProjectActionManager = artifacts.require("ProjectActionManager.sol");
const ProjectConstructor = artifacts.require("ProjectConstructor.sol");

const actions = [
  "ActionAddAction",
  "ActionAddActions",
  "ActionRemoveAction",
  "ActionLockActions",
  "ActionUnlockActions",
  "ActionSetUserRole",
  "ActionAddUser",
  "ActionSetActionPermission",
  "ActionAddContract",
  "ActionRemoveContract",

  "ActionProjectDeployer",
  "ActionAddTemplates",
];

const tpls = [
  "TPLOpenEndedSaleDb",
  "TPLOpenEndedToken",
  "TPLProjectActionManager",
  "TPLProjectConstructor",
  "TPLSnapshotDb",
  "TPLWalletDb",
];

let contractList = {};
let actionsList = {};
let templatesList = {};

function getAbi(contractName, param = "abi") {
  var obj = JSON.parse(fs.readFileSync(`${__dirname}/../build/contracts/${contractName}.json`, 'utf8'));
  return obj[param];
}

function getFunctionAbi(contractName, funcName = "execute") {
  let abi = getAbi(contractName);
  let item;
  for (item in abi) {
    if (abi[item].name == funcName) {
      return abi[item];
    }
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
  let structure = getFunctionAbi(actionName);
  //console.log("data", data);
  //console.log("actionName", actionName);

  let bytes = getFunctionCallData(structure, data);
  //console.log("bytes", actionName, bytes);
  //console.log("ActionAddActions", actionsList["ActionAddActions"].address);

  let instance = await ActionManager.deployed();

  await instance.execute(actionName, bytes);
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
  return;

  console.log("-----=====DEPLOY NOUS CONTRACT=====-----");

  await deployer.deploy(NousActionManager);

  contractList["ActionManager"] = NousActionManager.address;

  await deployer.deploy(ActionDb);
  contractList["ActionDb"] = ActionDb.address;

  await deployer.deploy(PermissionDb, OWNER);
  contractList["PermissionDb"] = PermissionDb.address;
  //let PermissionDBInst = await PermissionDb.deployed();

  await deployer.deploy(TemplatesDb);
  contractList["TemplatesDb"] = TemplatesDb.address;

  await deployer.deploy(ProjectDb);
  contractList["ProjectDb"] = ProjectDb.address;


  console.log("-----==========ADD FUND CONTRACT TO DOUG==========-----");
  //Contracts Doug Contract
  await deployer.deploy(NousCore,
    NOUSTOKEN,
    Object.keys(contractList),
    Object.keys(contractList).map(_name => contractList[_name])
  );

  console.log("-----==========DEPLOY ACTIONS FOR ACTION MANAGER==========-----");

  for (let item in actions) {
    let actionName = actions[item];

    actionsList[actionName] = (await eval(`${actionName}.new()`));
    console.log(`${actionName}: `, actionsList[actionName].address);
  }

  let _actionNames = Object.keys(actionsList).map(item => web3.utils.toHex(item));
  let _actionAddr =  Object.keys(actionsList).map(item => actionsList[item].address);


  await createAddActions([_actionNames, _actionAddr]);

  console.log("-----==========CREATE DEPLOY TEMPLATES==========-----");
  //deploy templatesList
  for (let item in tpls) {
    let tplName = tpls[item];
    templatesList[tplName] = await eval(`${tplName}.new()`);
    console.log(`${tplName}: `, templatesList[tplName].address);
  }

  console.log("-----==========ADD TEMPLATES==========-----");
  // add templatesList
  let _tplNames = Object.keys(templatesList).map(item => web3.utils.toHex(item));
  let _tplAddrs = Object.keys(templatesList).map(item => templatesList[item].address);

  let dataTpl = [_tplNames, _tplAddrs];
  await actionManagerQuery("ActionAddTemplates", dataTpl);

  console.log("\n");
  console.log("-----==========CONTRACT NOUS CORE==========-----");

  //console.log("nousToken: ", nousTokenInstance.address);
  console.log("NousCore: ", NousCore.address);
  console.log("ActionManager: ", ActionManager.address);
  console.log("ActionDb: ", ActionDb.address);
  console.log("PermissionDb: ", PermissionDb.address);
  console.log("TemplatesDb: ", TemplatesDb.address);
  console.log("ProjectDb: ", ProjectDb.address);

  console.log("");
  console.log("-----==========ACTION ADDRESSES==========-----");
  for (let item in actionsList) {
    console.log(`${item}: `, actionsList[item].address);
  }

  console.log("");
  console.log("-----==========TEMPLATES ADDRESSES==========-----");
  for (let item in templatesList) {
    console.log(`${item}: `, templatesList[item].address);
  }
};







//
