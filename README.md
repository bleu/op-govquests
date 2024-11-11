# GovQuests

GovQuests is a platform designed to gamify governance participation and education in the Optimism ecosystem. It combines a Ruby on Rails API backend with a Next.js frontend to create an engaging experience for users to learn about and participate in governance activities.

## Project Structure

The repository is organized as a monorepo with the following structure:

```
.
├── apps/
│   ├── govquests-api/               # Ruby API with DDD architecture
│   │   ├── govquests/               # Core domain implementations
│   │   │   ├── action_tracking/     # Action verification and tracking
│   │   │   ├── authentication/      # User identity and sessions
│   │   │   ├── gamification/        # Points, badges, and rewards
│   │   │   ├── notifications/       # User notifications
│   │   │   ├── processes/           # Process managers for cross-domain workflows
│   │   │   ├── questing/           # Core quest management
│   │   │   ├── rewarding/          # Reward distribution
│   │   │   └── shared_kernel/      # Shared types and utilities
│   │   ├── infra/                  # Infrastructure layer
│   │   └── rails_app/              # Rails application wrapper
│   └── govquests-frontend/         # Next.js frontend application
└── Makefile                        # Root level build commands
```

## Prerequisites

- Node.js (version specified in `.tool-versions`)
- pnpm
- Ruby (version specified in `.tool-versions`)
- Docker (to spin up a PostgreSQL instance), or PostgreSQL itself (if using this don't forget to update credentials in database.yml or set DATABASE_URL)
- Make

## Setup

1. Clone the repository:

   ```bash
   git clone https://github.com/your-org/govquests.git
   cd govquests
   ```

2. Install dependencies and prepare the development environment:

   ```bash
   make install
   ```

   This command will:

   - Set up the database in Docker
   - Install Node.js dependencies using pnpm
   - Install Ruby dependencies for the API and its subprojects

## Development

To start the development servers:

1. For the API (from the `apps/govquests-api/rails_app` directory):

   ```bash
   bin/rails server
   ```

2. For the frontend (from the `apps/govquests-frontend` directory):

   ```bash
   pnpm dev
   ```

## Testing

Run tests for all projects:

```bash
pnpm test
```

To run tests for specific parts of the application:

- API: `make -C apps/govquests-api test`
- Frontend: `pnpm --filter govquests-frontend test`

Test specific domains:

```bash
make -C apps/govquests-api/govquests/authentication test
make -C apps/govquests-api/govquests/questing test
```

Run mutation tests:

```bash
make -C apps/govquests-api mutate
```

## Code Quality

### Backend

```bash
# Run Rubocop linting
make -C apps/govquests-api/rails_app lint

# Run Sorbet type checking
make -C apps/govquests-api/rails_app sorbet

# Update Sorbet RBI files
make -C apps/govquests-api/rails_app sorbet/update

# Generate GraphQL schema
make -C apps/govquests-api/rails_app gql/schema
```

### Frontend

```bash
# Lint the entire project
pnpm lint

# Run type checking
pnpm check-types
```

## Building for Production

Build all projects:

```bash
pnpm build
```

## Architecture Overview

The backend follows Domain-Driven Design principles with the following bounded contexts:

- **Action Tracking**: Manages user interactions and verifies action completion
- **Authentication**: Handles user identity and sessions
- **Gamification**: Controls points, rewards, and game mechanics
- **Notifications**: Manages system notifications across channels
- **Questing**: Core quest management and progression
- **Rewarding**: Handles reward distribution
- **Processes**: Coordinates workflows across domains

Each domain follows a consistent structure:

```
domain/
├── lib/              # Domain implementation
├── spec/             # Tests
└── Makefile         # Build and test commands
```

## Common Tasks

```bash
# Set up development environment
make install

# Run all backend tests
make -C apps/govquests-api test

# Test specific domain
make -C apps/govquests-api/govquests/questing test

# Update Sorbet types
make -C apps/govquests-api/rails_app sorbet/update

# Generate GraphQL schema
make -C apps/govquests-api/rails_app gql/schema
```

## Documentation

- [Backend](apps/govquests-api/README.md)
- [Frontend](apps/govquests-frontend/README.md)
- [API](apps/govquests-api/rails_app/README.md)

## Contributing

Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
