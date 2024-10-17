import Button from "@/components/ui/Button";
import { cn } from "@/lib/utils";
import { CheckIcon, CheckSquareIcon, ExternalLinkIcon } from "lucide-react";
import React from "react";

type ActionStatus = "unstarted" | "started" | "completed" | "sign" | "connect";

type ActionButtonProps = {
  status: ActionStatus;
  onClick: () => void;
  disabled?: boolean;
  loading?: boolean;
  customLabel?: string;
};

const statusConfig: Record<
  ActionStatus,
  { label: string; icon: React.ReactNode }
> = {
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
  sign: {
    label: "Sign Message",
    icon: null,
  },
  connect: {
    label: "Connect Passport",
    icon: null,
  },
};

const ActionButton: React.FC<ActionButtonProps> = ({
  status,
  onClick,
  disabled = false,
  loading = false,
  customLabel,
}) => {
  const { label, icon } = statusConfig[status];

  return (
    <Button
      className={cn(
        "bg-secondary hover:bg-secondaryHover hover:text-white px-6",
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
};

export default ActionButton;
