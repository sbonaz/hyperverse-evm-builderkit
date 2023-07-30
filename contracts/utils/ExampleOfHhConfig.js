const { task, HardhatUserConfig } = require("hardhat/config");

require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("@nomiclabs/hardhat-etherscan");
require("solidity-coverage");
require("hardhat-deploy");

// Other dependencies and environment variable handling...

const config = {
  solidity: "0.8.0",
  // Rest of the configuration...
};

module.exports = config;
