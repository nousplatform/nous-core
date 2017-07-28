
var Doug = artifacts.require("./Doug.sol");
var DougEnabled = artifacts.require("./DougEnabled.sol");

contract("Doug", function(accounts){
    var account = accounts[0];

    function setInstance(contactName, shortName) {contactName.deployed().then(inst => global[shortName] = inst);}

    setInstance(Doug, 'doug')
    setInstance(DougEnabled, 'dougenabled')


    dougenabled.setDougAddress(doug.address)
    setInstance(ActionManager, 'actionmanager')

[].length

    /*DougEnabled.deployed()
        .then(function(instance) {
            DougEnabledInst = instance;
            return DougEnabledInst.address;
        })
        .then(function (address) {
            Doug.deployed()
                .then(function (instance) {
                    DougInst = instance;
                    DougInst.addContract("dougenabled", address).then(function (res) {
                        console.log("res", res);

                    });
                });
        })
    ;*/


    /*it("addContract", function() {
        //console.log(Doug.deployed());
        var DougInst;
        var DougEnabledInst;



         DougEnabled.deployed()
            .then(function(instance) {
                DougEnabledInst = instance;
                //console.log("DougEnabledInst.address", instance.address);

                return DougEnabledInst.address;
            })
            .then(function (de_address) {
                console.log("DougEnabledInst", DougEnabledInst);

                //assert.equal(de_address, DougEnabledInst.DOUG.call(), "address equal");

                Doug.deployed().then(function (instance) {
                    DougInst = instance;
                    DougInst.addContract("DougEnabled", de_address, {from: account_one});
                })
            }).then(function () {

            })



    })*/
});
// DougEnabled.deployed().then(inst => doug_enabled = inst)
// Doug.deployed().then(inst => doug = inst)
// doug.addContract("dougenabled", doug_enabled.address)
//

//Local geth
// Deploying Action...
//     Deploying ActionRemoveAction...
//     Deploying ActionRemoveContract...
//     Deploying ActionAddAction...
//     Deploying ActionSetUserPermission...
//     Deploying ActionLockActions...
//     Deploying ActionUnlockActions...
//     Deploying ActionAddContract...
//     Deploying ActionSetActionPermission...
//     ActionAddAction: 0x254826436667e90205c3ef93e82e690b812161d9
// ActionRemoveContract: 0x55af23c9de8eb82fb5858bcbc313c804f702f1ce
// ActionRemoveAction: 0x3b441fa630497b26e7db97b53478086a2455a846
// Action: 0x387bfefea18965aa2b18d47156411a4db35cb3f5
// ActionLockActions: 0x5b69387911081459284d3a4a34162a035a40d3c9
// ActionUnlockActions: 0x2d01b83838c12e7e6a6a9cc9b89e1aa310b10447
// ActionAddContract: 0xfbb7a04ed65179bfa7a28b97ef8917d95936510d
// ActionSetActionPermission: 0x1d64df4782e46a32bbc8465a7ec89d2755a169f1
// ActionSetUserPermission: 0xaf4e2b9502d57a5b7d75a958c8d6bc2e8c19bc6b
// Deploying Validator...
//     Deploying Charger...
//     Deploying ContractProvider...
//     Deploying Endower...
//     Deploying Permissioner...
//     Validator: 0x16a1e65a2fc8f9527e0ffe5a9fb94de722aba556
// Endower: 0x075b409d14c64739a33d09c7de68c795ec9443b5
// Permissioner: 0x98b51a57d66f809632bcf91386e70de9fc58285e
// Charger: 0x99c1a479c22e5d3f13afa0a742374778f35fc1ae
// ContractProvider: 0xc7c91f301d47fc56e0ec75c2bf43c61f45b6e37c
// Deploying DougDB...
//     Deploying ActionDB...
//     DougDB: 0xf91ddd7cfe14baf35587e9d9e17717c4978ca351
// ActionDB: 0x66fd5f32e1f72451f55d3538658a42f3e5d5d20d
// Deploying Validee...
//     Deploying DougEnabled...
//     Deploying ActionManagerEnabled...
//     DougEnabled: 0x71511d1cdacb343a7b963feb97dfe51b76a54b69
// ActionManagerEnabled: 0xe5893762c9fe3a4617a000e909e6740a80b1c7df
// Validee: 0x23ac37ca850117e7d3d19a8ea7996e3abe840226
// Deploying Doug...
//     Deploying ActionManager...
//     Deploying Permissions...
//     Doug: 0x89dc2c71bd71c6a64cd6da8bfedf4b9724781092
// ActionManager: 0x1c02ef002bb5a6d12e36a6d9e6dd0b7c0a14d083
// Permissions: 0xf0e735b60e03eb5e161f80f1e3875365d4f3e077


//Yura


// Action: 0x31095ad99fb8cd175963b05a48498bc69203e390
// ActionAddAction: 0x7fbd97ed0eae494a9eecfb5f61e85bc681e2bec6
// ActionRemoveAction: 0x234d56209e6e97c0393828f659ef086b3a765498
// ActionLockActions: 0xf505266802f659b5996aa4e7d7212b1ad66c6eae
// ActionAddContract: 0x7a7f9f38fc97d3d87dbd998846ff82f3c1170ebe
// ActionSetUserPermission: 0xa4896b209dcc1dc862769515f71c71a9ed549f37
// ActionRemoveContract: 0x7cc6bda1f6b2b8a382d2779347572f7f1a0dbafd
// ActionSetActionPermission: 0xc0404dce69e0f24be88076029f3945020c681753
// ActionUnlockActions: 0xcbaa4693b42f21cbac49bcabfe0822a37edd30e7

// Charger: 0x4ab531d251ec97cf8c9883a6df958282d6c74852
// ContractProvider: 0x9024e9613619aada1a70c735e4d4f4cc575d4c1c
// Endower: 0x85649b5397dc313812026ae188ff0e1c146538ba
// Permissioner: 0x8663e99f10adfa9d3150c9999051bde5e0be2669
// Validator: 0x309b0d82234b9cfd56389ccee9061ea699d5b338

// ActionDB: 0xd627e613053372f52bd85571841eacc85048ec1e
// DougDB: 0x65a3dc4769c394a965e48d78f26b0ae27a8e205b

// DougEnabled: 0x111b414016093a8fc8dece483e207d81d706a84d
// ActionManagerEnabled: 0x5f5dd12d307138e42d6b98428641957b43b8d848
// Validee: 0x62bdef7e9ac93689d6ddf3bbf8d724dcc8e29ce2

// ActionManager: 0x502a2a837238c0604868ae0595214023d94b41a4
// Permissions: 0x46f659cb52e3f3b423bdbfdaa6facbfb80a29cd9
// Doug: 0x6cf384d3b42fa3d723f9cbe1029484925d3de040
