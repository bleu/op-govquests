"use client";

import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "@/components/ui/carousel";
import { Dialog, DialogTrigger } from "@/components/ui/dialog";
import { cn } from "@/lib/utils";
import { UseEmblaCarouselType } from "embla-carousel-react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { useSearchParams } from "next/navigation";
import { useEffect, useMemo, useState } from "react";
import { useFetchBadges } from "../hooks/useFetchBadges";
import { BadgeCard } from "./BadgeCard";
import { BadgeDetails } from "./BadgeDetails";

export const SpecialBadgesSection: React.FC = () => {
  const [api, setApi] = useState<UseEmblaCarouselType[1] | null>(null);
  const params = useSearchParams();
  const queryBadgeId = params.get("badgeId");

  const { data } = useFetchBadges();

  const hasNavigationButtons = useMemo<boolean>(
    () => api && (api.canScrollPrev() || api.canScrollNext()),
    [api],
  );
  const [isLast, setIsLast] = useState(false);
  const [isFirst, setIsFirst] = useState(true);

  useEffect(() => {
    api &&
      api.on("scroll", () => {
        setIsLast(!api.canScrollNext());
        setIsFirst(!api.canScrollPrev());
      });
  }, [api]);

  return (
    data && (
      <div className="flex flex-col items-center justify-center w-full">
        <div className="flex flex-col gap-3 mx-8 pb-4 border-b border-foreground/20 w-[calc(100%-4rem)]">
          <h1 className="text-2xl font-bold"># Special Badges</h1>
          <span className="text-xl">
            Big achievements with special acknowledgement.
          </span>
        </div>

        <div className="relative w-full mx-2">
          {hasNavigationButtons && (
            <div className="absolute left-0 top-1/2 -translate-y-1/2 z-10">
              <button
                onClick={() => api.scrollPrev()}
                className={cn("p2", isFirst && "opacity-30 cursor-default")}
              >
                <ChevronLeft className="w-5 h-5" />
              </button>
            </div>
          )}

          <Carousel setApi={setApi} className="mx-4 overflow-visible">
            <CarouselContent className="px-4">
              {data.badges.map((badge, index) => (
                <CarouselItem key={badge.id} className="basis-1/5">
                  <Dialog defaultOpen={queryBadgeId == badge.id}>
                    <DialogTrigger>
                      <BadgeCard
                        badgeId={badge.id}
                        isCompleted={true}
                        withTitle
                        header={`SPECIAL BADGE #${index + 1}`}
                      />
                    </DialogTrigger>
                    <BadgeDetails badgeId={badge.id} />
                  </Dialog>
                </CarouselItem>
              ))}
            </CarouselContent>
          </Carousel>

          {hasNavigationButtons && (
            <div className="absolute right-0 top-1/2 -translate-y-1/2 z-10">
              <button
                onClick={() => api.scrollNext()}
                className={cn("p2", isLast && "opacity-30 cursor-default")}
              >
                <ChevronRight className="w-5 h-5" />
              </button>
            </div>
          )}
        </div>
      </div>
    )
  );
};
