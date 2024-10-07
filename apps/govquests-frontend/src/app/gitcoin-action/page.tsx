"use client";
import api from "@/lib/api";
import { useMutation } from "@tanstack/react-query";
import { useState } from "react";
import { useAccount, useSignMessage } from "wagmi";

type ApiSuccessResponse = {
  execution_id: string;
  action_type: string;
  completion_data: Record<string, unknown>;
  nonce: string;
  start_data: {
    step: number;
    nonce: string;
    state: string;
    message: string;
    stepCount: number;
  };
};

type ApiErrorResponse = {
  status: "error";
  error: {
    message: string;
  };
};

type ApiResponse = ApiSuccessResponse | ApiErrorResponse;

export default function Page() {
  const startMutation = useMutation({
    mutationFn: async () => {
      return await api<ApiResponse>(
        "/action_executions/54d24d70-1c89-4a0a-88ad-e24a1926a2f3/start",
        {
          method: "POST",
        }
      );
    },
  });

  const submitMutation = useMutation({
    mutationFn: async (data: {
      execution_id: string;
      nonce: string;
      completion_data: { nonce: string; address: string; signature: string };
    }) => {
      return await api<ApiResponse>(
        "/action_executions/54d24d70-1c89-4a0a-88ad-e24a1926a2f3/complete",
        {
          method: "POST",
          body: data,
        }
      );
    },
  });

  const { signMessage, data: signature } = useSignMessage();
  const { address } = useAccount();

  const handleStart = () => {
    startMutation.mutate();
  };

  const handleSign = () => {
    if (startMutation.isError || !startMutation.data) return;
    signMessage({
      message: startMutation.data.start_data.message,
    });
  };

  const handleSubmit = () => {
    console.log(startMutation.data);
    if (!signature || !address || !startMutation.data) return;
    submitMutation.mutate({
      execution_id: startMutation.data?.execution_id,
      nonce: startMutation.data.nonce,
      completion_data: {
        address,
        signature,
        nonce: startMutation.data.start_data.nonce,
      },
    });
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

  if (submitMutation.isSuccess) {
    return (
      <div>
        Passport submitted successfully:{" "}
        {submitMutation.data.completion_data.message}
      </div>
    );
  }

  return (
    <div>
      {!startMutation.data && (
        <button
          type="button"
          className="p-2 bg-blue-200 mr-2"
          onClick={handleStart}
        >
          Start Action
        </button>
      )}
      {startMutation.data && (
        <div>
          <div>Action Type: {startMutation.data.action_type}</div>
          <div>Execution ID: {startMutation.data.execution_id}</div>
          <div>
            Step: {startMutation.data.start_data.step + 1} of{" "}
            {startMutation.data.start_data.stepCount}
          </div>
          <div>State: {startMutation.data.start_data.state}</div>
          <div>Message to sign: {startMutation.data.start_data.message}</div>
          {!signature ? (
            <button
              type="button"
              className="p-2 bg-green-200 mt-2"
              onClick={handleSign}
            >
              Sign Message
            </button>
          ) : (
            <button
              type="button"
              className="p-2 bg-yellow-200 mt-2"
              onClick={handleSubmit}
            >
              Submit Signed Message
            </button>
          )}
        </div>
      )}
    </div>
  );
}
