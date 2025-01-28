import { IndicatorPill } from "@/components/IndicatorPill";
import Image from "next/image";

export const UserAchievementPanel = () => {
  return (
    <div className="w-full h-80 overflow-hidden rounded-[20px] relative">
      <Image
        src="backgrounds/first_tier.svg"
        alt="tier_background"
        width={100}
        height={100}
        className="object-cover size-full"
      />
      <div className="absolute bottom-0 bg-background/80 py-5 w-full rounded-[20px] h-20 text-white text-center items-center border-foreground/10 border">
        <div>
          <p className="text-sm">Current Tier</p>
          <p className="text-lg font-bold">Tier 1</p>
        </div>
      </div>
      <div className="flex flex-col gap-0 absolute bottom-[70px] left-1/2 -translate-x-1/2 items-center">
        <div className="w-full px-5">
          <div className="max-w-fit mx-auto px-5 bg-background/80 pb-1 pt-3 flex flex-col gap-2 border-foreground/10 border rounded-t-2xl overflow-hidden items-center">
            <div className="size-28 border p-1 flex flex-col justify-center rounded-full bg-white">
              <Image
                width={200}
                height={200}
                src="/optimismSun.svg"
                alt="opSun"
                className="object-cover"
              />
            </div>
            <p>Address</p>
          </div>
        </div>
        <IndicatorPill className="px-8 min-w-48">
          Delegation Initiate
        </IndicatorPill>
      </div>
    </div>
  );
};
