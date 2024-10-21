import React, { useMemo, useState } from "react";
import { useSIWE } from "connectkit";
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
      const result = await startMutation.mutateAsync({
        questId,
        actionId: action.id,
        actionType: action.actionType,
        discourseVerificationStartData: null,
      });
      const startData =
        result?.startActionExecution?.actionExecution?.startData;
      if (startData && "verificationUrl" in startData) {
        setVerificationUrl(startData.verificationUrl);
      }
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

  const buttonProps = useMemo(() => {
    const status = getStatus();
    const baseProps = {
      actionType: "ens" as const,
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
    getStatus,
    isSignedIn,
    isConnected,
    startMutation.isPending,
    completeMutation.isPending,
    handleStart,
    handleComplete,
  ]);

  return (
    <div className="flex flex-col items-start space-y-4">
      <span className="text-xl font-semibold">{action.displayData.title}</span>
      <span className="text-sm text-foreground/70">
        {action.displayData.description}
      </span>

      {verificationUrl && (
        <div className="bg-primary p-4 rounded-md">
          <p>Please visit this URL to verify your Discourse account:</p>
          <a
            href={verificationUrl}
            target="_blank"
            rel="noopener noreferrer"
            className="text-blue-500 underline"
          >
            {verificationUrl}
          </a>
        </div>
      )}

      {getStatus() === "started" && (
        <div className="w-full">
          <input
            type="text"
            value={encryptedKey}
            onChange={(e) => setEncryptedKey(e.target.value)}
            placeholder="Enter the encrypted key"
            className="w-full p-2 border rounded"
          />
        </div>
      )}

      {errorMessage && <span className="text-red-500">{errorMessage}</span>}

      <ActionButton {...buttonProps} />

      {execution?.completionData &&
        "discourseUsername" in execution.completionData && (
          <span className="text-sm font-bold">
            Verified as: {execution.completionData.discourseUsername}
          </span>
        )}
    </div>
  );
};
