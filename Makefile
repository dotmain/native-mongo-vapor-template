build:
	docker-compose build

run:
	docker-compose up app
	docker-compose up db
	docker-compose run migrate

stop:
	docker-compose down

clean:
	docker-compose down -v 
