import {
  Table,
  TableBody,
  TableCell,
  TableHead,
  TableHeader,
  TableRow,
} from "@/components/ui/table";
import { ResultOf } from "gql.tada";
import { TIER_QUERY } from "../graphql/tierQuery";
import { useUserProfile } from "@/hooks/useUserProfile";

export const LeaderboardTable = ({
  leaderboard,
}: {
  leaderboard: ResultOf<typeof TIER_QUERY>["tier"]["leaderboard"];
}) => {
  return (
    <Table className="border-separate border-spacing-y-3">
      <TableHeader className="text-sm font-bold">
        <TableRow className="hover:bg-inherit">
          <TableHead>#</TableHead>
          <TableHead>Address</TableHead>
          <TableHead>Points</TableHead>
          <TableHead>Voting Power</TableHead>
        </TableRow>
      </TableHeader>
      <TableBody className="text-sm font-bold">
        {leaderboard.gameProfiles.map((profile, index) => (
          <UserTableRow profile={profile} key={profile.profileId} />
        ))}
      </TableBody>
    </Table>
  );
};

const UserTableRow = ({
  profile,
}: {
  profile: ResultOf<
    typeof TIER_QUERY
  >["tier"]["leaderboard"]["gameProfiles"][number];
}) => {
  const { data } = useUserProfile(profile.user.address as `0x${string}`);

  return (
    <TableRow
      key={profile.profileId}
      className="bg-background/50 hover:bg-background hover:shadow-[0_4px_6px_0_#00000040]"
    >
      <TableCell className="py-4 rounded-l-lg">{profile.rank}</TableCell>
      {data && <TableCell className="py-4">{data.name}</TableCell>}
      <TableCell className="py-4">{profile.score}</TableCell>
      <TableCell className="py-4 rounded-r-lg">20,7K OP (3%)</TableCell>
    </TableRow>
  );
};
