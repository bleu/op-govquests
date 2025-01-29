"use client";

import { Tabs, TabsContent, TabsList, TabsTrigger } from "@radix-ui/react-tabs";
import { useCurrentUserInfo } from "../hooks/useUserInfo";
import { TierContent } from "./TierContent";

export const TierTabs = () => {
  const { data } = useCurrentUserInfo();

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
        {/* Content for My Tier will go here */}
        {data && (
          <TierContent tierId={data.currentUser.gameProfile.tier.tierId} />
        )}
      </TabsContent>

      <TabsContent value="all-tiers" className="mt-0">
        {/* Content for All Tiers will go here */}
      </TabsContent>
    </Tabs>
  );
};
