import { Button } from "@/components/ui/Button";
import { useState } from "react";
import { useFetchSpecialBadge } from "../hooks/useFetchSpecialBadge";
import { useCollectBadge } from "../hooks/useCollectBadge";
import { useAccount } from "wagmi";
import { useSIWE } from "connectkit";
import HtmlRender from "@/components/ui/HtmlRender";
import {
  Tooltip,
  TooltipContent,
  TooltipTrigger,
  TooltipProvider,
} from "@/components/ui/tooltip";
import { ConditionalWrapper } from "@/components/ui/ConditionalWrapper";

export const SpecialBadgeContent = ({
  badgeId,
  setIsOpen,
}: {
  badgeId: string;
  setIsOpen: (isOpen: boolean) => void;
}) => {
  const { data } = useFetchSpecialBadge(badgeId);

  const { isConnected } = useAccount();
  const { isSignedIn } = useSIWE();

  const isCompleted = data?.specialBadge.earnedByCurrentUser;

  const { mutate } = useCollectBadge();

  const [error, setError] = useState(null);

  const handleCollectBadge = () => {
    mutate(
      {
        badgeId,
        badgeType: data.specialBadge.badgeType,
      },
      {
        onSuccess: (result) => {
          if (!result.collectBadge.badgeEarned) {
            setError(result.collectBadge.errors?.[0]);
          } else {
            setError(null);
            setIsOpen(false);
          }
        },
        onError: (error) => {
          setError(error.message);
        },
      },
    );
  };

  const isPendingReward =
    data?.specialBadge.userBadges.length &&
    data?.specialBadge.userBadges[0]?.rewardIssuances.some(
      (rewardIssuance: any) => !rewardIssuance.confirmedAt,
    );

  return (
    data && (
      <div className="flex flex-col gap-4">
        <h2 className="font-black text-lg w-full">
          {isCompleted
            ? "Special Badge Unlocked!"
            : "This Special Badge is waiting for you!"}
        </h2>
        <span>
          <span className="font-bold">How to win</span>
          <br />
          <HtmlRender content={data.specialBadge.displayData.description} />
        </span>
        <span>
          If you've already reached this milestone, click to collect this badge
          now.
        </span>
        <div className="flex flex-col gap-2 justify-center items-center">
          <ConditionalWrapper
            condition={isPendingReward}
            wrapper={(children) => (
              <TooltipProvider delayDuration={0}>
                <Tooltip defaultOpen={false}>
                  <TooltipTrigger>{children}</TooltipTrigger>
                  <TooltipContent>
                    <p>
                      Waiting until OP rewards are successfully transferred to
                      your wallet.
                    </p>
                  </TooltipContent>
                </Tooltip>
              </TooltipProvider>
            )}
          >
            <Button
              className="px-5 w-fit self-center"
              disabled={isCompleted || !isSignedIn || !isConnected}
              onClick={handleCollectBadge}
            >
              {!isPendingReward ? "Collect Badge" : "Pending Reward"}
            </Button>
          </ConditionalWrapper>
          {error && (
            <p className="text-destructive font-bold text-xs text-center">
              {error}
            </p>
          )}
          {(!isConnected || !isSignedIn) && (
            <p className="text-destructive font-bold text-xs text-center">
              You need to be connected to a wallet to collect this badge.
            </p>
          )}
        </div>
      </div>
    )
  );
};
