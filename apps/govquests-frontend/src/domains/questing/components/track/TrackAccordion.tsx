"use client";

import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { Tracks } from "../../types/trackTypes";
import { QuestCarousel } from "../QuestCarousel";
import { TrackAccordionHeader } from "./TrackAccordionHeader";
import { TrackDescription } from "./TrackDescription";
import { useSearchParams } from "next/navigation";
import { useEffect, useRef } from "react";

export const TrackAccordion = ({ track }: { track: Tracks[number] }) => {
  const searchParams = useSearchParams();
  const trackId = searchParams.get("trackId");

  const accordionRef = useRef<HTMLDivElement>(null);
  const shouldOpen = trackId === track.id;

  useEffect(() => {
    if (shouldOpen && accordionRef.current) {
      accordionRef.current.scrollIntoView({
        behavior: "smooth",
        block: "start",
      });
    }
  }, [shouldOpen, track.id]);

  return (
    <Accordion
      type="single"
      collapsible
      className="border border-primary-foreground/10 rounded-lg bg-background/60"
      defaultValue={shouldOpen && "item-1"}
      ref={accordionRef}
    >
      <AccordionItem value="item-1">
        <AccordionTrigger className="px-10 py-5 text-foreground">
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
