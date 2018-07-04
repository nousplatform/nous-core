var HDWalletProvider = require("truffle-hdwallet-provider");

var infura_apikey = "YFD3CGj2bPu8A6GWVSsS";
const mnemonic = "army guard pitch actual second wild sing flip melt tribe erase grab";

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 4800000,
      gasPrice: 5000000000,
      //from: "0x719a22e179bb49a4596efe3bd6f735b8f3b00af1"
    },
    ganashe: {
      host: "localhost",
      port: 7545,
      network_id: "*",
      gas: 4800000,
      gasPrice: 5000000000,
    },
    ropsten2: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/"+infura_apikey)
      },
      gas: 4800000, // Gas limit used for deploys
      gasPrice: 50000000000, // 20 gwei
      network_id: 3
    },
    ropsten: {
      host: "192.168.88.13",
      port: 8545,
      network_id: "*",
      gas: 4800000, // Gas limit used for deploys
      gasPrice: 50000000000, // 20 gwei
      from: "0x719a22E179bb49a4596eFe3BD6F735b8f3b00AF1"
    },
    kovan: {
      host: "192.168.88.11",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 4712388,
      from: "0x22b2fC468FB5adca29775899d8AFFbcA414f5dE0"
    },
    ropsten_local: {
      network_id: 3,
      host: "192.168.88.11",
      port: 8545,
      gas: 4712388,
      from: "0x719a22e179bb49a4596efe3bd6f735b8f3b00af1"
    }
  },
  mocha: {
    useColors: true
  }
};
