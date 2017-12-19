
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

//var NousToken = artifacts.require("./NousToken.sol");

var PreSale = artifacts.require("./PreSale.sol");
var MainSale = artifacts.require("./MainSale.sol");


module.exports = function(deployer) {

  deployer
    .then(function() {

    })

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
    deployer.deploy([PreSale, MainSale]);

    //deployer.deploy([NousCreator, NousToken]);

};
