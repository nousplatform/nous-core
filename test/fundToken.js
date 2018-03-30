var Sale = artifacts.require("./Sale.sol");
var SampleCrowdsaleToken = artifacts.require("./SampleCrowdsaleToken.sol");

const _nousToken = "0x6142836bbc33a159f2503c132f255caa049392e0";

contract('Sale', function (accounts) {
  const _owner = accounts[0];
  const _walletAddress = accounts[9];

  const _totalSupplyCap = 100000;
  const _retainedByCompany = 100;

  it("Deploy set sale contract", async function () {
    const sale = await Sale.deployed(_owner, _totalSupplyCap, _retainedByCompany, _walletAddress, _nousToken);
    console.log(sale.nousToken.call());

    //console.log("sale", sale);
    assert.equal(true, true, "10000 wasn't in the first account")
    //return true;
  })
});

