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

eth_accounts
^Cvaleriy@valeriy-To-be-filled-by-O-E-M ~ $ testrpc
EthereumJS TestRPC v6.0.3 (ganache-core: 2.0.2)

# Available Accounts

(0) 0x11fe174b86cb5aac1b25e7d2696589a82b02f303
(1) 0x88379324d7e3c37cdab0aa0bdbf64ed64725adab
(2) 0x0c5abdd90c91caa475c1b88ca0944dca2e720584
(3) 0x78210f09612113805391ca75985807c11a084133
(4) 0xeb8ab2fd520fb30aec9734d72168b815c09e91cc
(5) 0x7014fb17d3fff189289524c3a3e61357c2a4810c
(6) 0x7b67d43619a0dc443b55aabb60930a064b999640
(7) 0x72bba2fd282b1703e082bb58d576b4f8785d4f10
(8) 0xe4d55bfcb9fa8f5f29d64cb3f8772967eb333458
(9) 0x06c3fc90700c2ed084260a94f3006ed95065de9d

# Private Keys

(0) `a13f0ea77680ef585bacca82150b86501ce18235a9355c5aa29d547afafb468c`
(1) 688bd9450fe165c4ec9085c33d30dca99e75fde362aef17da6caa85acae638c7
(2) b5bfd001a7f8d8bf76df3982465aa2d1394eb2649b0a77eefe84f7baaf7ab042
(3) 2386e050c20675da3ef8e597ce3e48007bbbd6922d5e8cb5e99bc86b2144236d
(4) fc4b0870e641007196b4985e8a39c918c474b4f8ea34a692829a63ea839517cb
(5) df876bde33a4ee3632e1eda503f346616812ee1ae9368df825a45bbd505f44b4
(6) 725af2172c3b6fbcc7d39eb547e53abf0659998e8b5c77753126194f2f6322d2
(7) 59b4d7b33cf136927bc7a70f8771c248fe43fa784829db4bcfeb263dc644897d
(8) 731c0391f3b853d82849c8eca853bcef1f3f33053940da1cd3088266dc0f87ab
(9) ae8addc5f03888fa59fef052d7a0d0eb23e8e0ef42cc85fe6fa131f0d7754929
