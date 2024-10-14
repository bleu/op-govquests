import Button from "@/components/ui/Button";
import SignInButton from "@/domains/authentication/components/SignInButton";
import { cn } from "@/lib/utils";
import type React from "react";

interface QuestButtonProps {
  status: "unstarted" | "started" | "completed";
  isSignedIn: boolean;
  onClaim: () => void;
}

const QuestButton: React.FC<QuestButtonProps> = ({
  status,
  isSignedIn,
  onClaim,
}) => {
  const getButtonConfig = () => {
    switch (status) {
      case "completed":
        return {
          text: "Claim Rewards",
          action: onClaim,
          disabled: false,
        };
      default:
        return {
          text: "Read the texts to claim",
          action: () => {},
          disabled: true,
        };
    }
  };

  const { text, action, disabled } = getButtonConfig();

  if (!isSignedIn) {
    return (
      <SignInButton className="self-center mt-6 py-3 px-24 bg-secondaryHover text-white hover:bg-secondaryDisabled font-medium rounded-lg" />
    );
  }

  return (
    <Button
      onClick={action}
      size="lg"
      className={cn(
        "self-center mt-6 px-24 bg-secondaryHover text-white hover:bg-secondaryDisabled font-medium rounded-lg",
        disabled &&
          "bg-secondaryDisabled text-foreground/60 cursor-not-allowed",
      )}
      disabled={disabled}
    >
      {text}
    </Button>
  );
};

export default QuestButton;
