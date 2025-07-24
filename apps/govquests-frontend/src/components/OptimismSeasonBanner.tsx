import Image from "next/image";
import { Button } from "./ui/Button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogTrigger,
} from "./ui/dialog";

export const OptimismSeasonBanner = () => {
  return (
    <div
      className="rounded-xl p-8 flex border border-white/10 items-center justify-between relative"
      style={{
        background: `linear-gradient(0deg, rgba(26, 27, 31, 0.1), rgba(26, 27, 31, 0.1)), linear-gradient(90deg, rgba(69, 23, 158, 0.3) 0%, rgba(242, 153, 142, 0.3) 100%)`,
      }}
    >
      <div className="flex flex-col gap-2">
        <h1 className="text-2xl font-bold">Optimism Season 8 is live!</h1>
        <span>
          Be the #1 in your leaderboard tier by the end of the Season 8 and earn
          OP rewards.
        </span>
      </div>
      <Dialog>
        <DialogTrigger asChild>
          <Button
            className="py-3 h-fit hover:invert-0 text-sm font-bold"
            style={{
              background: "linear-gradient(90deg, #622BD4 0%, #F49A8E 100%)",
            }}
          >
            Learn How it Works
          </Button>
        </DialogTrigger>
        <DialogContent
          className="max-w-md rounded-4xl flex flex-col gap-6"
          hideCloseButton
        >
          <Image
            src="/learn-flow/1-intro.png"
            alt="Optimism Season 8"
            width={1000}
            height={1000}
            className="w-full h-auto"
          />
          <div className="px-2.5 flex flex-col gap-2">
            <h1 className="text-xl font-bold">
              Earn OP by Participating in GovQuests
            </h1>
            <p className="text-md text-muted-foreground">
              GovQuests is a platform that allows you to earn OP by
              participating in quests.
            </p>
          </div>
          <DialogFooter className="flex items-center justify-between w-full">
            <Button variant="secondary" className="w-full py-3 h-fit font-bold">
              Previous
            </Button>
            <Button className="w-full py-3 h-fit font-bold">Next</Button>
          </DialogFooter>
        </DialogContent>
      </Dialog>
    </div>
  );
};
