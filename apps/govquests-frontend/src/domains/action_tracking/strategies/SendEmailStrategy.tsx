import { Input } from "@/components/ui/Input";
import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type { ActionType, SendEmailStatus } from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { BaseStrategy } from "./BaseStrategy";

export const SendEmailStrategy: ActionStrategy = (props) => {
  const [email, setEmail] = useState<string>("");

  const [errorMessage, setErrorMessage] = useState<string>();

  const getStartData = useCallback(
    () => ({
      sendEmailVerificationInput: { email: email.trim() },
    }),
    [email],
  );

  return (
    <BaseStrategy
      {...props}
      getStartData={getStartData}
      errorMessage={errorMessage}
      setErrorMessage={setErrorMessage}
    >
      {(context) => (
        <SendEmailContent
          {...context}
          {...props}
          email={email}
          setEmail={setEmail}
        />
      )}
    </BaseStrategy>
  );
};

interface SendEmailContentProps {
  email: string;
  setEmail: React.Dispatch<React.SetStateAction<string>>;
}

const SendEmailContent: StrategyChildComponent<SendEmailContentProps> = ({
  handleStart,
  isConnected,
  isSignedIn,
  startMutation,
  errorMessage,
  email,
  setEmail,
  execution,
  action,
}) => {
  const getStatus = useCallback((): SendEmailStatus => {
    if (execution?.status === "completed") return "completed";
    if (execution?.status === "started") return "started";
    return "unstarted";
  }, [execution]);

  const buttonProps = useMemo(
    () => ({
      actionType: action.actionType as ActionType,
      status: getStatus(),
      onClick: handleStart,
      disabled:
        getStatus() === "completed" ||
        getStatus() === "started" ||
        !isSignedIn ||
        !isConnected ||
        !email,
      loading: startMutation.isPending,
    }),
    [
      getStatus,
      handleStart,
      isSignedIn,
      isConnected,
      startMutation.isPending,
      action.actionType,
      email,
    ],
  );

  const renderedContent = useMemo(() => {
    if (errorMessage) {
      return <span className="text-sm font-bold">{errorMessage}</span>;
    }

    if (getStatus() === "started") {
      return (
        <span className="text-sm text-foreground/70">
          An email has been sent to {email} with a verification link. 📧
        </span>
      );
    }

    if (getStatus() === "completed") {
      return (
        <span className="text-sm text-foreground/70">
          Your email has been successfully verified! ✅
        </span>
      );
    }
  }, [getStatus, errorMessage]);

  return (
    <div className="flex flex-1 justify-between items-center">
      <div className="flex flex-col">
        <span className="text-xl font-semibold mb-1">
          {action.displayData.title}
        </span>
        <span className="text-sm text-foreground/70">
          {action.displayData.description}
        </span>
        <Input
          type="email"
          className="my-2 max-w-[90%]"
          value={
            getStatus() === "completed" ? execution?.startData?.email : email
          }
          onChange={(e) => setEmail(e.target.value)}
          disabled={getStatus() === "completed"}
        />
        {renderedContent}
      </div>
      <ActionButton {...buttonProps} />
    </div>
  );
};
