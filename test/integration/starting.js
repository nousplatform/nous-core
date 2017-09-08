const NousCreator   = artifacts.require("../contracts/NousCreator.sol");
const Fund          = artifacts.require("../contracts/fund/Fund.sol");
const FundManager   = artifacts.require("../contracts/fund/FundManager.sol");
const Permissions   = artifacts.require("../contracts/fund/components/Permissions.sol");
const Managers      = artifacts.require("../contracts/fund/components/Managers.sol");
const Wallets       = artifacts.require("../contracts/fund/components/Wallets.sol");
const ManagerDb     = artifacts.require("../contracts/fund/models/ManagerDb.sol");
const PermissionDb = artifacts.require("../contracts/fund/models/PermissionDb.sol");
const WalletDb     = artifacts.require("../contracts/fund/models/WalletDb.sol");

const fundContracts= ['FundManager', 'Permissions', 'Managers', 'Wallets', 'ManagerDb', 'PermissionDb', 'WalletDb'];


const contracts = {};

const deployedAndWriteInAddressBook = contract =>
    contract.deployed().then(deployedContract => {

        const name = deployedContract.constructor.toJSON().contract_name;

        //console.log(  name);

        contracts[name] = {
            name: name.toLowerCase(),
            address: deployedContract.address,
            contract: deployedContract
        }
    });

const initAllContracts = (done) => {
    Promise.all([
        deployedAndWriteInAddressBook( NousCreator ),

        //components
        deployedAndWriteInAddressBook( FundManager),
        deployedAndWriteInAddressBook( Managers ),
        deployedAndWriteInAddressBook( Permissions),
        deployedAndWriteInAddressBook( Wallets),

        //models
        deployedAndWriteInAddressBook( ManagerDb),
        deployedAndWriteInAddressBook( PermissionDb),
        deployedAndWriteInAddressBook( WalletDb),
    ])
    .then(() => {
        const NousCreatorContract = contracts.NousCreator.contract;

        let promiseAddContracts = [];
        //console.log("fundContracts.length", fundContracts.length);

        for (let i = 0; i < fundContracts.length; i++){
            //console.log("contracts[fundContracts[i]].name", contracts[fundContracts[i]].name);

            promiseAddContracts.push(NousCreatorContract.addContract(contracts[fundContracts[i]].name, contracts[fundContracts[i]].address ));
        }

        Promise.all( promiseAddContracts )
    })
    .then( done );

};

// Storage for temp fund contract
let fund;


contract('All contracts', function (accounts) {

    before(initAllContracts);

    it('getting default contracts', done => {

        contracts.NousCreator.contract.getDefaultContracts()
            .then( arrayOfDefaultContracts => {
                //console.log("arrayOfDefaultContracts", arrayOfDefaultContracts);

                assert.notEqual( arrayOfDefaultContracts.length, 0, 'array is empty' );
                assert.equal( arrayOfDefaultContracts[0].length, fundContracts.length, 'array ok' );
            })
            .then( done )
    });

    it('attempt to create fund', done => {

        contracts.NousCreator.contract.createNewFund('test')
            .then(contracts.NousCreator.contract.getAllFund)
            .then( arrayOfContracts => {

                assert.notEqual( arrayOfContracts.length, 0, 'array is empty' );
                fund = Fund.at(arrayOfContracts[0]);
                done();
            })
    });

    it('check fund address(DOUG address) in contracts', done => {
        const checkContractInFund = (nameOfContract, contract) =>

        fund.getContracts(nameOfContract)
                .then( contractAddress => {
                    //console.log("contractAddress", contractAddress);

                    return contractTest = contract.at(contractAddress).validateDoug()
                } )
                .then( res => {
                    //console.log("res", res);
                    //console.log("nameOfContract", nameOfContract);

                    assert.notEqual( res, '0x0000000000000000000000000000000000000000', `problem with ${nameOfContract} in fund` );
                    assert.equal(res, fund.address);
                } )

        var promisArr = [];

        for (let i = 1; i < fundContracts.length; i++){
            promisArr.push(checkContractInFund(contracts[fundContracts[i]].name, eval(fundContracts[i])));
        }

        Promise.all(promisArr)
            .then(() => done());
    });

    it('Check permissions', done => {
        let PDB;
        fund.contracts('permissiondb')
            .then(permissiondb_address => {
                PDB = PermissionDb.at(permissiondb_address);
                PDB.rolePermission('nous').then(console.log)
            });
    })

    it('Check add manager in managerDb', done => {
        let FM;
        fund.getContracts(contracts.FundManager.name)
            .then(fundManagerAddress => {
                FM = FundManager.at(fundManagerAddress);
                return FM.addManager(accounts[2], 'testFN', 'testLN', 'test@test');
            })
            .then(transaction => {
                console.log("transaction", transaction);
                FM.getAllManagers()
                    .then(console.log);

            })

    })

    /*it('validate managerDB', done => {
        fund.getContracts(contracts.FundManager.name)
            .then( fundManagerAddress => {
                FundManager.at(fundManagerAddress).addManager(accounts[2], 'testFN', 'testLN', 'test@test')
                    .then(console.log)
            })
            .then( () => fund.getContracts(contracts.ManagerDb.name) )
            .then( managerDbAddress => {
                let managerDb = ManagerDb.at(managerDbAddress);

                Promise.all([
                    managerDb.getAllManagers().then( res => console.log('get all', res)),
                    managerDb.getArrayData().then( res => console.log('getArrayData', res)),
                    managerDb.getManager(0).then( res => console.log('getManager', res))
                ])
            })
            .then(done)
    });*/


});
