import HtmlRender from "@/components/ui/HtmlRender";
import { useCallback, useMemo } from "react";
import ActionButton from "../components/ActionButton";
import { ActionType, VerifyWalletStatus } from "../types/actionButtonTypes";
import { ActionStrategy } from "./ActionStrategy";
import { BaseStrategy } from "./BaseStrategy";

export const DefaultStrategy: ActionStrategy = (props) => {
  const { action, execution } = props;

  const getStatus = useCallback((): VerifyWalletStatus => {
    if (execution?.status === "completed") return "completed";
    return "unstarted";
  }, [execution]);

  return (
    <BaseStrategy {...props}>
      {({
        handleStart,
        startMutation,
        completeMutation,
        isSignedIn,
        isConnected,
        errorMessage,
      }) => {
        const buttonProps = useMemo(
          () => ({
            actionType: action.actionType as ActionType,
            status: getStatus(),
            onClick: handleStart,
            disabled:
              getStatus() === "completed" || !isSignedIn || !isConnected,
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
          <div className="flex flex-1 justify-between items-center">
            <div className="flex flex-col">
              <span className="text-xl font-semibold mb-1">
                {action.displayData.title}
              </span>

              <HtmlRender content={action.displayData.description || ""} />
              {errorMessage && (
                <span className="text-sm font-bold">{errorMessage}</span>
              )}
            </div>
            <ActionButton {...buttonProps} />
          </div>
        );
      }}
    </BaseStrategy>
  );
};
