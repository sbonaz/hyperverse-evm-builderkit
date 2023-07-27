/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
           TS  React hook that exposes BYOM library to the react ecosystem.
 @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

import { useState, useEffect } from "react";
import { createContainer, useContainer } from "@decentology/unstated-next";
import { useEvm } from "@decentology/hyperverse-evm";
import { BYOMLibrary, BYOMLibraryType } from "./byomLibrary";
import { useHyperverse } from "@decentology/hyperverse";

function ModuleState(initialState: { tenantId: string } = { tenantId: "" }) {
  const { tenantId } = initialState;
  const { address, connectedProvider, readOnlyProvider } = useEvm();
  const hyperverse = useHyperverse();
  const [hyperverseModule, setHyperverseModule] = useState<BYOMLibraryType>();

  useEffect(() => {
    const lib = BYOMLibrary(
      hyperverse,
      connectedProvider || readOnlyProvider
    ).then(setHyperverseModule);
    return lib.cancel;
  }, [connectedProvider]);

  return {
    ...hyperverseModule,
    tenantId,
  };
}

export const Module = createContainer(ModuleState);

export function useModule() {
  return useContainer(Module);
}
