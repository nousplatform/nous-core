
//interfaces
//var ContractProvider = artifacts.require("./ContractProvider.sol");

//models
var ManagerDb = artifacts.require("./ManagerDb.sol");
var PermissionDb = artifacts.require("./PermissionDb.sol");
var WalletDb = artifacts.require("./WalletDb.sol");
var FundManager = artifacts.require("./FundManager.sol");
var NousCreator = artifacts.require("./NousCreator.sol");


module.exports = function(deployer) {

  //deployer.deploy(NousCreator)

  //deployer.deploy([FundManager, PermissionDb, WalletDb, ManagerDb])

  deployer.deploy(FundManager);
  deployer.deploy(PermissionDb);
  deployer.deploy(WalletDb);
  deployer.deploy(ManagerDb);

  /*deployer.then(function () {
      return NousCreator.new();
  })
    .then(function(NousCreator) {
      Promise.all(
        [
          FundManager.new(),
          PermissionDb.new(),
          WalletDb.new(),
          ManagerDb.new(),
        ]
      )
        .then(instances => {
          console.log("FundManager:", instances[0].address);
          console.log("PermissionDb:", instances[1].address);
          console.log("WalletDb:", instances[2].address);
          console.log("ManagerDb:", instances[3].address);

          NousCreator.addContract("fundmanager", instances[0].address);
          NousCreator.addContract("permissiondb", instances[1].address);
          NousCreator.addContract("walletdb", instances[2].address);
          NousCreator.addContract("managerdb", instances[3].address);

        })
    })*/
};

// NousCreator: 0x4ba855172161f598d2a8a1e949f346d10a68a48e