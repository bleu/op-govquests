import {
  Carousel,
  CarouselContent
} from "@/components/ui/carousel";
import { cn } from "@/lib/utils";
import { UseEmblaCarouselType } from "embla-carousel-react";
import { useEffect, useState } from "react";

export const SpecialBadgesSection: React.FC = () => {
  const [api, setApi] = useState<UseEmblaCarouselType[1] | null>(null);

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
    <div className="flex flex-col items-center justify-center w-full">
      <div className="flex flex-col gap-3 mx-8 pb-4 border-b border-foreground/20 w-[calc(100%-4rem)]">
        <h1 className="text-2xl font-bold"># Special Badges</h1>
        <span className="text-xl">
          Big achievements with special acknowledgement.
        </span>
      </div>

      <div className="grid grid-cols-1 gap-4 mt-9">
        <Carousel
          setApi={setApi}
          className={cn(hasNavigationButtons && "mx-10")}
        >
          <CarouselContent>
            {/* {badges.map((badge) => (
              <CarouselItem key={badge.id} className="basis-1/3">
                <BadgeCard
                  badgeId={badge.id}
                />
              </CarouselItem>
            ))} */}
          </CarouselContent>
        </Carousel>
      </div>
    </div>
  );
};
