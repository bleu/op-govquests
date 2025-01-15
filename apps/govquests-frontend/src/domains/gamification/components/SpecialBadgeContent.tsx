import { Button } from "@/components/ui/Button";
import { Badge } from "../types/badgeTypes";

export const SpecialBadgeContent = ({ badge }: { badge: Badge }) => {
  return (
    <div className="flex flex-col gap-4">
      <h2 className="font-black text-lg w-full">Special Badge Unlocked!</h2>
      <span>
        <span className="font-bold">How to win</span>
        <br />
        You collected this badge by completing the{" "}
        {badge.displayData.description}
      </span>
      <span>
        If you’ve already reached this milestone, click to collect this badge
        now.
      </span>
      <Button className="px-5 w-fit self-center">Collect Badge</Button>
    </div>
  );
};
