import { useSIWE } from "connectkit";
import React, { useCallback, useMemo, useState } from "react";
import { useAccount, useSignMessage } from "wagmi";
import ActionButton from "../components/ActionButton";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import { GitcoinScoreStatus } from "../types/actionButtonTypes";
import type { ActionStrategy } from "./ActionStrategy";
import invariant from "tiny-invariant";

export const GitcoinScoreStrategy: ActionStrategy = ({
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

  const {
    signMessage,
    data: signature,
    isPending: isSigning,
  } = useSignMessage();

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
      setErrorMessage("Failed to start the action. Please try again.");
    }
  }, [startMutation, questId, action.id, action.actionType, refetch]);

  const handleSignMessage = useCallback(() => {
    invariant(execution?.startData?.__typename === "GitcoinScoreStartData");

    if (!execution) return;
    try {
      signMessage({ message: execution.startData.message });
      setErrorMessage(null);
    } catch (error) {
      console.error("Error signing message:", error);
      setErrorMessage("Failed to sign the message. Please try again.");
    }
  }, [execution, signMessage]);

  const handleComplete = useCallback(async () => {
    invariant(execution?.startData?.__typename === "GitcoinScoreStartData");

    if (!execution || !signature) return;
    const completionData = {
      address: address!,
      signature,
      nonce: execution.startData.nonce,
    };

    try {
      const result = await completeMutation.mutateAsync({
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
        gitcoinScoreCompletionData: completionData,
      });

      if (result?.completeActionExecution?.errors?.length) {
        setErrorMessage(result?.completeActionExecution?.errors[0]);
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
  }, [
    execution,
    signature,
    address,
    completeMutation,
    action.actionType,
    refetch,
  ]);

  const getStatus = useCallback((): GitcoinScoreStatus => {
    if (!execution || execution.status === "unstarted") return "unstarted";
    if (execution.status === "started" && !signature) return "started";
    if (execution.status === "started" && signature) return "verify";
    return "completed";
  }, [execution, signature]);

  const buttonProps = useMemo(() => {
    const status = getStatus();
    const baseProps = {
      actionType: "gitcoin_score" as const,
      status,
      disabled: !isSignedIn || !isConnected || status === "completed",
      loading:
        startMutation.isPending || completeMutation.isPending || isSigning,
    };

    switch (status) {
      case "unstarted":
        return { ...baseProps, onClick: handleStart };
      case "started":
        return { ...baseProps, onClick: handleSignMessage };
      case "verify":
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
    isSigning,
    handleStart,
    handleSignMessage,
    handleComplete,
  ]);

  const renderedContent = useMemo(() => {
    if (errorMessage) {
      return (
        <>
          <span className="text-sm text-foreground/70">
            Verification failed. Sorry, you look like a bot. 🤖
          </span>
          <span className="text-sm font-bold">{errorMessage}</span>
        </>
      );
    }
    if (getStatus() === "completed") {
      invariant(
        execution?.completionData?.__typename === "GitcoinScoreCompletionData",
      );

      return (
        <>
          <span className="text-sm text-foreground/70">
            Verification succeeded! Seems like you're human. ✅
          </span>
          <span className="text-sm font-bold">
            Your Unique Humanity Score is currently{" "}
            {execution?.completionData.score}.
          </span>
        </>
      );
    }
    return (
      <span className="text-sm text-foreground/70">
        {action.displayData.description}
      </span>
    );
  }, [
    errorMessage,
    getStatus,
    execution?.completionData,
    action.displayData.description,
  ]);

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
