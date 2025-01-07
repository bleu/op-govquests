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
  return (
    <Accordion type="single" collapsible className="border rounded-lg">
      <AccordionItem value="item-1">
        <AccordionTrigger className="px-10 py-5">
          <TrackAccordionHeader track={track} />
        </AccordionTrigger>
        <AccordionContent>
          <TrackDescription track={track} />
          <QuestCarousel quests={track.quests} />
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  );
};
