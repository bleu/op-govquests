import { graphql } from "gql.tada";

export const SendEmailVerificationMutation = graphql(`
  mutation SendEmailVerification($email: String!) {
    sendEmailVerification(input: { email: $email }) {
      success
      errors
    }
  }
`);

export const EmailVerificationStatusQuery = graphql(`
  query EmailVerificationStatus {
    currentUser {
      email
      emailVerificationStatus
      emailVerificationToken
    }
  }
`);
