# Sample App 



```
$ cp config/database.yml{.sample,} 
$ cp config/cable.yml{.sample,} 
$ cp config/storage.yml{.sample,} 
$ docker-compose build
$ docker-compose run web rails webpacker:install
$ docker-compose run web rails db:create RAILS_ENV=development
$ docker-compose run web rails db:migrate RAILS_ENV=development
```


```
$ docker-compose build
```

```
$ docker-compose up -d
```

```
$ docker-compose down
```

## If you want to execute something from inside the container 

```
$ docker-compose exec web bash
root@f21e8f3026ca:/sample_app# <COMMAND>
```

or

```
$ docker exec -it sample_app_web_1 <COMMAND>
```

