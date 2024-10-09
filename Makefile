install:
	@echo "Preparing development environment..."
	@echo "Installing dependencies..."
	pnpm install
	$(MAKE) -C ./apps/govquests-api install
	@echo "Dependencies installed..."
	@echo "Setting up database..."
	$(MAKE) -C ./apps/govquests-api/rails_app setup
	@echo "Database is running on Docker."
	@echo "Development environment ready."

