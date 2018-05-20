module.exports = {
  networks: {
    development: {
      //host: "192.168.88.13",
      host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas:   4500000,
      gasPrice: 200,
      //from: "0x1a0816d178bfc9ad3a59b372a3270eb7e82dd1f4"
      //from: "0xc2Ddda15f8deB297EB4DE39B82ae0750dF693253",
    },
    ropsten: {
      host: "192.168.88.13",
      port: 8545,
      network_id: "3",
      gas: 4700000, // Gas limit used for deploys
      gasPrice: 50000000000, // 20 gwei
      from: "0x719a22e179bb49a4596efe3bd6f735b8f3b00af1",
    },
    kovan: {
      host: "192.168.88.11",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 10000000,
      from: "0x22b2fC468FB5adca29775899d8AFFbcA414f5dE0",
    },
    ropsten_local: {
      network_id: 3,
      host: "192.168.88.11",
      port: 8545,
      gas: 4700000,
      from: "0x719a22e179bb49a4596efe3bd6f735b8f3b00af1",
    }
  },
  mocha: {
    useColors: true
  }
};

//


