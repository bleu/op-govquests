# Define the subdirectories where tests should be run
SUBDIRS := govquests/shared_kernel govquests/authentication govquests/questing govquests/gamification govquests/notifications govquests/rewarding govquests/action_tracking infra rails_app

.PHONY: test $(SUBDIRS)

# Default target
all: test

# Run tests in all subdirectories
test: $(SUBDIRS)

$(SUBDIRS):
	@echo "Running tests in $@"
	@$(MAKE) -C $@ test

# Install dependencies in all subdirectories
install:
	@for dir in $(SUBDIRS); do \
		echo "Installing dependencies in $$dir"; \
		$(MAKE) -C $$dir install; \
	done

# Run linter (assuming it's only applicable to rails_app)
lint:
	@$(MAKE) -C rails_app lint

# Run Sorbet type checking (assuming it's only applicable to rails_app)
sorbet:
	@$(MAKE) -C rails_app sorbet

# Run mutation testing (where applicable)
mutate:
	@for dir in govquests/authentication govquests/questing infra; do \
		echo "Running mutation tests in $$dir"; \
		$(MAKE) -C $$dir mutate; \
	done

# Clean up (you can define cleanup tasks here if needed)
clean:
	@echo "Cleaning up..."
	# Add cleanup commands here

# Help target
help:
	@echo "Available targets:"
	@echo "  test       - Run all tests in subdirectories"
	@echo "  install    - Install dependencies in all subdirectories"
	@echo "  lint       - Run linter on rails_app"
	@echo "  sorbet     - Run Sorbet type checking on rails_app"
	@echo "  mutate     - Run mutation tests where applicable"
	@echo "  clean      - Clean up (if defined)"
	@echo "  help       - Show this help message"
