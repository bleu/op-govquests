import { useSIWE } from "connectkit";
import React, { ComponentProps, useCallback } from "react";
import { useAccount } from "wagmi";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import {
  CompleteActionExecutionResult,
  StartActionExecutionResult,
} from "../types/actionTypes";
import type { ActionStrategyProps, StrategyContext } from "./ActionStrategy";
import { cn } from "@/lib/utils";

interface BaseStrategyProps extends ActionStrategyProps {
  children: (contextValue: StrategyContext) => React.ReactNode;
  errorMessage: string;
  setErrorMessage: React.Dispatch<React.SetStateAction<string | undefined>>;
  getStartData?: () => Record<string, unknown>;
  getCompleteData?: () => Record<string, unknown>;
  onStartMutationSuccess?: (result: StartActionExecutionResult) => void;
  onStartMutationError?: (error: Error) => void;
  onCompleteMutationSuccess?: (result: CompleteActionExecutionResult) => void;
  onCompleteMutationError?: (error: Error) => void;
}

export const BaseStrategy = (props: BaseStrategyProps) => {
  const defaultOnStartMutationSuccess = () => {
    refetch();
    setErrorMessage(null);
  };

  const defaultOnStartMutationError = (error: Error) => {
    console.error("Error starting action:", error);
    setErrorMessage("Failed to start the verification. Please try again.");
  };

  const defaultOnCompleteMutationSuccess = defaultOnStartMutationSuccess;

  const defaultOnCompleteMutationError = (error: Error) => {
    console.error("Error completing action:", error);
    setErrorMessage("Failed to complete the action. Please try again.");
  };

  const {
    questSlug,
    questId,
    action,
    execution,
    refetch,
    errorMessage,
    setErrorMessage,
    getStartData,
    getCompleteData,
    children,
    onStartMutationSuccess = defaultOnStartMutationSuccess,
    onStartMutationError = defaultOnStartMutationError,
    onCompleteMutationSuccess = defaultOnCompleteMutationSuccess,
    onCompleteMutationError = defaultOnCompleteMutationError,
  } = props;

  const { isSignedIn } = useSIWE();
  const { isConnected } = useAccount();
  const startMutation = useStartActionExecution();
  const completeMutation = useCompleteActionExecution(["quest", questSlug]);

  const handleStart = useCallback(async () => {
    try {
      const result = await startMutation.mutateAsync({
        ...(getStartData?.() ?? {}),
        questId,
        actionId: action.id,
        actionType: action.actionType,
      });
      onStartMutationSuccess(result);
    } catch (error) {
      onStartMutationError(error);
    }
  }, [
    startMutation,
    questId,
    action.id,
    action.actionType,
    refetch,
    getStartData,
  ]);

  const handleComplete = useCallback(async () => {
    if (!execution) return;
    try {
      const result = await completeMutation.mutateAsync({
        ...(getCompleteData?.() ?? {}),
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
      });
      onCompleteMutationSuccess(result);
    } catch (error) {
      onCompleteMutationError(error);
    }
  }, [
    action.actionType,
    execution,
    execution?.id,
    execution?.nonce,
    refetch,
    completeMutation.mutateAsync,
    getCompleteData,
  ]);

  const contextValue: StrategyContext = {
    handleStart,
    handleComplete,
    startMutation,
    completeMutation,
    errorMessage,
    setErrorMessage,
    isSignedIn,
    isConnected,
  };

  return <>{children({ ...contextValue, ...props })}</>;
};

export const ActionContent = (props: ComponentProps<"div">) => {
  return (
    <div
      className={cn(
        "flex flex-col justify-between items-start gap-5 px-5",
        props.className,
      )}
      {...props}
    />
  );
};

export const ActionFooter = (props: ComponentProps<"div">) => {
  return (
    <div
      className={cn(
        "self-end mb-2 flex flex-col gap-1 items-end [&>button]:w-52 [&>span]:text-xs",
        props.className,
      )}
      {...props}
    />
  );
};
