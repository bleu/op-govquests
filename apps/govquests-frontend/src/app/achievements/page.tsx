import { SimpleBadgesSection } from "@/domains/gamification/components/GalleryBadgesSection";
import { SpecialBadgesSection } from "@/domains/gamification/components/SpecialBadgesSection";
import { Suspense } from "react";

export default function Page() {
  return (
    <div className="flex flex-1 flex-col gap-8 h-full mx-20">
      <Suspense>
        <SpecialBadgesSection />
      </Suspense>
      <Suspense>
        <SimpleBadgesSection />
      </Suspense>
    </div>
  );
}
