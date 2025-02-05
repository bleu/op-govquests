import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type { ReadDocumentStatus } from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";
import HtmlRender from "@/components/ui/HtmlRender";

export const ReadContentInappStrategy: ActionStrategy = (props) => {
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  return (
    <BaseStrategy
      {...props}
      errorMessage={errorMessage}
      setErrorMessage={setErrorMessage}
    >
      {(context) => <ReadDocumentContent {...props} {...context} />}
    </BaseStrategy>
  );
};

const ReadDocumentContent: StrategyChildComponent = ({
  action,
  execution,
  handleComplete,
  handleStart,
  isConnected,
  isSignedIn,
  startMutation,
  completeMutation,
}) => {
  const getStatus = useCallback((): ReadDocumentStatus => {
    if (execution?.status === "completed") return "completed";
    return "unstarted";
  }, [execution]);

  const buttonProps = useMemo(
    () => ({
      actionType: "read_content_inapp" as const,
      status: getStatus(),
      onClick: handleStart,
      disabled: getStatus() === "completed" || !isSignedIn || !isConnected,
      loading: startMutation.isPending || completeMutation.isPending,
    }),
    [
      getStatus,
      handleStart,
      handleComplete,
      isSignedIn,
      isConnected,
      startMutation.isPending,
      completeMutation.isPending,
    ],
  );

  const verificationStatus = useMemo(() => {
    if (!isConnected || !isSignedIn) {
      return (
        <span className="text-destructive">
          Connect your wallet to start the quest.
        </span>
      );
    }
  }, [isConnected, isSignedIn]);

  return (
    <ActionContent>
      <HtmlRender content={action.displayData.description} />
      <ActionFooter>
        <ActionButton {...buttonProps} />
        {verificationStatus}
      </ActionFooter>
    </ActionContent>
  );
};
