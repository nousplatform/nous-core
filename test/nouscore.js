const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const fs = require('fs');

var OWNER = "0x719a22E179bb49a4596eFe3BD6F735b8f3b00AF1";
////OWNER = "0x0b8976a4871ff9b0f1a33dee9c0ede304c0fa131";

const NOUSTOKEN = "0x16db3d98cf6babcfdfd4bc35d4e9da8f8a1ad983";

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

let nousTokenInstance;
let NOUSCoreInstance;
let ActionManagerInstance;

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

//
function getFunctionCallData({name, inputs = []}, _data = null) {
  return web3.eth.abi.encodeFunctionCall({
    name: name,
    type: 'function',
    inputs: inputs,
  }, _data);
}

//crate date for action manager
function getBytesCallData(actionName, data, functionName ) {
  let structure = getFunctionAbi(actionName, functionName);
  //console.log("structure", structure);

  return getFunctionCallData(structure, data);
}

//query to action manager
async function actionManagerQuery(actionName, data, funcName = "execute", address = "", actionManagerMethod = "execute") {

  let structure = getFunctionAbi(actionName, funcName);

  //console.log("structure", structure);
  //console.log("data", data);


  let _data = await getFunctionCallData(structure, data);
  //console.log("_data", _data);

  if (address) {}

  await ActionManagerInstance[actionManagerMethod](web3.utils.toHex(actionName), _data);
}

async function createAddActions(data) {
  //let data = [web3.utils.toHex(newActionName), actionsParams[newActionName].address];
  await actionManagerQuery("ActionAddActions", data);
}

contract('NousCore', async function (accounts) {

  let instanceList = {
    //"name" : "instance"
  }

  beforeEach(async function () {
    nousTokenInstance = await NousTokenTest.new();

    //deploy
    ActionManagerInstance = instanceList["ActionManager"] = await ActionManager.new();
    instanceList["ActionDb"] = await ActionDb.new();
    instanceList["PermissionDb"] = await PermissionDb.new(accounts[0]);

    //NOUS
    instanceList["TemplatesDb"] = await TemplatesDb.new();
    instanceList["ProjectDb"] = await ProjectDb.new();

    //Construc Doug Contract
    NOUSCoreInstance = await NousCore.new(
      nousTokenInstance.address,
      Object.keys(instanceList),
      Object.keys(instanceList).map(_name => instanceList[_name].address)
    );
  });

  it("Add Action templates. Action Create New Fund", async () => {

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
    for (let item in tpls) {
      let tplName = tpls[item];
      templatesList[tplName] = await eval(`${tplName}.new()`);
      console.log(`${tplName}: `, templatesList[tplName].address);
    }

    console.log("-----==========ADD TEMPLATES==========-----");
    let _tplNames = Object.keys(templatesList).map(item => web3.utils.toHex(item));
    let _tplAddrs = Object.keys(templatesList).map(item => templatesList[item].address);
    let dataTpl = [_tplNames, _tplAddrs];
    console.log("dataTpl", dataTpl);

    await actionManagerQuery("ActionAddTemplates", dataTpl);

    //validate add templates
    for ( let item in templatesList ) {
      assert.equal(templatesList[item].address, (await instanceList["TemplatesDb"].template(item, 0)), "Instance list not equal templates Db");
    }

    //STEP 1
    // todo дописать
    let _paramSale = [],_valSale = [];
    ["entryFee", "exitFee", "initPrice", "maxFundCup", "maxInvestors", "platformFee"].map(item => {
        _paramSale.push(web3.utils.toHex(item));
        _valSale.push(1);
    });

    let _data = [accounts[0], accounts[1], _paramSale, _valSale];
    console.log("STEP 1 TPLSnapshotDb", await actionManagerQuery("TPLSnapshotDb", _data, "create", undefined, "deployTemplates"));

    //STEP 2
    data = [accounts[0], accounts[1]];
    console.log("STEP 2 ActionCreateCompOEFund2", await actionManagerQuery("ActionCreateCompOEFund2", data));

    //STEP 3
    let walletAddress = accounts[2];
    data = [accounts[1], nousTokenInstance.address, "BWT Token", "BWT"];
    console.log("STEP 3 ActionCreateCompOEFund3 ", await actionManagerQuery("ActionCreateCompOEFund3", data));

    //STEP 4 create Fund
    data = [accounts[1]];
    console.log("STEP 4 ActionCreateActionsOEFund1", await actionManagerQuery("ActionCreateActionsOEFund1", data));

    //STEP 5 create Fund
    data = [accounts[1]];
    console.log("STEP 4 ActionCreateActionsOEFund2", await actionManagerQuery("ActionCreateActionsOEFund2", data));

    // get all tpls
    tpls = await instanceList["TemplatesDb"].getTplContracts(accounts[1], web3.utils.toHex("contracts"));
    //console.log("tpls", tpls)

    //Crate new fund
    data = [accounts[0], "Test Fund", "OpenEndedFund", tpls[0], tpls[1], tpls[2]];
    await actionManagerQuery("ActionCreateOpenEndedFund", data);

    let acts =  await instanceList["TemplatesDb"].getTplContracts(accounts[1], web3.utils.toHex("actions"));
    //console.log("acts", acts);


    let fundAddr = await instanceList["ProjectDb"].getOwnerFundLast(accounts[0]);
    //console.log("getOwnerFundLast", fundAddr);

    let dougFund = Doug.at(fundAddr);
    let actManagerFund = await dougFund.contractList.call("ActionManager");
    //console.log("actManagerFund", actManagerFund);

    //todo -------
    // let actionDbaddr = await dougFund.contractList.call("ActionDb");
    // let actionDb = ActionDb.at(actionDbaddr);
    // console.log("actionAddActions", await actionDb.actions.call("ActionAddActions"));
    // console.log("ActionLockActions", await actionDb.actions.call("ActionLockActions"));
    //todo -------


    let projectManager = ActionManager.at(actManagerFund);
    //console.log("projectManager.address", projectManager.address);
    let _actions = acts[0].map(item => web3.utils.toHex(item));

    let structure = actionsParams["ActionAddActions"];
    let bytes = getFunctionCallData(structure, [_actions, acts[1]]);
    //console.log("bytes", bytes);
    console.log("ActionAddActions", (await projectManager.execute("ActionAddActions", bytes)).tx);

  });
});

