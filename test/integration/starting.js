const NousCreator   = artifacts.require("../contracts/NousCreator.sol");
const Fund          = artifacts.require("../contracts/fund/Fund.sol");
const FundManager   = artifacts.require("../contracts/fund/FundManager.sol");
const Permissions   = artifacts.require("../contracts/fund/components/Permissions.sol");
const Managers      = artifacts.require("../contracts/fund/components/Managers.sol");
const Wallets       = artifacts.require("../contracts/fund/components/Wallets.sol");
const ManagerDb     = artifacts.require("../contracts/fund/models/ManagerDb.sol");
const PermissionDb = artifacts.require("../contracts/fund/models/PermissionDb.sol");
const WalletDb     = artifacts.require("../contracts/fund/models/WalletDb.sol");

const fundContracts= [ 'Permissions', 'PermissionDb', 'FundManager', 'Managers', 'Wallets', 'ManagerDb',  'WalletDb'];


const contracts = {};

const deployedAndWriteInAddressBook = contract =>
    contract.deployed().then(deployedContract => {


        const name = deployedContract.constructor.toJSON().contract_name;

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
            .then(res => { console.log('create gasUsed - ', res.receipt.gasUsed); return contracts.NousCreator.contract.getAllFund();})
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

    it('Check roles values', done => {
        let PDB;
        const roles = ['nous', 'owner', 'manager', 'investor'];

        fund.contracts('permissiondb')
            .then(permissiondb_address => {
                PDB = PermissionDb.at(permissiondb_address);

                Promise.all( roles.reverse().map(PDB.rolePermission))
                    .then( res => {

                        res.map((item, i)=> {
                            //console.log("roles[i]", roles[i]);
                            //console.log("item.c[0]", item.c[0]);
                            if (item.c[0] != i+1){
                                assert.notEqual( item.c[0], i+1, `problem with ${roles[i]} in equal ${item.c[0]}` );
                            }
                        })
                        assert.equal(res.length, 4, '4 roles');
                    }).then(done());

            });
    });

    it('Check permission', done => {
        fund.getContracts(contracts.FundManager.name)
            .then(fundManagerAddress => {
                FM = FundManager.at(fundManagerAddress).getOwnerAddress()
                    .then(res => {console.log("accounts", res); done()});

            })
    })

    /*it('Check permission 2', done => {
        fund.getContracts(contracts.PermissionDb.name)
            .then(permissionDbadd => {
                FM = PermissionDb.at(permissionDbadd).getUserPerm(accounts[0])
                    .then(res => {console.log("res", res); done()});

            })
    })*/


    /*it('Set permission', done => {
        fund.getContracts(contracts.FundManager.name)
            .then(fundManagerAddress => {
                FM = FundManager.at(fundManagerAddress).setPermission(web3.eth.accounts[0], 3)
                    .then(res => {console.log('set permission ', res); done()})

            });
    })*/

    /*it('checkPermission permission', done => {
        fund.getContracts(contracts.FundManager.name)
            .then(fundManagerAddress => {
                FM = FundManager.at(fundManagerAddress).checkPermission('owner')
                    .then(res => {console.log('check Permission ', res); done()})

            });
    })*/

    it('Check add manager in managerDb', done => {
        let FM;
        fund.getContracts(contracts.FundManager.name)
            .then(fundManagerAddress => {
                FM = FundManager.at(fundManagerAddress);
                return FM.addManager(accounts[2], 'testFN', 'testLN', 'test@test');
            })
            .then(transaction => {
                //console.log("transaction", transaction);

                FM.getAllManagers()
                    .then(res=> {
                        //console.log("get managers", res);

                        assert.equal(res[0].length, 1, 'Manager not added');
                        done();
                    })
            })
    })



});
