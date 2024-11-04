import { graphql } from "gql.tada";

export const QuestQuery = graphql(`
  query GetQuest($id: ID!) {
    quest(id: $id) {
      id
      audience
      rewardPools {
        rewardDefinition {
          type
          amount
        }
        remainingInventory
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
