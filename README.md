Les supports de cours sont sous forme de notebook jupyter et utilise docker. 
Une base de données relationnelle postgreSQL est créée automatiquement.
Il faut que le port 8888 soit libre (sinon éditer docker-compose.yml).
Si vous voulez accéder directement à postgres depuis l'hôte décommentez le mapping de port dans docker-compose.yml.

Pour lancer les supports de cours (sans l'option -d)
```bash
docker-compose up 
```

Chercher dans les log une ligne de la forme 
http://(6d5cf1cfbee5 or 127.0.0.1):8888/?token=a4dc41d46b543cbe81882d4b4ccd037b5ea7a7c7769ec856

et ouvrir dans un navigateur web :
http://127.0.0.1:8888/?token=a4dc41d46b543cbe81882d4b4ccd037b5ea7a7c7769ec856

Sous windows il faut activer ["shared drive"](https://docs.docker.com/docker-for-windows/troubleshoot/#volume-mounting-requires-shared-drives-for-linux-containers)
