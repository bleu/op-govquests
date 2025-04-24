"use client";

import { Button } from "@/components/ui/Button";
import Spinner from "@/components/ui/Spinner";
import { ConnectKitButton, useSIWE } from "connectkit";
import type React from "react";
import { useAccount } from "wagmi";
import { WalletPopover } from "./WalletPopover";

interface SignInButtonProps {
  className?: string;
}

const SignInButton: React.FC<SignInButtonProps> = ({ className }) => {
  const { isConnected } = useAccount();
  const { signIn, signOut, isSignedIn } = useSIWE();

  const handleAuth = async () => {
    if (!isConnected) return;
    if (!isSignedIn) {
      await signIn();
    } else {
      await signOut();
    }
  };

  return (
    <ConnectKitButton.Custom>
      {({ isConnecting, show }) => {
        if (isConnected && isSignedIn)
          return <WalletPopover className={className} />;
        return (
          <Button
            variant="default"
            onClick={isConnected ? handleAuth : show}
            disabled={isConnecting}
            className={className}
          >
            {isConnecting ? (
              <Spinner />
            ) : !isConnected ? (
              "Connect Wallet"
            ) : (
              !isSignedIn && "Sign-In with Ethereum"
            )}
          </Button>
        );
      }}
    </ConnectKitButton.Custom>
  );
};

export default SignInButton;
