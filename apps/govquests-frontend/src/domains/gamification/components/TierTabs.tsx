"use client";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@radix-ui/react-tabs";
import { useCurrentUserInfo } from "../hooks/useUserInfo";
import { TierContent } from "./TierContent";
import { useFetchTiers } from "../hooks/useFetchTiers";
import { useRouter, useSearchParams } from "next/navigation";
import { useMemo } from "react";

export const TierTabs = () => {
  const { data, isError, isSuccess } = useCurrentUserInfo();

  const searchParams = useSearchParams();
  const router = useRouter();

  const triggerClassName =
    "text-foreground/80 hover:text-foreground data-[state=active]:text-white data-[state=active]:bg-transparent data-[state=active]:font-extrabold bg-transparent border-none font-normal flex items-center gap-2 transition duration-300";

  if (isError) {
    return <AllTiersTab />;
  }

  const initialTab = useMemo(() => {
    return searchParams.get("tab") || "my-tier";
  }, [searchParams]);

  const handleTabChange = (value: string) => {
    router.push(`?tab=${value}`);
  };

  if (isSuccess) {
    return (
      <Tabs
        className="w-full"
        value={initialTab}
        onValueChange={handleTabChange}
      >
        <TabsList className="grid grid-cols-2 w-fit bg-transparent border-b mb-4 gap-4">
          <TabsTrigger value="my-tier" className={triggerClassName}>
            # My tier
          </TabsTrigger>
          <TabsTrigger value="all-tiers" className={triggerClassName}>
            # All tiers
          </TabsTrigger>
        </TabsList>

        <TabsContent value="my-tier" className="mt-0">
          {data && (
            <TierContent tierId={data.currentUser.gameProfile.tier.tierId} />
          )}
        </TabsContent>

        <TabsContent value="all-tiers" className="mt-0 flex flex-col gap-10">
          <AllTiersTab />
        </TabsContent>
      </Tabs>
    );
  }
};

const AllTiersTab = () => {
  const { data: tiersData } = useFetchTiers();

  return tiersData?.tiers.map((tier) => (
    <TierContent key={tier.tierId} tierId={tier.tierId} />
  ));
};
