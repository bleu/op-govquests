import React from "react";
import ReadActionButton from "../components/ActionButton";
import type { ActionStrategy } from "./ActionStrategy";

export const ReadDocumentStrategy: ActionStrategy = ({
  questId,
  action,
  execution,
  startMutation,
  completeMutation,
  refetch,
}) => {
  const handleStart = async () => {
    try {
      await startMutation.mutateAsync({
        questId,
        actionId: action.id,
        startData: {},
      });
      refetch();
      window.open(action.actionData.documentUrl, "_blank");
    } catch (error) {
      console.error("Error starting action:", error);
    }
  };

  const handleComplete = async () => {
    if (!execution) return;
    const completionData = { completed: true };
    try {
      await completeMutation.mutateAsync({
        executionId: execution.id,
        nonce: execution.nonce,
        completionData,
      });
      refetch();
    } catch (error) {
      console.error("Error completing action:", error);
    }
  };

  const getStatus = () => {
    if (execution?.status === "completed") {
      return "completed";
    }

    if (execution) {
      return "started";
    }

    return "unStarted";
  };

  return (
    <div className="flex w-full justify-between border-t-2 pt-3">
      <span className="font-medium">{action.displayData.content}</span>
      <ReadActionButton
        loading={startMutation.isPending || completeMutation.isPending}
        disabled={getStatus() === "completed"}
        status={getStatus()}
        onClick={getStatus() === "unStarted" ? handleStart : handleComplete}
      />
    </div>
  );
};
