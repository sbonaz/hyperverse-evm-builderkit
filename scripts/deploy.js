const hre = require("hardhat"); // Hardhat runtime emvironment
const { ethers, run, network } = require("hardhat"); 
const fs = require("fs-extra");
const { constants } = require("ethers"); // Pull from ethers by desctructuring?!

const main = async () => {
  const [deployer] = await ethers.getSigners(); // enum?? how are we signing the deployment Tx?
  console.log("Deployer Address: ", deployer.address);
  const hyperverseAdmin = deployer.address;

  const BYOM = await hre.ethers.getContractFactory("BYOM"); // don't confuse getContractFactory with BYOMFactory
  const byom = await BYOM.deploy(hyperverseAdmin);
  await byom.deployed();
  console.log("BYOM Contract deployed to: ", byom.address);
  console.log(network.config);

  // VERIFYING THE MASTERCONTRACT PROGRAMATICALLY ON A BLOCK EXPLORER (using HH and HH plug-ins)
  if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
    // NB: === means == without type conversion allowed. 4 is for Rinkby (?)
    await byom.getDeployTransaction.wait(6); // wait 6 block confirmations before verifying
    await verify(byom.address, Owner); // await needed as verify() is async function
    // Owner is constructor argument. Add all args contained in the construcor
    const currentValue = await byom.retrieve(); // right function here?! maybe not.
    console.log(`Current Value is : ${currentValue}`); // string interpolation
    // Update the currentValue
  }

  const Factory = await hre.ethers.getContractFactory("BYOMFactory");
  const byomFactory = await Factory.deploy(byom.address, hyperverseAdmin);
  await byomFactory.deployed();
  console.log("BYOMFactory Contract deployed to: ", byomFactory.address);
  
  // VERIFYING THE FABRICCONTRACT PROGRAMATICALLY ON A BLOCK EXPLORER
  if (network.config.chainId === 4 && process.env.ETHERSCAN_API_KEY) {
    await byomFactory.getDeployTransaction.wait(6); // wait 6 block confirmation before verifying
    await verify(byomFactory.address, masterContract, owner);
  }

  const env = JSON.parse(fs.readFileSync("contracts.json").toString());
  env[hre.network.name] = env[hre.network.name] || {};
  env[hre.network.name].testnet = env[hre.network.name].testnet || {};

  env[hre.network.name].testnet.contractAddress = byom.address;

  // Step 3: UPDATE moduleFactory
  env[hre.network.name].testnet.factoryAddress = byomFactory.address;

  // Save contract addresses back to file
  fs.writeJsonSync("contracts.json", env, { spaces: 2 }); // { spaces:2 } ??

  // Deploy default tenant
  let proxyAddress = constants.AddressZero;
  await byomFactory.createInstance(deployer.address);
  while (proxyAddress === constants.AddressZero) {
    s;
    proxyAddress = await byomFactory.getProxy(deployer.address);
  }
};

// DEFINING THE verify()FUNCTION.  Using hardhat's verify task to verify the contract
async function verify(contractAddress, Owner) {
  console.log("Verifying contract, please wait ...");
  try {
    await run("verify: verify", {     /* run allows to run any hardhat task.*/
      address: contractAddress,
      constructorArguments: Owner,
    });
  } catch (e) {
    if (e.message.toLowerCase().include("already verfied")) {
      console.log("Already Verified!");
    } else {
      console.log(e);
    }
  }
}

const runMain = async () => {
  // declaring the runMain() function
  try {
    await main(); //wait for main() terminates before proceeding
    process.exit(0);
  } catch (error) {
    console.error(error);
    process.exit(1);
  }
};

runMain(); // calling the runMain() function when exec deploy.js
