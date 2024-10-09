install:
	@bundle install

setup:
	docker-compose up -d
	@bundle exec rails db:setup

test:
	@bin/rspec

lint:
	@bundle exec rubocop -A

sorbet:
	bundle exec srb tc

sorbet/verify-ungenerated:
	bundle exec tapioca dsl -e development --verify

sorbet/update:
	bundle install
	# bundle exec tapioca require
	# bundle exec tapioca gem --all
	bundle exec tapioca gem -e development
	bundle exec tapioca annotations
	bundle exec tapioca dsl -e development
	# bundle exec tapioca todo

sorbet/bump:
	bundle exec spoom srb bump --from false --to true || true;
	bundle exec spoom srb bump --from true --to strict || true;
	bundle exec spoom srb bump --from strict --to strong || true;

.PHONY: install test lint sorbet
