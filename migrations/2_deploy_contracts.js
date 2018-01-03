
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


//Saving artifacts...
// NousCreator 0xf944ff104c96c86440fe33f16c0410c9f3d69da3
// FundManager: 0x7488746a601912a0e0ba22d69928097451c8e1ba
// InvestorDb: 0xe5a0074b5004e4861a38f5800d7a6defec0a4354
// ManagerDb: 0xdd856a77a8c63e0cf31c3ff182f0e09c0fab171d
// PermissionDb: 0xda6fa3801d5cb61b2f3102baac0e6c86e7500bd8
// WalletDb: 0xe449e9f0de6e2f83dfd2026bbe304bca4abee1d9





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
//

// Available Accounts
// ==================
// (0) 0x02630a20eeedfc11d4eeb3b00998b549f4fb501a
// (1) 0x9c529a7d7dbe4bdd86fb8e2f83274537e6cfe538
// (2) 0xa0e2fa97d09a70d1913c5204e492277a1576cc84
// (3) 0xe77b3d541cb668d0061c4ca71f7d9eea86be023b
// (4) 0x40803f75b12d38a15b71b498759378156681acce
// (5) 0x52a0bcd854eb5b6b0208b286ee0ed606221dcd5d
// (6) 0x0dc0f68d9d2ee960ecf4d08a894ad027a1dca217
// (7) 0x825169299ee4b7e9169c6cba4a345e5fc44672fc
// (8) 0xdd8f7f35b5d08c586a0f920cdbd7e16b07b5685a
// (9) 0x28d48183b5c02e57c79ae1a89d20a9ef676711be
//
// Private Keys
// ==================
// (0) 021943e389c4f6b0b480af7d840ed98f484a10d6f728dcc24754ec1411cad077
// (1) dc59b832eebfad07cbfd2ed902ad73a753c8e52cf57057b1ca6d5c9ef32a909f
// (2) c2c2e9afd2a9492c868511095bf1f8221f859e1c57a5f10666b472365d03a279
// (3) c1e3418750b5463113feb90b127ced84ef43707652452ab9d3319704dc5f9dc7
// (4) bebe811fb4b4874344902075fc98dbe74b62701c36ba18a440eaae52d41b215e
// (5) c1ae18ee3a4e65f5e205cdc3d32d44150b12afad742c19f94c3f17628321324a
// (6) 0650098f625a7045c75dd070ff926667f58d5e8a3c6bb2b05df35e323dad9e81
// (7) a39a56d7147531ccda077db50cfab89087361808276f961ab9c145e62748ce44
// (8) 937e1ec7da281813efcc247db7cebb660bff930c9eb3e19d691b6359e21775bd
// (9) c94597f42e13e0f35cb8aecfd05bce578819211b49400e53b0482f3f56611e61




//
