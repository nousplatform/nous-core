const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const fs = require('fs');
const BigNumber = require('bignumber.js');


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

const ActionAddTemplates = artifacts.require("ActionAddTemplates.sol");

//temlates
const TPLOpenEndedSaleDb = artifacts.require("TPLOpenEndedSaleDb.sol");
const TPLOpenEndedToken = artifacts.require("TPLOpenEndedToken.sol");
const TPLProjectActionManager = artifacts.require("TPLProjectActionManager.sol");
const TPLProjectConstructor = artifacts.require("TPLProjectConstructor.sol");
const TPLSnapshotDb = artifacts.require("TPLSnapshotDb.sol");
const TPLWalletDb = artifacts.require("TPLWalletDb.sol");

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
  //console.log("data", data);

  return getFunctionCallData(structure, data);
}

//query to action manager
async function actionManagerQuery(actionName, data) {
  let bytes = getBytesCallData(actionName, data);

  await ActionManagerInstance.execute(actionName, bytes);
}


async function createAddActions(data) {
  await actionManagerQuery("ActionAddActions", data);
}

contract('NousCore', async function(accounts) {


  let instanceList = {
    //"name" : "instance"
  }

  let decimals = 18;

  let projectType = web3.utils.toHex("Open-end Fund");

  let configTpls;
  let configTpls2;

  let fundOwner = accounts[1];
  let nousPlatform = accounts[0];
  let openEndedToken;

  let initTokens = {
    entryFee: 1,
    exitFee: 1,
    initPrice: 2,
    maxFundCup: 10000000,
    maxInvestors: 0,
    platformFee: 1
  };

  let _projContr;
  let projectActionManager;
  let openEndedSaleDb

  //STEP 1 To deploy
  beforeEach(async function () {

    nousTokenInstance = await NousTokenTest.new();

    // deployer.deploy(MathCalc);
    // deployer.autolink();


    //deploy
    ActionManagerInstance = instanceList["ActionManager"] = await NousActionManager.new();
    instanceList["ActionDb"] = await ActionDb.new();
    instanceList["PermissionDb"] = await PermissionDb.new(nousPlatform);

    //NOUS
    instanceList["TemplatesDb"] = await TemplatesDb.new();
    instanceList["ProjectDb"] = await ProjectDb.new();

    //Construc Doug Contract
    NOUSCoreInstance = await NousCore.new(
      nousTokenInstance.address,
      Object.keys(instanceList),
      Object.keys(instanceList).map(_name => instanceList[_name].address)
    );

    //console.log("-----==========DEPLOY ACTIONS FOR ACTION MANAGER==========-----");

    for (let item in actions) {
      let actionName = actions[item];
      actionsList[actionName] = (await eval(`${actionName}.new()`));
      //console.log(`${actionName}: `, actionsList[actionName].address);
    }

    let _actionNames = Object.keys(actionsList).map(item => web3.utils.toHex(item));
    let _actionAddr = Object.keys(actionsList).map(item => actionsList[item].address);

    await createAddActions([_actionNames, _actionAddr]);

    //console.log("-----==========CREATE DEPLOY TEMPLATES==========-----");
    for (let item in tpls) {
      let tplName = tpls[item];
      templatesList[tplName] = await eval(`${tplName}.new()`);
      //console.log(`${tplName}: `, templatesList[tplName].address);
    }

    //console.log("-----==========ADD TEMPLATES==========-----");
    let _tplNames = Object.keys(templatesList).map(item => web3.utils.toHex(item));
    let _tplAddrs = Object.keys(templatesList).map(item => templatesList[item].address);
    let dataTpl = [_tplNames, _tplAddrs];
    await actionManagerQuery("ActionAddTemplates", dataTpl);

    //console.log("-----==========VALIDATE TEMPLATES==========-----");

    for (let item in tpls) {
      let tplName = tpls[item];
      let res = await instanceList["TemplatesDb"].template(web3.utils.toHex(tplName), 0);
      assert.equal(templatesList[tplName].address, res, "Not Equal templates");
      //console.log(`${tplName}: ${res}`);
    }

    configTpls = {
      "TPLSnapshotDb": {
        "variables": [
          fundOwner
        ],
        "address": "0x0"
      },
      "TPLOpenEndedSaleDb": {
        "variables": [
          fundOwner,
          ...Object.keys(initTokens).map(item => new BigNumber(initTokens[item] * Math.pow(10, decimals)))
        ],
        "address": "0x0"
      },
      "TPLOpenEndedToken": {
        "variables": [
          fundOwner,
          [nousTokenInstance.address],
          "BWT TOKEN",
          "BWT",
          decimals,
          accounts[3]
        ],
        "address": "0x0"
      },
      "TPLProjectActionManager": {
        "variables": [
          fundOwner,
          nousPlatform,
        ],
        "address": "0x0"
      },
      "TPLWalletDb": {
        "variables": [
          fundOwner
        ],
        "address": "0x0"
      }
    }


    for (let _item in configTpls) {
      // console.log("_item", configTpls[_item].variables);
      await ActionManagerInstance.deployTemplates(web3.utils.toHex(_item), getBytesCallData(_item, configTpls[_item].variables, "create"));
    }

    let _projContr = await instanceList["ProjectDb"].getProjectContracts(fundOwner, web3.utils.toHex(projectType));

    configTpls2 = {
      "TPLProjectConstructor": {
        "variables": [
          fundOwner,
          "_fundName",
          "_fundType",
          _projContr[0],
          _projContr[1],
        ],
        "address": "0x0"
      }
    };

    await ActionManagerInstance.deployTemplates(web3.utils.toHex("TPLProjectConstructor"), getBytesCallData("TPLProjectConstructor", configTpls2["TPLProjectConstructor"].variables, "create"));
    //projectActionManager = ProjectActionManager.at(_projContr[1][3]);

  });

  it("Test Add/Remove Action", async function() {
    let newAction = await ActionAddUser.new();
    let actionName = web3.utils.toHex("ActionForTest");

    //Add new action
    let dataTpl = [actionName, newAction.address];
    await actionManagerQuery("ActionAddAction", dataTpl);

    let addr = await instanceList["ActionDb"].actions(actionName);
    assert.equal(newAction.address, addr, "address no correct ");

    // remove action
    await actionManagerQuery("ActionRemoveAction", [actionName]);

    try {
      await instanceList["ActionDb"].actions(actionName);
    } catch (e) {
      console.log("address deleted");
    }
  });

  it("Test Lock/Unlock Action", async function() {
    await actionManagerQuery("ActionLockActions", []);

    assert.isTrue(await ActionManagerInstance.locked(), "Locked true");

    await actionManagerQuery("ActionUnlockActions");
    assert.isFalse(await ActionManagerInstance.locked(), "Not locked");
  });

  //todo доделать
  it("Test Action add user", async function() {
    await actionManagerQuery("ActionAddUser", [accounts[5], web3.utils.toHex("test"), web3.utils.toHex("managerFunds")]);


  })

  it("Test Action set user role", async function() {

  })
})
