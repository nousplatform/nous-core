
const Doug = artifacts.require("./core/Doug.sol");
const DougEnabled = artifacts.require("./core/security/DougEnabled.sol");
const ActionManager = artifacts.require("./core/ActionManager.sol");
const ActionDB = artifacts.require("./core/models/ActionDB.sol");

//const ActionManagerEnabled  = artifacts.require( "./core/security/ActionManagerEnabled.sol");
//const Validee               = artifacts.require( "./core/security/Validee.sol");


contract("Doug", function (accounts) {

    it("it must work", function () {

        contract.deployed().then(deployedContract => {


        const name = deployedContract.constructor.toJSON().contract_name;

        contracts[name] = {
            name,
            address: deployedContract.address,
            contract: deployedContract
        }
    });

    Promise.all([
        Doug.deployed().then(resultDoug => web3.doug = doug = resultDoug),

        deployedAndWriteInAddressBook( DougEnabled ),
        deployedAndWriteInAddressBook( ActionManagerEnabled ),
        deployedAndWriteInAddressBook( Validee ),
        deployedAndWriteInAddressBook( ActionDB ),
        deployedAndWriteInAddressBook( ActionManager ),
        deployedAndWriteInAddressBook( Tests ),
    ]).then(() => {

            for(key in contracts){

            const tempContract = contracts[ key ];

            doug.addContract.call(
                tempContract.name.toString(),
                tempContract.address,
                { from : accounts[ 0 ] }
            )
                .then( (callResult) => {

                console.log(tempContract.name + ' is added? - '+ callResult);

            // it doesn't work
            doug.contractsTest.call(
                tempContract.name.toString(),
                { from : accounts[0] }
            )
                .then( res => {
                console.log('doug.contractTest with ' + tempContract.name + ' - ' + res)
        } )
        })
        .then( () => tempContract.contract.getAddressDoug.call(accounts[0]).then( console.log ) )

        }

        //doug.contractsTest.call( 'ActionManagerEnabled', { from : accounts[0]} ).then( console.log )
        //
        //
        //doug.contractsTest.call( 'ActionManagerEnabled', { from : accounts[0] } ).then( console.log )
        //doug.contractsTest.call( 'ActionManager', { from : accounts[0] } ).then( console.log )
        //doug.contractsTest.call( 'Validee', { from : accounts[0] } ).then( console.log )
        //doug.contractsTest.call( 'ActionDB', { from : accounts[0] } ).then( console.log )
        //doug.contractsTest.call( 'Tests', { from : accounts[0] } )
        //    .then( (callResponse) => console.log('doug.contractTest with Tests -> ' + callResponse ))
        //
        //doug.addContract('tests', tests.address)
        //tests.getAddressDoug()
        //
        //doug.contract.addContract('tests', tests.address)

        //contracts
        //contracts[Doug].contract.addContract()

        //doug.addContract('actionmanager', actionmanager.address)
        //doug.addContract('actionmanagerenabled', actionmanagerenabled.address)
        //doug.addContract('validee', validee.address)
        //
        //doug.addContract('actiondb', actiondb.address)
        //doug.addContract('tests', tests.address)
        //
        //doug.contractsTest('actionmanagerenabled')
        //doug.contractsTest('actionmanager')
        //doug.contractsTest('validee')
        //doug.contractsTest('actiondb')
        //doug.contractsTest('tests')
        //
        //doug.addContract('tests', tests.address)
        //tests.getAddressDoug()
    }
    )

        //function setInstance(contactName, shortName) {contactName.deployed().then(function(inst){global[shortName] = inst});}

        //setInstance(Doug, 'doug')
        //setInstance(DougEnabled, 'dougenabled')
        //
        //
        //dougenabled.setDougAddress(doug.address)
        //setInstance(ActionManager, 'actionmanager')
        //
        //
        //return DougEnabled.deployed().then(function(dougEnabled) {
        //
        //    const name = dougEnabled.constructor.toJSON().contract_name;
        //
        //    contracts[name] = dougEnabled.address;
        //
        //    console.log(contracts)
        //
        //
        //    assert.equal(contracts.length, 1, "addresses have 1 item");
        //    assert.equal(contracts.length, 0, "addresses haven't 1 item");
        //})
        /* .then(function (address) {
             Doug.deployed()
                 .then(function (instance) {
                     DougInst = instance;
                     DougInst.addContract("dougenabled", address).then(function (res) {
                         console.log("res", res);

                     });
                 });
         })*/

    })

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