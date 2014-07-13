docker-aperophp
===============

Installation
------------

Run the container

```
docker run -i -t -d  -p 9797:80  --volume=/home/user/Projets/aperophp:/var/www agallou/aperophp
```

Run the container and persisting the database between runs

```
docker run -i -t -d  -p 9797:80  --volume=/home/user/Projets/aperophp:/var/www  --volume=/home/user/.container_data/aperophp/mysql:/var/lib/mysql agallou/aperophp
```


Configuration
-------------

In order to use make the links work, you may want to add the in the ```app/config.php``` file : 

```php
$app->before(function (Request $request) use ($app) {
    $app['request_context']->setHost('localhost:9797');
});
```

