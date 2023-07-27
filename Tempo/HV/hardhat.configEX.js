require("dotenv").config();
// from nomiclabs, the team behind Hardhat project
require("@nomiclabs/hardhat-waffle"); //
require("@nomiclabs/hardhat-etherscan"); // to let Hardhat makes calls to Etherscan API
// from Me: I have created a directory (/tasks) for all Hardhat tasks I need to add here
// We can use scripts or tasks. Task is better for plugins whereas script is better for our local devs
require("./tasks/accounts"); // prinying Hardhat accounts list
require("./tasks/block-number"); // adding our own tak to the Hardhat config to let it show up.

// Setting up my config by exporting following object. Go to https://hardhat.org/config/ to learn more

/**************************** @type import('hardhat/config').HardhatUserConfig **********************************/

const accounts =
  process.env.NEXT_PRIVATE_KEY !== undefined
    ? [process.env.NEXT_PRIVATE_KEY] // we defined encryptKey.js
    : []; // a ternair

module.exports = {
  solidity: "0.8.4",
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
