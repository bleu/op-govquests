"use client";

import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "@/components/ui/carousel";
import { cn } from "@/lib/utils";
import { UseEmblaCarouselType } from "embla-carousel-react";
import { useEffect, useState } from "react";
import { useFetchBadges } from "../hooks/useFetchBadges";
import { BadgeCard } from "./BadgeCard";

export const SpecialBadgesSection: React.FC = () => {
  const [api, setApi] = useState<UseEmblaCarouselType[1] | null>(null);

  const { data } = useFetchBadges();

  const hasNavigationButtons = true;
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
        <Carousel
          setApi={setApi}
          className={cn(hasNavigationButtons && "mx-10 w-[calc(100%-2.5rem)]")}
        >
          <CarouselContent>
            {data.badges.map((badge, index) => (
              <CarouselItem key={badge.id} className="basis-1/5">
                <div className="my-3 p-2 rounded-lg bg-background/60 transition duration-300 hover:scale-105 flex flex-col">
                  <div className="px-2">
                    <h2 className="text-sm font-bold">
                      SPECIAL BADGE #{index}
                    </h2>
                    <span className="text-xs font-thin">
                      PARTICIPATION MILESTONE
                    </span>
                  </div>
                  <div className="w-full">
                    <BadgeCard badgeId={badge.id} isCompleted={true} />
                  </div>
                </div>
              </CarouselItem>
            ))}
          </CarouselContent>
        </Carousel>
      </div>
    )
  );
};
