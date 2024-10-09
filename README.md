# GovQuests

GovQuests is a platform designed to gamify governance participation and education in the Optimism ecosystem. It combines a Ruby on Rails API backend with a Next.js frontend to create an engaging experience for users to learn about and participate in governance activities.

## Project Structure

The repository is organized as a monorepo with the following structure:

- `apps/`
  - `govquests-api/`: Ruby on Rails API backend
    - `govquests/`: Core domain logic organized by bounded contexts
    - `infra/`: Domain infrastructure-related code
    - `rails_app/`: Rails application
  - `govquests-frontend/`: Next.js frontend application

## Prerequisites

- Node.js (version specified in `.tool-versions`)
- pnpm
- Ruby (version specified in `.tool-versions`)
- Docker (to spin up a PostgreSQL instance), or PostgreSQL itself (if using this don't forget to update credentials in database.yml or set DATABASE_URL)

## Setup

1. Clone the repository:

   ```
   git clone https://github.com/your-org/govquests.git
   cd govquests
   ```

2. Install dependencies and prepare the development environment:

   ```
   make prepare-dev
   ```

   This command will:

   - Set up the database in Docker
   - Install Node.js dependencies using pnpm
   - Install Ruby dependencies for the API and its subprojects

## Development

To start the development servers:

1. For the API (from the `apps/govquests-api/rails_app` directory):

   ```
   bin/rails server
   ```

2. For the frontend (from the `apps/govquests-frontend` directory):

   ```
   pnpm dev
   ```

## Testing

Run tests for all projects:

```
pnpm test
```

To run tests for specific parts of the application:

- API: `make -C apps/govquests-api test`
- Frontend: `pnpm --filter govquests-frontend test`

## Linting and Type Checking

- Lint the entire project:

  ```
  pnpm lint
  ```

- Run type checking:

  ```
  pnpm check-types
  ```

## Building for Production

Build all projects:

```
pnpm build
```

## Contributing

Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
