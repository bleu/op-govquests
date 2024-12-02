import { useSIWE } from "connectkit";
import React, { useCallback, useMemo } from "react";
import { useAccount } from "wagmi";
import ActionButton from "../components/ActionButton";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import type { ReadDocumentStatus } from "../types/actionButtonTypes";
import type { ActionStrategy } from "./ActionStrategy";

export const ReadDocumentStrategy: ActionStrategy = ({
  questSlug,
  questId,
  action,
  execution,
  refetch,
}) => {
  const { isSignedIn } = useSIWE();
  const { isConnected } = useAccount();
  const startMutation = useStartActionExecution();
  const completeMutation = useCompleteActionExecution(["quest", questSlug]);

  const handleStart = useCallback(async () => {
    try {
      await startMutation.mutateAsync({
        questId,
        actionId: action.id,
        actionType: action.actionType,
      });
      window.open(action.actionData.documentUrl, "_blank");
      refetch();
    } catch (error) {
      console.error("Error starting action:", error);
    }
  }, [
    startMutation,
    questId,
    action.id,
    action.actionType,
    action.actionData.documentUrl,
    refetch,
  ]);

  const handleComplete = useCallback(async () => {
    if (!execution) return;
    const completionData = { completed: true };
    try {
      await completeMutation.mutateAsync({
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
        completionData,
      });
      refetch();
    } catch (error) {
      console.error("Error completing action:", error);
    }
  }, [completeMutation, execution, action.actionType, refetch]);

  const getStatus = useCallback((): ReadDocumentStatus => {
    if (execution?.status === "completed") return "completed";
    if (execution) return "started";
    return "unstarted";
  }, [execution]);

  const buttonProps = useMemo(
    () => ({
      actionType: "read_document" as const,
      status: getStatus(),
      onClick: getStatus() === "unstarted" ? handleStart : handleComplete,
      disabled: getStatus() === "completed" || !isSignedIn || !isConnected,
      loading: startMutation.isPending || completeMutation.isPending,
    }),
    [
      getStatus,
      handleStart,
      handleComplete,
      isSignedIn,
      isConnected,
      startMutation.isPending,
      completeMutation.isPending,
    ],
  );

  return (
    <div className="flex w-full justify-between">
      <span className="font-medium">{action.displayData.title}</span>
      <ActionButton {...buttonProps} />
    </div>
  );
};
