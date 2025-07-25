import Image from "next/image";
import { Button } from "./ui/Button";
import {
  Dialog,
  DialogContent,
  DialogFooter,
  DialogTrigger,
} from "./ui/dialog";
import { cn } from "@/lib/utils";
import { useState } from "react";
import HtmlRender from "./ui/HtmlRender";

const STEPS = [
  {
    id: 1,
    title: "Earn OP by Participating in GovQuests",
    description:
      "GovQuests rewards you for contributing to Optimism’s governance.The more you can earn throughout Season 8!",
    image: "/learn-flow/1-intro.png",
  },
  {
    id: 2,
    title: "Complete Quests, Earn OP",
    description:
      "Some quests include OP rewards you can earn right away. Look for the OP reward tag on quest cards — the token amount will be clearly displayed.",
    image: "/learn-flow/2-quests.png",
  },
  {
    id: 3,
    title: "Top the Leaderboard to Win More",
    description:
      "At the end of Season 8, the top 1 participant in each tier will receive bonus rewards:<ul><li><b>1000 points</b>, plus:</li><ul><li>Optimistic Supporter — <b>30 OP</b></li><li>Delegation Initiate — <b>30 OP</b></li><li>Emerging Leader — <b>20 OP</b></li><li>Strategic Delegate — <b>20 OP</b></li><li>Ecosystem Guardian — <b>15 OP</b></li></ul></ul>",
    image: "/learn-flow/3-leaderboard.png",
  },
  {
    id: 4,
    title: "How Rewards Are Distributed",
    description:
      "OP rewards will be sent once per month to the wallet you used in GovQuests. You’ll get a push notification when your rewards are sent.\n\n🔔 You can also opt in to receive updates via email or Telegram.",
    image: "/learn-flow/4-reward.png",
  },
];

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
        <ModalStep steps={STEPS} />
      </Dialog>
    </div>
  );
};

export const ModalStep = ({ steps }: { steps: typeof STEPS }) => {
  const [currentStep, setCurrentStep] = useState(steps[0]);

  const handleNext = () => {
    if (currentStep.id === steps.length) return;
    setCurrentStep(steps.find((step) => step.id === currentStep.id + 1));
  };

  const handlePrevious = () => {
    if (currentStep.id === 1) return;
    setCurrentStep(steps.find((step) => step.id === currentStep.id - 1));
  };

  return (
    <DialogContent
      className="max-w-md sm:rounded-3xl flex flex-col gap-6 p-5"
      hideCloseButton
    >
      <Image
        src={currentStep.image}
        alt={currentStep.title}
        width={1000}
        height={1000}
        className="w-full h-auto"
      />
      <div className="px-2.5 flex flex-col gap-6">
        <h1 className="text-xl font-bold">{currentStep.title}</h1>
        <p className="text-md text-muted-foreground">
          <HtmlRender content={currentStep.description} />
        </p>
      </div>
      {/* STEP INDICATORS */}
      <div className="flex gap-2 items-center justify-center mb-2">
        {steps.map((step) => (
          <div
            key={step.id}
            className={cn(
              "size-2 rounded-full bg-white/20",
              step.id === currentStep.id && "bg-white",
            )}
          />
        ))}
      </div>
      <DialogFooter className="flex items-center justify-between w-full">
        <Button
          variant="secondary"
          className="w-full py-3 h-fit font-bold"
          onClick={handlePrevious}
        >
          Previous
        </Button>
        <Button className="w-full py-3 h-fit font-bold" onClick={handleNext}>
          Next
        </Button>
      </DialogFooter>
    </DialogContent>
  );
};
