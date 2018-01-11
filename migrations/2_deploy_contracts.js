
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
//

//
// //vailable Accounts
// ==================
// (0) 0x4ec74e19d3bec2d635d81f067164ee25f0596226
// (1) 0xed41acc85bb1dfbb6067b2f669ca5d8629ba3a17
// (2) 0x18e3adb9c49b57eed436fd30866f76e44ee327a0
// (3) 0xb70ec8e5c9339f9afb4744c56763357daaf5c7fc
// (4) 0x6747c16c2ff2741fe813af7020dfe00daab9bb3b
// (5) 0xfd7180062e88bc61b3e1428113d5ab96b232fa55
// (6) 0x70bb085ad550455a5640d29b51e33df3b3a0bce8
// (7) 0x1847dad95f89ace6af233383e64bd3c2181f55d5
// (8) 0xd45403a61e6c6a32de0a68daa7a337c926be90e3
// (9) 0xb17a116ccc6efbe36da92eba2ba3a346554b2f5e
//
// Private Keys
// ==================
// (0) a84a6a484f1425c3e7ad08f508e4e27041f018353ce92da56293b3dad5ea01cc
// (1) a2de8b394e33a5c7bba97906a996ffcf353fee1452d5504f99cbf932f0a97d3f
// (2) 631c392905f5a585aa5cfdc12983bcea29288d0afd354ecbf46aa757ecdc96a2
// (3) 1c6b0ae79289c5caa5955e179ac63b5044f7b9b7a2554afffdce2e5ed654cbf7
// (4) eb07e8c1924afa5c5126d53f96c25d813dbd9dba4ca1cc27399a2cca6b736765
// (5) fbc5b80ee9d0fb965dff06033379fef33ccf994836ad781810f7586e5c82d830
// (6) 407c797d331b3faf459f934c050f96b029b12564664c4efe194f2baefb896b26
// (7) 9ef5ad560998ee435e70fb3e32630f575751bff7917157bc400187babc51f523
// (8) a4480cb7a1d5005eb9b6b76883cfb76b3343feb60e43b83276a1aca02b5c257b
// (9) 24db1e50a4328455717139c963038b5dd9f5f34ec0cfc67645aa0eec0577be64





//
