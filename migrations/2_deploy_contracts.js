//componenets
var Managers = artifacts.require("./Managers.sol");
var Permissions = artifacts.require("./Permissions.sol");

//interfaces
var ContractProvider = artifacts.require("./ContractProvider.sol");

//models
var ManagerDb = artifacts.require("./ManagerDb.sol");
var PermissionsDb = artifacts.require("./PermissionsDb.sol");

//security
var DougEnabled = artifacts.require("./DougEnabled.sol");
var FundManagerEnabled = artifacts.require("./FundManagerEnabled.sol");

var Fund = artifacts.require("./Fund.sol");
var FundManager = artifacts.require("./FundManager.sol");


var NousCreator = artifacts.require("./NousCreator.sol");


module.exports = function(deployer) {

  //componenets
  //deployer.deploy([Managers, Permissions]);

  //interfaces
  //deployer.deploy([ContractProvider]);

  //models
  //deployer.deploy([ManagerDb, PermissionsDb]);

  //security
  //deployer.deploy([DougEnabled, FundManagerEnabled]);

  //deployer.deploy([Fund, FundManager]);


    deployer.deploy([NousCreator]);

};
