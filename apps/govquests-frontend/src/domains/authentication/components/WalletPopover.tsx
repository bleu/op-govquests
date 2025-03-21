"use client";

import { Button } from "@/components/ui/Button";
import { Popover } from "@/components/ui/popover";
import Spinner from "@/components/ui/Spinner";
import { useUserProfile } from "@/hooks/useUserProfile";
import { cn } from "@/lib/utils";
import {
  PopoverClose,
  PopoverContent,
  PopoverTrigger,
} from "@radix-ui/react-popover";
import { ChevronDown, X } from "lucide-react";
import Image from "next/image";
import { useAccount, useBalance, useDisconnect } from "wagmi";

export const WalletPopover = ({ className }: { className: string }) => {
  const { address } = useAccount();
  const { data: userProfile } = useUserProfile(address);
  const { disconnect, isPending } = useDisconnect();

  const { data: balance } = useBalance({
    address,
  });

  const handleDisconnect = () => {
    disconnect();
  };

  return (
    <Popover>
      <PopoverTrigger asChild>
        <div className="h-11">
          <Button variant="secondary" className={cn(className, "w-48")}>
            <div className="flex items-center gap-2">
              <div className="size-6 rounded-full overflow-hidden">
                {userProfile.avatarUrl && (
                  <Image
                    src={userProfile.avatarUrl}
                    alt="wallet avatar"
                    width={100}
                    height={100}
                    className="size-full object-cover"
                    unoptimized
                  />
                )}
              </div>
              <span>{userProfile.name}</span>
              <ChevronDown className="size-4" />
            </div>
          </Button>
        </div>
      </PopoverTrigger>
      <PopoverContent className="z-50 absolute translate-x-1/2 right-10">
        <div className="relative w-80 items-center text-center p-6 bg-background shadow-[0_8px_32px_0_#00000052] rounded-xl min-h-fit flex flex-col gap-4">
          <PopoverClose className="absolute top-2 right-4 size-4">
            <X width={16} />
          </PopoverClose>
          <div className="size-16 rounded-full overflow-hidden">
            {userProfile.avatarUrl && (
              <Image
                src={userProfile.avatarUrl}
                alt="wallet avatar"
                width={100}
                height={100}
                className="size-full object-cover"
                unoptimized
              />
            )}
          </div>
          <div className="flex flex-col">
            <span className="font-extrabold text-lg">{userProfile.name}</span>
            <span className="font-medium text-sm opacity-60">
              {Number(balance?.formatted).toFixed(4)} {balance?.symbol}
            </span>
          </div>
          <Button onClick={handleDisconnect} disabled={isPending}>
            {isPending ? <Spinner /> : "Disconnect"}
          </Button>
        </div>
      </PopoverContent>
    </Popover>
  );
};
