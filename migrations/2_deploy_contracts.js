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
//var interfaces = artifacts.require("./interfaces/interfaces.sol");
var Charger = artifacts.require("./Charger.sol");
var ContractProvider = artifacts.require("./ContractProvider.sol");
var Endower = artifacts.require("./Endower.sol");
var Permissioner = artifacts.require("./Permissioner.sol");
var Validator = artifacts.require("./Validator.sol");

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
    deployer.deploy([Charger, ContractProvider, Endower, Permissioner, Validator]);
    //models
    deployer.deploy([ActionDB, DougDB]);
    //security
    deployer.deploy([DougEnabled, ActionManagerEnabled, Validee]);
    //
    deployer.deploy([ActionManager, Permissions, Doug]);

    deployer.deploy(Tests);
    deployer.deploy(Tests2);
    //deployer.deploy(Permissions);
    //deployer.deploy(Doug);
    //deployer.link(ConvertLib, MetaCoin);
    //deployer.deploy(MetaCoin);
};

//
// Action: 0xa805ac429ff223dabb6df0bef1bbdea618819ee6
// ActionAddAction: 0x40a42ae45d20ec1f72f160a645f413a9fad672eb
// ActionRemoveAction: 0x7211afd83733f3588170287a710bdc4b1037848f
// ActionLockActions: 0xe901475c5376f426232e18cd3cbe7d2a8e275bb9
// ActionRemoveContract: 0xdb6988db403ad352289a35784b725e3f69c635a4
// ActionUnlockActions: 0x6cdd64b6f8d01d7f059247d41ce97b8bcbacab21
// ActionAddContract: 0xc3140a8c56f11818c6ebc18e520621dfd3256c10
// ActionSetUserPermission: 0x1eb926f6f597c0d7a794f2fb1e70be0368a79c52
// ActionSetActionPermission: 0xf91fb19d56e619bca7a62aba73967a8ac12601b1
// Charger: 0x3f6b5515052b75cc2bab5889c467c1b65264ade7
// ContractProvider: 0x2a5a7c549f283175c71c6bc9399f1ae84f9f5eda
// Endower: 0xfaaec477bef9b957d8e4f21b829531a87b44d47b
// Permissioner: 0x3388bce168c36096ed6aebfa728b022418b4ff13
// Validator: 0xa7e559eb4375846ffa03d45418c0573d854d1d28
// ActionManager: 0xc02b2053d3cbb32ffb4ba813238a4dcf9768943d
// Doug: 0x649359073520d88414583f821eaa6c4d459cd2bc
// Permissions: 0x35f382b52858e7654acc7a89dd5569ed16361fc0
// Doug: 0xa1307cbd0036ec0bd01bdb7d1bd0731bfe06da01
