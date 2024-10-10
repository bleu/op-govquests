import React from "react";
import { ActionStrategy, ActionStrategyProps } from "./ActionStrategy";
import Button from "@/components/ui/Button";

export const DefaultActionStrategy: ActionStrategy = ({
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

  if (startMutation.isPending || completeMutation.isPending) {
    return <p>Processing...</p>;
  }

  if (startMutation.isError) {
    return <p className="text-red-500">Error: {startMutation.error.message}</p>;
  }

  if (completeMutation.isError) {
    return (
      <p className="text-red-500">Error: {completeMutation.error.message}</p>
    );
  }

  if (completeMutation.isSuccess) {
    return <p className="text-green-500">Action completed successfully!</p>;
  }

  if (!execution) {
    return (
      <Button onClick={handleStart} className="w-full bg-optimism text-white">
        Start {action.actionType}
      </Button>
    );
  } else {
    return (
      <Button
        onClick={handleComplete}
        className="w-full bg-optimism text-white mt-4"
      >
        Complete {action.actionType}
      </Button>
    );
  }
};
