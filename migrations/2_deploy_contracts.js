var NCrowdsale = artifacts.require("./NCrowdsale.sol");
var NToken = artifacts.require("./NToken.sol");
var DateTime = artifacts.require("./DateTime.sol");
var NBuyback = artifacts.require("./NBuyback.sol");

module.exports = function(deployer) {
  const startTime = web3.eth.getBlock(web3.eth.blockNumber).timestamp + 1000, endTime = startTime + 3600 * 24 * 30;
  let NTokenInstance;
  let owner;

  deployer.deploy(NToken, {gas: 3000000})
    .then(() => NToken.deployed())
    .then(instance => {
      NTokenInstance = instance;
      return NTokenInstance.owner.call();
    })
    .then(_owner => {
      owner = _owner;
      return deployer.deploy(NCrowdsale,
        startTime,
        endTime,
        owner,
        NTokenInstance.address,
        owner
      , {gas: 3000000});
    })
    .then(() => {
      return deployer.deploy(DateTime, {gas: 3000000});
    })
    .then(() => DateTime.deployed())
    .then(DateTimeInstance => {
      return deployer.deploy(NBuyback,
        owner,
        NTokenInstance.address,
        DateTimeInstance.address,
        5000
      , {gas: 3000000});
    });

  // deployer.deploy(NToken, {gas: 3000000}).then(function() {
  //   NToken.deployed().then(function(ntokenInstance) {
  //     ntokenInstance.owner.call().then(function(owner) {
  //       deployer.deploy(NCrowdsale,
  //         startTime,
  //         endTime,
  //         owner,
  //         ntokenInstance.address,
  //         owner
  //       , {gas: 3000000});

  //       deployer.deploy(DateTime, {gas: 3000000}).then(function() {
  //         DateTime.deployed().then(function(dateTimeInstance) {
  //           deployer.deploy(NBuyback,
  //             owner,
  //             ntokenInstance.address,
  //             dateTimeInstance.address
  //           , {gas: 3000000});
  //         });
  //       });
  //     });
  //   });
  // });

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

