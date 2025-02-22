import HtmlRender from "@/components/ui/HtmlRender";
import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import { ActionType, VerifyWalletStatus } from "../types/actionButtonTypes";
import { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";

export const DefaultStrategy: ActionStrategy = (props) => {
  const [errorMessage, setErrorMessage] = useState<string>();

  return (
    <BaseStrategy
      {...props}
      errorMessage={errorMessage}
      setErrorMessage={setErrorMessage}
    >
      {(context) => <DefaultContent {...props} {...context} />}
    </BaseStrategy>
  );
};

const DefaultContent: StrategyChildComponent = ({
  handleStart,
  startMutation,
  completeMutation,
  isSignedIn,
  isConnected,
  errorMessage,
  execution,
  action,
}) => {
  const getStatus = useCallback((): VerifyWalletStatus => {
    if (execution?.status === "completed") return "completed";
    return "unstarted";
  }, [execution]);

  const buttonProps = useMemo(
    () => ({
      actionType: action.actionType as ActionType,
      status: getStatus(),
      onClick: handleStart,
      disabled: getStatus() === "completed" || !isSignedIn || !isConnected,
      loading: startMutation.isPending || completeMutation.isPending,
    }),
    [
      getStatus,
      handleStart,
      isSignedIn,
      isConnected,
      startMutation.isPending,
      completeMutation.isPending,
      action.actionType,
    ],
  );
  return (
    <ActionContent>
      <div className="text-sm">
        <HtmlRender content={action.displayData.description || ""} />
      </div>
      <ActionFooter>
        <ActionButton {...buttonProps} />
        {errorMessage && (
          <span className="text-xs font-bold self-end text-destructive">
            {errorMessage}
          </span>
        )}
      </ActionFooter>
    </ActionContent>
  );
};
