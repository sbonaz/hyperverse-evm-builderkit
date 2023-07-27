/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   TS  Handles imports and exports for JavaScript API.
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

export { useModule } from "./useHook";
import { Provider } from "./Provider";
export { Provider } from "./Provider";
export const ModuleName = "CustomModule";
export { ModuleLibrary } from "./byomLibrary";
export const CustomModule = {
  Provider,
  ModuleName,
};
