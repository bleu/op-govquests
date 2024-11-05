"use client";

import { Button } from "@/components/ui/shadcn-button";
import Spinner from "@/components/ui/Spinner";
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
          variant="default"
          onClick={isConnected ? handleAuth : show}
          disabled={isConnecting}
          className={className}
        >
          {isConnecting ? <Spinner /> : getButtonText()}
        </Button>
      )}
    </ConnectKitButton.Custom>
  );
};

export default SignInButton;
