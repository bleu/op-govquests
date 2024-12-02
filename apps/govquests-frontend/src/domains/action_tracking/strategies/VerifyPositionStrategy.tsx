import { useSIWE } from "connectkit";
import React, { useCallback, useMemo, useState } from "react";
import { useAccount } from "wagmi";
import ActionButton from "../components/ActionButton";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import type { VerifyPositionStatus } from "../types/actionButtonTypes";
import type { ActionStrategy } from "./ActionStrategy";

export const VerifyPositionStrategy: ActionStrategy = ({
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
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleStart = useCallback(async () => {
    try {
      await startMutation.mutateAsync({
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
  }, [startMutation, questId, action.id, action.actionType, refetch]);

  const handleComplete = useCallback(async () => {
    if (!execution) return;
    const completionData = { completed: true };
    try {
      const result = await completeMutation.mutateAsync({
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
        completionData,
      });
      if (result.completeActionExecution?.errors.length > 0) {
        setErrorMessage(
          "You haven't reached the Top 100 Delegates ranking for Season 6. Keep contributing and aim higher next season to unlock this reward.",
        );
      } else {
        setErrorMessage(null);
      }
      refetch();
    } catch (error) {
      console.error("Error completing action:", error);
      setErrorMessage(
        "An error occurred during verification. Please try again.",
      );
    }
  }, [completeMutation, execution, action.actionType, refetch]);

  const getStatus = useCallback((): VerifyPositionStatus => {
    if (execution?.status === "completed") return "completed";
    if (execution) return "started";
    return "unstarted";
  }, [execution]);

  const buttonProps = useMemo(
    () => ({
      actionType: "verify_position" as const,
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

  const renderedContent = useMemo(() => {
    if (errorMessage) {
      return (
        <>
          <span className="text-sm text-foreground/70">
            Verification failed. 👎
          </span>
          <span className="text-sm font-bold">{errorMessage}</span>
        </>
      );
    }
    const status = getStatus();

    if (status === "completed") {
      return (
        <>
          <span className="text-sm text-foreground/70">
            Verification succeeded. ✅
          </span>
          <span className="text-sm font-bold">
            Congratulations! You're in the Top 100 Delegates for Season 6. Claim
            your reward and celebrate your accomplishment!
          </span>
        </>
      );
    }
    return (
      <span className="text-sm text-foreground/70">
        Click to verify your status as a Top 100 Delegate.
      </span>
    );
  }, [getStatus, errorMessage]);

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
