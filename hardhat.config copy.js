require("@nomiclabs/hardhat-waffle")
require("hardhat-gas-reporter")
require("@nomiclabs/hardhat-etherscan")
require("dotenv").config()
require("solidity-coverage")
require("hardhat-deploy")
// You need to export an object to set up your config
// Go to https://hardhat.org/config/ to learn more

/**************************** @type import('hardhat/config').HardhatUserConfig **********************************/

const accounts =
  process.env.NEXT_PRIVATE_KEY !== undefined
    ? [process.env.NEXT_PRIVATE_KEY] // we defined encryptKey.js
    : []; // a tenary

module.exports = {
  solidity: 
,
  // the hardhat default network comes with RPC_URL and a PRIVATE_KEY
  defaultNetwork: "hardhat",
  networks: {
    // block-number will be reset every time we run the  deploy() script to this network
    hardhat: {},
    // a localhost on hh network that remains even after redeploy. Different from the defaultNetwork
    localhost: {
      // to spin up one, do: npx hardhat node "&" wait-on tcp:8545 on a terminal. Ctrl C to quit.
      url: "http://121.0.0.1:8545",
      accounts,
      chainId: 31337,
    },
    avalanche: {
      url: `${process.env.AVALANCHE_TESTNET_URL}/apikey/${process.env.AVALANCHE_TESTNET_FIGMENT_API_KEY}`,
      accounts, // accounts are Private Keys on Avalanche network
      chainId: 43114,
    },
    rinkeby: {
      url: `${process.env.RINKEBY_RPC_URL}/${process.env.RINKEBY_FIGMENT_RPC_API_KEY}`, // string interpolation
      accounts, // accounts are Private Keys on Rinkeby network
      chainId: 4,
    },
  },
};
