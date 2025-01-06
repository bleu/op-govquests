import HtmlRender from "@/components/ui/HtmlRender";
import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import { ActionType, VerifyWalletStatus } from "../types/actionButtonTypes";
import { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { BaseStrategy } from "./BaseStrategy";
import {
  Accordion,
  AccordionContent,
  AccordionTrigger,
} from "@/components/ui/accordion";
import { AccordionItem } from "@radix-ui/react-accordion";

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
    <div className="flex flex-col justify-between items-start gap-10">
      <div className="flex flex-col text-sm font-normal">
        <HtmlRender content={action.displayData.description || ""} />
        {errorMessage && (
          <span className="text-sm font-bold">{errorMessage}</span>
        )}
      </div>
      <ActionButton {...buttonProps} className="self-end" />
    </div>
  );
};
