var Doug = artifacts.require("./Doug.sol");
var ActionManager = artifacts.require("./ActionManager.sol");

//security
var DougEnabled = artifacts.require("./DougEnabled.sol");
var ActionManagerEnabled = artifacts.require("./ActionManagerEnabled.sol");

//models
var DougDB = artifacts.require("./DougDB.sol");
var ActionDB = artifacts.require("./ActionDB.sol");

//interfaces
var ContractProvider = artifacts.require("./ContractProvider.sol");
var ActionDbase = artifacts.require("./ActionDbase.sol");

module.exports = function(deployer) {

    deployer.deploy([Doug, ActionManager]);

    //security
    deployer.deploy([DougEnabled, ActionManagerEnabled]);

    //models
    deployer.deploy([DougDB, ActionDB]);

    //interfaces
    deployer.deploy([ContractProvider, ActionDbase]);
};
