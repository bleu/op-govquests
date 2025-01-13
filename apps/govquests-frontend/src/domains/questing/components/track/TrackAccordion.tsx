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

export const TrackAccordion = ({ track }: { track: Tracks[number] }) => {
  const isCompleted = track.quests
    .map((quest) => quest.userQuests[0]?.status)
    .every((status) => status === "completed");
  return (
    <Accordion
      type="single"
      collapsible
      className="border border-primary-foreground/10 rounded-lg bg-background/60"
    >
      <AccordionItem value="item-1">
        <AccordionTrigger className="px-10 py-5 text-foreground">
          <TrackAccordionHeader track={track} isCompleted={isCompleted} />
        </AccordionTrigger>
        <AccordionContent>
          <TrackDescription track={track} isCompleted={isCompleted} />
          <QuestCarousel
            quests={track.quests}
            backgroundGradient={track.displayData.backgroundGradient}
          />
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  );
};
