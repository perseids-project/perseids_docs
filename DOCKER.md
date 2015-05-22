# Instructions for working with Docker Image

These steps can and should all be optimized via a Dockerfile but for now, here are the steps

```docker pull balmas/perseidsdev:latest```

```docker run -t -i -p 80:80 -p 8800:8800 -p 3000:3000 --expose 80 --expose 8800 --expose 3000 balmas/perseidsdev bash```

```cd /usr/local/eXist-1.4.1/tools/wrapper/bin```

```./exist.sh start```

```service tomcat6 start``` (it says FAILED but it starts -- need to resolve why wrong report still)

```service apache2 start```

```su - sosol```

```source ~/.bashrc```

```cd /usr/local/sosol```  (Ignore jruby notice - it's harmless but need to fix the rvm setup somehow to prevent this)

```git pull origin rails-3-perseus-merge``` (get latest code)

```bundle exec rails server```

You should now be able to login on your host machine at http://localhost:3000

To connect a shell to the running container, in a terminal window

```docker ps```

```docker exec -t -i <name or id> bash```

