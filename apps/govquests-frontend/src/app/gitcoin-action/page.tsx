// src/app/gitcoin-action/page.tsx
"use client";
import { useMutation } from "@tanstack/react-query";
import { useAccount, useSignMessage } from "wagmi";
import { graphql } from "gql.tada";
import request from "graphql-request";
import Button from "@/components/ui/Button";
import { useState } from "react";

const START_ACTION_EXECUTION = graphql(`
  mutation StartActionExecution($actionId: ID!, $startData: JSON) {
    startActionExecution(
      input: { actionId: $actionId, startData: $startData }
    ) {
      actionExecution {
        id
        actionId
        userId
        actionType
        startData
        status
        nonce
        startedAt
      }
      errors
    }
  }
`);

const COMPLETE_ACTION_EXECUTION = graphql(`
  mutation CompleteActionExecution(
    $executionId: ID!
    $nonce: String!
    $completionData: JSON
  ) {
    completeActionExecution(
      input: {
        executionId: $executionId
        nonce: $nonce
        completionData: $completionData
      }
    ) {
      actionExecution {
        id
        actionId
        userId
        actionType
        startData
        completionData
        status
        nonce
        startedAt
        completedAt
      }
      errors
    }
  }
`);

export default function GitcoinActionPage() {
  const [step, setStep] = useState<"start" | "sign" | "submit" | "complete">(
    "start"
  );

  const startMutation = useMutation({
    mutationFn: async () => {
      return await request(
        "http://localhost:3001/graphql",
        START_ACTION_EXECUTION,
        {
          actionId: "54d24d70-1c89-4a0a-88ad-e24a1926a2f3",
          startData: {},
        }
      );
    },
  });

  const submitMutation = useMutation({
    mutationFn: async (data: {
      executionId: string;
      nonce: string;
      completionData: { nonce: string; address: string; signature: string };
    }) => {
      return await request(
        "http://localhost:3001/graphql",
        COMPLETE_ACTION_EXECUTION,
        data
      );
    },
  });

  const { signMessage, data: signature } = useSignMessage();
  const { address } = useAccount();

  const handleStart = () => {
    startMutation.mutate(undefined, {
      onSuccess: () => setStep("sign"),
    });
  };

  const handleSign = () => {
    if (
      startMutation.isError ||
      !startMutation.data?.startActionExecution?.actionExecution
    )
      return;
    signMessage({
      message:
        startMutation.data.startActionExecution.actionExecution.startData
          .message,
    });
    setStep("submit");
  };

  const handleSubmit = () => {
    if (
      !signature ||
      !address ||
      !startMutation.data?.startActionExecution?.actionExecution
    )
      return;
    submitMutation.mutate(
      {
        executionId: startMutation.data.startActionExecution.actionExecution.id,
        nonce: startMutation.data.startActionExecution.actionExecution.nonce,
        completionData: {
          address,
          signature,
          nonce:
            startMutation.data.startActionExecution.actionExecution.startData
              .nonce,
        },
      },
      {
        onSuccess: () => setStep("complete"),
      }
    );
  };

  if (startMutation.isPending) {
    return <div>Starting action...</div>;
  }

  if (startMutation.isError) {
    return <div>Error starting action: {startMutation.error.message}</div>;
  }

  if (submitMutation.isPending) {
    return <div>Submitting passport...</div>;
  }

  if (step === "complete" && submitMutation.isSuccess) {
    return (
      <div>
        Passport submitted successfully:{" "}
        {
          submitMutation.data.completeActionExecution.actionExecution
            .completionData.message
        }
      </div>
    );
  }

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      <div className="bg-white p-8 rounded-lg shadow-md max-w-md w-full">
        <h1 className="text-2xl font-bold mb-6 text-center">
          Gitcoin Passport Verification
        </h1>

        {step === "start" && (
          <Button
            onClick={handleStart}
            className="w-full bg-blue-500 text-white"
          >
            Start Verification
          </Button>
        )}

        {step === "sign" &&
          startMutation.data?.startActionExecution?.actionExecution && (
            <div>
              <p className="mb-4">Please sign the following message:</p>
              <pre className="bg-gray-100 p-3 rounded mb-4 overflow-x-auto">
                {
                  startMutation.data.startActionExecution.actionExecution
                    .startData.message
                }
              </pre>
              <Button
                onClick={handleSign}
                className="w-full bg-green-500 text-white"
              >
                Sign Message
              </Button>
            </div>
          )}

        {step === "submit" && (
          <Button
            onClick={handleSubmit}
            className="w-full bg-purple-500 text-white"
            disabled={!signature}
          >
            Submit Signed Message
          </Button>
        )}

        {startMutation.data?.startActionExecution?.actionExecution && (
          <div className="mt-6 text-sm text-gray-600">
            <p>
              Action Type:{" "}
              {
                startMutation.data.startActionExecution.actionExecution
                  .actionType
              }
            </p>
            <p>
              Execution ID:{" "}
              {startMutation.data.startActionExecution.actionExecution.id}
            </p>
          </div>
        )}
      </div>
    </div>
  );
}
