var HDWalletProvider = require("truffle-hdwallet-provider");
var keys = require('./keys');

module.exports = {
  networks: {
    development: {
      host: "localhost",
      port: 8545,
      network_id: "*" // Match any network id
    },
    rinkeby: {
      provider: new HDWalletProvider(
        keys.mnemonic,
        'https://rinkeby.infura.io/7Vjiw3k5GuN1jSfQ0Za0'
      ),
      network_id: 4,
      gasPrice: 35000000000,
      gas: 7400000
    },
  }
};
