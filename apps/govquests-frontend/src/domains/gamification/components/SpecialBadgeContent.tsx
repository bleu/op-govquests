import { Button } from "@/components/ui/Button";
import { useState } from "react";
import { useFetchSpecialBadge } from "../hooks/useFetchSpecialBadge";
import { useCollectBadge } from "../hooks/useCollectBadge";
import { useAccount } from "wagmi";
import { useSIWE } from "connectkit";

export const SpecialBadgeContent = ({ badgeId }: { badgeId: string }) => {
  const { data } = useFetchSpecialBadge(badgeId);

  const { isConnected } = useAccount();
  const { isSignedIn } = useSIWE();

  const isCompleted = data.specialBadge.earnedByCurrentUser;

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
          }
        },
        onError: (error) => {
          setError(error.message);
        },
      },
    );
  };

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
          {data.specialBadge.displayData.description}
        </span>
        <span>
          If you’ve already reached this milestone, click to collect this badge
          now.
        </span>
        <div className="flex flex-col gap-2 justify-center items-center">
          <Button
            className="px-5 w-fit self-center"
            disabled={isCompleted || !isSignedIn || !isConnected}
            onClick={handleCollectBadge}
          >
            Collect Badge
          </Button>
          {error && (
            <p className="text-destructive font-bold text-xs text-centerπ">
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
