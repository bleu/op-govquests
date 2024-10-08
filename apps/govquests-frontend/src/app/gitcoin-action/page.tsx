// src/app/gitcoin-action/page.tsx
"use client";
import { useAccount, useSignMessage } from "wagmi";
import Button from "@/components/ui/Button";
import { useActionHandler } from "@/hooks/useActionHandler";
import { useActionExecutionWithStore } from "@/stores/actionExecutionStore";
import { ActionComponentFactory } from "@/components/ActionComponentFactory";
import { ActionData } from "@/types/actionExecution";
import { useState, useEffect } from "react";

const GITCOIN_ACTION_ID = "54d24d70-1c89-4a0a-88ad-e24a1926a2f3";

const gitcoinAction: ActionData = {
  actionId: GITCOIN_ACTION_ID,
  actionType: "gitcoin_score",
  actionData: {},
  displayData: { content: "Complete Gitcoin Passport verification" },
};

export default function GitcoinActionPage() {
  const { address } = useAccount();
  const { signMessage, data: signature } = useSignMessage();
  const [debugInfo, setDebugInfo] = useState<string>("");

  const { currentExecution, startAction, completeAction } =
    useActionExecutionWithStore();
  const { isCompleted, handleStart, handleComplete } =
    useActionHandler(gitcoinAction);

  useEffect(() => {
    setDebugInfo(
      JSON.stringify(
        { currentExecution, isCompleted, address, signature },
        null,
        2
      )
    );
  }, [currentExecution, isCompleted, address, signature]);

  const handleSign = async () => {
    if (!currentExecution) return;
    await signMessage({ message: currentExecution.startData.message });
  };

  const handleSubmit = () => {
    if (!signature || !address || !currentExecution) return;
    handleComplete({
      address,
      signature,
      nonce: currentExecution.startData.nonce,
    });
  };

  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100">
      <div className="bg-white p-8 rounded-lg shadow-md max-w-md w-full">
        <h1 className="text-2xl font-bold mb-6 text-center">
          Gitcoin Passport Verification
        </h1>

        {!currentExecution && !isCompleted && (
          <Button
            onClick={handleStart}
            className="w-full bg-blue-500 text-white"
          >
            Start Verification
          </Button>
        )}

        {currentExecution && !signature && (
          <div>
            <p className="mb-4">Please sign the following message:</p>
            <pre className="bg-gray-100 p-3 rounded mb-4 overflow-x-auto">
              {currentExecution.startData.message}
            </pre>
            <Button
              onClick={handleSign}
              className="w-full bg-green-500 text-white mt-4"
            >
              Sign Message
            </Button>
          </div>
        )}

        {currentExecution && signature && (
          <Button
            onClick={handleSubmit}
            className="w-full bg-purple-500 text-white mt-4"
          >
            Submit Signed Message
          </Button>
        )}

        {isCompleted && (
          <div className="mt-4 p-4 bg-green-100 rounded">
            <p className="text-green-700">Passport submitted successfully!</p>
          </div>
        )}

        {currentExecution && (
          <div className="mt-6 text-sm text-gray-600">
            <p>Action Type: {currentExecution.actionType}</p>
            <p>Execution ID: {currentExecution.id}</p>
          </div>
        )}

        <div className="mt-8">
          <h2 className="text-lg font-semibold mb-2">Debug Information:</h2>
          <pre className="bg-gray-100 p-4 rounded overflow-x-auto text-xs">
            {debugInfo}
          </pre>
        </div>
      </div>
    </div>
  );
}
