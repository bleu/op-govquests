import { useState } from "react";
import { useActionExecutionWithStore } from "../stores/actionExecutionStore";
import { ActionData } from "../types/actionExecution";

export const useActionHandler = (action: ActionData) => {
  const { currentExecution, startAction, completeAction } =
    useActionExecutionWithStore();
  const [isCompleted, setIsCompleted] = useState(false);

  const handleStart = async () => {
    await startAction(action);
  };

  const handleComplete = async (completionData: Record<string, any>) => {
    await completeAction(completionData);
    setIsCompleted(true);
  };

  return {
    execution: currentExecution,
    isCompleted,
    handleStart,
    handleComplete,
  };
};
