# Enigma

```
$ cp config/database.yml{.sample,} 
$ cp config/cable.yml{.sample,} 
$ cp config/storage.yml{.sample,} 
$ docker-compose build
$ docker-compose run web rails webpacker:install
$ docker-compose run web rails db:create RAILS_ENV=development
$ docker-compose run web rails db:migrate RAILS_ENV=development
$ docker-compose up -d
$ docker-compose down
```

