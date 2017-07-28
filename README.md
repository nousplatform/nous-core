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

## Deployed contracts truffle

DougEnabled. Once the doug address is set, don't allow it to be set again, except by the
doug contract itself.



```diff    
function setInstance(contactName, shortName) {contactName.deployed().then(inst => global[shortName] = inst);}
setInstance(Doug, 'doug')
setInstance(DougEnabled, 'dougenabled')
setInstance(ActionManager, 'actionmanager')
setInstance(ActionManagerEnabled, 'actionmanagerenabled')
setInstance(Validee, 'validee')
setInstance(ActionDB, 'actiondb')
-------------------------------------------------------------------------------------------------------------
setInstance(Tests, 'tests');
-------------------------------------------------------------------------------------------------------------
doug.addContract('actionmanager', actionmanager.address)
doug.addContract('actionmanagerenabled', actionmanagerenabled.address)
doug.addContract('validee', validee.address)
-------------------------------------------------------------------------------------------------------------
doug.addContract('actiondb', actiondb.address)
doug.addContract('tests', tests.address)
-------------------------------------------------------------------------------------------------------------
doug.contractsTest('actionmanagerenabled')
doug.contractsTest('actionmanager')
doug.contractsTest('validee')
doug.contractsTest('actiondb')
doug.contractsTest('tests')
-------------------------------------------------------------------------------------------------------------
doug.addContract('tests', tests.address)
tests.getAddressDoug()
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


