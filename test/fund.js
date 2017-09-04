var Fund = artifacts.require("./Fund.sol");
var FundManager = artifacts.require("./FundManager.sol");

//function setInstance(contactName, shortName) {contactName.deployed().then(inst => global[shortName] = inst);} //setInstance(NousCreator, 'nousCreater')

contract('Fund', function (accounts) {
    //console.log(accounts);
    let fund;

    const contrats = ['FundManager', ];

    const contracts = {};

    Fund.deployed()
        .then(resultDoug => fund = resultDoug)
        .then(

        )



    const deployedAndWriteInAddressBook = contract =>
        it('Deployed '+contract+" and add contract to DOUG ", function() {
            contract.deployed().then(deployedContract => {

                const name = deployedContract.constructor.toJSON().contract_name;

                return fund.addContract(name, deployedContract.address, { from : accounts[ 0 ] })
                    .then((result) => {
                        console.log('Add dug to component ' + name, result);

                        contracts[name] = {
                            address: deployedContract.address,
                            contract: deployedContract
                        }

                        return fund.contracts.call(name)
                            .then(res => {
                                assert.equal(res, deployedContract.address, " Should be same address");
                                assert.equal(result, deployedContract.address, " Should be same address");
                            })
                    })
            });
        });

    Fund.deployed().then(resultDoug => fund = resultDoug)
        .then(() => Promise.all([
            deployedAndWriteInAddressBook(FundManager)
        ])
        .then(() => {
            fund.getContracts.call('FundManager').then(console.log);

            //console.log(contracts.FundManager.address);
            //console.log(contracts.FundManager.contract.getDoug.call().then(res => console.log("getDoug", res)));


            /*for (key in contracts) {

                const tempContract = contracts[key];

                doug.addContract.call(
                    tempContract.name.toString(),
                    tempContract.address,
                    {from: accounts[0]}
                )
                    .then((callResult) => {

                        console.log(tempContract.name + ' is added? - ' + callResult);

                        // it doesn't work
                        doug.contractsTest.call(
                            tempContract.name.toString(),
                            {from: accounts[0]}
                        )
                            .then(res => {
                                console.log('doug.contractTest with ' + tempContract.name + ' - ' + res)
                            })
                    })
                    .then(() => tempContract.contract.getAddressDoug.call(accounts[0]).then(console.log))
            }*/

        })
    );

});

/*contract('MetaCoin', function(accounts) {
  it("should put 10000 MetaCoin in the first account", function() {
    return MetaCoin.deployed().then(function(instance) {
      return instance.getBalance.call(accounts[0]);
    }).then(function(balance) {
      assert.equal(balance.valueOf(), 10000, "10000 wasn't in the first account");
    });
  });
  it("should call a function that depends on a linked library", function() {
    var meta;
    var metaCoinBalance;
    var metaCoinEthBalance;

    return MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.getBalance.call(accounts[0]);
    }).then(function(outCoinBalance) {
      metaCoinBalance = outCoinBalance.toNumber();
      return meta.getBalanceInEth.call(accounts[0]);
    }).then(function(outCoinBalanceEth) {
      metaCoinEthBalance = outCoinBalanceEth.toNumber();
    }).then(function() {
      assert.equal(metaCoinEthBalance, 2 * metaCoinBalance, "Library function returned unexpected function, linkage may be broken");
    });
  });
  it("should send coin correctly", function() {
    var meta;

    // Get initial balances of first and second account.
    var account_one = accounts[0];
    var account_two = accounts[1];

    var account_one_starting_balance;
    var account_two_starting_balance;
    var account_one_ending_balance;
    var account_two_ending_balance;

    var amount = 10;

    return MetaCoin.deployed().then(function(instance) {
      meta = instance;
      return meta.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_starting_balance = balance.toNumber();
      return meta.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_starting_balance = balance.toNumber();
      return meta.sendCoin(account_two, amount, {from: account_one});
    }).then(function() {
      return meta.getBalance.call(account_one);
    }).then(function(balance) {
      account_one_ending_balance = balance.toNumber();
      return meta.getBalance.call(account_two);
    }).then(function(balance) {
      account_two_ending_balance = balance.toNumber();

      assert.equal(account_one_ending_balance, account_one_starting_balance - amount, "Amount wasn't correctly taken from the sender");
      assert.equal(account_two_ending_balance, account_two_starting_balance + amount, "Amount wasn't correctly sent to the receiver");
    });
  });
});*/
