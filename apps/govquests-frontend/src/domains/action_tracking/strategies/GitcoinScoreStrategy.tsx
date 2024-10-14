import React, { useEffect } from "react";
import { ActionStrategy } from "./ActionStrategy";
import Button from "@/components/ui/Button";
import { useAccount, useSignMessage } from "wagmi";
import { useRouter } from "next/router";
import { useCompleteActionExecution } from "../hooks/useCompleteActionExecution";
import { useStartActionExecution } from "../hooks/useStartActionExecution";

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
    try {
      await completeMutation.mutateAsync({
        executionId: execution.id,
        nonce: execution.nonce,
        actionType: action.actionType,
        completionData,
      });
    } catch (error) {
      console.error("Error completing action:", error);
    }
  };

  if (startMutation.isPending || completeMutation.isPending || isSigning) {
    return <p>Processing...</p>;
  }

  if (startMutation.isError) {
    return <p className="text-red-500">Error: {startMutation.error.message}</p>;
  }

  if (completeMutation.isError) {
    return (
      <p className="text-red-500">Error: {completeMutation.error.message}</p>
    );
  }

  if (execution?.status === "completed") {
    return <p className="text-green-500">Action completed successfully!</p>;
  }

  if (!execution) {
    return (
      <Button onClick={handleStart} className="w-full bg-blue-500 text-white">
        Start Gitcoin Verification
      </Button>
    );
  } else if (!signature) {
    return (
      <div>
        <p className="mb-4">Please sign the following message:</p>
        <pre className="bg-gray-100 p-3 rounded mb-4 overflow-x-auto">
          {execution.startData.message}
        </pre>
        <Button
          onClick={handleSignMessage}
          className="w-full bg-green-500 text-white mt-4"
        >
          {isSigning ? "Signing..." : "Sign Message"}
        </Button>
      </div>
    );
  } else {
    return (
      <Button
        onClick={handleComplete}
        className="w-full bg-purple-500 text-white mt-4"
      >
        Submit Signed Message
      </Button>
    );
  }
};
