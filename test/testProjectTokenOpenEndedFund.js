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
  let nousWallet = accounts[9];
  let openEndedToken;

  const user_1 = {address: accounts[2], balance: {nsu: 0, bwt: 0}};
  const user_2 = {address: accounts[5], balance: {nsu: 0, bwt: 0}};
  const user_3 = {address: accounts[3], balance: {nsu: 0, bwt: 0}};
  const nousPlatformWallet = {address: nousWallet, balance: {nsu: 0, bwt: 0}};

  let initTokens = {
    entryFee: 0,
    exitFee: 0, ///1 * Math.pow(10, (decimals-2)),
    initPrice: 2 * Math.pow(10, (decimals)),
    maxFundCup: 10000000 * Math.pow(10, (decimals)),
    maxInvestors: 0,
    platformFee: 1 * Math.pow(10, (decimals-2)) // 0.02
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
          ...Object.keys(initTokens).map(item => new BigNumber(initTokens[item]))
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
          nousWallet
        ],
        "address": "0x0"
      },
      "TPLProjectActionManager": {
        "variables": [
          fundOwner,
          nousPlatformWallet.address,
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
      //console.log("_item", configTpls[_item].variables);
      await ActionManagerInstance.deployTemplates(web3.utils.toHex(_item), getBytesCallData(_item, configTpls[_item].variables, "create"));
    }

    let _projContr = await instanceList["ProjectDb"].getProjectContracts(fundOwner, web3.utils.toHex(projectType));
    //console.log("_projContr", _projContr);
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

    let initialBalances = [100, 100, 150, 500];

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

    _projContr = await instanceList["ProjectDb"].getProjectContracts(fundOwner, web3.utils.toHex(projectType));

    openEndedToken = OpenEndedToken.at(_projContr[1][2]);

  });

  it("Allow purchases", async function () {
    assert.equal(true, await openEndedToken.allowPurchases(nousTokenInstance.address), "allow purchases nsu tokens");
  });


  let sumToBy = Math.pow(10, (decimals+2));

  it("Sale tokens", async function () {

    let bigSum = new BigNumber(sumToBy);

    user_2.balance.nsu -= sumToBy;

    // check balance NSU
    await nousTokenInstance.approveAndCall(openEndedToken.address, bigSum.toString(), "0x0", {from: user_2.address});
    assert.equal(user_2.balance.nsu, (await nousTokenInstance.balanceOf(user_2.address)).toNumber(), "NSU tokens not equal");

    // check entry fee
    let entryFee = (initTokens.entryFee * sumToBy) / Math.pow(10, (decimals+2));
    assert.equal(entryFee, (await openEndedToken.getFee(bigSum.toString(), "entryFee")).toNumber(), "Entry fee is not correct");

    // check platform fee
    let platformFee = (initTokens.platformFee * sumToBy) / Math.pow(10, (decimals+2));
    assert.equal(platformFee, (await openEndedToken.getFee(bigSum.toString(), "platformFee")).toString(), "Platform fee is not correct");
    nousPlatformWallet.balance.nsu += platformFee;

    // check sum amount bwt
    let sum = (sumToBy - platformFee - entryFee);
    user_2.balance.bwt = (new BigNumber((sum * Math.pow(10, (decimals))) / initTokens.initPrice)).toString();
    assert.equal(user_2.balance.bwt, (await openEndedToken.balanceOf(user_2.address)).toNumber(),  "All balance is equal 0");

    //check balance owner wallet
    assert.equal(entryFee, (await nousTokenInstance.balanceOf(fundOwner)).toNumber(), "Entree fee not equal balance owner fund");

    //check balance nous platform

    assert.equal(nousPlatformWallet.balance.nsu, (await nousTokenInstance.balanceOf(nousPlatformWallet.address)).toNumber(), "Platform fee not equal balance nousPlatform");

  });

  let sumR = Math.pow(10, (decimals+1));

  it("Redeem tokens", async function() {

    //console.log("(await nousTokenInstance.balanceOf(user_2.address)).toNumber()", (await nousTokenInstance.balanceOf(user_2.address)).toNumber());

    let bigSum = new BigNumber(sumToBy);
    await nousTokenInstance.approveAndCall(openEndedToken.address, bigSum.toString(), "0x0", {from: user_2.address});
    user_2.balance.nsu -= sumToBy;


    let bigSumR = new BigNumber(sumR);
    user_2.balance.bwt -= sumR;

    // check balance NSU
    await openEndedToken.redeem(nousTokenInstance.address, bigSumR.toString(), "0x0", {from: user_2.address});
    assert.equal(user_2.balance.bwt, (await openEndedToken.balanceOf(user_2.address)).toNumber(), "Balance not equal expected");

    let amount = (sumR * initTokens.initPrice) / Math.pow(10, (decimals));

    // check platform fee
    let platformFee = (initTokens.platformFee * amount) / Math.pow(10, (decimals+2));

    // platform fee
    nousPlatformWallet.balance.nsu += platformFee;
    assert.equal(nousPlatformWallet.balance.nsu, (await nousTokenInstance.balanceOf(nousPlatformWallet.address)).toNumber(), "Balance my be equal");

    //exit fee
    let exitFee = (initTokens.exitFee * amount) / Math.pow(10, (decimals+2));
    assert.equal(exitFee, (await nousTokenInstance.balanceOf(fundOwner)).toNumber(), "exit fee not equal");

    //validate balance
    user_2.balance.nsu += amount - platformFee - exitFee;

    assert.equal(user_2.balance.nsu, (await nousTokenInstance.balanceOf(user_2.address)).toNumber(), "not correct balance nsu");

  });





  /*it("Test Project tokens", async function () {


    // let sum = user_2.balance.nsu;
    // user_2.balance.nsu -= sum;


    //let exponent = 10 * Math.pow(10, decimals+2),
    // entryFee = (await openEndedToken.getDataParamsSaleDb(web3.utils.toHex("entryFee"))).toNumber();
    //
    // let platformFee = (await openEndedToken.getDataParamsSaleDb(web3.utils.toHex("platformFee"))).toNumber();
    //
    // let entryFeeSumExpected = (entryFee*sum)/exponent;
    // let platformFeeSumExpected = (platformFee*sum)/exponent;
    // let rate = (await openEndedToken.rate()).toNumber();
    //
    // let totalSummFeeBWT = rate * sum;
    // let totalSummBWT = totalSummFeeBWT - entryFee - platformFee;

    //console.log("---=========redeem=========-------");

    // await openEndedToken.redeem(nousTokenInstance.address, 10 * Math.pow(10, decimals), "0x0", {from: user_2.address});
    // user_2.balance.bwt = (await openEndedToken.balanceOf(user_2.address)).toNumber();
    //
    // //console.log("balance BWT ", user_2.balance);
    //
    // console.log("balance NSU ", (await nousTokenInstance.balanceOf(user_2.address)).toNumber());
    //
    // console.log("---=========NET=========-------");
    // console.log("NET Purchase  BWT ", (await openEndedToken.fundCup(nousTokenInstance.address)).toNumber());
    //
    //
    // console.log("---=========Total investors=========-------");
    //
    // assert.equal(1, (await openEndedToken.totalInvestors()).toNumber());
    //
    // console.log("---=========Redeem ALL=========-------");
    // await openEndedToken.redeem(nousTokenInstance.address, user_2.balance.bwt, "0x0", {from: user_2.address});
    // user_2.balance.bwt = (await openEndedToken.balanceOf(user_2.address)).toNumber();
    //
    // //console.log("balance BWT ", user_2.balance);
    // console.log("balance NSU ", (await nousTokenInstance.balanceOf(user_2.address)).toNumber());
    //
    // assert.equal(0, (await openEndedToken.totalInvestors()).toNumber(), "Investors counter ");
    // assert.equal(0,  user_2.balance.bwt, "Toatal balance BWT zero.");
  });*/
});
