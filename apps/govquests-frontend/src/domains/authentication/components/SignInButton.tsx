"use client";

import { Button } from "@/components/ui/Button";
import { Popover } from "@/components/ui/popover";
import Spinner from "@/components/ui/Spinner";
import { cn } from "@/lib/utils";
import {
  PopoverClose,
  PopoverContent,
  PopoverTrigger,
} from "@radix-ui/react-popover";
import { ConnectKitButton, useSIWE } from "connectkit";
import { ChevronDown, X } from "lucide-react";
import React from "react";
import {
  useAccount,
  useBalance,
  useEnsAvatar,
  useEnsName,
  useDisconnect,
} from "wagmi";

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

const WalletPopover = ({ className }: { className: string }) => {
  const { address } = useAccount();
  const { data: ensName } = useEnsName({ address });
  const { data: ensAvatar } = useEnsAvatar({ name: ensName });
  const { disconnect } = useDisconnect();

  const { data: balance } = useBalance({
    address,
  });

  const getDisplayAddress = () => {
    if (!address) return "";
    if (ensName) return ensName;
    return `${address.slice(0, 6)}...${address.slice(-4)}`;
  };

  return (
    <Popover>
      <PopoverTrigger>
        <Button variant="secondary" className={cn(className, "w-48")}>
          <WalletDisplay />
        </Button>
      </PopoverTrigger>
      <PopoverContent className="z-50 absolute -top-10 translate-x-1/2 right-10">
        <div className="relative w-80 items-center text-center p-6 bg-background shadow-2xl rounded-xl min-h-fit flex flex-col gap-4">
          <PopoverClose className="absolute top-2 right-4 size-4">
            <X width={16} />
          </PopoverClose>
          <div className="size-16 rounded-full overflow-hidden">
            <img
              src={ensAvatar || `https://effigy.im/a/${address}`}
              alt="wallet avatar"
              className="size-full object-cover"
            />
          </div>
          <div className="flex flex-col">
            <span className="font-extrabold text-lg">
              {getDisplayAddress()}
            </span>
            <span className="font-medium text-sm opacity-60">
              {Number(balance?.formatted).toFixed(4)} {balance?.symbol}
            </span>
          </div>
          <Button onClick={() => disconnect()}>Disconnect</Button>
        </div>
      </PopoverContent>
    </Popover>
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
      {({ isConnecting, show }) => {
        if (isConnected && isSignedIn)
          return <WalletPopover className={className} />;
        else
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
