/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
   JS  React hook that exposes your library to the react ecosystem.
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

"use strict";
var __assign =
  (this && this.__assign) ||
  function () {
    __assign =
      Object.assign ||
      function (t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
          s = arguments[i];
          for (var p in s)
            if (Object.prototype.hasOwnProperty.call(s, p)) t[p] = s[p];
        }
        return t;
      };
    return __assign.apply(this, arguments);
  };
Object.defineProperty(exports, "__esModule", { value: true });
exports.useModule = exports.Module = void 0;
var react_1 = require("react");
var unstated_next_1 = require("@decentology/unstated-next");
var hyperverse_evm_1 = require("@decentology/hyperverse-evm");
var moduleLibrary_1 = require("./moduleLibrary");
var hyperverse_1 = require("@decentology/hyperverse");
function ModuleState(initialState) {
  if (initialState === void 0) {
    initialState = { tenantId: "" };
  }
  var tenantId = initialState.tenantId;
  var _a = (0, hyperverse_evm_1.useEvm)(),
    address = _a.address,
    connectedProvider = _a.connectedProvider,
    readOnlyProvider = _a.readOnlyProvider;
  var hyperverse = (0, hyperverse_1.useHyperverse)();
  var _b = (0, react_1.useState)(),
    hyperverseModule = _b[0],
    setHyperverseModule = _b[1];
  (0, react_1.useEffect)(
    function () {
      var lib = (0, moduleLibrary_1.ModuleLibrary)(
        hyperverse,
        connectedProvider || readOnlyProvider
      ).then(setHyperverseModule);
      return lib.cancel;
    },
    [connectedProvider]
  );
  return __assign(__assign({}, hyperverseModule), { tenantId: tenantId });
}
exports.Module = (0, unstated_next_1.createContainer)(ModuleState);
function useModule() {
  return (0, unstated_next_1.useContainer)(exports.Module);
}
exports.useModule = useModule;
