import { useSIWE } from "connectkit";
import React from "react";
import { useAccount } from "wagmi";
import ActionButton from "../components/ActionButton";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import type { ActionStrategy } from "./ActionStrategy";

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
    <div className="flex w-full justify-between border-t-2 pt-3 mb-4">
      <span className="font-medium">{action.displayData.title}</span>

      <ActionButton
        status={getStatus()}
        onClick={getStatus() === "unstarted" ? handleStart : handleComplete}
        disabled={getStatus() === "completed" || !isSignedIn || !isConnected}
        loading={startMutation.isPending || completeMutation.isPending}
      />
    </div>
  );
};
