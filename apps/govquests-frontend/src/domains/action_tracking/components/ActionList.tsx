import React from "react";
import { Action } from "@/domains/questing/types/questTypes";
import ActionHandler from "./ActionHandler";

interface ActionListProps {
  actions: Action[];
}

const ActionList: React.FC<ActionListProps> = ({ actions }) => {
  return (
    <div>
      {actions.map((action) => (
        <div key={action.id} className="mb-4">
          <ActionHandler action={action} />
        </div>
      ))}
    </div>
  );
};

export default ActionList;
