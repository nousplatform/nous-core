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

1. Add instance for contracts
```diff    
function setInstance(contactName, shortName) {contactName.deployed().then(inst => global[shortName] = inst);}
setInstance(Doug, 'doug')
setInstance(DougEnabled, 'dougenabled')
setInstance(ActionManager, 'actionmanager')
setInstance(ActionDB, 'actiondb')
setInstance(ActionManagerEnabled, 'actionmanagerenabled')
setInstance(Validee, 'validee')
setInstance(ActionRemoveAction, 'removeactions')
```
2. Add contract action manager and check addresses.
```
doug.addContract('actionmanager', actionmanager.address)

actionmanager.test() 
doug.address

actionmanager.address
doug.contractsTest('actionmanager')
```
3. Activate actionDB, add address to doug and add crate and add first action ActionAddAction 
```
doug.setActionDB(actiondb.address)

// test add actiondb
doug.contractsTest('actiondb').then(res => res == actiondb.address)
//test in doug addrees
actiondb.testValidateDoug().then(res => res == doug.address.replace("'", ''))
// test add action
actiondb.testGetAction('addaction')
```
#####5. Now need add action for add contracts
```

```
4. Now need add action for add contracts
```

```
Test 

```
var dougaddress = doug.address.replace("'", '')

// test add action
var actiondbaddress = actiondb.address
doug.contractsTest('actiondb').then(res => res == actiondbaddress)

```

```
setInstance(ActionManagerEnabled, 'actionmanagerenabled')
setInstance(Validee, 'validee')


//
actiondb.setDougAddress(doug.address)
doug.addContract('actionmanager', actionmanager.address)
-------------------------------------------------------------------------------------------------------------
setInstance(Tests, 'tests');
-------------------------------------------------------------------------------------------------------------

doug.addContract('actionmanagerenabled', actionmanagerenabled.address)
doug.addContract('validee', validee.address)
-------------------------------------------------------------------------------------------------------------
actiondb.setDougAddress(doug.add)

//doug.addContract('actiondb', actiondb.address)
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


