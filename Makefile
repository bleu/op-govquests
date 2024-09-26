prepare-dev:
	@echo "Preparing development environment..."
	$(MAKE) -C ./apps/govquests-api prepare-dev
	@echo "Database is running on Docker."
	@echo "Installing dependencies..."
	pnpm install
	$(MAKE) -C ./apps/govquests-api install
	@echo "Dependencies installed..."
	@echo "Development environment ready."

