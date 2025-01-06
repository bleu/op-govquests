import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type { VerifyPositionStatus } from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionFooter, BaseStrategy } from "./BaseStrategy";

export const VerifyPositionStrategy: ActionStrategy = (props) => {
  const { refetch } = props;

  const [errorMessage, setErrorMessage] = useState<string | null>(null);

  const onCompleteMutationSuccess = (result) => {
    if (result.completeActionExecution?.errors.length > 0) {
      setErrorMessage(
        "You haven't reached the Top 100 Delegates ranking for Season 6. Keep contributing and aim higher next season to unlock this reward.",
      );
    } else {
      setErrorMessage(null);
    }
    refetch();
  };

  return (
    <BaseStrategy
      {...props}
      errorMessage={errorMessage}
      setErrorMessage={setErrorMessage}
      onCompleteMutationSuccess={onCompleteMutationSuccess}
      getCompleteData={() => ({ completed: true })}
    >
      {(context) => <VerifyPositionContent {...props} {...context} />}
    </BaseStrategy>
  );
};

interface VerifyPositionContentProps {}

const VerifyPositionContent: StrategyChildComponent<
  VerifyPositionContentProps
> = ({
  action,
  execution,
  handleComplete,
  handleStart,
  completeMutation,
  startMutation,
  isSignedIn,
  isConnected,
  errorMessage,
}) => {
  const getStatus = useCallback((): VerifyPositionStatus => {
    if (execution?.status === "completed") return "completed";
    if (execution) return "started";
    return "unstarted";
  }, [execution]);

  const buttonProps = useMemo(
    () => ({
      actionType: "verify_position" as const,
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

  const renderedContent = useMemo(() => {
    if (errorMessage) {
      return {
        message: (
          <span className="text-sm text-foreground/70">
            Verification failed. 👎
          </span>
        ),
        description: <span className="text-sm font-bold">{errorMessage}</span>,
      };
    }
    const status = getStatus();

    if (status === "completed") {
      return {
        message: (
          <span className="text-sm text-foreground/70">
            Verification succeeded. ✅
          </span>
        ),
        description: (
          <span className="text-sm font-bold">
            Congratulations! You're in the Top 100 Delegates for Season 6. Claim
            your reward and celebrate your accomplishment!
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
  }, [getStatus, errorMessage]);

  return (
    <div className="flex justify-between items-center">
      <span className="text-sm text-foreground/70">
        {renderedContent.description}
      </span>
      <ActionFooter>
        <ActionButton {...buttonProps} />
        {renderedContent.message}
      </ActionFooter>
    </div>
  );
};
