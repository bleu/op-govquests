"use client";

import { Button } from "@/components/ui/Button";
import Spinner from "@/components/ui/Spinner";
import { ConnectKitButton, useSIWE } from "connectkit";
import { ChevronDown } from "lucide-react";
import React from "react";
import { useAccount, useEnsAvatar, useEnsName } from "wagmi";

const WalletDisplay = () => {
  const { address } = useAccount();
  const { data: ensName } = useEnsName({ address });
  const { data: ensAvatar } = useEnsAvatar({ name: ensName });

  const getDisplayAddress = () => {
    if (!address) return "";
    if (ensName) return ensName;
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  return (
    <div className="flex items-center gap-2">
      <div className="size-6 rounded-full overflow-hidden">
        <img
          src={ensAvatar || `https://effigy.im/a/${address}`}
          alt="wallet avatar"
          className="size-full object-cover"
        />
      </div>
      <span>{getDisplayAddress()}</span>
      <ChevronDown className="size-4" />
    </div>
  );
};

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
      {({ isConnecting, show }) => (
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
          ) : !isSignedIn ? (
            "Sign-In with Ethereum"
          ) : (
            <WalletDisplay />
          )}
        </Button>
      )}
    </ConnectKitButton.Custom>
  );
};

export default SignInButton;
