/*
The configuration object should contain various settings for our Hardhat project,
 including network configurations, task definitions, and the Solidity compiler version.
*/
require("@nomiclabs/hardhat-waffle");
require("hardhat-gas-reporter");
require("@nomiclabs/hardhat-etherscan");
require("dotenv").config(); // Remove this line since we are using CommonJS?
require("solidity-coverage");
require("hardhat-deploy");
// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || "";
const GOERLI_RPC_URL =
  process.env.GOERLI_RPC_URL ||
  "https://eth-mainnet.alchemyapi.io/v2/your-api-key";
const PRIVATE_KEY =
  process.env.PRIVATE_KEY ||
  "0x11ee3108a03081fe260ecdc106554d09d9d1209bcafd46942b10e02943effc4a";
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || "";

module.exports = {
  solidity: "0.8.0",
  defaultNetwork: "hardhat",
  networks: {
    hardhat: {
      chainId: 31337,
      // gasPrice: 130000000000,
    },
    localhost: {
      url: "http://121.0.0.1:8545",
      accounts: [PRIVATE_KEY],
      chainId: 31337,
    },
    goerli: {
      url: GOERLI_RPC_URL,
      accounts: [PRIVATE_KEY],
      chainId: 5,
      blockConfirmations: 6,
    },
    avalanche: {
      url: `${process.env.AVALANCHE_TESTNET_URL}/apikey/${process.env.AVALANCHE_TESTNET_FIGMENT_API_KEY}`,
      accounts: [PRIVATE_KEY], // Assuming accounts is defined somewhere above
      chainId: 43114,
    },
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
    // customChains: [], // uncomment this line if you are getting a TypeError: customChains is not iterable
  },
  snowtrace: {
    apiKey: SNOWTRACE_API_KEY, // Where is SNOWTRACE_API_KEY defined? Make sure it's defined or remove this line if not used.
    // customChains: [], // uncomment this line if you are getting a TypeError: customChains is not iterable
  },
  gasReporter: {
    enabled: true,
    currency: "USD",
    outputFile: "gas-report.txt",
    noColors: true,
    // coinmarketcap: COINMARKETCAP_API_KEY,
  },
  namedAccounts: {
    deployer: {
      default: 0,
      1: 0,
    },
  },
  mocha: {
    timeout: 500000,
  },
};
module.exports = config;
