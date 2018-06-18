# Nous Core Project

Beta version, only for review.

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

1.  Create new fund from Nous Contract

```javascript
function setInstance(instance, instanceName) {
  instance.deployed().then(inst => (global[instanceName] = inst));
}

setInstance(NOUS, "NOUS");

NOUS.createNewFund("Fund name", "Token name", "Ticker name", 1000000);

NOUS.addContract(
  ["permission_db"],
  ["0xd3469e9a982cdb4d85961c4a1b09224652c46d89"]
);

var arr = [
  FundManager,
  Permissions,
  Wallets,
  ManagerDb,
  PermissionDb,
  WalletDb
];
// components

setInstance(FundManager, "fundmanager");
setInstance(PermissionDb, "permissiondb");
setInstance(ManagerDb, "managerdb");
setInstance(WalletDb, "walletdb");

// models
setInstance(NOUS, "NOUS");

NOUS.addContract("permissions", permissions.address);
NOUS.addContract("permissiondb", PermissionDb.address);

NOUS.addContract("fundmanager", fundmanager.address);

NOUS.addContract("managers", managers.address);
NOUS.addContract("managerdb", managerdb.address);

NOUS.addContract("wallets", wallets.address);
NOUS.addContract("walletdb", walletdb.address);

// validation
NOUS.getDefaultContracts();

NOUS.createNewFund("test").then(() =>
  NOUS.getAllFund().then(res => (fund = Fund.at(res[0])))
);

//first addr
NOUS.getAllFund().then(res => (fund = Fund.at(res[0])));

////validate some components
fund.getContracts("permissions");
fund.getContracts("walletdb");
fund.getContracts("managers");
fund.getContracts("fundmanager");

fund.getContracts("fundmanager").then(
  res =>
    (fundManager = FundManager.at(res)
      .getTestVar()
      .then(() => {}))
);

fund.getContracts("fundmanager").then(
  res =>
    (fundManager = FundManager.at(res)
      .getDoug()
      .then(console.log))
);
fund.getContracts("permissions").then(
  res =>
    (permissiontest = Permissions.at(res)
      .validateDoug()
      .then(console.log))
);
fund.getContracts("managers").then(
  res =>
    (managerstest = Managers.at(res)
      .validateDoug()
      .then(console.log))
);
fund.getContracts("wallets").then(
  res =>
    (walletstest = Wallets.at(res)
      .validateDoug()
      .then(console.log))
);
fund.getContracts("managerdb").then(
  res =>
    (managerdbtest = ManagerDb.at(res)
      .validateDoug()
      .then(console.log))
);

fund.getContracts("permissiondb").then(
  res =>
    (permsdb = PermissionDb.at(res)
      .validateDoug()
      .then(data => {
        conslole.log(data);
      }))
);

//end

fund
  .getContracts("fundmanager")
  .then(res => (fundManager = FundManager.at(res)))
  .then(() =>
    fundManager.addManager(
      web3.eth.accounts[2],
      "John",
      "Doe",
      "johndoe@test.com"
    )
  );
fundManager.getOwnerAddress();
fundManager.getAllManagers();
fundManager.checkPermission("owner");
fundManager.setPermission(web3.eth.accounts, "owner");

// checking permissions
fund
  .getContracts("permissiondb")
  .then(res => (permissionDb = PermissionDb.at(res)));
permissionDb.rolePermission("owner");
permissionDb.perms(web3.eth.accounts[0]);

// adding fund manager
fund.getContracts("managerdb").then(res => (managerDb = ManagerDb.at(res)));
managerDb.getAllManagers();
managerDb.getArrayData();
managerDb.getManager(0);
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
