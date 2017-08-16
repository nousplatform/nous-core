var Doug = artifacts.require("./Doug.sol");
var ActionManager = artifacts.require("./ActionManager.sol");
var Permissions = artifacts.require("./Permissions.sol");

//security
var DougEnabled = artifacts.require("./DougEnabled.sol");
var ActionManagerEnabled = artifacts.require("./ActionManagerEnabled.sol");
var Validee = artifacts.require("./Validee.sol");

//models
var DougDB = artifacts.require("./DougDB.sol");
var ActionDB = artifacts.require("./ActionDB.sol");

//interfaces
var ActionDbase = artifacts.require("./ActionDbase.sol");
var ContractProvider = artifacts.require("./ContractProvider.sol");
var Permissioner = artifacts.require("./Permissioner.sol");
var Validator = artifacts.require("./Validator.sol");

//actions
var ActionRemoveAction = artifacts.require("./ActionRemoveAction.sol");
var TestAction = artifacts.require("./TestAction.sol");

module.exports = function(deployer) {

    deployer.deploy([Doug, ActionManager, Permissions]);

    //security
    deployer.deploy([DougEnabled, ActionManagerEnabled, Validee, Permissioner]);

    //models
    deployer.deploy([DougDB, ActionDB]);

    //interfaces
    deployer.deploy([ContractProvider, ActionDbase, Validator]);

    //actions
    deployer.deploy([ActionRemoveAction, TestAction]);
};
