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

        console.log( deployedContract ? '+' : '-' );

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

    it('getting default contracts', () =>{

        contracts.NousCreator.contract.getDefaultContracts()
            .then(console.log)
    })

    it('attempt to  create fund', (done) =>{

        contracts.NousCreator.contract.createNewFund('test')
            .then(contracts.NousCreator.contract.getAllFund)
            .then( res => {
                assert.notEqual( res, undefined );
                fund = Fund.at(res[0]);
                contracts.NousCreator.contract.getFundContracts(res[0]).then(res => { console.log("contracts", res); done();});
            })
    })


    it('validate some components', (done) =>{
        console.log("fund.address", fund.address);

        fund.getContracts('perms').then(console.log);

        const checkContractInFund = (nameOfContract, contract) =>
            fund.getContracts(nameOfContract)
                .then( contractAddress => {
                    console.log(contractAddress);
                    return contractTest = contract.at(contractAddress).validateDoug()
                } )
                .then( res => { assert.notEqual( res, undefined, `problem with ${nameOfContract} in fund` ) } )


        Promise.all([
            fund.getContracts('fundmanager')
                .then( res => {
                    console.log("res", res);
                    FundManager.at(res).getDoug()})
                .then( res => {
                    console.log('fundmanager', res)
                    //console.log('fund', fund)
                    assert.notEqual( res, undefined, `problem with fundmanager in fund` )
                } ),

            fund.getContracts('perms').then(res => Permissions.at(res).validateDoug().then(console.log)),
            checkContractInFund('perms', Permissions),
            checkContractInFund('managers', Managers),
            checkContractInFund('wallets', Wallets),
            checkContractInFund('managerdb', ManagerDb)
        ])
        .then(() => done())

    })


});
