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
            .then( (res) => {
                assert.notEqual(res, undefined)
            })
    })

    it('attempt to  create fond', (done) =>{

        contracts.NousCreator.contract.createNewFund('test')
            .then(contracts.NousCreator.contract.getAllFund)
            .then( res => {
                assert.notEqual( res, undefined );
                fund = Fund.at(res[0])
                done()
            })
    })


    it('validate some components', () =>{

        const checkContractInFund = (nameOfContract, contract) =>
            fund.getContracts(nameOfContract)
                .then( contractAddress => {
                    console.log(contractAddress);
                    return contractTest = FundManager.at(contractAddress).validateDoug()
                } )
                .then( res => { assert.notEqual( res, undefined, `problem with ${nameOfContract} in fund` ) } )


        Promise.all([
            checkContractInFund('fundmanager', FundManager),
            checkContractInFund('perms', Permissions),
            checkContractInFund('managers', Managers),
            checkContractInFund('wallets', Wallets),
            checkContractInFund('managerdb', ManagerDb),
        ])

    })


});
