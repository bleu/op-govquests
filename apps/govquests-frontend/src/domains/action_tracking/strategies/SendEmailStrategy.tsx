import { Input } from "@/components/ui/Input";
import { useCallback, useMemo, useState } from "react";
import ActionButton from "../components/ActionButton";
import type { ActionType, SendEmailStatus } from "../types/actionButtonTypes";
import type { ActionStrategy, StrategyChildComponent } from "./ActionStrategy";
import { ActionContent, ActionFooter, BaseStrategy } from "./BaseStrategy";
import HtmlRender from "@/components/ui/HtmlRender";

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

  const verificationStatus = useMemo(() => {
    if (!isConnected || !isSignedIn) {
      return (
        <span className="text-destructive">
          Connect your wallet to start the quest.
        </span>
      );
    }
    if (errorMessage) {
      return <span className="font-bold">{errorMessage}</span>;
    }

    if (getStatus() === "unstarted") {
      return (
        <span className="text-foreground">
          Type your email and click to send the verification link.
        </span>
      );
    }

    if (getStatus() === "started") {
      return (
        <span className="text-foreground">
          An email has been sent to {email} with a verification link. 📧
        </span>
      );
    }

    if (getStatus() === "completed") {
      return (
        <span className="text-foreground">
          Your email has been successfully verified! ✅
        </span>
      );
    }
  }, [getStatus, errorMessage, isConnected, isSignedIn, email]);

  return (
    <ActionContent>
      <form onSubmit={() => handleStart()}>
        <div className="flex flex-col">
          <HtmlRender content={action.displayData.description} />
          <Input
            type="email"
            placeholder="Type your email"
            className="my-2 max-w-[90%] ml-1 bg-primary text-primary-foreground"
            value={
              getStatus() === "completed" ? execution?.startData?.email : email
            }
            onChange={(e) => setEmail(e.target.value)}
            disabled={
              getStatus() === "completed" || !isConnected || !isSignedIn
            }
          />
        </div>
        <ActionFooter>
          <ActionButton {...buttonProps} />
          {verificationStatus}
        </ActionFooter>
      </form>
    </ActionContent>
  );
};
