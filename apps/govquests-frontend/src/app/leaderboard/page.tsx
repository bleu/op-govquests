import { TierTabs } from "@/domains/gamification/components/TierTabs";
import { UserAchievementPanel } from "@/domains/gamification/components/UserAchievementPanel";

export default function Page() {
  return (
    <div className="flex flex-col gap-9">
      <UserAchievementPanel />
      <TierTabs />
    </div>
  );
}
