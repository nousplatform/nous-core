const NousCreator   = artifacts.require("../contracts/NousCreator.sol");
const FundManager   = artifacts.require("../contracts/fund/FundManager.sol");
const Fund          = artifacts.require("../contracts/fund/Fund.sol");
const Permissions   = artifacts.require("../contracts/fund/components/Permissions.sol");
const Managers      = artifacts.require("../contracts/fund/components/Managers.sol");
const Wallets       = artifacts.require("../contracts/fund/components/Wallets.sol");
const ManagerDb     = artifacts.require("../contracts/fund/models/ManagerDb.sol");
const PermissionsDb = artifacts.require("../contracts/fund/models/PermissionsDb.sol");
const WalletsDb     = artifacts.require("../contracts/fund/models/WalletsDb.sol");




const contracts = {};

const deployedAndWriteInAddressBook = contract =>
    contract.deployed().then(deployedContract => {

        const name = deployedContract.constructor.toJSON().contract_name;

        //console.log( deployedContract ? '+' : '-', name);

        contracts[name] = {
            name,
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
        deployedAndWriteInAddressBook( PermissionsDb),
        deployedAndWriteInAddressBook( WalletsDb),
    ])
    .then(() => {
        const NousCreatorContract = contracts.NousCreator.contract;
        Promise.all( [
            NousCreatorContract.addContract(
                contracts.FundManager.name, contracts.FundManager.address ),

            NousCreatorContract.addContract(
                contracts.Permissions.name, contracts.Permissions.address ),

            NousCreatorContract.addContract( contracts.Wallets.name,
                contracts.Wallets.address ),

            NousCreatorContract.addContract(
                contracts.ManagerDb.name, contracts.ManagerDb.address ),

            NousCreatorContract.addContract(
                contracts.Managers.name, contracts.Managers.address ),

            NousCreatorContract.addContract(
                contracts.PermissionsDb.name, contracts.PermissionsDb.address ),

            NousCreatorContract.addContract(
                contracts.WalletsDb.name, contracts.WalletsDb.address ),
        ] )
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
                assert.notEqual( arrayOfDefaultContracts.length, 0, 'array is empty' );
                //console.log( arrayOfDefaultContracts )
            })
            .then( done )
    })

    it('attempt to  create fund', done => {

        contracts.NousCreator.contract.createNewFund('test')
            .then(contracts.NousCreator.contract.getAllFund)
            .then( arrayOfContracts => {
                //console.log(arrayOfContracts)
                assert.notEqual( arrayOfContracts.length, 0, 'array is empty' );
                fund = Fund.at(arrayOfContracts[0]);
                done();
            })
    })

    it('validate fund', done => {

        const checkContractInFund = (nameOfContract, contract) =>
            fund.getContracts(nameOfContract)
                .then( contractAddress => {
                    //console.log(contractAddress);
                    return contractTest = contract.at(contractAddress).validateDoug()
                } )
                .then( res => assert.notEqual( res, '0x0000000000000000000000000000000000000000', `problem with ${nameOfContract} in fund` ) )


        Promise.all([
            fund.getContracts(contracts.FundManager.name)
                .then( fundManagerAddress => FundManager.at(fundManagerAddress).getDoug() )
                .then( dougAddress => {
                    //console.log('fundmanager', fundManagerAddress)
                    assert.notEqual( dougAddress, '0x0000000000000000000000000000000000000000', `problem with fundmanager in fund` )
                } ),

            checkContractInFund(contracts.Permissions.name, Permissions),
            checkContractInFund(contracts.Managers.name, Managers),
            checkContractInFund(contracts.Wallets.name, Wallets),
            checkContractInFund(contracts.ManagerDb.name, ManagerDb)
        ])
        .then(() => done())

    })

    it('validate managerDB', done => {

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
    })


});
