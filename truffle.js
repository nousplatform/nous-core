module.exports = {
    networks: {
        development: {
            host: "192.168.88.11",
            port: 8545,
            network_id: "*" // Match any network id
        },
        ropsten: {
            host: "localhost",
            port: 8545,
            network_id: "3",
            gas: 1000000000
        },
    }
};