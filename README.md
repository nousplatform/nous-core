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

function setInstance(contactName, shortName) {contactName.deployed().then(inst => global[shortName] = inst);}
setInstance(NousCreator, 'nousCreater')

nousCreater.createNewFund('test')
nousCreater.getContract().then( res => fund = Fund.at(res[0]))
fund.createComponents()
////fund.createSecondComponents()

fund.getContracts('perms')
fund.getContracts('walletsdb')

fund.getContracts('fundManager').then(res => fundManager = FundManager.at(res))


//add fund manager 
 
fundManager.addManager(web3.eth.accounts[2], 'testFN', 'testLN', 'test@test')

fund.getContracts('managerdb').then(res => managerDb = ManagerDb.at(res))
managerDb.getAllManagers()
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


