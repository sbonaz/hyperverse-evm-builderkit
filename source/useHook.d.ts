export declare const Module: import("@decentology/unstated-next").Container<{
    tenantId: string;
    setProvider?: ((provider: import("@ethersproject/abstract-provider").Provider) => void) | undefined;
    checkInstance?: ((account: any) => Promise<any>) | undefined;
    createInstance?: ((account: string) => Promise<any>) | undefined;
    getTotalTenants?: (() => Promise<any>) | undefined;
    factoryContract?: import("ethers").Contract | undefined;
    proxyContract?: import("ethers").Contract | undefined;
    proxyAddress?: string | undefined;
}, {
    tenantId: string;
} | undefined>;
export declare function useModule(): {
    tenantId: string;
    setProvider?: ((provider: import("@ethersproject/abstract-provider").Provider) => void) | undefined;
    checkInstance?: ((account: any) => Promise<any>) | undefined;
    createInstance?: ((account: string) => Promise<any>) | undefined;
    getTotalTenants?: (() => Promise<any>) | undefined;
    factoryContract?: import("ethers").Contract | undefined;
    proxyContract?: import("ethers").Contract | undefined;
    proxyAddress?: string | undefined;
};
