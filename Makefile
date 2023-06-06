install:
	bundle install

start:
	bin/rails s -p 3000 -b "0.0.0.0"

assets:
	bin/rails assets:precompile

lint:
	bundle exec rubocop
	bundle exec slim-lint app/views/

console:
	bin/rails console

test:
	bundle exec rake
	
.PHONY: test