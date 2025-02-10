import { BeginYourJourney } from "@/domains/authentication/components/BeginYourJourney";
import Image from "next/image";

export default async function Home() {
  return (
    <main className="flex flex-1 px-6 flex-col gap-8 h-full items-center justify-center text-center max-w-[600px] mx-auto">
      <Image
        width={500}
        height={500}
        src="/optimismSun.png"
        alt="opSun"
        className="size-48"
      />

      <div className="flex flex-col gap-5">
        <h1 className="font-bold text-3xl [text-shadow:2px_4px_0_rgb(0,0,0)]">
          Your Odyssey Into the Future of Optimism Governance.
        </h1>
        <h2 className="font-normal text-xl">
          Take on quests, collect badges and make your mark in the governance
          ecosystem.
        </h2>
      </div>

      <BeginYourJourney />
    </main>
  );
}
