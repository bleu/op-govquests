import { TierTabs } from "@/domains/gamification/components/TierTabs";
import {
  CurrentUserAchievementPanel,
} from "@/domains/gamification/components/UserAchievementPanel";

export default function Page() {
  return (
    <div className="flex flex-col gap-9 p-8 mx-8">
      <CurrentUserAchievementPanel />
      <TierTabs />
    </div>
  );
}
