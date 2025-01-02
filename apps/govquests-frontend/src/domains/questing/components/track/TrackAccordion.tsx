import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { Quests } from "../../types/questTypes";
import { TrackAccordionHeader } from "./TrackAccordionHeader";

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
    <Accordion type="single" collapsible className="border rounded-lg px-10">
      <AccordionItem value="item-1">
        <AccordionTrigger>
          <TrackAccordionHeader track={track} />
        </AccordionTrigger>
        <AccordionContent>
          Yes. It adheres to the WAI-ARIA design pattern.
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  );
};
