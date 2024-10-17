import { useQueryClient } from "@tanstack/react-query";
import { useSIWE } from "connectkit";
import React, { useCallback, useMemo, useState } from "react";
import { useAccount, useSignMessage } from "wagmi";
import ActionButton from "../components/ActionButton";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import type { ActionStrategy } from "./ActionStrategy";

export const GitcoinScoreStrategy: ActionStrategy = ({
  questId,
  action,
  execution,
  refetch,
}) => {
  const startMutation = useStartActionExecution();
  const completeMutation = useCompleteActionExecution(["quest", questId]);
  const { isSignedIn } = useSIWE();
  const { isConnected } = useAccount();
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const {
    signMessage,
    data: signature,
    isPending: isSigning,
  } = useSignMessage();
  const { address } = useAccount();

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
    if (!execution) return;
    try {
      signMessage({
        message: execution.startData.message,
      });
      setErrorMessage(null);
    } catch (error) {
      console.error("Error signing message:", error);
      setErrorMessage("Failed to sign the message. Please try again.");
    }
  }, [execution, signMessage]);

  const handleComplete = useCallback(async () => {
    if (!execution || !signature) return;
    const completionData = {
      address,
      signature,
      nonce: execution.startData.nonce,
    };

    try {
      const result = await completeMutation.mutateAsync({
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
        gitcoinScoreCompletionData: completionData,
        readDocumentCompletionData: null,
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
  }, [
    execution,
    signature,
    address,
    completeMutation,
    action.actionType,
    refetch,
  ]);

  const buttonProps = useMemo(() => {
    if (!execution || execution.status === "unstarted") {
      return {
        status: "connect" as const,
        onClick: handleStart,
        customLabel: "Connect passport",
      };
    }

    if (execution.status === "started" && !signature) {
      return {
        status: "sign" as const,
        onClick: handleSignMessage,
        customLabel: "Sign Message",
      };
    }

    if (execution.status === "started" && signature) {
      return {
        status: "started" as const,
        onClick: handleComplete,
        customLabel: "Complete Connect passport",
      };
    }

    if (execution.status === "completed") {
      return {
        status: "completed" as const,
        onClick: () => {},
        customLabel: "Connected",
        disabled: true,
      };
    }

    return {
      status: "connect" as const,
      onClick: handleStart,
      customLabel: "Connect passport",
    };
  }, [execution, signature, handleStart, handleSignMessage, handleComplete]);

  const renderedContent = useMemo(() => {
    if (errorMessage) {
      return (
        <>
          <span className="text-sm text-foreground/70">
            Verification failed. Sorry, you look like a bot. 🤖
          </span>
          <span className="text-sm  font-bold">{errorMessage}</span>
        </>
      );
    }
    if (execution?.status === "completed") {
      return (
        <>
          <span className="text-sm text-foreground/70">
            Verification succeeded! Seems like you're human. ✅
          </span>
          <span className="text-sm font-bold">
            Your Unique Humanity Score is currently{" "}
            {execution.completionData.score}.
          </span>
        </>
      );
    }
    return (
      <>
        <span className="text-sm text-foreground/70">
          {action.displayData.description}
        </span>
      </>
    );
  }, [
    errorMessage,
    execution?.status,
    execution?.completionData.score,
    action.displayData,
  ]);

  return (
    <div className="flex justify-between items-center">
      <div className="flex flex-col">
        <span className="text-xl font-semibold mb-1">
          {action.displayData.title}
        </span>
        {renderedContent}
      </div>
      <ActionButton
        {...buttonProps}
        loading={
          startMutation.isPending || completeMutation.isPending || isSigning
        }
        disabled={
          !isSignedIn || !isConnected || execution?.status === "completed"
        }
      />
    </div>
  );
};
