import { Blockchain, EvmEnvironment, NetworkConfig } from "@decentology/hyperverse";
export declare const ContractABI: any;
export declare const FactoryABI: any;
declare const environment: EvmEnvironment;
declare function getEnvironment(blockchainName: Blockchain, network: NetworkConfig): {
    ContractABI: any;
    FactoryABI: any;
    contractAddress?: string | null | undefined;
    factoryAddress?: string | null | undefined;
};
export { environment, getEnvironment };
