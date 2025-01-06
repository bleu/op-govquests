import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type { ActionType, EnsStatus } from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";

export const EnsStrategy: ActionStrategy = (props) => {
  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  return (
    <BaseStrategy
      {...props}
      errorMessage={errorMessage}
      setErrorMessage={setErrorMessage}
    >
      {(context) => <EnsStrategyContent {...context} {...props} />}
    </BaseStrategy>
  );
};

const EnsStrategyContent: StrategyChildComponent = ({
  execution,
  action,
  isConnected,
  isSignedIn,
  startMutation,
  completeMutation,
  handleStart,
  errorMessage,
}) => {
  const getStatus = useCallback((): EnsStatus => {
    if (execution && execution.status === "completed") return "completed";
    return "unstarted";
  }, [execution]);

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
      case "completed":
        return { ...baseProps, onClick: () => {} };
    }
  }, [
    getStatus,
    isSignedIn,
    isConnected,
    startMutation.isPending,
    completeMutation.isPending,
    action.actionType,
    handleStart,
  ]);

  const renderedContent = useMemo(() => {
    if (errorMessage) {
      return {
        message: (
          <span className="text-sm text-foreground/70">
            ENS verification failed. 😕
          </span>
        ),
        description: <span className="text-sm font-bold">{errorMessage}</span>,
      };
    }
    if (getStatus() === "completed") {
      return {
        message: (
          <span className="text-sm text-foreground/70">
            ENS verification succeeded! ✅
          </span>
        ),
        description: (
          <span className="text-sm font-bold">
            Your ENS name is {execution?.startData.domains[0].name}.
          </span>
        ),
      };
    }
    return {
      description: (
        <span className="text-sm text-foreground/70">
          {action.displayData.description}
        </span>
      ),
    };
  }, [errorMessage, getStatus, action.displayData, execution?.startData]);

  return (
    <ActionContent>
      <div className="flex flex-col">
        <span className="text-sm text-foreground/70">
          {renderedContent.description}
        </span>
      </div>
      <ActionFooter>
        <ActionButton {...buttonProps} />
        {renderedContent.message}
      </ActionFooter>
    </ActionContent>
  );
};
