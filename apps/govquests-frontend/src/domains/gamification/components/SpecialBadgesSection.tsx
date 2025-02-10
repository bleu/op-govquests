"use client";

import { SectionHeader } from "@/components/SectionHeader";
import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "@/components/ui/carousel";
import { cn } from "@/lib/utils";
import type { UseEmblaCarouselType } from "embla-carousel-react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { useSearchParams } from "next/navigation";
import { useEffect, useMemo, useState } from "react";
import { useFetchSpecialBadges } from "../hooks/useFetchSpecialBadges";
import { SpecialBadgeCard } from "./BadgeCard";
import { BadgeDialog } from "./BadgeDialog";

export const SpecialBadgesSection: React.FC = () => {
  const [api, setApi] = useState<UseEmblaCarouselType[1] | null>(null);
  const params = useSearchParams();
  const queryBadgeId = params.get("badgeId");

  const { data } = useFetchSpecialBadges();

  const hasNavigationButtons = useMemo<boolean>(
    () => api && (api.canScrollPrev() || api.canScrollNext()),
    [api],
  );
  const [isLast, setIsLast] = useState(false);
  const [isFirst, setIsFirst] = useState(true);

  useEffect(() => {
    api?.on("scroll", () => {
      setIsLast(!api.canScrollNext());
      setIsFirst(!api.canScrollPrev());
    });
  }, [api]);

  return (
    data && (
      <div className="flex flex-col items-center justify-center w-full">
        <SectionHeader
          title="Special Badges"
          description="Big achievements with special acknowledgement."
          className="w-[calc(100%-3rem)] mx-6"
        />

        <div className="relative w-full">
          {hasNavigationButtons && (
            <div className="absolute left-0 top-1/2 -translate-y-1/2 z-10">
              <button
                type="button"
                onClick={() => api.scrollPrev()}
                className={cn(isFirst && "opacity-30 cursor-default")}
              >
                <ChevronLeft className="w-5 h-5" />
              </button>
            </div>
          )}

          <Carousel
            setApi={setApi}
            className="mx-6 overflow-visible"
            opts={{ align: "center" }}
          >
            <CarouselContent>
              {data.specialBadges.map((badge, index) => (
                <CarouselItem
                  key={badge.id}
                  className="xl:basis-1/5 lg:basis-1/4 md:basis-1/3 sm:basis-1/2 basis-full py-5 flex flex-col w-full max-w-56"
                >
                  <BadgeDialog
                    defaultOpen={queryBadgeId === badge.id}
                    badgeId={badge.id}
                    special
                  >
                    <SpecialBadgeCard
                      badgeId={badge.id}
                      withTitle
                      header={`SPECIAL BADGE #${index + 1}`}
                      className="w-full"
                    />
                  </BadgeDialog>
                </CarouselItem>
              ))}
            </CarouselContent>
          </Carousel>

          {hasNavigationButtons && (
            <div className="absolute right-0 top-1/2 -translate-y-1/2 z-10">
              <button
                type="button"
                onClick={() => api.scrollNext()}
                className={cn(isLast && "opacity-30 cursor-default")}
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
