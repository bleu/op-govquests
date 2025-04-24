import { graphql } from "gql.tada";

export const QuestQuery = graphql(`
  query GetQuest($slug: String!) {
    quest(slug: $slug) {
      id
      audience
      slug
      badge {
        id
        displayData {
          imageUrl
          title
        }
      }
      rewardPools {
        rewardDefinition {
          type
          amount
        }
        remainingInventory
      }
      track {
        id
        displayData {
          title
          description
        }
      }
      displayData {
        title
        intro
        imageUrl
        requirements
      }
      userQuests {
        id
        status
        startedAt
        completedAt
      }
      actions {
        id
        actionType
        displayData {
          title
          description
        }
        actionData {
          actionType
          ... on ReadDocumentActionData {
            documentUrl
          }
        }
        actionExecutions {
          id
          actionId
          userId
          actionType
          status
          nonce
          startedAt
          completedAt
          startData {
            __typename
            ... on GitcoinScoreStartData {
              message
              nonce
            }
            ... on DiscourseVerificationStartData {
              verificationUrl
            }
            ... on SendEmailStartData {
              email
            }
            ... on EnsStartData {
              domains {
                name
                owner
              }
            }
          }
          completionData {
            __typename
            ... on GitcoinScoreCompletionData {
              score
              minimumPassingScore
            }
            ... on DiscourseVerificationCompletionData {
              discourseUsername
            }
          }
        }
      }
    }
  }
`);
