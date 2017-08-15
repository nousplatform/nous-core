//actopns
var Action = artifacts.require("./Action.sol");
var ActionAddAction = artifacts.require("./ActionAddAction.sol");
var ActionRemoveAction = artifacts.require("./ActionRemoveAction.sol");
var ActionLockActions = artifacts.require("./ActionLockActions.sol");
var ActionUnlockActions = artifacts.require("./ActionUnlockActions.sol");
var ActionAddContract = artifacts.require("./ActionAddContract.sol");
var ActionRemoveContract = artifacts.require("./ActionRemoveContract.sol");
var ActionSetUserPermission = artifacts.require("./ActionSetUserPermission.sol");
var ActionSetActionPermission = artifacts.require("./ActionSetActionPermission.sol");

//var ActionCharge = artifacts.require("./ActionCharge.sol");
//var ActionEndow = artifacts.require("./ActionEndow.sol");

//interfaces
//var interfaces = artifacts.require("./interfaces/Interfaces.sol");
var Charger = artifacts.require("./Charger.sol");
var ContractProvider = artifacts.require("./ContractProvider.sol");
var Endower = artifacts.require("./Endower.sol");
var Permissioner = artifacts.require("./Permissioner.sol");
var Validator = artifacts.require("./Validator.sol");
var ActionDbase = artifacts.require("./ActionDbase.sol");

//models
var ActionDB = artifacts.require("./ActionDB.sol");
var DougDB = artifacts.require("./DougDB.sol");

//security
var DougEnabled = artifacts.require("./DougEnabled.sol");
var ActionManagerEnabled = artifacts.require("./ActionManagerEnabled.sol");
var Validee = artifacts.require("./Validee.sol");

//
var ActionManager = artifacts.require("./ActionManager.sol");
var Permissions = artifacts.require("./Permissions.sol");
var Doug = artifacts.require("./Doug.sol");

var Tests = artifacts.require("./Tests.sol");
var Tests2 = artifacts.require("./Tests2.sol");


module.exports = function(deployer) {
  //deployer.link(DougEnabled, ContractProvider, ActionDB, Permissions, ActionManager);

    //actions
    deployer.deploy([Action, ActionAddAction, ActionRemoveAction, ActionLockActions, ActionUnlockActions, ActionAddContract,
        ActionRemoveContract, ActionSetUserPermission, ActionSetActionPermission
    ]);
    //interfaces
    deployer.deploy([Charger, ContractProvider, Endower, Permissioner, Validator, ActionDbase]);
    //models
    deployer.deploy([ActionDB, DougDB]);
    //security
    deployer.deploy([DougEnabled, ActionManagerEnabled, Validee]);
    //
    deployer.deploy([ActionManager, Permissions, Doug]);

    deployer.deploy(Tests);
    deployer.deploy(Tests2);

};
