const CoinFlip = artifacts.require("CoinFlip");

module.exports = function (deployer, network, accounts) {
  // deploying with 4 ether so there is funds in the contract to gamble with
  deployer.deploy(CoinFlip, {value: web3.utils.toWei("4", "ether"), from: accounts[1]}).catch(function(err){
    console.log("deploy failed " + err);
  });
};
