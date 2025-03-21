import { useFetchQuest } from "@/domains/questing/hooks/useFetchQuest";
import type { Action } from "@/domains/questing/types/questTypes";
import type React from "react";
import { ActionStrategyFactory } from "../strategies/ActionStrategyFactory";
import {
  Accordion,
  AccordionContent,
  AccordionItem,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { useSearchParams } from "next/navigation";

interface ActionHandlerProps {
  questSlug: string;
  action: Action;
  actionIndex: number;
}

const ActionHandler: React.FC<ActionHandlerProps> = ({
  questSlug,
  action,
  actionIndex,
}) => {
  const { data, isLoading, refetch } = useFetchQuest(questSlug);

  const quest = data?.quest || null;
  const actionExecutions = quest?.actions.find(
    (a) => a.id === action.id,
  )?.actionExecutions;

  const searchParams = useSearchParams();
  const actionId = searchParams.get("actionId");

  const execution = actionExecutions?.[0] || null;

  const StrategyComponent = ActionStrategyFactory.createStrategy(
    action.actionType,
  );

  if (isLoading) {
    return <p>Loading action executions...</p>;
  }

  return (
    <Accordion
      type="single"
      collapsible
      className="border rounded-lg py-0 bg-background/60"
      defaultValue={actionId == action.id ? "item-1" : undefined}
    >
      <AccordionItem value="item-1" className="md:px-5">
        <AccordionTrigger className="py-4 px-5">
          <span className="text-lg font-semibold mb-1 py-0 flex gap-2">
            <span className="opacity-60">#{actionIndex + 1}</span>
            {action.displayData.title}
          </span>
        </AccordionTrigger>
        <AccordionContent>
          <StrategyComponent
            questSlug={questSlug}
            questId={quest.id}
            action={action}
            execution={execution}
            refetch={refetch}
          />
        </AccordionContent>
      </AccordionItem>
    </Accordion>
  );
};

export default ActionHandler;
