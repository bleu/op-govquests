import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type { ReadDocumentStatus } from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";

export const ReadDocumentStrategy: ActionStrategy = (props) => {
  const { refetch, action } = props;

  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const onStartMutationSuccess = () => {
    window.open(action.actionData.documentUrl, "_blank");
    refetch();
  };

  return (
    <BaseStrategy
      {...props}
      onStartMutationSuccess={onStartMutationSuccess}
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
    if (execution) return "started";
    return "unstarted";
  }, [execution]);

  const buttonProps = useMemo(
    () => ({
      actionType: "read_document" as const,
      status: getStatus(),
      onClick: getStatus() === "unstarted" ? handleStart : handleComplete,
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
        <span className="text-red-500">
          Connect your wallet to start the quest.
        </span>
      );
    }
  }, [isConnected, isSignedIn]);

  const handleTitleClick = () => {
    if (getStatus() === "unstarted") {
      handleStart();
    } else {
      window.open(action.actionData.documentUrl, "_blank");
    }
  };

  return (
    <ActionContent>
      <span
        className="font-normal hover:cursor-pointer"
        onClick={handleTitleClick}
      >
        Read {action.displayData.title}
      </span>
      <ActionFooter>
        <ActionButton {...buttonProps} />
        {verificationStatus}
      </ActionFooter>
    </ActionContent>
  );
};
