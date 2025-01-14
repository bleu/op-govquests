"use client";

import { Button } from "@/components/ui/Button";
import { ConnectKitButton } from "connectkit";
import Link from "next/link";

export const BeginYourJourney: React.FC = () => {
  return (
    <ConnectKitButton.Custom>
      {({ show, isConnected }) => {
        if (isConnected)
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
