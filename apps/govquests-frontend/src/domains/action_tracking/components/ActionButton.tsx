import { Button } from "@/components/ui/button";
import Spinner from "@/components/ui/Spinner";
import { cn } from "@/lib/utils";
import { CheckIcon, CheckSquareIcon, ExternalLinkIcon } from "lucide-react";
import { ComponentProps } from "react";

const ACTIONS = {
  gitcoin_score: {
    unstarted: { label: "Connect Passport" },
    started: { label: "Sign Message" },
    verify: { label: "Verify Score" },
    completed: { label: "Connected" },
  },
  read_document: {
    unstarted: { label: "Read Content", icon: ExternalLinkIcon },
    started: { label: "Mark as read", icon: CheckIcon },
    completed: { label: "Confirmed", icon: CheckSquareIcon },
  },
  verify_position: {
    unstarted: { label: "Verify Position" },
    started: { label: "Submit API Key", icon: ExternalLinkIcon },
    completed: { label: "Verified", icon: CheckSquareIcon },
  },
  discourse_verification: {
    unstarted: { label: "Get Verification URL" },
    started: { label: "Submit API Key", icon: ExternalLinkIcon },
    completed: { label: "Verified", icon: CheckSquareIcon },
  },
  verify_delegate: {
    unstarted: { label: "Verify" },
    completed: { label: "Verified", icon: CheckSquareIcon },
  },
  verify_delegate_statement: {
    unstarted: { label: "Verify" },
    completed: { label: "Verified", icon: CheckSquareIcon },
  },
  ens: {
    unstarted: { label: "Connect ENS" },
    completed: { label: "ENS Connected" },
  },
  send_email: {
    unstarted: { label: "Send" },
    started: { label: "Email sent" },
    completed: { label: "Verified e-mail" },
  },
  wallet_verification: {
    unstarted: { label: "Verify Wallet" },
    completed: { label: "Verified" },
  },
  verify_agora: {
    unstarted: { label: "Connect Agora" },
    completed: { label: "Connected" },
  },
  verify_first_vote: {
    unstarted: { label: "Confirm first vote" },
    completed: { label: "Vote confirmed" },
  },
  holds_op: {
    unstarted: { label: "Verify" },
    completed: { label: "Verified", icon: CheckSquareIcon },
  },
  become_delegator: {
    unstarted: { label: "Verify" },
    completed: { label: "Verified", icon: CheckSquareIcon },
  },
  governance_voter_participation: {
    unstarted: { label: "Verify" },
    completed: { label: "Verified", icon: CheckSquareIcon },
  },
} as const;

type ActionType = keyof typeof ACTIONS;
type ActionStatus<T extends ActionType> = keyof (typeof ACTIONS)[T];

interface ActionButtonProps<T extends ActionType>
  extends ComponentProps<"button"> {
  actionType: T;
  status: ActionStatus<T>;
  onClick: () => void;
  disabled?: boolean;
  loading?: boolean;
  customLabel?: string;
}

function ActionButton<T extends ActionType>({
  actionType,
  status,
  onClick,
  disabled = false,
  loading = false,
  customLabel,
  ...props
}: ActionButtonProps<T>) {
  const config = ACTIONS[actionType][status];
  const Icon = config.icon;

  return (
    <Button
      variant="secondary"
      size="sm"
      className={cn(
        disabled && "pointer-events-none",
        status === "completed" && "opacity-50",
      )}
      onClick={onClick}
      disabled={disabled || status === "completed" || loading}
      {...props}
    >
      {loading ? (
        <span className="flex items-center gap-2">
          <Spinner className="h-4 w-4" />
          {customLabel || config.label}
          {Icon && <Icon className="h-4 w-4" />}
        </span>
      ) : (
        <span className="flex items-center gap-2">
          {customLabel || config.label}
          {Icon && <Icon className="h-4 w-4" />}
        </span>
      )}
    </Button>
  );
}

export default ActionButton;
