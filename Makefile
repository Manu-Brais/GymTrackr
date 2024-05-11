.PHONY: install
install:
	docker compose run --rm app bash -c "\
	bundle install && \
	bundle exec rails db:drop && \
	bundle exec rails db:create && \
	bundle exec rails db:migrate && \
	bundle exec rails db:seed"

.PHONY: bundle
bundle:
	docker compose run --rm app bundle install

.PHONY: console
console:
	docker compose run --rm app bundle exec rails console

.PHONY: server
server:
	docker compose up app

.PHONY: db.migrate
db.migrate:
	docker compose run --rm app bundle exec rails db:migrate

STEP ?= 1
.PHONY: db.rollback
db.rollback:
	docker compose run --rm app bundle exec rails db:rollback STEP=$(STEP)

.PHONY: db.reset
db.reset:
	docker compose run --rm app bundle exec rails db:reset

.PHONY: db.seed
db.seed:
	docker compose run --rm app bundle exec rails db:seed

.PHONY: db.session
db.session:
	docker compose run --rm app bundle exec rails db

.PHONY: standard
standard:
	docker compose run --rm app bundle exec standardrb --fix-unsafely

.PHONY: bash
bash:
	docker compose run --rm app bash

.PHONY: test
test:
	docker compose run --rm app bundle exec rspec

