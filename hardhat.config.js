require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")
require("@nomiclabs/hardhat-etherscan")
require("dotenv").config()
require("solidity-coverage")
require("hardhat-deploy")
// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**************************** @type import('hardhat/config').HardhatUserConfig **********************************/


const COINMARKETCAP_API_KEY = process.env.COINMARKETCAP_API_KEY || ""
const GOERLI_RPC_URL =
    process.env.GOERLI_RPC_URL ||
    "https://eth-mainnet.alchemyapi.io/v2/your-api-key"
const PRIVATE_KEY =
    process.env.PRIVATE_KEY ||
    "0x11ee3108a03081fe260ecdc106554d09d9d1209bcafd46942b10e02943effc4a"
const ETHERSCAN_API_KEY = process.env.ETHERSCAN_API_KEY || ""


module.exports = {
  // the hardhat default network comes with RPC_URL and a PRIVATE_KEY
  defaultNetwork: "hardhat",
    networks: {
    // block-number will be reset every time we run the  deploy() script to this network
    hardhat: {
      chainId: 31337,
      // gasPrice: 130000000000,
    },
    // a localhost on hh network that remains even after redeploy. Different from the defaultNetwork
    localhost: {
      // to spin up one, do: npx hardhat node "&" wait-on tcp:8545 on a terminal. Ctrl C to quit.
      url: "http://121.0.0.1:8545",
      accounts,
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
      accounts, // accounts are Private Keys on Avalanche network
      chainId: 43114,
    },
  },
  solidity: {
    compilers: [
        {
            version: "0.8.6",
        },
        {
            version: "0.8.4",
        },
        {
          version: "0.6.12",
      },
    ],
  },
  etherscan: {
    apiKey: ETHERSCAN_API_KEY,
    // customChains: [], // uncomment this line if you are getting a TypeError: customChains is not iterable
  },
  snowtrace: {
    apiKey: SNOWTRACE_API_KEY,
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
        default: 0, // here this will by default take the first account as deployer
        1: 0, // similarly on mainnet it will take the first account as deployer. Note though that depending on how hardhat network are configured, the account 0 on one network can be different than on another
    },
  },
  mocha: {
    timeout: 500000,
  },
};
