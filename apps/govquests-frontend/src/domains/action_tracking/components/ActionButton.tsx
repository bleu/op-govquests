import Button from "@/components/ui/Button";
import { cn } from "@/lib/utils";
import { CheckIcon, CheckSquareIcon, ExternalLinkIcon } from "lucide-react";
import type React from "react";
import type {
  ActionType,
  EnsStatus,
  GitcoinScoreStatus,
  ReadDocumentStatus,
  SendEmailStatus,
  VerifyPositionStatus,
  VerifyWalletStatus,
} from "../types/actionButtonTypes";

type StatusConfig = {
  label: string;
  icon: React.ReactNode;
};

type ActionConfig = {
  gitcoin_score: {
    statuses: Record<GitcoinScoreStatus, StatusConfig>;
  };
  read_document: {
    statuses: Record<ReadDocumentStatus, StatusConfig>;
  };
  verify_position: {
    statuses: Record<VerifyPositionStatus, StatusConfig>;
  };
  ens: {
    statuses: Record<EnsStatus, StatusConfig>;
  };
  discourse_verification: {
    statuses: Record<VerifyPositionStatus, StatusConfig>;
  };
  send_email: {
    statuses: Record<SendEmailStatus, StatusConfig>;
  };
  wallet_verification: {
    statuses: Record<VerifyWalletStatus, StatusConfig>;
  };
};

const actionConfig: ActionConfig = {
  gitcoin_score: {
    statuses: {
      unstarted: { label: "Connect Passport", icon: null },
      started: { label: "Sign Message", icon: null },
      verify: { label: "Verify Score", icon: null },
      completed: { label: "Connected", icon: null },
    },
  },

  read_document: {
    statuses: {
      unstarted: {
        label: "Read Content",
        icon: <ExternalLinkIcon className="ml-2 w-4 h-4" />,
      },
      started: {
        label: "Mark as read",
        icon: <CheckIcon className="ml-2 w-4 h-4" />,
      },
      completed: {
        label: "Confirmed",
        icon: <CheckSquareIcon className="ml-2 w-4 h-4" />,
      },
    },
  },
  verify_position: {
    statuses: {
      unstarted: { label: "Verify Position", icon: null },
      started: {
        label: "Submit API Key",
        icon: <ExternalLinkIcon className="ml-2 w-4 h-4" />,
      },
      completed: {
        label: "Verified",
        icon: <CheckSquareIcon className="ml-2 w-4 h-4" />,
      },
    },
  },
  ens: {
    statuses: {
      unstarted: { label: "Connect ENS", icon: null },
      started: { label: "Verifying ENS", icon: null },
      completed: { label: "ENS Connected", icon: null },
    },
  },
  discourse_verification: {
    statuses: {
      unstarted: { label: "Get Verification URL", icon: null },
      started: {
        label: "Submit API Key",
        icon: <ExternalLinkIcon className="ml-2 w-4 h-4" />,
      },
      completed: {
        label: "Verified",
        icon: <CheckSquareIcon className="ml-2 w-4 h-4" />,
      },
    },
  },
  send_email: {
    statuses: {
      unstarted: { label: "Send", icon: null },
      completed: { label: "Verified e-mail", icon: null },
    },
  },
  wallet_verification: {
    statuses: {
      unstarted: { label: "Verify Wallet", icon: null },
      completed: { label: "Verified", icon: null },
    },
  },
};

type ActionButtonProps<T extends ActionType> = {
  actionType: T;
  status: keyof ActionConfig[T]["statuses"];
  onClick: () => void;
  disabled?: boolean;
  loading?: boolean;
  customLabel?: string;
};

function ActionButton<T extends ActionType>({
  actionType,
  status,
  onClick,
  disabled = false,
  loading = false,
  customLabel,
}: ActionButtonProps<T>) {
  const { label, icon } = actionConfig[actionType].statuses[status];

  return (
    <Button
      className={cn(
        "bg-secondary hover:bg-secondaryHover hover:text-white px-6 mr-6",
        disabled &&
          "bg-secondaryDisabled text-opacity-60 cursor-not-allowed pointer-events-none",
      )}
      size="sm"
      onClick={onClick}
      disabled={disabled || status === "completed"}
      loading={loading}
    >
      <span className="flex items-center">
        {customLabel || label}
        {icon}
      </span>
    </Button>
  );
}

export default ActionButton;
