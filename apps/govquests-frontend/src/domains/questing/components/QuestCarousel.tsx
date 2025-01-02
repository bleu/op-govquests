import {
  Carousel,
  CarouselContent,
  CarouselItem,
} from "@/components/ui/carousel";
import { Quests } from "../types/questTypes";
import QuestCard from "./QuestCard";
import { useState } from "react";
import { UseEmblaCarouselType } from "embla-carousel-react";
import { ChevronLeft, ChevronRight } from "lucide-react";
import { cn } from "@/lib/utils";

export const QuestCarousel = ({ quests }: { quests: Quests }) => {
  const [api, setApi] = useState<UseEmblaCarouselType[1] | null>(null);
  const hasNavigationButtons = quests.length > 3;

  return (
    <div className="flex flex-col gap-8 mt-7 mb-3">
      <div className="flex items-center justify-center w-full gap-9">
        <div className="border-b h-0 w-full" />
        <div className="text-xl font-bold whitespace-nowrap">Quests</div>
        <div className="border-b h-0 w-full" />
      </div>
      <div className="relative mx-10">
        {hasNavigationButtons && (
          <div className="absolute left-0 top-1/2 -translate-y-1/2 z-10">
            <button onClick={() => api.scrollPrev()} className="p-2">
              <ChevronLeft
                className={cn("w-5 h-5", !api.canScrollPrev() && "opacity-30")}
              />
            </button>
          </div>
        )}

        <Carousel
          setApi={setApi}
          className={cn(hasNavigationButtons && "mx-10")}
        >
          <CarouselContent>
            {quests.map((quest) => (
              <CarouselItem key={quest.id} className="basis-1/3">
                <QuestCard quest={quest} />
              </CarouselItem>
            ))}
          </CarouselContent>
        </Carousel>

        {hasNavigationButtons && (
          <div className="absolute right-0 top-1/2 -translate-y-1/2 z-10">
            <button onClick={() => api.scrollNext()} className="p-2">
              <ChevronRight
                className={cn("w-5 h-5", !api.canScrollNext() && "opacity-30")}
              />
            </button>
          </div>
        )}
      </div>
    </div>
  );
};
