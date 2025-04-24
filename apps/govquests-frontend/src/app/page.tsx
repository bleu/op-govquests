import { BeginYourJourney } from "@/domains/authentication/components/BeginYourJourney";
import Image from "next/image";
import { CursorHighlight } from "@/components/CursorHighlight";

export default async function Home() {
  return (
    <>
      <CursorHighlight />
      <main className="flex flex-1 px-6 flex-col gap-8 h-full items-center justify-center text-center max-w-[600px] mx-auto">
        <div className="relative w-48 h-48 overflow-hidden group">
          <div className="absolute translate-x-1/2 translate-y-1/2 w-24 h-24 overflow-hidden z-20">
            <Image
              width={96}
              height={96}
              src="/optimismSun.png"
              alt="opSun"
              className="absolute size-full scale-[2]"
              style={{
                objectPosition: "center",
              }}
            />
          </div>
          <Image
            width={192}
            height={192}
            src="/optimismSun.png"
            alt="opSun"
            className="absolute size-full object-cover group-hover:animate-[spin_10s_linear_infinite]"
            style={{
              objectPosition: "center",
            }}
          />
        </div>
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
    </>
  );
}
