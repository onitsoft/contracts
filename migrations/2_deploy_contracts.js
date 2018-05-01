var NCrowdsale = artifacts.require("./NCrowdsale.sol");
var NToken = artifacts.require("./NToken.sol");

module.exports = function(deployer) {
  const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1000, endTime = startTime + 3600 * 24 * 30;

  deployer.deploy(NToken, {gas: 3000000});
  NToken.deployed().then(function (instance) {
      instance.owner.call().then(function(owner) {
        deployer.deploy(NCrowdsale,
          startTime,
          endTime,
          owner,
          instance.address,
          owner
        , {gas: 3000000});
      });
  });
};

