const Web3 = require("web3");
const web3 = new Web3(new Web3.providers.HttpProvider("http://localhost:8545"));
const fs = require("fs");

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
const ActionSetActionPermission = artifacts.require(
  "ActionSetActionPermission.sol"
);
const ActionAddAction = artifacts.require("ActionAddAction.sol");
const ActionAddUser = artifacts.require("ActionAddUser.sol");
const ActionAddActions = artifacts.require("ActionAddActions.sol");
const ActionAddContract = artifacts.require("ActionAddContract.sol");
const ActionRemoveContract = artifacts.require("ActionRemoveContract.sol");
//project actions

const ActionAddTemplates = artifacts.require("ActionAddTemplates.sol");
const ActionCreateNewProject = artifacts.require("ActionCreateNewProject.sol");

//temlates
const TPLOpenEndedSaleDb = artifacts.require("TPLOpenEndedSaleDb.sol");
const TPLOpenEndedToken = artifacts.require("TPLOpenEndedToken.sol");
const TPLProjectActionManager = artifacts.require(
  "TPLProjectActionManager.sol"
);
const TPLProjectConstructor = artifacts.require("TPLProjectConstructor.sol");
const TPLSnapshotDb = artifacts.require("TPLSnapshotDb.sol");
const TPLWalletDb = artifacts.require("TPLWalletDb.sol");

const ProjectActionManager = artifacts.require("ProjectActionManager.sol");
const ProjectConstructor = artifacts.require("ProjectConstructor.sol");

const OpenEndedToken = artifacts.require("OpenEndedToken.sol");

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

  "ActionCreateNewProject",
  "ActionAddTemplates"
];

const tpls = [
  "TPLOpenEndedSaleDb",
  "TPLOpenEndedToken",
  "TPLProjectActionManager",
  "TPLProjectConstructor",
  "TPLSnapshotDb",
  "TPLWalletDb"
];

let contractList = {};
let actionsList = {};
let templatesList = {};

let nousTokenInstance;
let NOUSCoreInstance;
let ActionManagerInstance;

