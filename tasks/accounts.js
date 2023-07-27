// This is a sample Hardhat task. To learn how to create my own, go to https://hardhat.org/guides/create-task.html

const { truncateSync } = require("fs");
const hardhatConfig = require("../hardhat.config");
// 1. import the task function
const { task } = require("hardhat/config");
// 2. call the task function with arguments, if any, then set actions
task("accounts", "Prints the list of accounts", async (taskArgs, hre) => {
  const accounts = await hre.ethers.getSigners();
  for (const account of accounts) {
    console.log(account.address); // just printing the list of accounts
  }
});
