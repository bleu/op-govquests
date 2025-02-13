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
    <DialogContent
      onOpenAutoFocus={(e) => e.preventDefault()}
      className="p-0 rounded-[20px] sm:rounded-[20px] max-w-[800px] w-4/5"
    >
      <DialogHeader>
        <DialogTitle hidden>User Information</DialogTitle>
        <DialogDescription asChild>
          <div>
            <ThirdUserAchievementPanel userId={userId} />
            <UserBadgesCollection
              userId={userId}
              headerClassName="px-7 text-left"
            />
          </div>
        </DialogDescription>
      </DialogHeader>
    </DialogContent>
  );
};
