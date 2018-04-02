var Sale = artifacts.require("./Sale.sol");
var SampleCrowdsaleToken = artifacts.require("./SampleCrowdsaleToken.sol");

const _nousToken = "0x6142836bbc33a159f2503c132f255caa049392e0";

contract('Sale', function (accounts) {

  const saleInitialParams = {
    _owner: accounts[0],
    _totalSupplyCap: 100000,
    _retainedByCompany: 100,
    _walletAddress: accounts[9],
    _nousToken: _nousToken
  }

  const tokenInitialParams = {
    _name: "FundTKN",
    _symbol: "FTK",
    _decimals: 18
  }

  let saleInstance;
  let tokenInstance;

  //create new smart contract instance before each test method
  beforeEach(async function() {
    saleInstance = await Sale.new(...Object.values(saleInitialParams));
    tokenInstance = await SampleCrowdsaleToken.new(saleInstance.address, ...Object.values(tokenInitialParams));
    await saleInstance.setTokenAddress(tokenInstance.address);

  });

  it("Re sets token address for mining tokens.", async function () {
    await saleInstance.setTokenAddress(tokenInstance.address, {from: accounts[1]});
    let tknAddress = await saleInstance.tokenAddress.call();

    assert.equal(tknAddress, tokenInstance.address, "Token address sets is ok");
    console.log("tknAddress", tknAddress);

    //const token = await SampleCrowdsaleToken.deployed(_owner, "Fund Token", "FTK", 18);
    //const sale = await Sale.deployed(_owner, _totalSupplyCap, _retainedByCompany, _walletAddress, _nousToken);
    //console.log(sale.nousToken.call());

    //console.log("sale", sale);
    //assert.equal(true, true, "10000 wasn't in the first account");
    return true;
  })
});


// Available Accounts
// ==================
// (0) 0x4d49465620a938bc284755f77b42ab35d294f948
// (1) 0x8506b359b1c1064c65462a2f214ed618b9391c2d
// (2) 0xbcf1a63ef49dcafcc79fe3f2a64e8f52eb9520d5
// (3) 0xba00aee74f75bad6bc7892cf383ad0bb637f8a2e
// (4) 0x605deddfdc65fed3102f007527ae9df5ab3edf87
// (5) 0xd1a4c31d83f81b1133d642ce4b69771650dc5acd
// (6) 0x8ed9b5c61844c06122d3ff2be25aecdf04e93561
// (7) 0x69f89398be181d804b6b9ed5b74a0db1b4ca8d91
// (8) 0x5a054b99c53b83f5f9164330c8a44039a8f3a671
// (9) 0x1c9e03b0a5e44ce3e883e1865728beec2bb6f9ed
//
// Private Keys
// ==================
// (0) 2c2bb17a588be58fba673214291b29153bef093a93b3c472b878ef862e22a455
// (1) 837b828b91c7bcb57e4dae3dd7695eabdc7831d126909047624bed40cc827929
// (2) aefb4298d739a62c54ad02537979c1977410044141d1da92749868d9fe9d8258
// (3) bfb324cb3fd90f793299aed66d315ed87d93966750be8b84b0238b55c8c61fd5
// (4) be3bfcc5cd1f0b5fcd2a77fa59484467ded58ec6a500231962146fecd5c653c4
// (5) 2b11000e8a0661f18f9bca522f2c3d83a9f5df972cfb4f126c082c1c8637893c
// (6) d2ca1ba820613eadc717c4a6981b84e07cdd46a5fddb7daef3b970005402ed54
// (7) a8232d869d208c128be02ff13959c8611ead44e1d499b73f612fdd6491b74bf8
// (8) b985977832a682b71a8efaa76a8583f3f30f4d3de902a284a6023b9ceb91370b
// (9) 6d37333355d4e4e80e82835a0a6b504b2b7ea48eeb42226f6389b0404cb420de
//
// HD Wallet




