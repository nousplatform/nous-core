module.exports = {
  networks: {
    development: {
      host: "192.168.88.13",
      //host: "localhost",
      port: 8545,
      network_id: "*", // Match any network id
      gas:   4500000,
      gasPrice: 1,
      //from: "0xc2Ddda15f8deB297EB4DE39B82ae0750dF693253",
    },
    ropsten: {
      host: "192.168.88.11",
      port: 8545,
      network_id: "3",
      gas: 4000000,
      from: "0x719a22e179bb49a4596efe3bd6f735b8f3b00af1",
    },
    kovan: {
      host: "192.168.88.11",
      port: 8545,
      network_id: "*", // Match any network id
      gas: 4700000,
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

// 39c1ba7ca4d3e8208e4751396edc30600b25b595e1c97ec482b763cc38f
// (3) 2f057b8c65b451c3a8d019acaf72b73ff7f6aef902b66ea90b461cf078d85cc7
// (4) 3342bf0ca433462bd7dd22450ea0e4bef9970fd6477c39377b488aa865430815
// (5) dbb3c0e55abe09a9426b7660aa86fef57c002e9f9c109731444765ea70049e62
// (6) 192eca8f291f3b01b526afa2316f04e392cb9195bf81b5608612062b1e828ca7
// (7) c06c3a7df95c471bc27a7b9b7f48e962d91556ce4aad9616318ac7f9a20bb943
// (8) d26728fdf2d9098da5f0b449a4ce9cab8b605b6351b54ff01b6121ce4283218c
// (9) c52dab98569840136b6bfcee21dbc3b67fc2e8d56a0f5d79a13bd61ac8b1b76c
//
