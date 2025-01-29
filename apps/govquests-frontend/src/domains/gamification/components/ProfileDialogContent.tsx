import {
  DialogContent,
  DialogDescription,
  DialogHeader,
  DialogTitle,
} from "@/components/ui/dialog";
import { ThirdUserAchievementPanel } from "./UserAchievementPanel";
import { UserBadgesCollection } from "./UserBadgesCollection";

export const ProfileDialogContent = ({ userId }: { userId: string }) => {
  return (
    <DialogContent className="p-0 sm:rounded-[20px] max-w-[800px] w-4/5">
      <DialogHeader>
        <DialogTitle hidden>User Information</DialogTitle>
        <DialogDescription>
          <ThirdUserAchievementPanel userId={userId} />
          <UserBadgesCollection userId={userId} />
        </DialogDescription>
      </DialogHeader>
    </DialogContent>
  );
};
