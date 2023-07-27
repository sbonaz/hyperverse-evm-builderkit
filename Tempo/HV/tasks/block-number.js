/* difference between a and b is:?
        a). define your function with "function" keyword -> async function blockTask() {}
        b). having your function being a variable        -> const blockTask = async () => {}
        answer: b is an anonymous function, it doesn't have a name
        */

// Creating our own task : getting a block number, wherever the blockchain we are working with

const { truncateSync } = require("fs");
const hardhatConfig = require("../hardhat.config");
// 1. import the task function
const { task } = require("hardhat/config");
// 2. call the task function with arguments, if any, then set actions
task("block-number", "Print the current block number").setAction(
  async (taskArgs, hre) => {
    const blockNumber = await hre.ethers.provider.getBlockNumber;
    console.log(`Current block number is : ${blockNumber}`); // we do string interpolating, here.
  }
);
