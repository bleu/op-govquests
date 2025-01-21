import { ResultOf, VariablesOf } from "gql.tada";
import { BadgeQuery } from "../graphql/badgeQuery";
import { COLLECT_BADGE } from "../graphql/collectBadge";

export type Badge = ResultOf<typeof BadgeQuery>["badge"];

export type CollectBadgeVariables = VariablesOf<typeof COLLECT_BADGE>;
export type CollectBadgeResult = ResultOf<typeof COLLECT_BADGE>;
