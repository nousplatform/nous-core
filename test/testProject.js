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
    entryFee: 0,
    exitFee: 0,
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
    let _actionAddr =  Object.keys(actionsList).map(item => actionsList[item].address);

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
        "variables" : [
          fundOwner
        ],
        "address": "0x0"
      },
      "TPLOpenEndedSaleDb": {
        "variables" : [
          fundOwner,
          ...Object.keys(initTokens).map(item => new BigNumber(initTokens[item] * Math.pow(10, decimals)))
        ],
        "address": "0x0"
      },
      "TPLOpenEndedToken": {
        "variables" : [
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
        "variables" : [
          fundOwner,
          nousPlatform,
        ],
        "address": "0x0"
      },
      "TPLWalletDb": {
        "variables" : [
          fundOwner
        ],
        "address": "0x0"
      }
    }


    for (let _item in configTpls) {
      //console.log("_item", configTpls[_item].variables);
      await ActionManagerInstance.deployTemplates(web3.utils.toHex(_item), getBytesCallData(_item, configTpls[_item].variables, "create"));
    }

    let _projContr = await instanceList["ProjectDb"].getProjectContracts(fundOwner, web3.utils.toHex(projectType));
    //console.log("_projContr", _projContr);
    configTpls2 = {"TPLProjectConstructor": {
        "variables" : [
          fundOwner,
          "_fundName",
          "_fundType",
          _projContr[0],
          _projContr[1],
        ],
        "address": "0x0"
      }};

    await ActionManagerInstance.deployTemplates(web3.utils.toHex("TPLProjectConstructor"), getBytesCallData("TPLProjectConstructor", configTpls2["TPLProjectConstructor"].variables, "create"));
    //projectActionManager = ProjectActionManager.at(_projContr[1][3]);

  });

  it("Test Project tokens", async function() {
    _projContr = await instanceList["ProjectDb"].getProjectContracts(fundOwner, web3.utils.toHex(projectType));

    let initialBalances = [100, 100, 150, 500];

    const user_1 = { address: fundOwner, balance: {nsu: 0, bwt:0} };
    const user_2 = { address: accounts[5], balance: {nsu: 0, bwt:0} };
    const user_3 = { address: accounts[3], balance: {nsu: 0, bwt:0} };

    await nousTokenInstance.mint(user_1.address, initialBalances[0], {
      from: nousPlatform
    });

    user_1.balance.nsu = initialBalances[0] * Math.pow(10, decimals);
    assert.equal(user_1.balance.nsu, (await nousTokenInstance.balanceOf(user_1.address)).toNumber(), "First balance");

    await nousTokenInstance.mint(user_2.address, initialBalances[1], {
      from: nousPlatform
    });
    user_2.balance.nsu = initialBalances[1] * Math.pow(10, decimals);
    assert.equal(user_2.balance.nsu, (await nousTokenInstance.balanceOf(user_2.address)).toNumber(), "Second balance");

    await nousTokenInstance.mint(user_3.address, initialBalances[2], {
      from: nousPlatform
    });
    user_3.balance.nsu = initialBalances[2] * Math.pow(10, decimals);
    assert.equal(user_3.balance.nsu, (await nousTokenInstance.balanceOf(user_3.address)).toNumber(), "Third balance");

    //console.log("---=========Sale=========-------");

    openEndedToken = OpenEndedToken.at(_projContr[1][2]);
    //console.log("total supplay", await openEndedToken.totalSupply());
    assert.equal(true, await openEndedToken.allowPurchases(nousTokenInstance.address), "allow purchases nsu tokens");

    assert.equal(user_2.balance.nsu, (await nousTokenInstance.balanceOf(user_2.address, {from: nousPlatform})).toNumber(), "Owner is first mining user_2 1000");

    let sum = user_2.balance.nsu;
    user_2.balance.nsu -= sum;

    await nousTokenInstance.approveAndCall(openEndedToken.address, sum, "0x0", {from: user_2.address});

    assert.equal((await nousTokenInstance.balanceOf(user_2.address)).toNumber(), 0, "All balance is equal 0");
    assert.equal((await openEndedToken.balanceOf(user_2.address)).toNumber(), 49500000000000000000, "All balance is equal 0");
    assert.equal((await openEndedToken.fundCup(nousTokenInstance.address)).toNumber(), 49500000000000000000, "Net is equal balance user")

    //console.log("---=========redeem=========-------");

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
  });

  it("Create Snapshot", async function() {
    projectActionManager = ProjectActionManager.at(_projContr[1][3]);
    let rete = 0.05 * Math.pow(10, decimals);

    let time = new Date().getTime();
    await projectActionManager.actionAddSnapshot(time, web3.utils.toHex("swswsw"), rete, {from: nousPlatform});

    let snapshotDb = SnapshotDb.at(_projContr[1][0]);
    //console.log("Current Rate",  (await snapshotDb.rate()).toNumber());
    //console.log("rate open ended token ", (await openEndedToken.rate()).toNumber());
    assert.equal(rete, (await snapshotDb.rate()).toNumber());
  });

  it("Confirm Wallet", async function() {
    let walletTicker = web3.utils.toHex("BTC");
    let walletAddress = "0x00000002234";

    await projectActionManager.actionAddWallet(walletTicker, walletAddress, {from: accounts[1]});

    let walletAddr = await projectActionManager.getContractAddress("WalletDb");
    let walletDb = WalletDb.at(walletAddr);
    let addedWalet = await walletDb.wallets(0);
    assert.equal(false, addedWalet[2], "added wallet not confirmed");

    await projectActionManager.actionConfirmWallet(walletTicker, walletAddress, {from: accounts[0]});
    addedWalet = await walletDb.wallets(0);
    assert.equal(true, addedWalet[2], "added wallet not confirmed");
  });

  it("SetEntryFee", async function() {
    let newEntryFee = 0.1 * Math.pow(10, decimals);
    await projectActionManager.actionSetEntryFee(newEntryFee, {from: fundOwner});

    let openEndedSaleDbAddr = await projectActionManager.getContractAddress("OpenEndedSaleDb");
    openEndedSaleDb = OpenEndedSaleDb.at(openEndedSaleDbAddr);
    assert.equal(newEntryFee, (await openEndedSaleDb.params("entryFee")).toNumber());
  });

  it("Set Exit Fee", async function() {
    let newExitFee = 0.2 * Math.pow(10, decimals);
    await projectActionManager.actionSetExitFee(newExitFee, {from: fundOwner});
    assert.equal(newExitFee, (await openEndedSaleDb.params("exitFee")).toNumber());
  });

  it("Set Platform Fee", async function() {
    let newPlatformFee = 0.02 * Math.pow(10, decimals);
    await projectActionManager.actionSetPlatformFee(newPlatformFee, {from: nousPlatform});
    assert.equal(newPlatformFee, (await openEndedSaleDb.params("platformFee")).toNumber());
  });

  it("Owner Add Remove Manager", async function() {
    //add manager
    await projectActionManager.ownerAddManager(accounts[4], {from: fundOwner});

    let newExitFee = 0.3 * Math.pow(10, decimals);
    await projectActionManager.actionSetExitFee(newExitFee, {from: accounts[4]});
    assert.equal(newExitFee, (await openEndedSaleDb.params("exitFee")).toNumber());

    try {
      await projectActionManager.ownerAddManager(accounts[4], {from: nousPlatform});
      assert.isNotOk('everything', 'this will fail');
    } catch (e) { }

    //delete manager
    await projectActionManager.ownerRemoveManager(accounts[4], {from: fundOwner});
    newExitFee = 0.4 * Math.pow(10, decimals);
    try{
      await projectActionManager.actionSetExitFee(newExitFee, {from: accounts[4]});
      assert.isNotOk("", 'manager not permission changes params');
    } catch (e) { }

  });


  it("Lock Unlock Actions", async function() {
    await projectActionManager.actionsLock({from: fundOwner});

    try {
      await projectActionManager.actionSetExitFee(0.3 * Math.pow(10, decimals), {from: fundOwner});
      assert.isNotOk("action set fees", "should be an exception");
    } catch (e) { }

    try {
      await projectActionManager.actionsUnlock({from: nousPlatform});
      assert.isNotOk("unlock action", "should be an exception. Nous platform cant unlocked action");
    } catch (e) {
      //console.log("Not unlocking true");
    }

    await projectActionManager.actionsUnlock({from: fundOwner});

    await projectActionManager.actionSetExitFee(0.3 * Math.pow(10, decimals), {from: fundOwner});

  });

  it("Validate Add Remove Contracts", async function() {

    assert.isFalse(await projectActionManager.allowed(), 'on deploy allowed is false');

    // allow
    await projectActionManager.ownerAllow({from: fundOwner});

    assert.isTrue(await projectActionManager.allowed(), 'owner allow changes contracts');

    // add contract is allowed
    await ActionManagerInstance.deployTemplates(web3.utils.toHex("TPLSnapshotDb"), getBytesCallData("TPLSnapshotDb", configTpls["TPLSnapshotDb"].variables, "create"));
    _projContr = await instanceList["ProjectDb"].getProjectContracts(fundOwner, web3.utils.toHex(projectType));

    let addr = _projContr[1].pop();
    await projectActionManager.actionAddContract(web3.utils.toHex("SnapshotDb"), addr, {from: nousPlatform});

    assert.equal(addr, await projectActionManager.getContractAddress(web3.utils.toHex("SnapshotDb")), "address is not equal");

    //add contract not allowed
    await projectActionManager.ownerDisallow({from: fundOwner});
    assert.isFalse(await projectActionManager.allowed(), 'owner allow changes contracts');

    await ActionManagerInstance.deployTemplates(web3.utils.toHex("TPLSnapshotDb"), getBytesCallData("TPLSnapshotDb", configTpls["TPLSnapshotDb"].variables, "create"));
    _projContr = await instanceList["ProjectDb"].getProjectContracts(fundOwner, web3.utils.toHex(projectType));
    addr = _projContr[1].pop();

    try {
      await projectActionManager.actionAddContract(web3.utils.toHex("SnapshotDb"), addr, {from: nousPlatform});
      assert.throw("Is not true. May be exception");
    } catch (e) {

    }

  });

  it("Validate airdrop tokens", async function() {
    let amountOf = 1 * Math.pow(10, decimals);

    await projectActionManager.actionAirdropToken(amountOf, {from: nousPlatform});

    let balance = (await openEndedToken.balanceOf(fundOwner)).toNumber();
    assert.equal(balance, amountOf, "Valid balance");

  });






})
