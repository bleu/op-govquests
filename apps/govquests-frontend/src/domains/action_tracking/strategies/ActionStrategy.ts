import {
  Action,
  ActionExecution,
  Quest,
} from "@/domains/questing/types/questTypes";

export interface ActionStrategyProps {
  quest: Quest;
  questId: string;
  action: Action;
  execution: ActionExecution | null;
  refetch: () => void;
}

export type ActionStrategy = React.FC<ActionStrategyProps>;
