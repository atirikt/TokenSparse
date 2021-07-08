const Migrations = artifacts.require("TokenSparse");

module.exports = function (deployer) {
  deployer.deploy(Migrations);
};
