import { createAuthenticationAdapter } from "@rainbow-me/rainbowkit";
import { SiweMessage } from "siwe";
export const authenticationAdapter = createAuthenticationAdapter({
  getNonce: async () => {
    console.log("nonce test");
    const response = await fetch("http://localhost:3001/siwe/nonce");
    return await response.text();
  },
  createMessage: ({ nonce, address, chainId }) => {
    return new SiweMessage({
      domain: window.location.host,
      address,
      statement: "Sign in with Ethereum to the app.",
      uri: window.location.origin,
      version: "1",
      chainId,
      nonce,
    });
  },

  getMessageBody: ({ message }) => {
    console.log("message", message);
    console.log("prepareMessage", message.prepareMessage());
    return message.prepareMessage();
  },

  verify: async ({ message, signature }) => {
    console.log("verify");
    const verifyRes = await fetch("http://localhost:3001/siwe/verify", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ message, signature }),
    });
    return Boolean(verifyRes.ok);
  },

  signOut: async () => {
    await fetch("/api/logout");
  },
});
