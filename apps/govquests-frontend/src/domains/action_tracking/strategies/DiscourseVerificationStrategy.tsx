import { Input } from "@/components/ui/Input";
import React, { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type {
  ActionType,
  DiscourseVerificationStatus,
} from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { BaseStrategy } from "./BaseStrategy";

export const DiscourseVerificationStrategy: ActionStrategy = (props) => {
  const [encryptedKey, setEncryptedKey] = useState<string>("");
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const getCompleteData = useCallback(
    () => ({
      discourseVerificationCompletionData: { encryptedKey },
    }),
    [encryptedKey],
  );

  return (
    <BaseStrategy
      {...props}
      errorMessage={errorMessage}
      setErrorMessage={setErrorMessage}
      getCompleteData={getCompleteData}
    >
      {(context) => (
        <DiscourseVerificationContent
          {...props}
          {...context}
          encryptedKey={encryptedKey}
          setEncryptedKey={setEncryptedKey}
        />
      )}
    </BaseStrategy>
  );
};

interface DiscourseVerificationContentProps {
  encryptedKey: string;
  setEncryptedKey: React.Dispatch<React.SetStateAction<string>>;
}

const DiscourseVerificationContent: StrategyChildComponent<
  DiscourseVerificationContentProps
> = ({
  execution,
  completeMutation,
  action,
  isConnected,
  isSignedIn,
  errorMessage,
  startMutation,
  handleComplete,
  handleStart,
  encryptedKey,
  setEncryptedKey,
}) => {
  const getStatus = useCallback((): DiscourseVerificationStatus => {
    if (execution?.status === "completed") {
      return "completed";
    }
    if (execution) {
      return "started";
    }
    return "unstarted";
  }, [execution]);

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
            <Input
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
  }, [
    completeMutation.isPending,
    execution?.startData,
    execution?.completionData,
    getStatus,
    encryptedKey,
  ]);

  const buttonProps = useMemo(() => {
    const status = getStatus();
    const baseProps = {
      actionType: action.actionType as ActionType,
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
    getStatus,
    handleStart,
    handleComplete,
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
