import { Button } from "@/components/ui/Button";
import { useState } from "react";
import { useFetchSpecialBadge } from "../hooks/useFetchSpecialBadge";
import { useCollectBadge } from "../hooks/useCollectBadge";

export const SpecialBadgeContent = ({ badgeId }: { badgeId: string }) => {
  const { data } = useFetchSpecialBadge(badgeId);

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
          if (result.collectBadge.errors) {
            setError(result.collectBadge.errors);
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
            disabled={isCompleted}
            onClick={handleCollectBadge}
          >
            Collect Badge
          </Button>
          {error && (
            <p className="text-destructive font-bold text-xs">
              Sorry, you haven&apos;t met the requirements.Try again another
              time.
            </p>
          )}
        </div>
      </div>
    )
  );
};
