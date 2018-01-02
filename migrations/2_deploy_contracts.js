
//interfaces
//var ContractProvider = artifacts.require("./ContractProvider.sol");

var NousCreator = artifacts.require("./NousCreator.sol");
var FundManager = artifacts.require("./FundManager.sol");
//models
var InvestorDb = artifacts.require("./InvestorDb.sol");
var ManagerDb = artifacts.require("./ManagerDb.sol");
var PermissionDb = artifacts.require("./PermissionDb.sol");
var WalletDb = artifacts.require("./WalletDb.sol");


module.exports = function(deployer) {

  //deployer.deploy(NousCreator)

  deployer.then(function () {
      return NousCreator.new();
  })
    .then(function(NousCreator) {

      Promise.all(
        [
          FundManager.new(),
          InvestorDb.new(),
          ManagerDb.new(),
          PermissionDb.new(),
          WalletDb.new(),
        ]
      )
        .then(instances => {
          console.log("NousCreator", NousCreator.address);
          console.log("FundManager:", instances[0].address);
          console.log("InvestorDb:", instances[1].address);
          console.log("ManagerDb:", instances[2].address);
          console.log("PermissionDb:", instances[3].address);
          console.log("WalletDb:", instances[4].address);

          NousCreator.addContract(["investors_db","manager_db","permission_db","wallet_db","fund_manager"],
            [instances[1].address, instances[2].address,instances[3].address, instances[4].address, instances[0].address]);
        })
    })
};

// NousCreator: 0x4ba855172161f598d2a8a1e949f346d10a68a48e

// NousCreator: 0xffb5516d4432178ef105475835ad79e1cb6b2686


// NousCreator: 0xaef8bc4ae3b97fcca6521d843d0c3ab731dce630
// FundManager: 0xdffc69d37eb87b500e3bf7ee3d3a7feb66aede89 "fund_manager","0xdffc69d37eb87b500e3bf7ee3d3a7feb66aede89"
// InvestorDb: 0xa084b4172c996cf111fdeea4461c2e81836c8c6d  "investor_db","0xa084b4172c996cf111fdeea4461c2e81836c8c6d"
// ManagerDb: 0xdc683f7a21ec8dd3f3d87a6d1f1ffc1accb1e28a   "manager_db","0xdc683f7a21ec8dd3f3d87a6d1f1ffc1accb1e28a"
// PermissionDb: 0xeded62c65ba826d7e572e9f38ddf10458a1db01c "permission_db","0xeded62c65ba826d7e572e9f38ddf10458a1db01c"
// WalletDb: 0x5dee2857979762654fc0bca57974bb0df39998fa     "wallet_db","0x5dee2857979762654fc0bca57974bb0df39998fa"

// "Trast","Trast Token","TTT",1000000
// ["fund_manager","investor_db"],["0xdffc69d37eb87b500e3bf7ee3d3a7feb66aede89","0xa084b4172c996cf111fdeea4461c2e81836c8c6d"]
// ["investor_db","manager_db"],["0xef55bfac4228981e850936aaf042951f7b146e41","0xdc04977a2078c8ffdf086d618d1f961b6c546222"]


//NousCreator: 0x41091e367eb324be6880336f80e18a4524f88d6b
//
// FundManager: 0xe597a3db61dd2cdf4dbb0e113878fc207e91c5da
// InvestorDb: 0x98d3bee26c28a820947ec81e1842a8200ebbd3c4
// ManagerDb: 0x4b1ba8f64de4c15c065aef18774b957facfd0301
// PermissionDb: 0xd3469e9a982cdb4d85961c4a1b09224652c46d89
// WalletDb: 0xe386c3845f45a69e0489cf4a0dbe5132bbee8a3d




