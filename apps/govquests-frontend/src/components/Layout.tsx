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

export const queryClient = new QueryClient();

const Providers = ({ children }: Readonly<{ children: React.ReactNode }>) => {
  const router = useRouter();

  const handleHomeToQuestsRedirect = () => {
    if (window.location.pathname !== "/") return;
    router.push("/quests");
  };

  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        <SIWEProvider {...siweConfig}>
          <ConnectKitProvider onConnect={handleHomeToQuestsRedirect}>
            {children}
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
      <div className="flex-1 relative z-10">{children}</div>
      <Footer />
      <Toaster />
    </Providers>
  );
}

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
