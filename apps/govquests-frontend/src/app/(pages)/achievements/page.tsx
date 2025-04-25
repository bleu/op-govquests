import { SimpleBadgesSection } from "@/domains/gamification/components/GalleryBadgesSection";
import { SpecialBadgesSection } from "@/domains/gamification/components/SpecialBadgesSection";
import { Suspense } from "react";

export default function Page() {
  return (
    <div className="flex flex-col gap-8 h-full py-8">
      <Suspense>
        <SpecialBadgesSection />
      </Suspense>
      <Suspense>
        <SimpleBadgesSection />
      </Suspense>
    </div>
  );
}
