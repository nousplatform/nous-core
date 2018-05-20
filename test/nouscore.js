const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const fs = require('fs');

const NousCore = artifacts.require("NousCore.sol");
const NousTokenTest = artifacts.require("NousTokenTest.sol");
const ActionManager = artifacts.require("ActionManager.sol");
const ActionDb = artifacts.require("ActionDb.sol");
const PermissionDb = artifacts.require("PermissionDb.sol");
const TemplatesDb = artifacts.require("TemplatesDb.sol");
const ProjectDb = artifacts.require("ProjectDb.sol");
const Doug = artifacts.require("Doug.sol");
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

const ActionProjectDeployer = artifacts.require("ActionProjectDeployer.sol");
const ActionTemplates = artifacts.require("ActionTemplates.sol");

//temlates
const TPLOpenEndedSaleDb = artifacts.require("TPLOpenEndedSaleDb.sol");
const TPLOpenEndedToken = artifacts.require("TPLOpenEndedToken.sol");
const TPLProjectActionManager = artifacts.require("TPLProjectActionManager.sol");
const TPLProjectConstructor = artifacts.require("TPLProjectConstructor.sol");
const TPLSnapshotDb = artifacts.require("TPLSnapshotDb.sol");
const TPLWalletDb = artifacts.require("TPLWalletDb.sol");


const ProjectActionManager = artifacts.require("ProjectActionManager.sol");
const ProjectConstructor = artifacts.require("ProjectConstructor.sol");

function getAbi(contractName, param, ) {
  var obj = JSON.parse(fs.readFileSync(`../build/contracts/${contractName}`, 'utf8'));
  if (param) {
    return obj[param];
  }
}

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
    instanceList["ProjectDb"] = await ProjectDb.new();

    //Construc Doug Contract
    NOUSCoreInstance = await NousCore.new(
      nousTokenInstance.address,
      Object.keys(instanceList),
      Object.keys(instanceList).map(_name => instanceList[_name].address)
    );
  });

  async function createAllActions() {

    for (let item in actionsParams) {
      actionsParams[item].address = (await eval(`${item}.new()`)).address;
      console.log(`${item}: `, actionsParams[item].address);
    }

    let _actionNames = Object.keys(actionsParams).map(item => web3.utils.toHex(item));
    //console.log("_actionNames", _actionNames);
    let _actionAddr =  Object.keys(actionsParams).map(item => actionsParams[item].address);

    //console.log("_actionAddr", _actionAddr);

    await createAddActions([_actionNames, _actionAddr]);

    /*for (let item in actionsParams) {
      actionsParams[item].interface = await eval(`${item}.new()`);
      await createAddAction(item);
      //console.log(item, actionsParams[item].interface.address);

      assert.equal(actionsParams[item].interface.address, await instanceList["ActionDb"].actions(item));
    }*/
  }

  async function createAddAction(newActionName) {

    let data = [web3.utils.toHex(newActionName), actionsParams[newActionName].interface.address];
    let structure = actionsParams["ActionAddAction"];
    let bytes = getFunctionCallData(structure, data);

    await ActionManagerInstance.execute("ActionAddAction", bytes);
  }

  async function createAddActions(data) {
    //let data = [web3.utils.toHex(newActionName), actionsParams[newActionName].address];
    await actionManagerQuery("ActionAddActions", data);
  }

  async function actionManagerQuery(actionNmae, data) {
    let structure = actionsParams[actionNmae];
    let bytes = getFunctionCallData(structure, data);

    return (await ActionManagerInstance.execute(actionNmae, bytes)).tx;
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

    //await createAllActions();
    //let tpls = Object.keys(templates);

    // create instance templates
    for ( let item in templates ) {
      templates[item].interface = await eval(`${item}.new()`);
      /*let data = [[web3.utils.toHex(item)], [templates[item].interface.address], [templates[item].overwrite]];
      console.log(data);
      await actionManagerQuery("ActionAddTemplates", data);;*/
      console.log(item, templates[item].interface.address)
    }

    // add templates
    let _tplNames = Object.keys(templates).map(item => web3.utils.toHex(item));
    let _tplAddrs = Object.keys(templates).map(item => templates[item].interface.address);
    let _tplOwerWr = Object.keys(templates).map(item => templates[item].overwrite);

    console.log("_tplNames", _tplNames);
    console.log("_tplAddrs", _tplAddrs);

    let data = [_tplNames, _tplAddrs, _tplOwerWr];
    console.log("data", data);

    await actionManagerQuery("ActionAddTemplates", data);


    //console.log("11", await instanceList["TemplatesDb"].template("TPLConstructorOpenEndedFund", 0));

    //validate add templates
    for ( let item in templates ) {
      assert.equal(templates[item].interface.address, (await instanceList["TemplatesDb"].template(item, 0))[0], "Instance list not equal templates Db");
    }

    //STEP 1
    // todo дописать
    let _paramSale = [],_valSale = [];
    ["entryFee", "exitFee", "initPrice", "maxFundCup", "maxInvestors", "managementFee"].map(item => {
        _paramSale.push(web3.utils.toHex(item));
        _valSale.push(1);
    });

    data = [accounts[0], accounts[1], _paramSale, _valSale];
    console.log("STEP 1 ActionCreateCompOEFund1", await actionManagerQuery("ActionCreateCompOEFund1", data));

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
    let tpls = await instanceList["TemplatesDb"].getTplContracts(accounts[1], web3.utils.toHex("contracts"));
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

