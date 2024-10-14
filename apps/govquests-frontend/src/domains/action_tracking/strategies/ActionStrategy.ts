import { Action, ActionExecution } from "@/domains/questing/types/questTypes";

export interface ActionStrategyProps {
  questId: string;
  action: Action;
  execution: ActionExecution | null;
}

export type ActionStrategy = React.FC<ActionStrategyProps>;
