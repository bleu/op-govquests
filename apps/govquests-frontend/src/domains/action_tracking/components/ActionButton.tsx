import Button from "@/components/ui/Button";
import { cn } from "@/lib/utils";
import { CheckIcon, CheckSquareIcon, ExternalLinkIcon } from "lucide-react";
import React from "react";

type ReadActionStatus = "unStarted" | "started" | "completed";

type ReadActionButtonProps = {
  status: ReadActionStatus;
  disabled?: boolean;
  loading?: boolean;
  onClick: () => void;
};

const statusConfig: Record<
  ReadActionStatus,
  { label: string; icon: React.ReactNode }
> = {
  unStarted: {
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
};

const ReadActionButton: React.FC<ReadActionButtonProps> = ({
  status,
  disabled = false,
  loading = false,
  onClick,
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
      disabled={disabled}
      loading={loading}
    >
      <span className="flex items-center">
        {label}
        {icon}
      </span>
    </Button>
  );
};

export default ReadActionButton;
