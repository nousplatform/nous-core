var NOUSManager = artifacts.require("./NOUSManager.sol");
var FundManager = artifacts.require("./FundManager.sol");
//models
var InvestorDb = artifacts.require("./InvestorDb.sol");
var ManagerDb = artifacts.require("./ManagerDb.sol");
var PermissionDb = artifacts.require("./PermissionDb.sol");
var WalletDb = artifacts.require("./WalletDb.sol");

contract('NOUSManager', function (accounts) {
    it("Deploy set default contracts", function () {
        return NOUSManager.deployed()
                .then((instance) => {
                    console.log("instance", instance);

                })
        /*deployer
            .then(() => {
                return NOUSManager.new();
            })
            .then((NOUSManagerInstance) => {
                console.log("NOUSManagerInstance.address", NOUSManagerInstance);

            })*/

        /*return NOUSManager.deployed()
            .then((instance) => {

            })*/
    })
});