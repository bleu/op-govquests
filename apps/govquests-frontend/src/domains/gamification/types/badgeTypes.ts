import { ResultOf } from "gql.tada";
import { BadgeQuery } from "../graphql/badgeQuery";

export type Badge = ResultOf<typeof BadgeQuery>["badge"];
