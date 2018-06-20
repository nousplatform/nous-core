const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const fs = require('fs');
const BigNumber = require('bignumber.js');

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
const WalletDb = artifacts.require("WalletDb.sol");
const OpenEndedSaleDb = artifacts.require("OpenEndedSaleDb.sol");

const OpenEndedToken = artifacts.require("OpenEndedToken.sol");

const SnapshotDb = artifacts.require("SnapshotDb.sol");

const MathCalc = artifacts.require("MathCalc.sol");

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
  //console.log("data", data);

  return getFunctionCallData(structure, data);
}

//query to action manager
async function actionManagerQuery(actionName, data) {
  let bytes = getBytesCallData(actionName, data);
  //console.log("bytes", bytes);

  await ActionManagerInstance.execute(actionName, bytes);
}


async function createAddActions(data) {
  //let data = [web3.utils.toHex(newActionName), actionsParams[newActionName].address];
  await actionManagerQuery("ActionAddActions", data);
}

contract('NousCore', async function(accounts) {


  let instanceList = {
    //"name" : "instance"
  }

  beforeEach(async function () {

    // deployer.deploy(MathCalc);
    // deployer.autolink();

    nousTokenInstance = await NousTokenTest.new();

    //deploy
    ActionManagerInstance = instanceList["ActionManager"] = await NousActionManager.new();
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


  it("Validate Templates", async function() {

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
    await actionManagerQuery("ActionAddTemplates", dataTpl);

    console.log("-----==========VALIDATE TEMPLATES==========-----");

    for (let item in tpls) {
      let tplName = tpls[item];
      let res = await instanceList["TemplatesDb"].template(web3.utils.toHex(tplName), 0);
      assert.equal(templatesList[tplName].address, res, "Not Equal templates");
      console.log(`${tplName}: ${res}`);
    }

    let decimals = 18;

    let initTokens = {
      entryFee: 1,
      exitFee: 1,
      initPrice: 2,
      maxFundCup: 10000000,
      maxInvestors: 0,
      platformFee: 1
    };

    //STEP 1 To deploy
    var obj = {
      "TPLSnapshotDb": {
        "variables" : [
          accounts[1]
        ],
        "address": "0x0"
      },
      "TPLOpenEndedSaleDb": {
        "variables" : [
          accounts[1],
          ...Object.keys(initTokens).map(item => new BigNumber(initTokens[item] * Math.pow(10, decimals)))
        ],
        "address": "0x0"
      },
      "TPLOpenEndedToken": {
        "variables" : [
          accounts[1],
          [nousTokenInstance.address],
          "BWT TOKEN",
          "BWT",
          decimals,
          accounts[3]
        ],
        "address": "0x0"
      },
      "TPLProjectActionManager": {
        "variables" : [
          accounts[1],
          accounts[0],
        ],
        "address": "0x0"
      },
      "TPLWalletDb": {
        "variables" : [
          accounts[1]
        ],
        "address": "0x0"
      },
      /*"TPLProjectConstructor": {
        "variables" : [
          accounts[1],
          "_fundName",
          "_fundType",
          Object.keys(this).filter(item => {if (this instanceof item && item != "TPLProjectConstructor") { console.log("item", item); return item; } }),
          Object.keys(this).filter(item => {if (this instanceof item && item != "TPLProjectConstructor") { return this[item].address} }),
        ],
        "address": "0x0"
      }*/
    }

    let projectType = web3.utils.toHex("Open-end Fund");

    for (let _item in obj) {
      console.log("_item", obj[_item].variables);
      await ActionManagerInstance.deployTemplates(web3.utils.toHex(_item), getBytesCallData(_item, obj[_item].variables, "create"));
    }

    let _projContr = await instanceList["ProjectDb"].getProjectContracts(accounts[1], web3.utils.toHex(projectType));
    //console.log("_projContr", _projContr);

    var obj2 = {"TPLProjectConstructor": {
        "variables" : [
          accounts[1],
          "_fundName",
          "_fundType",
          _projContr[0],
          _projContr[1],
        ],
        "address": "0x0"
      }};

    await ActionManagerInstance.deployTemplates(web3.utils.toHex("TPLProjectConstructor"), getBytesCallData("TPLProjectConstructor", obj2["TPLProjectConstructor"].variables, "create"));

    let initialBalances = [100, 100, 150, 500];
    console.log("initialBalances", initialBalances);

    const user_1 = { address: accounts[1], balance: {nsu: 0, bwt:0} };
    const user_2 = { address: accounts[5], balance: {nsu: 0, bwt:0} };
    const user_3 = { address: accounts[3], balance: {nsu: 0, bwt:0} };

    await nousTokenInstance.mint(user_1.address, initialBalances[0], {
      from: accounts[0]
    });
    user_1.balance.nsu = initialBalances[0] * Math.pow(10, decimals);
    assert.equal(user_1.balance.nsu, (await nousTokenInstance.balanceOf(user_1.address)).toNumber(), "First balance");

    await nousTokenInstance.mint(user_2.address, initialBalances[1], {
      from: accounts[0]
    });
    user_2.balance.nsu = initialBalances[1] * Math.pow(10, decimals);
    assert.equal(user_2.balance.nsu, (await nousTokenInstance.balanceOf(user_2.address)).toNumber(), "Second balance");

    await nousTokenInstance.mint(user_3.address, initialBalances[2], {
      from: accounts[0]
    });
    user_3.balance.nsu = initialBalances[2] * Math.pow(10, decimals);
    assert.equal(user_3.balance.nsu, (await nousTokenInstance.balanceOf(user_3.address)).toNumber(), "Third balance");

    console.log("---=========Sale=========-------");

    let openEndedToken = OpenEndedToken.at(_projContr[1][2]);
    //console.log("total supplay", await openEndedToken.totalSupply());
    assert.equal(true, await openEndedToken.allowPurchases(nousTokenInstance.address), "allow purchases nsu tokens");

    assert.equal(user_2.balance.nsu, (await nousTokenInstance.balanceOf(user_2.address, {from: accounts[0]})).toNumber(), "Owner is first mining user_2 1000");

    let sum = user_2.balance.nsu;
    user_2.balance.nsu -= sum;

    let exponent = 10 * Math.pow(10, decimals+2),
    entryFee = (await openEndedToken.getDataParamsSaleDb(web3.utils.toHex("entryFee"))).toNumber();
    console.log("entryFee", entryFee);


    let platformFee = (await openEndedToken.getDataParamsSaleDb(web3.utils.toHex("platformFee"))).toNumber();

    let entryFeeSumExpected = (entryFee*sum)/exponent;
    let platformFeeSumExpected = (platformFee*sum)/exponent;
    let rate = (await openEndedToken.rate()).toNumber();

    console.log("entryFeeSumExpected ",entryFeeSumExpected);
    console.log("platformFeeSumExpected ",platformFeeSumExpected);

    console.log("rate  ",rate);


    //console.log("calculatePercent entry fee  ", (await openEndedToken.calculatePercent(sum, initTokens['entryFee'] * Math.pow(10, decimals), decimals)).toNumber());

    console.log("balance NSU 1", (await nousTokenInstance.balanceOf(user_2.address)).toNumber());
    console.log("sum to transfer NSU", sum);

    let totalSummFeeBWT = rate * sum;
    let totalSummBWT = totalSummFeeBWT - entryFee - platformFee;
    //console.log("Total sum rate  ", (await openEndedToken.percent(sum, rate, decimals)).toNumber());
    //console.log("maxFundCup ", (await openEndedToken.getDataParamsSaleDb(web3.utils.toHex("maxFundCup"))).toNumber());

    await nousTokenInstance.approveAndCall(openEndedToken.address, sum, "0x0", {from: user_2.address});
    console.log("approveAndCall");
    console.log("balance NSU 2 ", (await nousTokenInstance.balanceOf(user_2.address)).toNumber());
    console.log("balance BWT 2", (await openEndedToken.balanceOf(user_2.address)).toNumber());
    //assert.equal(totalSummBWT, (await openEndedToken.balanceOf(user_2.address)).toNumber(), "total summ BWT");

    console.log("NETSale BWT ", (await openEndedToken.fundCup(nousTokenInstance.address)).toNumber());

    console.log("---=========redeem=========-------");

    await openEndedToken.redeem(nousTokenInstance.address, 10 * Math.pow(10, decimals), "0x0", {from: user_2.address});
    user_2.balance.bwt = (await openEndedToken.balanceOf(user_2.address)).toNumber();

    //console.log("balance BWT ", user_2.balance);

    console.log("balance NSU ", (await nousTokenInstance.balanceOf(user_2.address)).toNumber());

    console.log("---=========NET=========-------");
    console.log("NET Purchase  BWT ", (await openEndedToken.fundCup(nousTokenInstance.address)).toNumber());


    console.log("---=========Total investors=========-------");

    assert.equal(1, (await openEndedToken.totalInvestors()).toNumber());

    console.log("---=========Redeem ALL=========-------");
    await openEndedToken.redeem(nousTokenInstance.address, user_2.balance.bwt, "0x0", {from: user_2.address});
    user_2.balance.bwt = (await openEndedToken.balanceOf(user_2.address)).toNumber();

    //console.log("balance BWT ", user_2.balance);
    console.log("balance NSU ", (await nousTokenInstance.balanceOf(user_2.address)).toNumber());

    assert.equal(0, (await openEndedToken.totalInvestors()).toNumber(), "Investors counter ");
    assert.equal(0,  user_2.balance.bwt, "Toatal balance BWT zero.");

    console.log("---=========Create Snapshot=========-------");

    let projectActionManager = ProjectActionManager.at(_projContr[1][3]);

    let time = new Date().getTime();
    await projectActionManager.actionAddSnapshot(time, web3.utils.toHex("swswsw"), 0.05 * Math.pow(10, decimals), {from: accounts[0]});


    let snapshotDb = SnapshotDb.at(_projContr[1][0]);
    //console.log("Current Rate",  (await snapshotDb.rate()).toNumber());
    //console.log("rate open ended token ", (await openEndedToken.rate()).toNumber());
    assert.equal(0.05 * Math.pow(10, decimals), (await snapshotDb.rate()).toNumber());


    console.log("---=========Add Wallet=========-------");
    await projectActionManager.actionAddWallet(web3.utils.toHex("BTC"), "0x00000002234", {from: accounts[1]});

    let walletAddr = await projectActionManager.getContractAddress("WalletDb");
    let walletDb = WalletDb.at(walletAddr);
    let addedWalet = await walletDb.wallets(0);
    assert.equal(false, addedWalet[2], "added wallet not confirmed");
    //console.log("walletDb.", await walletDb.wallets(0));

    console.log("---=========Confirm Wallet=========-------");
    //confirm wallet? only nous core
    await projectActionManager.actionConfirmWallet(web3.utils.toHex("BTC"), "0x00000002234", {from: accounts[0]});
    addedWalet = await walletDb.wallets(0);
    assert.equal(true, addedWalet[2], "added wallet not confirmed");

    console.log("---=========SetEntryFee=========-------");
    await projectActionManager.actionSetEntryFee(0.1 * Math.pow(10, decimals), {from: accounts[1]});

    let openEndedSaleDbAddr = await projectActionManager.getContractAddress("OpenEndedSaleDb");
    let openEndedSaleDb = OpenEndedSaleDb.at(openEndedSaleDbAddr);
    assert.equal(0.1 * Math.pow(10, decimals), (await openEndedSaleDb.params("entryFee")).toNumber());

    console.log("---=========SetExitFee=========-------");
    await projectActionManager.actionSetExitFee(0.2 * Math.pow(10, decimals), {from: accounts[1]});
    assert.equal(0.2 * Math.pow(10, decimals), (await openEndedSaleDb.params("exitFee")).toNumber());


    console.log("---=========SetPlatformFee=========-------");
    await projectActionManager.actionSetPlatformFee(0.02 * Math.pow(10, decimals), {from: accounts[0]});
    assert.equal(0.02 * Math.pow(10, decimals), (await openEndedSaleDb.params("platformFee")).toNumber());


    console.log("---=========Second PROJECT =========-------");

    for (let _item in obj) {
      console.log("_item", _item);
      await ActionManagerInstance.deployTemplates(web3.utils.toHex(_item), getBytesCallData(_item, obj[_item].variables, "create"));
    }

    _projContr = await instanceList["ProjectDb"].getProjectContracts(accounts[1], web3.utils.toHex(projectType));
    //console.log("_projContr", _projContr);
    _projContr[0] = _projContr[0].splice(-5);
    _projContr[1] = _projContr[1].splice(-5);

    var obj2 = {"TPLProjectConstructor": {
        "variables" : [
          accounts[1],
          "_fundName",
          "_fundType",
          _projContr[0],
          _projContr[1],
        ],
        "address": "0x0"
      }};

    await ActionManagerInstance.deployTemplates(web3.utils.toHex("TPLProjectConstructor"), getBytesCallData("TPLProjectConstructor", obj2["TPLProjectConstructor"].variables, "create"));

    console.log("---========= owner Add Manager =========-------");
    await projectActionManager.ownerAddManager(accounts[4], {from: accounts[1]});

    try {
      await projectActionManager.ownerAddManager(accounts[4], {from: accounts[0]});
    } catch (e) {
      console.log("Validate sequrity")
    }

    console.log("---========= Lock Actions =========-------");
    await projectActionManager.actionsLock({from: accounts[1]});

    try {
      console.log("try call from manager");
      await projectActionManager.actionSetExitFee(0.3 * Math.pow(10, decimals), {from: accounts[5]});
    } catch (e) {
      console.log("Is locked true");
    }

    try {
      console.log("Try unlock from nous platform");
      await projectActionManager.actionsUnlock({from: accounts[0]});
    } catch (e) {
      console.log("Not unlocking true");
    }








    /*try {
      await snapshotDb.createSnapshot(time, time, 0.05 * Math.pow(10, decimals));
    } catch (e) {
      console.log("Validate sequrity")
    }*/

    /*try {
       var res = await projectActionManager.actionAddSnapshot(time, time, 0.05 * Math.pow(10, decimals), {from: accounts[1]});
    } catch (e) {
      console.log("Validate sequrity")
    }*/



    //var dataSnapshotDb = [accounts[0]];

    //var deployData1 = [web3.utils.toHex("TPLSnapshotDb"), getBytesCallData("TPLSnapshotDb", dataSnapshotDb, "create")];

    //console.log("deployData1", deployData1);

    //var res = await instanceList["ActionDb"].actions("ActionProjectDeployer");
    //console.log("res", res);

    //await ActionManagerInstance.execute2(web3.utils.toHex("TPLSnapshotDb"), web3.eth.abi.encodeParameters(["address"], [accounts[0]]));

    /*var dataOpenEndedSaleDb = [accounts[1]];
    ["entryFee", "exitFee", "initPrice", "maxFundCup", "maxInvestors", "managementFee"].map(item => {
      dataOpenEndedSaleDb.push(item.length);
    });
    console.log("dataOpenEndedSaleDb", dataOpenEndedSaleDb);

    var deployData1 = [[web3.utils.toHex("TPLOpenEndedSaleDb")],[getBytesCallData("TPLOpenEndedSaleDb", dataOpenEndedSaleDb, "create")]];
    console.log("deployData1", deployData1);

    var res = await instanceList["ActionDb"].actions("ActionProjectDeployer");
    console.log("res", res);

    await actionManagerQuery("ActionProjectDeployer", deployData1);var dataOpenEndedSaleDb = [accounts[1]];*/



  })
})
