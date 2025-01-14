import {
  generateSiweMessage,
  signInWithEthereum,
  signOut,
} from "@/domains/authentication/services/authService";
import {
  createAuthenticationAdapter,
  getDefaultConfig,
} from "@rainbow-me/rainbowkit";
import { http } from "wagmi";
import { optimism } from "wagmi/chains";
import { queryClient } from "./components/Layout";

// if (!process.env.NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID) {
//   throw new Error("Missing NEXT_PUBLIC_WALLETCONNECT_PROJECT_ID");
// }

export const config = getDefaultConfig({
  appName: "GovQuests",
  chains: [optimism],
  transports: {
    [optimism.id]: http(),
  },
  projectId: "ABXC",
});

export const getSiweConfig = () =>
  createAuthenticationAdapter({
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
    verify: async ({ signature }: { signature: string }) => {
      const { signInWithEthereum: result } = await signInWithEthereum({
        signature,
      });

      queryClient.invalidateQueries();
      return !result?.errors.length;
    },
    signOut: async () => {
      await signOut();

      queryClient.invalidateQueries();
    },
  });
