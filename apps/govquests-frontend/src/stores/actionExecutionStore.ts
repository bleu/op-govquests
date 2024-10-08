import { create } from "zustand";
import { ActionData, ActionExecution } from "../types/actionExecution";
import { useActionExecution } from "@/services/useActionExecution";

interface ActionExecutionState {
  currentAction: ActionData | null;
  currentExecution: ActionExecution | null;
  setCurrentAction: (action: ActionData | null) => void;
  setCurrentExecution: (execution: ActionExecution | null) => void;
}

export const useActionExecutionStore = create<ActionExecutionState>((set) => ({
  currentAction: null,
  currentExecution: null,
  setCurrentAction: (action) => set({ currentAction: action }),
  setCurrentExecution: (execution) => set({ currentExecution: execution }),
}));

export const useActionExecutionWithStore = () => {
  const { startAction, completeAction } = useActionExecution();
  const {
    currentAction,
    currentExecution,
    setCurrentAction,
    setCurrentExecution,
  } = useActionExecutionStore();

  const handleStartAction = async (action: ActionData) => {
    setCurrentAction(action);
    const execution = await startAction(action);
    setCurrentExecution(execution);
  };

  const handleCompleteAction = async (completionData: Record<string, any>) => {
    if (!currentExecution) return;
    const updatedExecution = await completeAction(
      currentExecution,
      completionData
    );
    setCurrentExecution(updatedExecution);
    setCurrentAction(null);
  };

  return {
    currentAction,
    currentExecution,
    startAction: handleStartAction,
    completeAction: handleCompleteAction,
  };
};
