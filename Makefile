.PHONY: install
install:
	docker compose build
	make bundle
	make db.setup
	make db.migrate
	docker compose run --rm frontend npm install

.PHONY: bundle
bundle:
	docker compose run --rm --no-deps app bundle install
	docker compose run --rm --no-deps app-test bundle install

.PHONY: console
console:
	docker compose run --rm app bundle exec rails console

.PHONY: server
server:
	docker compose --profile server up

.PHONY: db.setup
db.setup:
	docker compose --profile migrations run --rm app bundle exec rails db:drop db:setup

.PHONY: db.migrate
db.migrate:
	docker compose --profile migrations run --rm app bundle exec rails db:migrate

STEP ?= 1
.PHONY: db.rollback
db.rollback:
	docker compose --profile migrations run --rm app bundle exec rails db:rollback STEP=$(STEP)

.PHONY: db.reset
db.reset:
	docker compose --profile migrations run --rm app bundle exec rails db:reset

.PHONY: db.seed
db.seed:
	docker compose --profile migrations run --rm app bundle exec rails db:seed

.PHONY: db.session
db.session:
	docker compose --profile migrations run --rm app bundle exec rails db

.PHONY: standard
standard:
	docker compose run --rm --no-deps app bundle exec standardrb --fix-unsafely

.PHONY: bash
bash:
	docker compose run --rm --no-deps app bash

.PHONY: test
test:
	docker compose --profile test run --rm app-test bundle exec rspec

.PHONY: test.session
test.session:
	docker compose --profile test run --rm app-test bash

