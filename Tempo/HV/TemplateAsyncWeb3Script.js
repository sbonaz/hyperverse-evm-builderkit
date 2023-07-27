const ethers = require("ethers");
const fs = require("fs-extra");
require("dotenv").config();

async function main() {}

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

runMain(); // calling the runMain() function when exec the script
