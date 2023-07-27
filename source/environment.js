"use strict";
var __assign = (this && this.__assign) || function () {
    __assign = Object.assign || function(t) {
        for (var s, i = 1, n = arguments.length; i < n; i++) {
            s = arguments[i];
            for (var p in s) if (Object.prototype.hasOwnProperty.call(s, p))
                t[p] = s[p];
        }
        return t;
    };
    return __assign.apply(this, arguments);
};
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.getEnvironment = exports.environment = exports.FactoryABI = exports.ContractABI = void 0;
var hyperverse_1 = require("@decentology/hyperverse");
var ModuleFactory_json_1 = __importDefault(require("../artifacts/contracts/ModuleFactory.sol/ModuleFactory.json"));
var Module_json_1 = __importDefault(require("../artifacts/contracts/Module.sol/Module.json"));
var contracts_json_1 = __importDefault(require("../contracts.json"));
exports.ContractABI = Module_json_1.default.abi;
exports.FactoryABI = ModuleFactory_json_1.default.abi;
var environment = contracts_json_1.default;
exports.environment = environment;
function getEnvironment(blockchainName, network) {
    if (blockchainName == null) {
        throw new Error("Blockchain is not set");
    }
    if (!(0, hyperverse_1.isEvm)(blockchainName)) {
        throw new Error("Blockchain is not EVM compatible");
    }
    var chain = environment[blockchainName];
    if (!chain) {
        throw new Error("Blockchain is not supported");
    }
    var env = chain[network.type];
    return __assign(__assign({}, env), { ContractABI: exports.ContractABI, FactoryABI: exports.FactoryABI });
}
exports.getEnvironment = getEnvironment;
