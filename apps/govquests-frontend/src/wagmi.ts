import { getDefaultConfig } from "@rainbow-me/rainbowkit";
import { http, createConfig } from "wagmi";
import { optimism } from "wagmi/chains";

declare module "wagmi" {
  interface Register {
    config: typeof config;
  }
}

export const config = getDefaultConfig({
  appName: "op-govquests",
  projectId: "YOUR_PROJECT_ID",
  chains: [optimism],
  transports: {
    [optimism.id]: http(),
  },
});
