//componenets
var Managers = artifacts.require("./Managers.sol");
var Permissions = artifacts.require("./Permissions.sol");
var Wallets = artifacts.require("./Wallets.sol");

//interfaces
var ContractProvider = artifacts.require("./ContractProvider.sol");

//models
var ManagerDb = artifacts.require("./ManagerDb.sol");
var PermissionsDb = artifacts.require("./PermissionsDb.sol");
var WalletsDb = artifacts.require("./WalletsDb.sol");

//security
var DougEnabled = artifacts.require("./DougEnabled.sol");
var FundManagerEnabled = artifacts.require("./FundManagerEnabled.sol");

var Fund = artifacts.require("./Fund.sol");
var FundManager = artifacts.require("./FundManager.sol");


var NousCreator = artifacts.require("./NousCreator.sol");

var NousToken = artifacts.require("./NousToken.sol");


module.exports = function(deployer) {

  //componenets
  deployer.deploy([Managers, Permissions, Wallets]);

  //interfaces
  //deployer.deploy([ContractProvider]);

  //models
  deployer.deploy([ManagerDb, PermissionsDb, WalletsDb]);

  //security
  //deployer.deploy([DougEnabled, FundManagerEnabled]);
    //deployer.deploy([Fund]);
    deployer.deploy([FundManager]);

    deployer.deploy([NousCreator, NousToken]);

};
