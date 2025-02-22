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

  const handleSubmit = (e) => {
    e.preventDefault();
    const status = getStatus();
    if (!email || !isConnected || !isSignedIn || status !== "unstarted") return;
    handleStart();
  };

  const buttonProps = useMemo(
    () => ({
      actionType: action.actionType as ActionType,
      status: getStatus(),
      disabled:
        getStatus() !== "unstarted" || !isSignedIn || !isConnected || !email,
      loading: startMutation.isPending,
      type: "submit",
    }),
    [
      getStatus,
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
      return <span className="font-bold text-destructive">{errorMessage}</span>;
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
    <ActionContent className="w-full">
      <form onSubmit={handleSubmit}>
        <div className="flex flex-col mb-2">
          <HtmlRender content={action.displayData.description} />
        </div>
        <ActionFooter className="flex flex-row align-top justify-between mr-4">
          <Input
            type="email"
            placeholder="Type your email"
            className="max-w-96 ml-1 bg-primary text-primary-foreground"
            value={
              getStatus() === "completed" ? execution?.startData?.email : email
            }
            onChange={(e) => setEmail(e.target.value)}
            disabled={
              getStatus() === "completed" || !isConnected || !isSignedIn
            }
          />
          <div className="flex flex-col gap-1 mt-1 text-end">
            <ActionButton {...buttonProps} className="w-52 self-end" />
            {verificationStatus}
          </div>
        </ActionFooter>
      </form>
    </ActionContent>
  );
};
