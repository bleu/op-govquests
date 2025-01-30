"use client";

import { Button } from "@/components/ui/Button";
import { ConnectKitButton, useSIWE } from "connectkit";
import Link from "next/link";

export const BeginYourJourney: React.FC = () => {
  const { isSignedIn } = useSIWE();

  return (
    <ConnectKitButton.Custom>
      {({ show, isConnected }) => {
        if (isConnected && isSignedIn)
          return (
            <Button asChild>
              <Link href="/quests">Begin your journey</Link>
            </Button>
          );
        else return <Button onClick={show}>Begin your journey</Button>;
      }}
    </ConnectKitButton.Custom>
  );
};
