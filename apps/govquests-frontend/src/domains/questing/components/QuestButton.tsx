import Button from "@/components/ui/Button";
import SignInButton from "@/domains/authentication/components/SignInButton";
import { cn } from "@/lib/utils";
import type React from "react";
import { useMemo } from "react";

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
  const { text, action, disabled } = useMemo(() => {
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
  }, [status, onClaim]);

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
        "self-center mt-6 px-24 bg-secondary text-secondary-foreground hover:bg-secondary/70 font-medium rounded-lg",
        disabled &&
          "bg-secondary/50 text-secondary-foreground/60 cursor-not-allowed",
      )}
      disabled={disabled}
    >
      {text}
    </Button>
  );
};

export default QuestButton;
