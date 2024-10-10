import React from "react";
import { Action } from "@/domains/questing/types/questTypes";
import ActionHandler from "./ActionHandler";

interface ActionListProps {
  questId: string;
  actions: Action[];
}

const ActionList: React.FC<ActionListProps> = ({ questId, actions }) => {
  return (
    <div>
      {actions.map((action) => (
        <div key={action.id} className="mb-4">
          <ActionHandler questId={questId} action={action} />
        </div>
      ))}
    </div>
  );
};

export default ActionList;
