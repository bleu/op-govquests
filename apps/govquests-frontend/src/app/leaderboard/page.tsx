import { TierTabs } from "@/domains/gamification/components/TierTabs";
import { CurrentUserAchievementPanel } from "@/domains/gamification/components/UserAchievementPanel";
import { Suspense } from "react";

export default function Page() {
  return (
    <div className="flex flex-col gap-9 p-8 mx-8">
      <CurrentUserAchievementPanel />
      <Suspense fallback={<div>Loading...</div>}>
        <TierTabs />
      </Suspense>
    </div>
  );
}
