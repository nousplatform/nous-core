
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
// Available Accounts
// ==================
// (0) 0x2e978e66a435891694d73ddd5927dd183ea886f0
// (1) 0xc5b69164ffa3bb1caf8f50574a099d544ec704ed
// (2) 0x80f0f160bb752fccf9ac28cefbb980b246b0a18c
// (3) 0x72a06b19a7d2cc5cb5d423a7eb97fd978843f985
// (4) 0x40d5845c33a195c68488d12949024cea6aee2ff1
// (5) 0x02cdb8184f8233cb986d090a32e7f078273dff8c
// (6) 0x94f87ceb6eb7e377d23646973a8ce6758978dd20
// (7) 0xc201b6e74e0dcf6836f5681085dd374d9a4427df
// (8) 0x6b087c430ac465b841163dd394a4ed32c69de2ba
// (9) 0x06e5af0bc04007d3d21889e05b5b97f6c7e953db
//
// Private Keys
// ==================
// (0) 6a9820c88b6cd969500d568adb3eba64ae2f01d80fc0664fc4e4e484a9b30208
// (1) c8caff6dfe9f419d38e683bf4ab85e71aea1ff9f18220b4065d11d35233a8b0c
// (2) aa94239bb3b55c142190878f87d4884db016a86cfab64c9164b8edc1ceb104e0
// (3) 7fb409a2dec346177eb691999203bbb675bb5026f791797705aefeaa4598b62c
// (4) bf181bccdbf2318223ea322f0d4e225d0fb4df969b9229b1bd99226297e70afa
// (5) bd34425ce1d6727e32f0f7d7779758001c67c7289a2ad2bf07da87ff7c7f0e6e
// (6) 94c2aeeb451d80188a064874753b9e320ba427bd58961caa1325cfb078eb8cad
// (7) 6764a64e51f456f99620102501b6c45161309c09b5b4e5d4bce32087010fee5a
// (8) f9cc7746ab2176d671c8c4042e2badfe7ffc0fdf280d5c84ffd4a2d84e8362ce
// (9) 15790602ef2f5ae9bb6b73ce6cd4f9c6dd0990eeaa26471b6374af925a12843e




//
