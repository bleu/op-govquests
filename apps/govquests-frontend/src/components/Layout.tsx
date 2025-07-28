"use client";

import { config, siweConfig } from "@/wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";
import { ConnectKitProvider, SIWEProvider } from "connectkit";
import Image from "next/image";
import { WagmiProvider } from "wagmi";
import Footer from "./Footer";
import Header from "./Header";
import { Toaster } from "./ui/toaster";
import { useRouter } from "next/navigation";
import { useCurrentUserInfo } from "@/domains/gamification/hooks/useUserInfo";
import { useCurrentUser } from "@/domains/authentication/hooks";
import { ConfettiProvider } from "./ConfettiProvider";
import { PostHogProvider } from "./PosthogProvider";
import { OnboardingModal } from "./OnboardingModal";
import { useState, useEffect } from "react";

export const queryClient = new QueryClient();

const Providers = ({ children }: Readonly<{ children: React.ReactNode }>) => {
  const router = useRouter();

  const handleConnect = () => {
    if (window.location.pathname !== "/") return;
    router.push("/quests");
  };

  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <SIWEProvider {...siweConfig}>
          <ConnectKitProvider onConnect={handleConnect}>
            <PostHogProvider>
              <ConfettiProvider>{children}</ConfettiProvider>
            </PostHogProvider>
          </ConnectKitProvider>
        </SIWEProvider>
      </QueryClientProvider>
    </WagmiProvider>
  );
};

export default function Layout({
  children,
}: Readonly<{
  children: React.ReactNode;
}>) {
  return (
    <Providers>
      <Header />
      <BackgroundTier />
      <div className="flex-1 relative z-10 mx-auto w-full">{children}</div>
      <Footer />
      <Toaster />
      <OnboardingFlow />
    </Providers>
  );
}

const OnboardingFlow = () => {
  const { data: currentUser } = useCurrentUser();
  const [showOnboarding, setShowOnboarding] = useState(false);

  useEffect(() => {
    if (!currentUser?.currentUser?.createdAt) return;

    const createdAt = new Date(currentUser.currentUser.createdAt as string);
    const now = new Date();
    const timeDiff = now.getTime() - createdAt.getTime();
    const fiveMinutesInMs = 5 * 60 * 1000;

    const hasSeenOnboarding = localStorage.getItem("hasSeenOnboarding");

    if (timeDiff <= fiveMinutesInMs && !hasSeenOnboarding) {
      setShowOnboarding(true);
    }
  }, [currentUser]);

  const handleCloseOnboarding = () => {
    setShowOnboarding(false);
    localStorage.setItem("hasSeenOnboarding", "true");
  };

  return (
    <OnboardingModal isOpen={showOnboarding} onClose={handleCloseOnboarding} />
  );
};

const BackgroundTier = () => {
  const { data, isFetched } = useCurrentUserInfo();

  return (
    isFetched && (
      <>
        <Image
          src={
            data?.currentUser.gameProfile.tier.imageUrl ||
            "/backgrounds/OP_BLEU_TIER_01.png"
          }
          width={1000}
          height={1000}
          className="object-cover fixed size-full"
          alt="background_tier"
        />
        <div className="fixed object-cover size-full z-[1] bg-gradient-to-b from-[#1A1B1F] to-[rgba(26,27,31,0.6)]" />
      </>
    )
  );
};
