import { useCallback, useMemo, useState } from "react";
import { useAccount, useSignMessage } from "wagmi";
import ActionButton from "../components/ActionButton";
import { GitcoinScoreStatus } from "../types/actionButtonTypes";
import { CompleteActionExecutionResult } from "../types/actionTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";

export const GitcoinScoreStrategy: ActionStrategy = (props) => {
  const { refetch, execution } = props;

  const { address } = useAccount();
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const {
    signMessage,
    data: signature,
    isPending: isSigning,
  } = useSignMessage();

  const handleSignMessage = useCallback(() => {
    // invariant(execution?.startData?.__typename === "GitcoinScoreStartData");

    if (!execution) return;
    try {
      signMessage({ account: address, message: execution.startData.message });
      setErrorMessage(null);
    } catch (error) {
      console.error("Error signing message:", error);
      setErrorMessage("Failed to sign the message. Please try again.");
    }
  }, [execution, signMessage]);

  const getCompleteData = useCallback(
    () => ({
      gitcoinScoreCompletionData: {
        address: address!,
        signature,
        nonce: execution.startData.nonce,
      },
    }),
    [address, signature, execution],
  );

  const onCompleteMutationSuccess = (result: CompleteActionExecutionResult) => {
    if (result?.completeActionExecution?.errors?.length) {
      setErrorMessage(result?.completeActionExecution?.errors[0]);
    } else {
      setErrorMessage(null);
      refetch();
    }
  };

  return (
    <BaseStrategy
      {...props}
      errorMessage={errorMessage}
      setErrorMessage={setErrorMessage}
      onCompleteMutationSuccess={onCompleteMutationSuccess}
      getCompleteData={getCompleteData}
    >
      {(context) => (
        <GitcoinScoreContent
          {...props}
          {...context}
          signature={signature}
          isSigning={isSigning}
          handleSignMessage={handleSignMessage}
        />
      )}
    </BaseStrategy>
  );
};

interface GitcoinScoreContentProps {
  signature: string | null;
  isSigning: boolean;
  handleSignMessage: () => void;
}

const GitcoinScoreContent: StrategyChildComponent<GitcoinScoreContentProps> = ({
  execution,
  action,
  startMutation,
  completeMutation,
  handleComplete,
  handleStart,
  isConnected,
  isSignedIn,
  errorMessage,
  signature,
  isSigning,
  handleSignMessage,
}) => {
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

  const verificationStatus = useMemo(() => {
    if (!isConnected || !isSignedIn) {
      return (
        <span className="text-red-500">
          Connect your wallet to start the quest.
        </span>
      );
    }
    if (errorMessage) {
      return (
        <span className="text-red-500">
          Verification failed. Sorry, you look like a bot. 🤖
        </span>
      );
    }
    const status = getStatus();
    if (status === "completed") {
      // invariant(
      //   execution?.completionData?.__typename === "GitcoinScoreCompletionData",
      // );

      return (
        <span className="text-foreground/70">
          Verification succeeded! Seems like you're human. ✅
        </span>
      );
    } else if (status === "unstarted") {
      return (
        <span className="text-foreground/70">
          Connect your passport to start.
        </span>
      );
    }
  }, [
    errorMessage,
    getStatus,
    execution?.completionData,
    action.displayData.description,
    isConnected,
    isSignedIn,
  ]);

  return (
    <ActionContent>
      <div className="flex flex-col">
        <span className="text-sm text-foreground/70">
          {action.displayData.description}
        </span>
      </div>
      <ActionFooter>
        <ActionButton {...buttonProps} />
        {verificationStatus}
      </ActionFooter>
    </ActionContent>
  );
};
