import { Action } from "@/domains/questing/types/questTypes";
import React from "react";
import ActionHandler from "./ActionHandler";

interface ActionListProps {
  questId: string;
  actions: Action[];
}

const ActionList: React.FC<ActionListProps> = ({ questId, actions }) => {
  return (
    <div>
      {actions.every((action) => action.actionType === "read_document") && (
        <h4 className="mb-7">Read</h4>
      )}
      {actions.map((action) => (
        <div key={action.id} className="mb-4">
          <ActionHandler questId={questId} action={action} />
        </div>
      ))}
    </div>
  );
};

export default ActionList;
