import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "@/components/ui/carousel";
import type { Quests } from "../types/questTypes";
import QuestCard from "./QuestCard";
import { useEffect, useState } from "react";
import type { UseEmblaCarouselType } from "embla-carousel-react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { cn } from "@/lib/utils";
import type { Tracks } from "../types/trackTypes";
import { useBreakpoints } from "@/hooks/useBreakpoints";

interface QuestCarouselProps {
  quests: Quests;
  backgroundGradient: Tracks[number]["displayData"]["backgroundGradient"];
}

export const QuestCarousel = ({
  quests,
  backgroundGradient,
}: QuestCarouselProps) => {
  const [api, setApi] = useState<UseEmblaCarouselType[1] | null>(null);
  const { isSmallerThan } = useBreakpoints();
  const hasNavigationButtons = isSmallerThan.md
    ? quests.length > 1
    : quests.length > 3;
  const [isLast, setIsLast] = useState(false);
  const [isFirst, setIsFirst] = useState(true);

  useEffect(() => {
    api?.on("scroll", () => {
      setIsLast(!api.canScrollNext());
      setIsFirst(!api.canScrollPrev());
    });
  }, [api]);

  return (
    <div className="flex flex-col gap-8 mt-7 mb-3">
      <div className="flex items-center justify-center w-full gap-9">
        <div className="border-b h-0 w-full" />
        <div className="text-xl font-bold whitespace-nowrap">Quests</div>
        <div className="border-b h-0 w-full" />
      </div>
      <div className="relative md:mx-10 mx-4">
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
          className={cn(hasNavigationButtons && "md:mx-10 mx-6")}
        >
          <CarouselContent>
            {quests.map((quest) => (
              <CarouselItem
                key={quest.id}
                className="md:basis-1/3 sm:basis-1/2"
              >
                <QuestCard
                  quest={quest}
                  backgroundGradient={backgroundGradient}
                />
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
  );
};
