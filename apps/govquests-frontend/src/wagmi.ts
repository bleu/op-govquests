import { http, createConfig } from "wagmi";
import { optimism } from "wagmi/chains";

declare module "wagmi" {
  interface Register {
    config: typeof config;
  }
}

export const config = createConfig({
  chains: [optimism],
  transports: {
    [optimism.id]: http(),
  },
});
