/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   TS  Library that contains the detailed functions that read & write to the blockchain.
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */  

import { HyperverseConfig } from "@decentology/hyperverse";
import { ethers } from "ethers";
import { CancellablePromise } from "real-cancellable-promise";
export declare type BYOMLibraryType = Awaited<
  ReturnType<typeof BYOMLibraryInternal>
>;
export declare function BYOMLibrary(
  ...args: Parameters<typeof BYOMLibraryInternal>
): CancellablePromise<BYOMLibraryType>;
declare function BYOMLibraryInternal(
  hyperverse: HyperverseConfig,
  providerOrSigner?: ethers.providers.Provider | ethers.Signer
): Promise<{
  setProvider: (provider: ethers.providers.Provider) => void;
  checkInstance: (account: any) => Promise<any>;
  createInstance: (account: string) => Promise<any>;
  getTotalTenants: () => Promise<any>;
  factoryContract: ethers.Contract;
  proxyContract: ethers.Contract;
  proxyAddress: string;
}>;
export {};
