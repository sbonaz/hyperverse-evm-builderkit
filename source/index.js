"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.CustomModule = exports.ModuleLibrary = exports.ModuleName = exports.Provider = exports.useModule = void 0;
var useHook_1 = require("./useHook");
Object.defineProperty(exports, "useModule", { enumerable: true, get: function () { return useHook_1.useModule; } });
var Provider_1 = require("./Provider");
var Provider_2 = require("./Provider");
Object.defineProperty(exports, "Provider", { enumerable: true, get: function () { return Provider_2.Provider; } });
exports.ModuleName = 'CustomModule';
var moduleLibrary_1 = require("./byomLibrary");
Object.defineProperty(exports, "ModuleLibrary", { enumerable: true, get: function () { return moduleLibrary_1.ModuleLibrary; } });
exports.CustomModule = {
    Provider: Provider_1.Provider,
    ModuleName: exports.ModuleName
};
