//componenets
var Managers = artifacts.require("./Managers.sol");
var Permissions = artifacts.require("./Permissions.sol");
var Wallets = artifacts.require("./Wallets.sol");

//interfaces
var ContractProvider = artifacts.require("./ContractProvider.sol");

//models
var ManagerDb = artifacts.require("./ManagerDb.sol");
var PermissionDb = artifacts.require("./PermissionDb.sol");
var WalletDb = artifacts.require("./WalletDb.sol");

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
  deployer.deploy([ManagerDb, PermissionDb, WalletDb]);

  //security
  //deployer.deploy([DougEnabled, FundManagerEnabled]);
    //deployer.deploy([Fund]);
    deployer.deploy([FundManager]);

    deployer.deploy([NousCreator, NousToken]);

};
