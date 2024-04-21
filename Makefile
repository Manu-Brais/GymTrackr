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