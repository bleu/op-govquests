import { useSIWE } from "connectkit";
import React, { useCallback, useState } from "react";
import { useAccount } from "wagmi";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import type { ActionStrategyProps, StrategyContext } from "./ActionStrategy";

interface BaseStrategyProps extends ActionStrategyProps {
  children: (contextValue: StrategyContext) => React.ReactNode;
  startData?: Record<string, unknown>;
  completeData?: Record<string, unknown>;
}

export const BaseStrategy: React.FC<BaseStrategyProps> = ({
  questId,
  action,
  execution,
  refetch,
  startData,
  completeData,
  children,
}) => {
  const { isSignedIn } = useSIWE();
  const { isConnected } = useAccount();
  const startMutation = useStartActionExecution();
  const completeMutation = useCompleteActionExecution(["quest", questId]);

  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleStart = useCallback(async () => {
    try {
      await startMutation.mutateAsync({
        ...startData,
        questId,
        actionId: action.id,
        actionType: action.actionType,
      });
      refetch();
      setErrorMessage(null);
    } catch (error) {
      console.error("Error starting action:", error);
      setErrorMessage("Failed to start the verification. Please try again.");
    }
  }, [
    startMutation,
    questId,
    action.id,
    action.actionType,
    refetch,
    startData,
  ]);

  const handleComplete = useCallback(async () => {
    if (!execution) return;
    try {
      await completeMutation.mutateAsync({
        ...completeData,
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
      });
      refetch();
      setErrorMessage(null);
    } catch (error) {
      console.error("Error completing action:", error);
      setErrorMessage("Failed to complete the action. Please try again.");
    }
  }, [
    action.actionType,
    execution,
    execution?.id,
    execution?.nonce,
    refetch,
    completeMutation.mutateAsync,
    completeData,
  ]);

  const contextValue = {
    handleStart,
    handleComplete,
    startMutation,
    completeMutation,
    errorMessage,
    setErrorMessage,
    isSignedIn,
    isConnected,
  };

  return <>{children(contextValue)}</>;
};
