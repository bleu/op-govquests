import { ActionStrategy } from "./ActionStrategy";
import Button from "@/components/ui/Button";

export class GitcoinScoreStrategy implements ActionStrategy {
  async start(mutation, action) {
    await mutation.mutateAsync({ actionId: action.actionId, startData: {} });
  }

  async complete(mutation, execution, data) {
    await mutation.mutateAsync({
      executionId: execution.id,
      nonce: execution.nonce,
      completionData: this.getCompletionData(execution, data),
    });
  }

  renderStartContent(action) {
    return (
      <Button className="w-full bg-blue-500 text-white">
        Start Gitcoin Verification
      </Button>
    );
  }

  renderCompleteContent(execution) {
    return (
      <div>
        <p className="mb-4">Please sign the following message:</p>
        <pre className="bg-gray-100 p-3 rounded mb-4 overflow-x-auto">
          {execution.startData.message}
        </pre>
      </div>
    );
  }

  getCompletionData(execution, data) {
    return {
      address: data.address,
      signature: data.signature,
      nonce: execution.startData.nonce,
    };
  }
}
