import { Action, ActionExecution } from "@/domains/questing/types/questTypes";

export interface ActionStrategyProps {
  questSlug: string;
  questId: string;
  action: Action;
  execution: ActionExecution | null;
  refetch: () => void;
}

export type ActionStrategy = React.FC<ActionStrategyProps>;
