import { useSIWE } from "connectkit";
import React, { useMemo, useState } from "react";
import { useAccount } from "wagmi";
import ActionButton from "../components/ActionButton";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import type { ActionStrategy } from "./ActionStrategy";

export const DiscourseVerificationStrategy: ActionStrategy = ({
  questId,
  action,
  execution,
  refetch,
}) => {
  const { isSignedIn } = useSIWE();
  const { isConnected } = useAccount();
  const startMutation = useStartActionExecution();
  const completeMutation = useCompleteActionExecution(["quest", questId]);
  const [verificationUrl, setVerificationUrl] = useState<string | null>(null);
  const [encryptedKey, setEncryptedKey] = useState<string>("");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const handleStart = async () => {
    try {
      await startMutation.mutateAsync({
        questId,
        actionId: action.id,
        actionType: action.actionType,
        discourseVerificationStartData: null,
      });
      refetch();
      setErrorMessage(null);
    } catch (error) {
      console.error("Error starting action:", error);
      setErrorMessage("Failed to start the action. Please try again.");
    }
  };

  const handleComplete = async () => {
    if (!execution) return;
    try {
      await completeMutation.mutateAsync({
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
        discourseVerificationCompletionData: { encryptedKey },
      });
      refetch();
      setErrorMessage(null);
    } catch (error) {
      console.error("Error completing action:", error);
      setErrorMessage("Failed to complete the action. Please try again.");
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

  const renderedContent = useMemo(() => {
    if (getStatus() === "started") {
      return (
        <div className="flex flex-col">
          <div className="text-sm text-foreground/70">
            <p className="my-3">
              Please visit{" "}
              <a
                href={execution?.startData?.verificationUrl}
                target="_blank"
                rel="noopener noreferrer"
                className="text-blue-500 underline"
              >
                this
              </a>{" "}
              URL and paste the generated API Key to verify your Discourse
              account:
            </p>
          </div>
          <div className="w-full">
            <input
              type="text"
              value={encryptedKey}
              onChange={(e) => setEncryptedKey(e.target.value)}
              placeholder="Enter the encrypted key"
              className="w-full p-2 border rounded"
              disabled={
                completeMutation.isPending || getStatus() === "completed"
              }
            />
          </div>
        </div>
      );
    }
    if (
      getStatus() === "completed" &&
      execution?.completionData &&
      "discourseUsername" in execution.completionData
    ) {
      return (
        <span className="text-sm font-bold">
          Verified as: {execution.completionData.discourseUsername}
        </span>
      );
    }
  }, [getStatus, errorMessage]);

  const buttonProps = useMemo(() => {
    const status = getStatus();
    const baseProps = {
      actionType: action.actionType,
      status,
      disabled: !isSignedIn || !isConnected || status === "completed",
      loading: startMutation.isPending || completeMutation.isPending,
    };

    switch (status) {
      case "unstarted":
        return { ...baseProps, onClick: handleStart };
      case "started":
        return { ...baseProps, onClick: handleComplete };
      case "completed":
        return { ...baseProps, onClick: () => {} };
    }
  }, [
    isSignedIn,
    isConnected,
    startMutation.isPending,
    completeMutation.isPending,
    action.actionType,
  ]);

  return (
    <div className="flex flex-1  items-center">
      <div className="flex flex-col flex-1 pr-6">
        <span className="text-xl font-semibold">
          {action.displayData.title}
        </span>
        <span className="text-sm text-foreground/70">
          {action.displayData.description}
        </span>

        {renderedContent}
        {errorMessage && (
          <span className="text-sm font-bold">{errorMessage} </span>
        )}
      </div>
      <ActionButton {...buttonProps} />
    </div>
  );
};
