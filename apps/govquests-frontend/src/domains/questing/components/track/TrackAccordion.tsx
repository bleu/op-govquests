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
  return (
    <Accordion type="single" collapsible className="border rounded-lg">
      <AccordionItem value="item-1">
        <AccordionTrigger className="px-10 py-5">
          <TrackAccordionHeader track={track} />
        </AccordionTrigger>
        <AccordionContent>
          <TrackDescription track={track} />
          <QuestCarousel quests={track.quests.slice(0, 4)} />
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  );
};
