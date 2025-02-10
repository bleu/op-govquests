"use client";

import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { useBreakpoints } from "@/hooks/useBreakpoints";
import { cn } from "@/lib/utils";
import { useSearchParams } from "next/navigation";
import { useEffect, useRef } from "react";
import type { Tracks } from "../../types/trackTypes";
import { QuestCarousel } from "../QuestCarousel";
import { TrackAccordionHeader } from "./TrackAccordionHeader";
import { TrackDescription } from "./TrackDescription";

export const TrackAccordion = ({ track }: { track: Tracks[number] }) => {
  const searchParams = useSearchParams();
  const trackId = searchParams.get("trackId");
  const { isSmallerThan } = useBreakpoints();

  const accordionRef = useRef<HTMLDivElement>(null);
  const shouldOpen = trackId === track.id;

  useEffect(() => {
    if (shouldOpen && accordionRef.current) {
      accordionRef.current.scrollIntoView({
        behavior: "smooth",
        block: "start",
      });
    }
  }, [shouldOpen]);

  return (
    <Accordion
      type="single"
      collapsible
      className="border border-primary-foreground/10 rounded-lg bg-background/60"
      defaultValue={shouldOpen && "item-1"}
      ref={accordionRef}
    >
      <AccordionItem value="item-1">
        <AccordionTrigger className="md:px-10 md:py-5 text-foreground p-4">
          <TrackAccordionHeader track={track} />
        </AccordionTrigger>
        <AccordionContent>
          <TrackDescription track={track} />
          <QuestCarousel
            quests={track.quests}
            backgroundGradient={track.displayData.backgroundGradient}
          />
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  );
};
