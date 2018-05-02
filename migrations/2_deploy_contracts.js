var NCrowdsale = artifacts.require("./NCrowdsale.sol");
var NToken = artifacts.require("./NToken.sol");

module.exports = async (deployer) => {
  const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1000, endTime = startTime + 3600 * 24 * 30;

  deployer.deploy(NToken, {gas: 3000000}).then(function() {
    NToken.deployed().then(function(instance) {
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
  });


  

  // web3.eth.getBlockNumber(function(err, blockNumber) {
  //   web3.eth.getBlock(blockNumber, function(err, block) {
  //     const startTime = block.timestamp + 1000, endTime = startTime + 3600 * 24 * 30;
  
  //     deployer.deploy(NToken, {gas: 3000000}).then(function() {
  //       NToken.deployed().then(function(instance) {
  //         instance.owner.call().then(function(owner) {
  //           deployer.deploy(NCrowdsale,
  //             startTime,
  //             endTime,
  //             owner,
  //             instance.address,
  //             owner
  //           , {gas: 3000000});
  //         });
  //     });
  //     });
  //   })
  // });
};

