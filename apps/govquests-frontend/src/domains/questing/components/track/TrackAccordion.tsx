import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { Quests } from "../../types/questTypes";
import { TrackAccordionHeader } from "./TrackAccordionHeader";
import { TrackDescription } from "./TrackDescription";
import { QuestCarousel } from "../QuestCarousel";

export type Badge = {
  id: number;
  name: string;
  image: string;
};

export type Track = {
  id: number;
  title: string;
  description: string;
  image: string;
  totalPoints: number;
  badge: Badge;
  quests: Quests;
};

export const TrackAccordion = ({ track }: { track: Track }) => {
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
          <QuestCarousel quests={track.quests} />
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  );
};
