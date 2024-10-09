import { createConfig, http } from "wagmi";
import { mainnet, optimism } from "wagmi/chains";
import { getDefaultConfig } from "connectkit";
import { SiweMessage } from "siwe";
import {
  generateSiweMessage,
  signInWithEthereum,
  signOut,
  fetchCurrentUser,
} from "@/domains/authentication/services/authService";

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

export const siweConfig = {
  getNonce: () => {
    console.log("got nonce");
    return Promise.resolve(Date.now().toString());
  },
  createMessage: async ({ nonce, address, chainId }) => {
    console.log("creating message");
    // return new SiweMessage({
    //   version: "1",
    //   domain: window.location.host,
    //   uri: window.location.origin,
    //   address,
    //   chainId,
    //   nonce,
    //   statement: "Sign in to GovQuests",
    // }).prepareMessage();
    const { generateSiweMessage: messageData } = await generateSiweMessage({
      address,
      chainId,
    });
    return messageData?.message!;
  },
  verifyMessage: async ({ message, signature }) => {
    const { signInWithEthereum: result } = await signInWithEthereum({
      signature,
    });
    return !result?.errors.length;
  },
  getSession: async () => {
    const { currentUser } = await fetchCurrentUser();

    if (!currentUser) return null;

    return {
      address: currentUser.wallets[0].address as `0x${string}`,
      chainId: currentUser.wallets[0].chainId,
    };
  },
  signOut: async () => {
    const { signOut: result } = await signOut();
    return !!result?.success;
  },
};
