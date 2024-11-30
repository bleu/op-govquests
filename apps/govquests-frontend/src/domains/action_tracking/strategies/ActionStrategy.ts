import { Action, ActionExecution } from "@/domains/questing/types/questTypes";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";

export interface ActionStrategyProps {
  questId: string;
  action: Action;
  execution: ActionExecution | null;
  refetch: () => void;
}

export type ActionStrategy = React.FC<ActionStrategyProps>;

export interface StrategyContext {
  handleStart: () => Promise<void>;
  handleComplete: () => Promise<void>;
  isSignedIn: boolean;
  isConnected: boolean;
  startMutation: ReturnType<typeof useStartActionExecution>;
  completeMutation: ReturnType<typeof useCompleteActionExecution>;
  errorMessage: string | null;
  setErrorMessage: React.Dispatch<React.SetStateAction<string | null>>;
}

export type StrategyChildComponent<T extends object = {}> = React.FC<
  StrategyContext & ActionStrategyProps & T
>;
