/// <reference types="react" />
export { useModule } from "./useHook";
export { Provider } from "./Provider";
export declare const ModuleName = "CustomModule";
export { ModuleLibrary } from "./byomLibrary";
export declare const CustomModule: {
  Provider: import("react").FC<
    import("@decentology/hyperverse").HyperverseModuleInstance
  >;
  ModuleName: string;
};
