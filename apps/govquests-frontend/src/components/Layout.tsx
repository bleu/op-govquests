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
            <div className="min-h-screen flex flex-col">
              <Header />
              <div className="flex-1">{children}</div>
              <Footer />
            </div>
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
      <div className="h-full relative">
        <BackgroundTier />
        <div className="fixed object-cover size-full z-[1] bg-gradient-to-b from-[#1A1B1F] to-[rgba(26,27,31,0.6)]" />
        <div className="relative z-10 h-full max-w-[1200px] mx-auto">
          {children}
        </div>
      </div>
      <Toaster />
    </Providers>
  );
}

const BackgroundTier = () => {
  const { data } = useCurrentUserInfo();

  return (
    data && (
      <Image
        src={data.currentUser.gameProfile.tier.imageUrl}
        width={1000}
        height={1000}
        className="object-cover fixed size-full"
        alt="background_tier"
      />
    )
  );
};
