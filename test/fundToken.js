var Sale = artifacts.require("./Sale.sol");
var SampleCrowdsaleToken = artifacts.require("./SampleCrowdsaleToken.sol");

const _nousToken = "0x6142836bbc33a159f2503c132f255caa049392e0";

contract('Sale', function (accounts) {
  const _owner = accounts[0];
  const _walletAddress = accounts[9];

  const _totalSupplyCap = 100000;
  const _retainedByCompany = 100;

  it("Deploy set sale contract", async function () {
    //const sale = await Sale.deployed(_owner, _totalSupplyCap, _retainedByCompany, _walletAddress, _nousToken);
    //console.log(sale.nousToken.call());

    //console.log("sale", sale);
    //assert.equal(true, true, "10000 wasn't in the first account");
    return true;
  })
});


//
// Available Accounts
// ==================
// (0) 0x58a87d9035d10d9f8638acb238340e5aaf603b97
// (1) 0xfc38b8249ea93c9151992026d79243aeb953bad9
// (2) 0xb46382ea5d205b00272dbb6386f7c82204560853
// (3) 0x4a6942f87a6fa9ab7f420bdb669c084a364f9021
// (4) 0x4a1ae0314e86e1f880d35cf2683572fdb7e77a9f
// (5) 0xd4cd77d62982103ce812b44496450eb5b60ec294
// (6) 0xbfdb2fec59f0501c7df25d4cb13c7f6352a2806f
// (7) 0x57afd88b88bb55f10ec1a14e4792a3729686aaf3
// (8) 0x98421399d5ed3098f4369791858daa75b42fa24a
// (9) 0x62fd5a9dc2a4a99288c8b4d5b24a75b89eeb8070
//
// Private Keys
// ==================
// (0) 29c395dab016f4fa03500cb3a80fced07d921db05002d8cc95c0c33fa15d9c64
// (1) 66bfb4543ad18d2c25d6dba5742a002126fb37fae945d573ab6889cd134bfbb1
// (2) 673bba0b2a569dd54d7a2aa1eaa775157e7c2bd57630905e1c4715fee9f45622
// (3) 81699e9a7a521eb32b34b153b3be2d29c945ddb65185c3b208e591bd0f003a07
// (4) 2550b2d2909cb4729589925a5225bba64828cc2a0aa7150fff201429a41eda13
// (5) dadfac16a46ed386c5a5e3d86c96d3316ebee3116c5165af5a656edf4700de63
// (6) 1fe49abff9ca9b0e131afa84c39dd93d7729236a1fb5038a6ad8e26f9a06f873
// (7) 6a99b73d1db6b46cb3d75a150ebeaec1e2a80bedd869d2e098bf00879a7c49fa
// (8) c85e171651825bd64ab31e902405238efc08a8ccd3e2e0bd7759b137fb5e6913
// (9) 745fef3ea995947d0a6dccfb4294bef200084c718ceb84e0fa2ed83bb3ac4559



