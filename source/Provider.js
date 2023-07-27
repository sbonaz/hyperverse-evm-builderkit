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
Object.defineProperty(exports, "__esModule", { value: true });
exports.Provider = void 0;
var jsx_runtime_1 = require("react/jsx-runtime");
var react_query_1 = require("react-query");
var useHook_1 = require("./useHook");
var client = new react_query_1.QueryClient();
var Provider = function (_a) {
    var children = _a.children, tenantId = _a.tenantId;
    if (tenantId == null) {
        throw new Error('Tenant ID is required');
    }
    return ((0, jsx_runtime_1.jsx)(react_query_1.QueryClientProvider, __assign({ client: client }, { children: (0, jsx_runtime_1.jsx)(useHook_1.Module.Provider, __assign({ initialState: { tenantId: tenantId } }, { children: children })) })));
};
exports.Provider = Provider;
