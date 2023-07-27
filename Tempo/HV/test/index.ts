import { expect } from "chai";
import { ethers } from "hardhat";

describe("ByomUserGreeter", function () {
  it("Should return the new greeting once it's changed", async function () {
    const ByomUserGreeter = await ethers.getContractFactory("ByomUserGreeter");
    const greeter = await ByomUserGreeter.deploy("Hello, Sbo!");
    await greeter.deployed();

    expect(await greeter.greet()).to.equal("Hello, sbo!");

    const setGreetingTx = await greeter.setGreeting("Hola, sbo!");

    // wait until the transaction is mined
    await setGreetingTx.wait();

    expect(await greeter.greet()).to.equal("Hola, sbo!");
  });
});
