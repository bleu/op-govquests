import { SectionHeader } from "@/components/SectionHeader";
import { useUserInfo } from "../hooks/useUserInfo";
import { NormalBadgeCard, SpecialBadgeCard } from "./BadgeCard";

export const UserBadgesCollection = ({ userId }: { userId: string }) => {
  const { data } = useUserInfo(userId);

  return (
    data && (
      <div className="flex flex-col p-7 text-foreground">
        <SectionHeader title="Badges Collection" />
        <div className="grid md:grid-cols-4 grid-cols-3">
          {data.user.userBadges.map(({ badge }) => {
            console.log(badge);
            if (badge.__typename == "Badge")
              return (
                <NormalBadgeCard
                  badgeId={badge.id}
                  key={badge.id}
                  withTitle={true}                
                  header={`${badge.badgeable.__typename} BADGE #${badge.displayData.sequenceNumber}`}
                  revealIncomplete
                />
              );
            else
              return (
                <SpecialBadgeCard
                  badgeId={badge.id}
                  key={badge.id}
                  withTitle={true}
                  header={`SPECIAL BADGE #${badge.displayData.sequenceNumber}`}
                  revealIncomplete
                />
              );
          })}
        </div>
      </div>
    )
  );
};
