
var Doug = artifacts.require("./Doug.sol");
var DougEnabled = artifacts.require("./DougEnabled.sol");

contract("Doug", function(accounts){
    var account = accounts[0];

    function setInstance(contactName, shortName) {contactName.deployed().then(function(inst){global[shortName] = inst});}

    setInstance(Doug, 'doug')
    setInstance(DougEnabled, 'dougenabled')


    dougenabled.setDougAddress(doug.address)
    setInstance(ActionManager, 'actionmanager')

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