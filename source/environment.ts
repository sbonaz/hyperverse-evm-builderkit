/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   TS  component that will identify which blockchain and network your module is being used under..
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

import {
  Blockchain,
  isEvm,
  BlockchainEvm,
  EvmEnvironment,
  NetworkConfig,
} from "@decentology/hyperverse";
import BYOMFactory from "../artifacts/contracts/BYOMFactory.sol/BYOMFactory.json";
import BYOM from "../artifacts/contracts/BYOM.sol/BYOM.json";
import Contracts from "../contracts.json";
export const BYOM_ABI = BYOM.abi;
export const BYOMFactory_ABI = BYOMFactory.abi;
const environment = Contracts as EvmEnvironment;

function getEnvironment(blockchainName: Blockchain, network: NetworkConfig) {
  if (blockchainName == null) {
    throw new Error("Blockchain is not set");
  }
  if (!isEvm(blockchainName)) {
    throw new Error("Blockchain is not EVM compatible");
  }

  const chain = environment[blockchainName as BlockchainEvm];
  if (!chain) {
    throw new Error("Blockchain is not supported");
  }
  const env = chain[network.type];
  return {
    ...env,
    BYOM_ABI,
    BYOMFactory_ABI,
  };
}

export { environment, getEnvironment };
