# jupyter web interface
JUPYTER_PORT=8888

# H2 database server
H2_SERVER_PORT=9092

docker run \
      	--name javanotebook \
      	--rm \
	-e TERM -e COLORTERM \
      	--env PUID=$UID \
      	--env PGID=$GID \
      	--env SUDO_PASSWORD=abc \
      	--volume $PWD/notebooks:/notebooks \
      	--volume $HOME/.m2:/home/user/.m2 \
	--volume $PWD/codeserver:/codeserver \
      	--publish $JUPYTER_PORT:8888 \
      	--publish $H2_SERVER_PORT:9092 \
      brunoe/javanotebook:develop 
