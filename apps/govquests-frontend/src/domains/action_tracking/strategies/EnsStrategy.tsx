import { useSIWE } from "connectkit";
import React, { useCallback, useMemo, useState } from "react";
import { useAccount } from "wagmi";
import ActionButton from "../components/ActionButton";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import { EnsStatus } from "../types/actionButtonTypes";
import type { ActionStrategy } from "./ActionStrategy";

export const EnsStrategy: ActionStrategy = ({
  questId,
  action,
  execution,
  refetch,
}) => {
  const startMutation = useStartActionExecution();
  const completeMutation = useCompleteActionExecution(["quest", questId]);
  const { isSignedIn } = useSIWE();
  const { isConnected, address } = useAccount();
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleStart = useCallback(async () => {
    if (!address) {
      setErrorMessage("Wallet address not found");
      return;
    }
    try {
      await startMutation.mutateAsync({
        questId,
        actionId: action.id,
        actionType: action.actionType,
        ensStartData: { address },
      });
      refetch();
      setErrorMessage(null);
    } catch (error) {
      console.error("Error starting action:", error);
      setErrorMessage("Failed to start the action. Please try again.");
    }
  }, [startMutation, questId, action.id, action.actionType, address, refetch]);

  const handleComplete = useCallback(async () => {
    if (!execution) return;
    try {
      const result = await completeMutation.mutateAsync({
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
      });

      if (result.completeActionExecution?.errors.length > 0) {
        setErrorMessage(result.completeActionExecution?.errors[0]);
      } else {
        setErrorMessage(null);
        refetch();
      }
    } catch (error) {
      console.error("Error completing action:", error);
      setErrorMessage(
        "An error occurred while completing the action. Please try again.",
      );
    }
  }, [execution, completeMutation, action.actionType, refetch]);

  const getStatus = useCallback((): EnsStatus => {
    if (!execution || execution.status === "unstarted") return "unstarted";
    if (execution.status === "started") return "started";
    return "completed";
  }, [execution]);

  const buttonProps = useMemo(() => {
    const status = getStatus();
    const baseProps = {
      actionType: "ens" as const,
      status,
      disabled: !isSignedIn || !isConnected || status === "completed",
      loading: startMutation.isPending || completeMutation.isPending,
    };

    switch (status) {
      case "unstarted":
        return { ...baseProps, onClick: handleStart };
      case "started":
        return { ...baseProps, onClick: handleComplete };
      case "completed":
        return { ...baseProps, onClick: () => {} };
    }
  }, [
    getStatus,
    isSignedIn,
    isConnected,
    startMutation.isPending,
    completeMutation.isPending,
    handleStart,
    handleComplete,
  ]);

  const renderedContent = useMemo(() => {
    if (errorMessage) {
      return (
        <>
          <span className="text-sm text-foreground/70">
            ENS verification failed. 😕
          </span>
          <span className="text-sm font-bold">{errorMessage}</span>
        </>
      );
    }
    if (getStatus() === "completed") {
      return (
        <>
          <span className="text-sm text-foreground/70">
            ENS verification succeeded! ✅
          </span>
          <span className="text-sm font-bold">Your ENS name is ensName.</span>
        </>
      );
    }
    return (
      <span className="text-sm text-foreground/70">
        {action.displayData.description}
      </span>
    );
  }, [errorMessage, getStatus, action.displayData.description]);

  return (
    <div className="flex justify-between items-center">
      <div className="flex flex-col">
        <span className="text-xl font-semibold mb-1">
          {action.displayData.title}
        </span>
        {renderedContent}
      </div>
      <ActionButton {...buttonProps} />
    </div>
  );
};
