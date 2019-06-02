const landTrx = artifacts.require("landTrx");

module.exports = function(deployer) {
  deployer.deploy(landTrx);
};
