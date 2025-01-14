import { useConnectModal } from "@rainbow-me/rainbowkit";
import { useState } from "react";
import { useAccount } from "wagmi";

export function useAuth() {
  const { openConnectModal } = useConnectModal();
  const { address, isConnected, isConnecting } = useAccount();
  const [isAuthLoading, setIsAuthLoading] = useState(false);

  const checkAuth = async () => {
    try {
      const response = await fetch("/api/siwe/me");
      return response.ok;
    } catch {
      return false;
    }
  };

  const signIn = async () => {
    if (!isConnected) {
      openConnectModal?.();
      return;
    }

    setIsAuthLoading(true);
    try {
      // Your existing sign in logic here
      const response = await fetch("/api/siwe/me");
      if (!response.ok) {
        openConnectModal?.();
      }
    } finally {
      setIsAuthLoading(false);
    }
  };

  const signOut = async () => {
    setIsAuthLoading(true);
    try {
      await fetch("/api/siwe/logout", { method: "POST" });
    } finally {
      setIsAuthLoading(false);
    }
  };

  return {
    address,
    isSignedIn: isConnected,
    isSigningIn: isConnecting,
    isAuthLoading,
    signIn,
    signOut,
    checkAuth,
  };
}

// Usage example:
/*
function YourComponent() {
  const { address, isConnected, isAuthLoading, signIn } = useAuth();

  if (isAuthLoading) return <div>Loading...</div>;

  return (
    <div>
      {isConnected ? (
        <div>Connected as {address}</div>
      ) : (
        <button onClick={signIn}>Connect Wallet</button>
      )}
    </div>
  );
}
*/
