const Doug = artifacts.require("./core/Doug.sol");
const DougEnabled = artifacts.require("./core/security/DougEnabled.sol");
const ActionManager = artifacts.require("./core/ActionManager.sol");
const ActionDB = artifacts.require("./core/models/ActionDB.sol");

//const ActionManagerEnabled  = artifacts.require( "./core/security/ActionManagerEnabled.sol");
//const Validee               = artifacts.require( "./core/security/Validee.sol");


contract("Doug", function (accounts) {

    it("it must work", function () {

        let doug;

        const contracts = {};


        /**
         * for deployed contract and save it in contracts
         * @param contract
         */
        const deployedAndWriteInAddressBook = contract =>
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

            deployedAndWriteInAddressBook(DougEnabled),
            deployedAndWriteInAddressBook(ActionManager),
            deployedAndWriteInAddressBook(ActionDB),
            //deployedAndWriteInAddressBook(ActionManagerEnabled),
            //deployedAndWriteInAddressBook(Validee),
        ]).then(() => {
            doug.addContract.call(
                contracts.actionmanager.name.toString(),
                contracts.actionmanager.address
            ).then((callResult) => {
                console.log(tempContract.name + ' is added? - ' + callResult);
            })






            /*for (key in contracts) {

                const tempContract = contracts[key];

                doug.addContract.call(
                    tempContract.name.toString(),
                    tempContract.address,
                    {from: accounts[0]}
                )
                .then((callResult) => {

                    console.log(tempContract.name + ' is added? - ' + callResult);

                    // it doesn't work
                    doug.contractsTest.call(
                        tempContract.name.toString(),
                        {from: accounts[0]}
                    )
                        .then(res => {
                            console.log('doug.contractTest with ' + tempContract.name + ' - ' + res)
                        })
                })
                .then(() => tempContract.contract.getAddressDoug.call(accounts[0]).then(console.log))

            }*/
            }
        )


    })


});