function getAbi(contractName, param = "abi") {
  var obj = JSON.parse(
    fs.readFileSync(
      `${__dirname}/../build/contracts/${contractName}.json`,
      "utf8"
    )
  );
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
function getFunctionCallData({ name, inputs = [] }, _data = null) {
  return web3.eth.abi.encodeFunctionCall(
    {
      name: name,
      type: "function",
      inputs: inputs
    },
    _data
  );
}

//crate date for action manager
function getBytesCallData(actionName, data, functionName) {
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

contract("NousCore", async function(accounts) {
  let instanceList = {
    //"name" : "instance"
  };

  beforeEach(async function() {
    nousTokenInstance = await NousTokenTest.new();

    //deploy
    ActionManagerInstance = instanceList[
      "ActionManager"
    ] = await NousActionManager.new();
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
    console.log(
      "-----==========DEPLOY ACTIONS FOR ACTION MANAGER==========-----"
    );

    for (let item in actions) {
      let actionName = actions[item];

      actionsList[actionName] = await eval(`${actionName}.new()`);
      console.log(`${actionName}: `, actionsList[actionName].address);
    }

    let _actionNames = Object.keys(actionsList).map(item =>
      web3.utils.toHex(item)
    );
    let _actionAddr = Object.keys(actionsList).map(
      item => actionsList[item].address
    );

    await createAddActions([_actionNames, _actionAddr]);

    console.log("-----==========CREATE DEPLOY TEMPLATES==========-----");
    for (let item in tpls) {
      let tplName = tpls[item];
      templatesList[tplName] = await eval(`${tplName}.new()`);
      console.log(`${tplName}: `, templatesList[tplName].address);
    }

    console.log("-----==========ADD TEMPLATES==========-----");
    let _tplNames = Object.keys(templatesList).map(item =>
      web3.utils.toHex(item)
    );
    let _tplAddrs = Object.keys(templatesList).map(
      item => templatesList[item].address
    );
    let dataTpl = [_tplNames, _tplAddrs];
    await actionManagerQuery("ActionAddTemplates", dataTpl);

    console.log("-----==========VALIDATE TEMPLATES==========-----");

    for (let item in tpls) {
      let tplName = tpls[item];
      let res = await instanceList["TemplatesDb"].template(
        web3.utils.toHex(tplName),
        0
      );
      assert.equal(templatesList[tplName].address, res, "Not Equal templates");
      console.log(`${tplName}: ${res}`);
    }

    //STEP 1 To deploy
    var obj = {
      TPLSnapshotDb: {
        variables: [accounts[1]],
        address: "0x0"
      },
      TPLOpenEndedSaleDb: {
        variables: [
          accounts[1],
          ...[
            "entryFee",
            "exitFee",
            "initPrice",
            "maxFundCup",
            "maxInvestors",
            "managementFee"
          ].map(item => {
            return item.length;
          })
        ],
        address: "0x0"
      },
      TPLOpenEndedToken: {
        variables: [
          accounts[1],
          nousTokenInstance.address,
          "BWT TOKEN",
          "BWT",
          18,
          accounts[0]
        ],
        address: "0x0"
      },
      TPLProjectActionManager: {
        variables: [accounts[1], accounts[0]],
        address: "0x0"
      }
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
    };

    let projectType = web3.utils.toHex("Open-end Fund");
    // console.log("1111", 1111);

    await actionManagerQuery("ActionCreateNewProject", [
      accounts[1],
      projectType
    ]);

    let nextIdProject = await instanceList["ProjectDb"].getLasId(
      accounts[1],
      projectType
    );

    assert.equal(
      1,
      await instanceList["ProjectDb"].getLasId(accounts[1], projectType)
    );

    for (let _item in obj) {
      console.log("_item", _item);
      await ActionManagerInstance.deployTemplates(
        web3.utils.toHex(_item),
        getBytesCallData(_item, obj[_item].variables, "create")
      );
    }

    let _projContr = await instanceList["ProjectDb"].getProjectContracts(
      accounts[1],
      web3.utils.toHex(projectType),
      0
    );
    console.log("_projContr", _projContr);

    var obj2 = {
      TPLProjectConstructor: {
        variables: [
          accounts[1],
          "_fundName",
          "_fundType",
          _projContr[0],
          _projContr[1]
        ],
        address: "0x0"
      }
    };
    //console.log("obj2", obj2);

    await ActionManagerInstance.deployTemplates(
      web3.utils.toHex("TPLProjectConstructor"),
      getBytesCallData(
        "TPLProjectConstructor",
        obj2["TPLProjectConstructor"].variables,
        "create"
      )
    );

    let _projContr2 = await instanceList["ProjectDb"].getProjectContracts(
      accounts[1],
      "Open-end Fund"
    );
    //console.log("_projContr2", _projContr2);

    console.log("_projContr", _projContr2);

    let initialBalances = [
      1000 * Math.pow(10, 18),
      2000 * Math.pow(10, 18),
      150 * Math.pow(10, 18),
      500 * Math.pow(10, 18)
    ];

    const user_1 = { address: accounts[1], balance: 0 };
    const user_2 = { address: accounts[2], balance: 0 };
    const user_3 = { address: accounts[3], balance: 0 };

    await nousTokenInstance.mint(user_1.address, initialBalances[0], {
      from: accounts[0]
    });
    user_1.balance = initialBalances[0] * Math.pow(10, 18);
    await nousTokenInstance.mint(user_2.address, initialBalances[1], {
      from: accounts[0]
    });
    user_2.balance = initialBalances[1] * Math.pow(10, 18);
    await nousTokenInstance.mint(user_3.address, initialBalances[2], {
      from: accounts[0]
    });
    user_3.balance = initialBalances[2] * Math.pow(10, 18);

    let openEndedToken = OpenEndedToken.at(_projContr[1][2]);
    console.log("total supplay", await openEndedToken.totalSupply());
    console.log(
      "await openEndedToken.allowPurchases(nousTokenInstance.address)",
      await openEndedToken.allowPurchases(nousTokenInstance.address)
    );

    assert.equal(
      user_1.balance,
      (await nousTokenInstance.balanceOf(user_1.address, {
        from: accounts[0]
      })).toNumber(),
      "Owner is first mining user_1 1000"
    );
    console.log("_projContr[1][2]", _projContr[1][2]);

    let sum = 99 * Math.pow(10, 18);
    await nousTokenInstance.approveAndCall(_projContr[1][2], sum, {
      from: user_1.address
    });

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
  });
});
