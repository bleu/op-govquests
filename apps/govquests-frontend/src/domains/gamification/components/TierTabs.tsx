"use client";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@radix-ui/react-tabs";
import { useCurrentUserInfo } from "../hooks/useUserInfo";
import { TierContent } from "./TierContent";
import { useFetchTiers } from "../hooks/useFetchTiers";

export const TierTabs = () => {
  const { data: currentUserData } = useCurrentUserInfo();
  const { data: tiersData } = useFetchTiers();

  const triggerClassName =
    "text-foreground/80 hover:text-foreground data-[state=active]:text-white data-[state=active]:bg-transparent data-[state=active]:font-extrabold bg-transparent border-none font-normal flex items-center gap-2 transition duration-300";

  return (
    <Tabs defaultValue="my-tier" className="w-full">
      <TabsList className="grid grid-cols-2 w-fit bg-transparent border-b mb-4 gap-4">
        <TabsTrigger value="my-tier" className={triggerClassName}>
          # My tier
        </TabsTrigger>
        <TabsTrigger value="all-tiers" className={triggerClassName}>
          # All tiers
        </TabsTrigger>
      </TabsList>

      <TabsContent value="my-tier" className="mt-0">
        {currentUserData && (
          <TierContent
            tierId={currentUserData.currentUser.gameProfile.tier.tierId}
          />
        )}
      </TabsContent>

      <TabsContent value="all-tiers" className="mt-0 flex flex-col gap-10">
        {tiersData?.tiers.map((tier) => (
          <TierContent key={tier.tierId} tierId={tier.tierId} />
        ))}
      </TabsContent>
    </Tabs>
  );
};
