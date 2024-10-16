import { createConfig, http } from "wagmi";
import { mainnet, optimism } from "wagmi/chains";
import { getDefaultConfig, SIWEConfig } from "connectkit";
import { SiweMessage } from "siwe";
import {
  generateSiweMessage,
  signInWithEthereum,
  signOut,
  fetchCurrentUser,
} from "@/domains/authentication/services/authService";
import { QueryClient, useMutation } from "@tanstack/react-query";
import { useSignInWithEthereum } from "./domains/authentication/hooks";
import { queryClient } from "./components/Layout";

// if (!process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID) {
//   throw new Error("Missing NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID");
// }

export const config = createConfig(
  getDefaultConfig({
    appName: "GovQuests",
    chains: [optimism],
    transports: {
      [optimism.id]: http(),
    },
    walletConnectProjectId: "ABXC",
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
    const { currentUser } = await fetchCurrentUser();

    if (!currentUser) return null;

    return {
      address: currentUser.address as `0x${string}`,
      chainId: currentUser.chainId as number,
    };
  },
  signOut: async () => {
    const { signOut: result } = await signOut();

    queryClient.invalidateQueries();

    return !!result?.success;
  },
};
