import React from "react";
import { ActionStrategy, ActionStrategyProps } from "./ActionStrategy";
import Button from "@/components/ui/Button";

export const ReadDocumentStrategy: ActionStrategy = ({
  action,
  execution,
  startMutation,
  completeMutation,
  refetch,
}) => {
  const handleStart = async () => {
    try {
      await startMutation.mutateAsync({ actionId: action.id, startData: {} });
      refetch();
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

  if (execution?.status === "completed") {
    return <p className="text-green-500">Action completed successfully!</p>;
  }

  if (!execution) {
    return (
      <Button onClick={handleStart} className="w-full bg-green-500 text-white">
        Start Reading Document
      </Button>
    );
  } else {
    return (
      <div>
        <p className="mb-4">Have you read the document?</p>
        <Button
          onClick={handleComplete}
          className="w-full bg-purple-500 text-white mt-4"
        >
          Confirm Document Read
        </Button>
      </div>
    );
  }
};
