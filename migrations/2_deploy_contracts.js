
//interfaces
//var ContractProvider = artifacts.require("./ContractProvider.sol");

//var NOUSManager = artifacts.require("./NOUSManager.sol");
// var FundConstructor = artifacts.require("./FundConstructor.sol");
// var FundManager = artifacts.require("./FundConstructor.sol");
//
// //models
// var InvestorDb = artifacts.require("./InvestorDb.sol");
// var TokensDb = artifacts.require("./TokensDb.sol");
// var PermissionDb = artifacts.require("./PermissionDb.sol");
// var WalletDb = artifacts.require("./WalletDb.sol");
//
// //tokens
// const Sale = artifacts.require("./Sale.sol");



module.exports = async function(deployer) {

  //deployer.deploy(NOUSManager);
  // let nousManager = await NOUSManager.deployed();
  // let Sale = await Sale.deployed();
  //
  //
  // console.log("nousManager", nousManager);


  // deployer.then(function () {
  //     return NOUSManager.new();
  // })
  //   .then(function(NOUSManager) {
  //
  //     Promise.all(
  //       [
  //         FundManager.new(),
  //         FundConstructor.new(),
  //         InvestorDb.new(),
  //         TokensDb.new(),
  //         PermissionDb.new(),
  //         WalletDb.new(),
  //       ]
  //     )
  //       .then(instances => {
  //         console.log("NOUSManager", NOUSManager.address);
  //         console.log("FundManager:", instances[0].address);
  //         console.log("FundConstructor:", instances[1].address);
  //         console.log("InvestorDb:", instances[2].address);
  //         console.log("TokensDb:", instances[3].address);
  //         console.log("PermissionDb:", instances[4].address);
  //         console.log("WalletDb:", instances[5].address);
  //
  //         NOUSManager.addContract([,"fund_manager","fund_constructor","investors_db","tokens_db","permission_db","wallet_db"],
  //           [instances[0].address, instances[1].address, instances[2].address,instances[3].address, instances[4].address, ]);
  //       })
  //   })
};


//Saving artifacts...
// NOUSManager 0xf944ff104c96c86440fe33f16c0410c9f3d69da3
// FundManager: 0x7488746a601912a0e0ba22d69928097451c8e1ba
// InvestorDb: 0xe5a0074b5004e4861a38f5800d7a6defec0a4354
// ManagerDb: 0xdd856a77a8c63e0cf31c3ff182f0e09c0fab171d
// PermissionDb: 0xda6fa3801d5cb61b2f3102baac0e6c86e7500bd8
// WalletDb: 0xe449e9f0de6e2f83dfd2026bbe304bca4abee1d9

// NOUSManager: 0x4ba855172161f598d2a8a1e949f346d10a68a48e

// NOUSManager: 0xffb5516d4432178ef105475835ad79e1cb6b2686


// NOUSManager: 0xaef8bc4ae3b97fcca6521d843d0c3ab731dce630
// FundManager: 0xdffc69d37eb87b500e3bf7ee3d3a7feb66aede89 "fund_manager","0xdffc69d37eb87b500e3bf7ee3d3a7feb66aede89"
// InvestorDb: 0xa084b4172c996cf111fdeea4461c2e81836c8c6d  "investor_db","0xa084b4172c996cf111fdeea4461c2e81836c8c6d"
// ManagerDb: 0xdc683f7a21ec8dd3f3d87a6d1f1ffc1accb1e28a   "manager_db","0xdc683f7a21ec8dd3f3d87a6d1f1ffc1accb1e28a"
// PermissionDb: 0xeded62c65ba826d7e572e9f38ddf10458a1db01c "permission_db","0xeded62c65ba826d7e572e9f38ddf10458a1db01c"
// WalletDb: 0x5dee2857979762654fc0bca57974bb0df39998fa     "wallet_db","0x5dee2857979762654fc0bca57974bb0df39998fa"

// "0x719a22e179bb49a4596efe3bd6f735b8f3b00af1","Trast","Trast Token","TTT",1000000,50
// ["fund_manager","investor_db"],["0xdffc69d37eb87b500e3bf7ee3d3a7feb66aede89","0xa084b4172c996cf111fdeea4461c2e81836c8c6d"]
// ["investor_db","manager_db"],["0xef55bfac4228981e850936aaf042951f7b146e41","0xdc04977a2078c8ffdf086d618d1f961b6c546222"]


// NOUSManager: 0x41091e367eb324be6880336f80e18a4524f88d6b
// FundManager: 0xe597a3db61dd2cdf4dbb0e113878fc207e91c5da
// InvestorDb: 0x98d3bee26c28a820947ec81e1842a8200ebbd3c4
// ManagerDb: 0x4b1ba8f64de4c15c065aef18774b957facfd0301
// PermissionDb: 0xd3469e9a982cdb4d85961c4a1b09224652c46d89
// WalletDb: 0xe386c3845f45a69e0489cf4a0dbe5132bbee8a3d


//
// Available Accounts
// ==================
// (0) 0xa82af5b6a43dfd261e3061f8a68f8e63cc3bc5e3
// (1) 0x04ca650e90fe2e329b9bfb20bf130dc64a520cb2
// (2) 0x3a962db180e4761f354cc017c6b2c67afda50a8b
// (3) 0xdcba110c1167ae41c13aece07fe09bac4bbec64f
// (4) 0x3063d65a5beb079e1288f40e8b0e0f0ec418d37a
// (5) 0x5a47c3ce0da9a115af6538574eca3c44a2b90f96
// (6) 0x3214902b4584eaea860f7866fd1feba427b8e3b3
// (7) 0x86728a862c1c7e450612b0de0165d797fda30d19
// (8) 0x3dad111a1dab03943a0ee7dd716db985c8fbd0e6
// (9) 0xafd2d8d60797fdfbf4cfa48d06d281ff53bce351
//
// Private Keys
// ==================
// (0) 485174eca2021e7f400ef90f5c6fefbce9dbd06d3af9745f8fbfb97dc768d504
// (1) 4cc70eb846fb971cb07012833875ac3bca733fd4bf25ad4a76d9c8e77f5b948a
// (2) 75fbd30d0438eeec15da5fe434653faf30dddcd78ec05019e9c15e8228ea2245
// (3) 5c06997bfc667dffa8b86f8036c054d850f71c585c9ca7e6e4984de5654fc9f2
// (4) ea7faf64ca705d7a964b9486b1c479641ca62091214176a7d941676cef4c33d6
// (5) 79f5c3e728fea95cd5890496f2580f85f4d17dea5b5914efce52bc081acb75ee
// (6) cc1fbae61bd2a3abb476b1bc117595765423dc9b988e2d7a23dba48f9b93e1a8
// (7) 17e22d4b67a609209c021bf354753aebddf36f892fbc193f6580d9738651c74c
// (8) 8756302f736e9bf1c0c7a741315b49f8deae2f89acc14b56c0034b80a9dea61f
// (9) 8346303c36575a6bec5b3a5451a955a338632949fbf23feda0a9ab0e02438e4f

// nousToken 0xc0f09168046c43a64d59dd78bbd503d8f2e9a71d







//
