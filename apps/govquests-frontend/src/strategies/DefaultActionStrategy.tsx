import { ActionStrategy } from "./ActionStrategy";
import Button from "@/components/ui/Button";

export class DefaultActionStrategy implements ActionStrategy {
  async start(
    mutation: UseMutationResult<any, Error, any, unknown>,
    action: ActionData
  ): Promise<void> {
    await mutation.mutateAsync({ actionId: action.actionId, startData: {} });
  }

  async complete(
    mutation: UseMutationResult<any, Error, any, unknown>,
    execution: ActionExecutionData,
    data: any
  ): Promise<void> {
    await mutation.mutateAsync({
      executionId: execution.id,
      nonce: execution.nonce,
      completionData: this.getCompletionData(execution, data),
    });
  }

  renderStartContent(action: ActionData): React.ReactNode {
    return <Button>Start {action.actionType}</Button>;
  }

  renderCompleteContent(execution: ActionExecutionData): React.ReactNode {
    return <Button>Complete {execution.actionType}</Button>;
  }

  getCompletionData(execution: ActionExecutionData, data: any): any {
    return { completed: true };
  }
}
