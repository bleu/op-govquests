"use client";

import Button from "@/components/ui/Button";
import { ConnectKitButton, useSIWE } from "connectkit";
import React from "react";
import { useAccount } from "wagmi";

interface SignInButtonProps {
  className?: string;
}

const SignInButton: React.FC<SignInButtonProps> = ({ className }) => {
  const { isConnected } = useAccount();
  const { signIn, signOut, isSignedIn } = useSIWE();

  const handleAuth = async () => {
    if (!isConnected) {
      // This will open the ConnectKit modal
      return;
    }
    if (!isSignedIn) {
      await signIn();
    } else {
      await signOut();
    }
  };

  const getButtonText = () => {
    if (!isConnected) return "Connect Wallet";
    if (isSignedIn) return "Sign Out";
    return "Sign-In with Ethereum";
  };

  return (
    <ConnectKitButton.Custom>
      {({ isConnecting, show }) => (
        <Button
          onClick={isConnected ? handleAuth : show}
          disabled={isConnecting}
          loading={isConnecting}
          className={className}
        >
          {getButtonText()}
        </Button>
      )}
    </ConnectKitButton.Custom>
  );
};

export default SignInButton;
