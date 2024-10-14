import { useSIWE } from "connectkit";
import React from "react";
import { useAccount } from "wagmi";
import ReadActionButton from "../components/ActionButton";
import type { ActionStrategy } from "./ActionStrategy";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";

export const ReadDocumentStrategy: ActionStrategy = ({
  questId,
  action,
  execution,
}) => {
  const { isSignedIn } = useSIWE();
  const { isConnected } = useAccount();
  const startMutation = useStartActionExecution();
  const completeMutation = useCompleteActionExecution(["quest", questId]);

  const handleStart = async () => {
    try {
      await startMutation.mutateAsync({
        questId,
        actionId: action.id,
        actionType: action.actionType,
      });
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
        actionType: action.actionType,
        completionData,
      });
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

    return "unstarted";
  };

  return (
    <div className="flex w-full justify-between border-t-2 pt-3">
      <span className="font-medium">{action.displayData.content}</span>
      <ReadActionButton
        loading={startMutation.isPending || completeMutation.isPending}
        disabled={getStatus() === "completed" || !isSignedIn || !isConnected}
        status={getStatus()}
        onClick={getStatus() === "unstarted" ? handleStart : handleComplete}
      />
    </div>
  );
};
