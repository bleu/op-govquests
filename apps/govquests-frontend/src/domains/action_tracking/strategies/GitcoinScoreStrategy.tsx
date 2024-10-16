import Button from "@/components/ui/Button";
import { cn } from "@/lib/utils";
import { useRouter } from "next/router";
import React, { useEffect } from "react";
import { useAccount, useSignMessage } from "wagmi";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";
import { ActionStrategy } from "./ActionStrategy";
const disabled = false;

export const GitcoinScoreStrategy: ActionStrategy = ({
  questId,
  action,
  execution,
}) => {
  const startMutation = useStartActionExecution();
  const completeMutation = useCompleteActionExecution(["quest", questId]);

  const {
    signMessage,
    data: signature,
    isPending: isSigning,
  } = useSignMessage();
  const { address } = useAccount();

  const handleStart = async () => {
    try {
      await startMutation.mutateAsync({
        questId,
        actionId: action.id,
        actionType: action.actionType,
      });
    } catch (error) {
      console.error("Error starting action:", error);
    }
  };

  const handleSignMessage = () => {
    if (!execution) return;
    try {
      signMessage({
        message: execution.startData.message,
      });
    } catch (error) {
      console.error("Error signing message:", error);
    }
  };

  const handleComplete = async () => {
    if (!execution || !signature) return;
    const completionData = {
      address,
      signature,
      nonce: execution.startData.nonce,
    };
    console.log("Sending completion data:", completionData);
    try {
      const result = await completeMutation.mutateAsync({
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
        gitcoinScoreCompletionData: completionData,
        readDocumentCompletionData: null,
      });
    } catch (error) {
      console.error("Error completing action:", error);
    }
  };

  // if (startMutation.isPending || completeMutation.isPending || isSigning) {
  //   return <p>Processing...</p>;
  // }

  if (startMutation.isError) {
    return <p className="text-red-500">Error: {startMutation.error.message}</p>;
  }

  if (completeMutation.isError) {
    return (
      <p className="text-red-500">Error: {completeMutation.error.message}</p>
    );
  }
  const gitcoinScore = execution?.completionData?.score;

  console.log("execution?.completionData", execution?.completionData);
  if (execution?.status === "completed") {
    return (
      <div className="text-green-500">
        <p>Action completed successfully!</p>
        <p>Your Gitcoin Score: {gitcoinScore}</p>
      </div>
    );
  }

  if (!execution) {
    return (
      <Button onClick={handleStart} className="bg-secondaryDisabled ">
        Connect passport
      </Button>
    );
  }

  <div>
    <p className="mb-4">Please sign the following message:</p>
    <Button
      onClick={handleSignMessage}
      className="w-full bg-green-500 text-white mt-4"
    >
      {isSigning ? "Signing..." : "Sign Message"}
    </Button>
  </div>;
  if (!signature) {
    return (
      <div className="flex justify-between items-center">
        <div className="flex flex-col">
          <span className="text-xl font-semibold">
            {action.displayData.title}
          </span>
          <span className="text-sm text-opacity-70">
            {action.displayData.description}
          </span>
          <p className="mb-4">Please sign the following message:</p>
          <p className="bg-gray-100 p-3 rounded mb-4 ">
            execution.startData.message: {execution?.startData?.message}
          </p>
        </div>

        <Button
          onClick={handleSignMessage}
          loading={startMutation.isPending || completeMutation.isPending}
          className={cn(
            "bg-secondary hover:bg-secondaryHover hover:text-white px-6",
            disabled &&
              "bg-secondaryDisabled text-opacity-60 cursor-not-allowed pointer-events-none",
          )}
        >
          Sign Message
        </Button>
      </div>
    );
  }
  return (
    // <Button
    //   onClick={handleComplete}
    //   className="w-full bg-purple-500 text-white mt-4"
    // >
    //   Submit Signed Message
    // </Button>
    <div className="flex justify-between items-center">
      <div className="flex flex-col">
        <span className="text-xl font-semibold">
          {action.displayData.title}
        </span>
        <span className="text-sm text-opacity-70">
          {action.displayData.description}
        </span>
      </div>

      <Button
        onClick={handleComplete}
        loading={startMutation.isPending || completeMutation.isPending}
        className={cn(
          "bg-secondary hover:bg-secondaryHover hover:text-white px-6",
          disabled &&
            "bg-secondaryDisabled text-opacity-60 cursor-not-allowed pointer-events-none",
        )}
      >
        Complete Connect passport
      </Button>
    </div>
  );
};
