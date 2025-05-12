import HtmlRender from "@/components/ui/HtmlRender";
import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type {
  ActionType,
  EnableNotificationsStatus,
} from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";
import { useRouter } from "next/navigation";

export const EnableNotificationsStrategy: ActionStrategy = (props) => {
  const [errorMessage, setErrorMessage] = useState<string>();

  return (
    <BaseStrategy
      {...props}
      errorMessage={errorMessage}
      setErrorMessage={setErrorMessage}
    >
      {(context) => <EnableNotificationsContent {...props} {...context} />}
    </BaseStrategy>
  );
};

const EnableNotificationsContent: StrategyChildComponent = ({
  handleStart,
  handleComplete,
  startMutation,
  completeMutation,
  isSignedIn,
  isConnected,
  errorMessage,
  execution,
  action,
}) => {
  const getStatus = useCallback((): EnableNotificationsStatus => {
    if (execution?.status === "completed") return "completed";
    if (execution?.status === "started") return "started";
    return "unstarted";
  }, [execution]);

  const router = useRouter();

  const onClickStart = useCallback(() => {
    handleStart();
    router.push("?showNotificationSettings=true", { scroll: false });
  }, [handleStart, router]);

  const buttonProps = useMemo(
    () => ({
      actionType: action.actionType as ActionType,
      status: getStatus(),
      onClick:
        getStatus() === "unstarted"
          ? onClickStart
          : getStatus() === "started"
            ? handleComplete
            : undefined,
      disabled: getStatus() === "completed" || !isSignedIn || !isConnected,
      loading: startMutation.isPending || completeMutation.isPending,
    }),
    [
      getStatus,
      onClickStart,
      handleComplete,
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
