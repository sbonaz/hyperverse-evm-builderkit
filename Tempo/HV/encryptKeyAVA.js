const ethers = require("ethers");
const fs = require("fs-extra");
const { runMain } = require("module");
require("dotenv").config();

async function main() {
  const wallet = new ethers.Wallet(process.env.AVALANCHE_PRIVATE_KEY); // creating a wallet  with a private key
  const encryptedJsonKey = await ethers.encrypt(
    process.env.AVALANCHE_PRIVATE_KEY_PASSWORD,
    process.env.AVALANCHE_PRIVATE_KEY
  ); //encrypting the key with a password
  console.log(encryptedJsonKey);
  fs.writeFileSync("./.encryptedKey.json", encryptedJsonKey); // writing down the encrypted key in json file on main directory
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
