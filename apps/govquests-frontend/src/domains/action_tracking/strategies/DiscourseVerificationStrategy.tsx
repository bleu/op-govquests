import { Input } from "@/components/ui/Input";
import React, { FormEvent, useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type {
  ActionType,
  DiscourseVerificationStatus,
} from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";

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

  const handleSubmit = (e: FormEvent<HTMLFormElement>) => {
    e.preventDefault();
    if (getStatus() === "started") {
      handleComplete();
    } else if (getStatus() === "unstarted") {
      handleStart();
    }
  };

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
          <span className="flex flex-col text-sm font-normal">
            {action.displayData.description}
          </span>

          {renderedContent}
          {errorMessage && (
            <span className="text-sm font-bold">{errorMessage} </span>
          )}
        </div>
        <ActionFooter>
          <ActionButton type="submit" {...buttonProps} />
          {errorMessage && (
            <span className="text-xs font-bold self-end">{errorMessage}</span>
          )}
        </ActionFooter>
      </form>
    </ActionContent>
  );
};
