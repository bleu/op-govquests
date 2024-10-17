import { useQueryClient } from "@tanstack/react-query";
import { useSIWE } from "connectkit";
import React, { useCallback, useEffect, useMemo, useState } from "react";
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
  const [error, setError] = useState<string | null>(null);

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
    } catch (error) {
      console.error("Error starting action:", error);
    }
  }, [startMutation, questId, action.id, action.actionType, refetch]);

  const handleSignMessage = useCallback(() => {
    if (!execution) return;
    try {
      signMessage({
        message: execution.startData.message,
      });
    } catch (error) {
      console.error("Error signing message:", error);
    }
  }, [execution, signMessage]);
  console.log(signature);

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

      if (
        result.completeActionExecution &&
        (result.completeActionExecution.errors ?? []).length > 0
      ) {
        throw new Error(result.completeActionExecution.errors[0]);
      }

      setError(null);
    } catch (error) {
      console.error("Error completing action:", error);
      setError(
        error instanceof Error ? error.message : "An unknown error occurred",
      );
    }
  }, [execution, signature, address, completeMutation, action.actionType]);

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

  if (startMutation.isError) {
    return <p className="text-red-500">Error: {startMutation.error.message}</p>;
  }

  if (completeMutation.isError) {
    return (
      <p className="text-red-500">Error: {completeMutation.error.message}</p>
    );
  }
  console.log(execution?.completionData);
  return (
    <div className="flex justify-between items-center">
      <div className="flex flex-col">
        <span className="text-xl font-semibold">
          {action.displayData.title}
        </span>
        <span className="text-sm text-opacity-70">
          {execution?.status === "completed"
            ? "Verification succeeded! Seems like you're human. ✅"
            : action.displayData.description}
        </span>
        {execution?.status === "completed" && (
          <span className="text-sm font-bold">
            Your Unique Humanity Score is {execution.completionData.score}. The
            minimum is {execution.completionData.minimumPassingScore}.
          </span>
        )}
      </div>
      <ActionButton
        {...buttonProps}
        loading={
          startMutation.isPending || completeMutation.isPending || isSigning
        }
        disabled={!isSignedIn || !isConnected}
      />
    </div>
  );
};
