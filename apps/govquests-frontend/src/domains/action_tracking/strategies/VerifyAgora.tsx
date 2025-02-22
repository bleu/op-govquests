import HtmlRender from "@/components/ui/HtmlRender";
import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type {
  ActionType,
  VerifyWalletStatus,
} from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";

export const VerifyAgora: ActionStrategy = (props) => {
  const [errorMessage, setErrorMessage] = useState<string>();

  return (
    <BaseStrategy
      {...props}
      errorMessage={errorMessage}
      setErrorMessage={setErrorMessage}
    >
      {(context) => <VerifyAgoraChild {...context} {...props} />}
    </BaseStrategy>
  );
};

const VerifyAgoraChild: StrategyChildComponent = ({
  handleStart,
  isConnected,
  isSignedIn,
  startMutation,
  completeMutation,
  errorMessage,
  action,
  execution,
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

  const verificationStatus = useMemo(() => {
    if (!isConnected || !isSignedIn) {
      return (
        <span className="text-destructive">
          Connect your wallet to start the quest.
        </span>
      );
    }
    if (errorMessage) {
      return <span className="font-bold text-destructive">{errorMessage}</span>;
    }
  }, [errorMessage, isConnected, isSignedIn]);

  return (
    <ActionContent>
      <HtmlRender content={action.displayData.description || ""} />
      <ActionFooter>
        <ActionButton {...buttonProps} />
        {verificationStatus}
      </ActionFooter>
    </ActionContent>
  );
};
