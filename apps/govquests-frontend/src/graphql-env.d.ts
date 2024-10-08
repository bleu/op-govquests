/* eslint-disable */
/* prettier-ignore */

export type introspection_types = {
    'Action': { kind: 'OBJECT'; name: 'Action'; fields: { 'actionData': { name: 'actionData'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'JSON'; ofType: null; }; } }; 'actionType': { name: 'actionType'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; 'displayData': { name: 'displayData'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'OBJECT'; name: 'DisplayData'; ofType: null; }; } }; 'id': { name: 'id'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'ID'; ofType: null; }; } }; }; };
    'ActionExecution': { kind: 'OBJECT'; name: 'ActionExecution'; fields: { 'actionId': { name: 'actionId'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'ID'; ofType: null; }; } }; 'actionType': { name: 'actionType'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; 'completedAt': { name: 'completedAt'; type: { kind: 'SCALAR'; name: 'ISO8601DateTime'; ofType: null; } }; 'completionData': { name: 'completionData'; type: { kind: 'SCALAR'; name: 'JSON'; ofType: null; } }; 'id': { name: 'id'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'ID'; ofType: null; }; } }; 'nonce': { name: 'nonce'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; 'startData': { name: 'startData'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'JSON'; ofType: null; }; } }; 'startedAt': { name: 'startedAt'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'ISO8601DateTime'; ofType: null; }; } }; 'status': { name: 'status'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; 'userId': { name: 'userId'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'ID'; ofType: null; }; } }; }; };
    'Boolean': unknown;
    'CompleteActionExecutionInput': { kind: 'INPUT_OBJECT'; name: 'CompleteActionExecutionInput'; isOneOf: false; inputFields: [{ name: 'clientMutationId'; type: { kind: 'SCALAR'; name: 'String'; ofType: null; }; defaultValue: null }, { name: 'completionData'; type: { kind: 'SCALAR'; name: 'JSON'; ofType: null; }; defaultValue: null }, { name: 'executionId'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'ID'; ofType: null; }; }; defaultValue: null }, { name: 'nonce'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; }; defaultValue: null }]; };
    'CompleteActionExecutionPayload': { kind: 'OBJECT'; name: 'CompleteActionExecutionPayload'; fields: { 'actionExecution': { name: 'actionExecution'; type: { kind: 'OBJECT'; name: 'ActionExecution'; ofType: null; } }; 'clientMutationId': { name: 'clientMutationId'; type: { kind: 'SCALAR'; name: 'String'; ofType: null; } }; 'errors': { name: 'errors'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'LIST'; name: never; ofType: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; }; }; } }; }; };
    'DisplayData': { kind: 'OBJECT'; name: 'DisplayData'; fields: { 'content': { name: 'content'; type: { kind: 'SCALAR'; name: 'String'; ofType: null; } }; 'imageUrl': { name: 'imageUrl'; type: { kind: 'SCALAR'; name: 'String'; ofType: null; } }; 'intro': { name: 'intro'; type: { kind: 'SCALAR'; name: 'String'; ofType: null; } }; 'title': { name: 'title'; type: { kind: 'SCALAR'; name: 'String'; ofType: null; } }; }; };
    'ID': unknown;
    'ISO8601DateTime': unknown;
    'Int': unknown;
    'JSON': unknown;
    'Mutation': { kind: 'OBJECT'; name: 'Mutation'; fields: { 'completeActionExecution': { name: 'completeActionExecution'; type: { kind: 'OBJECT'; name: 'CompleteActionExecutionPayload'; ofType: null; } }; 'startActionExecution': { name: 'startActionExecution'; type: { kind: 'OBJECT'; name: 'StartActionExecutionPayload'; ofType: null; } }; }; };
    'Query': { kind: 'OBJECT'; name: 'Query'; fields: { 'quest': { name: 'quest'; type: { kind: 'OBJECT'; name: 'Quest'; ofType: null; } }; 'quests': { name: 'quests'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'LIST'; name: never; ofType: { kind: 'NON_NULL'; name: never; ofType: { kind: 'OBJECT'; name: 'Quest'; ofType: null; }; }; }; } }; 'user': { name: 'user'; type: { kind: 'OBJECT'; name: 'User'; ofType: null; } }; }; };
    'Quest': { kind: 'OBJECT'; name: 'Quest'; fields: { 'actions': { name: 'actions'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'LIST'; name: never; ofType: { kind: 'NON_NULL'; name: never; ofType: { kind: 'OBJECT'; name: 'Action'; ofType: null; }; }; }; } }; 'audience': { name: 'audience'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; 'displayData': { name: 'displayData'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'OBJECT'; name: 'DisplayData'; ofType: null; }; } }; 'id': { name: 'id'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'ID'; ofType: null; }; } }; 'questType': { name: 'questType'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; 'rewards': { name: 'rewards'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'LIST'; name: never; ofType: { kind: 'NON_NULL'; name: never; ofType: { kind: 'OBJECT'; name: 'Reward'; ofType: null; }; }; }; } }; 'status': { name: 'status'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; }; };
    'Reward': { kind: 'OBJECT'; name: 'Reward'; fields: { 'amount': { name: 'amount'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'Int'; ofType: null; }; } }; 'type': { name: 'type'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; }; };
    'StartActionExecutionInput': { kind: 'INPUT_OBJECT'; name: 'StartActionExecutionInput'; isOneOf: false; inputFields: [{ name: 'actionId'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'ID'; ofType: null; }; }; defaultValue: null }, { name: 'clientMutationId'; type: { kind: 'SCALAR'; name: 'String'; ofType: null; }; defaultValue: null }, { name: 'startData'; type: { kind: 'SCALAR'; name: 'JSON'; ofType: null; }; defaultValue: null }]; };
    'StartActionExecutionPayload': { kind: 'OBJECT'; name: 'StartActionExecutionPayload'; fields: { 'actionExecution': { name: 'actionExecution'; type: { kind: 'OBJECT'; name: 'ActionExecution'; ofType: null; } }; 'clientMutationId': { name: 'clientMutationId'; type: { kind: 'SCALAR'; name: 'String'; ofType: null; } }; 'errors': { name: 'errors'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'LIST'; name: never; ofType: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; }; }; } }; }; };
    'String': unknown;
    'User': { kind: 'OBJECT'; name: 'User'; fields: { 'email': { name: 'email'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; 'id': { name: 'id'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'ID'; ofType: null; }; } }; 'userType': { name: 'userType'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; 'wallets': { name: 'wallets'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'LIST'; name: never; ofType: { kind: 'NON_NULL'; name: never; ofType: { kind: 'OBJECT'; name: 'Wallet'; ofType: null; }; }; }; } }; }; };
    'Wallet': { kind: 'OBJECT'; name: 'Wallet'; fields: { 'chainId': { name: 'chainId'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'Int'; ofType: null; }; } }; 'walletAddress': { name: 'walletAddress'; type: { kind: 'NON_NULL'; name: never; ofType: { kind: 'SCALAR'; name: 'String'; ofType: null; }; } }; }; };
};

/** An IntrospectionQuery representation of your schema.
 *
 * @remarks
 * This is an introspection of your schema saved as a file by GraphQLSP.
 * It will automatically be used by `gql.tada` to infer the types of your GraphQL documents.
 * If you need to reuse this data or update your `scalars`, update `tadaOutputLocation` to
 * instead save to a .ts instead of a .d.ts file.
 */
export type introspection = {
  name: never;
  query: 'Query';
  mutation: 'Mutation';
  subscription: never;
  types: introspection_types;
};

import * as gqlTada from 'gql.tada';

declare module 'gql.tada' {
  interface setupSchema {
    introspection: introspection
  }
}