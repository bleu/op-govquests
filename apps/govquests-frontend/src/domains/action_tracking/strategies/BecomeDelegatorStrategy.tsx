import HtmlRender from "@/components/ui/HtmlRender";
import { useSIWE } from "connectkit";
import React, { useCallback, useMemo, useState } from "react";
import { useAccount } from "wagmi";
import ActionButton from "../components/ActionButton";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import type {
  ActionType,
  VerifyWalletStatus,
} from "../types/actionButtonTypes";
import type { ActionStrategy } from "./ActionStrategy";

export const BecomeDelegatorStrategy: ActionStrategy = ({
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

  const getStatus = useCallback((): VerifyWalletStatus => {
    if (execution?.status === "completed") return "completed";
    return "unstarted";
  }, [execution]);

  const buttonProps = useMemo(
    () => ({
      actionType: action.actionType as ActionType,
      status: getStatus(),
      onClick: handleStart,
      disabled: getStatus() === "completed" || !isSignedIn || !isConnected,
      loading: startMutation.isPending || completeMutation.isPending,
    }),
    [
      getStatus,
      handleStart,
      isSignedIn,
      isConnected,
      startMutation.isPending,
      completeMutation.isPending,
      action.actionType,
    ],
  );

  return (
    <div className="flex flex-1 justify-between items-center">
      <div className="flex flex-col">
        <span className="text-xl font-semibold mb-1">
          {action.displayData.title}
        </span>

        <HtmlRender content={action.displayData.description || ""} />
        {errorMessage && (
          <span className="text-sm font-bold">{errorMessage}</span>
        )}
      </div>
      <ActionButton {...buttonProps} />
    </div>
  );
};
