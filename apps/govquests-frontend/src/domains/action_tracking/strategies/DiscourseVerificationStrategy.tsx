import { Input } from "@/components/ui/Input";
import React, { FormEvent, useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type {
  ActionType,
  DiscourseVerificationStatus,
} from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";
import HtmlRender from "@/components/ui/HtmlRender";

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
          setEncryFptedKey={setEncryptedKey}
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

  const verificationStatus = useMemo(() => {
    if (!isConnected || !isSignedIn) {
      return (
        <span className="text-destructive">
          Connect your wallet to start the quest.
        </span>
      );
    }
    if (errorMessage) {
      return <span className="text-destructive">{errorMessage}</span>;
    }
    if (
      getStatus() === "completed" &&
      execution?.completionData &&
      "discourseUsername" in execution.completionData
    ) {
      return (
        <span className="font-bold text-foreground/80">
          Verified as: {execution.completionData.discourseUsername}
        </span>
      );
    }
  }, [
    execution?.completionData,
    getStatus,
    isConnected,
    errorMessage,
    isSignedIn,
  ]);

  const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (getStatus() === "started") {
      handleComplete();
    } else if (getStatus() === "unstarted") {
      handleStart();
    }
  };

  const APIKeyComponent = useMemo(() => {
    if (getStatus() === "started")
      return (
        <div className="flex flex-col">
          <div className="text-sm text-foreground/70">
            <p className="my-3">
              Please visit{" "}
              <a
                href={
                  (execution?.startData as Record<string, string>)
                    ?.verificationUrl
                }
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
              className="w-full p-2 border rounded bg-primary text-primary-foreground"
              disabled={
                completeMutation.isPending || getStatus() === "completed"
              }
            />
          </div>
        </div>
      );
  }, [getStatus, execution?.startData, encryptedKey]);

  const buttonProps = useMemo(() => {
    const status = getStatus();
    return {
      actionType: action.actionType as ActionType,
      status,
      disabled:
        !isSignedIn ||
        !isConnected ||
        status === "completed" ||
        (status == "started" && !encryptedKey),
      loading: startMutation.isPending || completeMutation.isPending,
      onClick: handleSubmit,
    };
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
    <ActionContent>
      <form
        onSubmit={handleSubmit}
        className="flex flex-col justify-between items-start gap-8"
      >
        <div className="flex flex-col flex-1 pr-6">
          <HtmlRender content={action.displayData.description} />
          {APIKeyComponent}
        </div>
        <ActionFooter>
          <ActionButton type="submit" {...buttonProps} />
          {verificationStatus}
        </ActionFooter>
      </form>
    </ActionContent>
  );
};
