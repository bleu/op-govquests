// src/domains/authentication/components/SignInButton.tsx
import React from "react";
import { ConnectKitButton } from "connectkit";
import { useAccount } from "wagmi";
import { useSIWE } from "connectkit";
import Button from "@/components/ui/Button";

const SignInButton: React.FC = () => {
  const { isConnected, chainId } = useAccount();
  const { signIn, signOut, isSignedIn } = useSIWE();

  if (!isConnected || !chainId) {
    return <ConnectKitButton />;
  }

  if (isSignedIn) {
    return <Button onClick={() => signOut()}>Sign Out</Button>;
  }

  return <Button onClick={() => signIn()}>Sign-In with Ethereum</Button>;
};

export default SignInButton;
