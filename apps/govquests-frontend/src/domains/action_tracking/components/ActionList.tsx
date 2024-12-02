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
    <div>
      {actions.every((action) => action.actionType === "read_document") && (
        <h4 className="mb-5 text-xl font-semibold">Read</h4>
      )}
      {actions.map((action, index) => (
        <div
          key={action.id}
          className={cn(
            "border-t-2 py-7",
            index === 0 && "border-b-2 border-transparent",
          )}
        >
          <ActionHandler questSlug={questSlug} action={action} />
        </div>
      ))}
    </div>
  );
};

export default ActionList;
