"use client";
import { useSignMessage, WagmiProvider } from "wagmi";
import { config } from "@/wagmi";
import { QueryClient, QueryClientProvider } from "@tanstack/react-query";

const queryClient = new QueryClient();

const Providers = ({ children }: Readonly<{ children: React.ReactNode }>) => {
  return (
    <WagmiProvider config={config}>
      <QueryClientProvider client={queryClient}>
        {children}{" "}
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
      {/* MOCKED HEADER AND SIDE BAR, SHOUDL BE REMOVED: OP-299 & OP-300 */}
      <header className="h-16 bg-red-500 flex-1">
        <div />
      </header>
      <div className="flex">
        <aside className="w-64 bg-red-100 min-h-screen p-6 hidden md:flex">
          <div />
        </aside>
        {children}
      </div>
    </Providers>
  );
}
