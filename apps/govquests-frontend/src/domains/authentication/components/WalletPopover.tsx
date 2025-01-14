"use client";

import { Button } from "@/components/ui/Button";
import { Popover } from "@/components/ui/popover";
import { cn } from "@/lib/utils";
import {
  PopoverClose,
  PopoverContent,
  PopoverTrigger,
} from "@radix-ui/react-popover";
import { ChevronDown, X } from "lucide-react";
import Image from "next/image";
import {
  useAccount,
  useBalance,
  useDisconnect,
  useEnsAvatar,
  useEnsName,
} from "wagmi";

export const WalletPopover = ({ className }: { className: string }) => {
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
          <div className="flex items-center gap-2">
            <div className="size-6 rounded-full overflow-hidden">
              <Image
                src={ensAvatar || `https://effigy.im/a/${address}`}
                alt="wallet avatar"
                width={100}
                height={100}
                className="size-full object-cover"
                unoptimized
              />
            </div>
            <span>{getDisplayAddress()}</span>
            <ChevronDown className="size-4" />
          </div>
        </Button>
      </PopoverTrigger>
      <PopoverContent className="z-50 absolute -top-10 translate-x-1/2 right-10">
        <div className="relative w-80 items-center text-center p-6 bg-background shadow-2xl rounded-xl min-h-fit flex flex-col gap-4">
          <PopoverClose className="absolute top-2 right-4 size-4">
            <X width={16} />
          </PopoverClose>
          <div className="size-16 rounded-full overflow-hidden">
            <Image
              src={ensAvatar || `https://effigy.im/a/${address}`}
              alt="wallet avatar"
              width={100}
              height={100}
              className="size-full object-cover"
              unoptimized
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
