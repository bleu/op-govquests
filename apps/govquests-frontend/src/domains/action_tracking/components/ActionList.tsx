import type { Action } from "@/domains/questing/types/questTypes";
import { cn } from "@/lib/utils";
import type React from "react";
import ActionHandler from "./ActionHandler";

interface ActionListProps {
  questSlug: string;
  actions: Action[];
}

const ActionList: React.FC<ActionListProps> = ({ questSlug, actions }) => {
  return (
    <div className="flex flex-col gap-5">
      {actions.every((action) => action.actionType === "read_document") && (
        <h4 className="text-xl font-semibold">Read</h4>
      )}
      {actions.map((action, index) => (
        <div key={action.id}>
          <ActionHandler
            questSlug={questSlug}
            action={action}
            actionIndex={index}
          />
        </div>
      ))}
    </div>
  );
};

export default ActionList;
