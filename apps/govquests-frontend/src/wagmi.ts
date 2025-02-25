import {
  fetchCurrentUser,
  generateSiweMessage,
  signInWithEthereum,
  signOut,
} from "@/domains/authentication/services/authService";
import { getDefaultConfig, SIWEConfig } from "connectkit";
import { createConfig, http } from "wagmi";
import { mainnet, optimism } from "wagmi/chains";
import { queryClient } from "./components/Layout";

// if (!process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID) {
//   throw new Error("Missing NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID");
// }

export const config = createConfig(
  getDefaultConfig({
    appName: "GovQuests",
    chains: [optimism, mainnet],
    transports: {
      [optimism.id]: http(),
      [mainnet.id]: http(),
    },
    walletConnectProjectId: "ABXC",
    appUrl: process.env.APP_URL,
  }),
);

export const siweConfig: SIWEConfig = {
  getNonce: async () => {
    // Just making TS happy here, we don't need to actually return
    // a nonce since the backend will handle it when creating the message
    return Date.now().toString();
  },
  createMessage: async ({
    address,
    chainId,
  }: {
    nonce: string;
    address: string;
    chainId: number;
  }) => {
    const { generateSiweMessage: messageData } = await generateSiweMessage({
      address,
      chainId,
    });
    return messageData?.message!;
  },
  verifyMessage: async ({ signature }: { signature: string }) => {
    const { signInWithEthereum: result } = await signInWithEthereum({
      signature,
    });

    queryClient.invalidateQueries();
    return !result?.errors.length;
  },
  getSession: async () => {
    try {
      const { currentUser } = await fetchCurrentUser();

      if (!currentUser) {
        return null;
      }

      return {
        address: currentUser.address as `0x${string}`,
        chainId: currentUser.chainId as number,
      };
    } catch (error) {
      return null;
    }
  },
  signOut: async () => {
    const { signOut: result } = await signOut();

    queryClient.invalidateQueries();

    return !!result?.success;
  },
};
