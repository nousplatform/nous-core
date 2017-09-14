# Nous Core Project
Pre beta version, only for review. 

## Getting Started


### Prerequisites

What things you need to install the software 
Truffle [https://github.com/trufflesuite/truffle]

```
npm install -g truffle
```

### Installing

```
truffle migrate
```

And 

```
truffle console
```

Only development version

## Deployed and test contracts in truffle

DougEnabled. Once the doug address is set, don't allow it to be set again, except by the
doug contract itself.

1. Create new fond from Nous Contract
```diff    

function setInstance(contactName, shortName) {contactName.deployed().then(inst => global[shortName] = inst);} setInstance(NousCreator, 'nousCreater')

var arr = [FundManager, Permissions, Wallets, ManagerDb, PermissionDb, WalletDb ]
//components

setInstance(FundManager, 'fundmanager')
setInstance(Managers, 'managers')
setInstance(Permissions, 'permissions')
setInstance(Wallets, 'wallets')

//models
setInstance(ManagerDb, 'managerdb')
setInstance(PermissionDb, 'permissiondb')
setInstance(WalletDb, 'walletdb')

nousCreater.addContract('permissions', permissions.address)
nousCreater.addContract('permissiondb', PermissionDb.address)

nousCreater.addContract('fundmanager', fundmanager.address)


nousCreater.addContract('managers', managers.address)
nousCreater.addContract('managerdb', managerdb.address)

nousCreater.addContract('wallets', wallets.address)
nousCreater.addContract('walletdb', walletdb.address)

//validater 
nousCreater.getDefaultContracts()


nousCreater.createNewFund('test').then(()=> nousCreater.getAllFund().then( res => fund = Fund.at(res[0])) )

//first addr
nousCreater.getAllFund().then( res => fund = Fund.at(res[0]))

////validate some components 
fund.getContracts('permissions')
fund.getContracts('walletdb')
fund.getContracts('managers')
fund.getContracts('fundmanager')


fund.getContracts('fundmanager').then(res => fundManager = FundManager.at(res).getTestVar().then(console.log))

fund.getContracts('fundmanager').then(res => fundManager = FundManager.at(res).getDoug().then(console.log))
fund.getContracts('permissions').then(res => permissiontest = Permissions.at(res).validateDoug().then(console.log))
fund.getContracts('managers').then(res => managerstest = Managers.at(res).validateDoug().then(console.log))
fund.getContracts('wallets').then(res => walletstest = Wallets.at(res).validateDoug().then(console.log))
fund.getContracts('managerdb').then(res => managerdbtest = ManagerDb.at(res).validateDoug().then(console.log))

fund.getContracts('permissiondb').then(res => permsdb = PermissionDb.at(res).validateDoug().then(console.log))


//end



fund.getContracts('fundmanager').then(res => fundManager = FundManager.at(res)).then(()=> fundManager.addManager(web3.eth.accounts[2], 'testFN', 'testLN', 'test@test'))
fundManager.getOwnerAddress()
fundManager.getAllManagers()
fundManager.checkPermission('owner')
fundManager.setPermission(web3.eth.accounts, 'owner')


//проверка задался адресс разрешений
fund.getContracts('permissiondb').then(res => permissionDb = PermissionDb.at(res))
permissionDb.rolePermission('owner')
permissionDb.perms(web3.eth.accounts[0])


//add fund manager
fund.getContracts('managerdb').then(res => managerDb = ManagerDb.at(res))
managerDb.getAllManagers()
managerDb.getArrayData()

managerDb.getManager(0)

```


## Running the tests

Tests in development 

## Deployment
Only development version.


## Built With

* [monax](https://monax.io/docs/tutorials/solidity/solidity_2_action_driven_architecture/) - An Action-Driven Architecture

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags). 

## Authors


## License


