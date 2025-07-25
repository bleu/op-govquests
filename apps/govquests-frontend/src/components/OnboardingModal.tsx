import { Dialog } from "./ui/dialog";
import { ModalSteps, ModalStep } from "./ModalSteps";

const ONBOARDING_STEPS: ModalStep[] = [
  {
    id: 1,
    title: "Welcome to GovQuests",
    description: "Your odyssey into the future of Optimism Governance.",
    image: "/onboarding-flow/1-welcome.png",
  },
  {
    id: 2,
    title: "Take on Quests",
    description:
      "Complete Optimism governance-related tasks to boost your engagement and impact.",
    image: "/onboarding-flow/2-quests.png",
  },
  {
    id: 3,
    title: "Earn Points & Badges",
    description:
      "Be rewarded for participating — collect badges and rack up points as you go.",
    image: "/onboarding-flow/3-badges.png",
  },
  {
    id: 4,
    title: "Climb the Leaderboard",
    description:
      "Track your progress and see how you stack up. The leaderboard is split into tiers based on your governance activity.",
    image: "/onboarding-flow/4-leaderboard.png",
  },
  {
    id: 5,
    title: "Get Rewarded",
    description:
      "Earn OP during Optimism Season 8 through select quests — and if you finish as the top #1 in your tier, earn extra OP rewards.",
    image: "/onboarding-flow/5-reward.png",
  },
];

interface OnboardingModalProps {
  isOpen: boolean;
  onClose: () => void;
}

export const OnboardingModal = ({ isOpen, onClose }: OnboardingModalProps) => {
  return (
    <Dialog open={isOpen} onOpenChange={onClose}>
      <ModalSteps
        steps={ONBOARDING_STEPS}
        ctaLastStep="Get started"
        handleClose={onClose}
      />
    </Dialog>
  );
};
