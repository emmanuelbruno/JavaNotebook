FROM brunoe/jupyterjava:develop
RUN curl -s https://repo1.maven.org/maven2/com/h2database/h2/1.4.200/h2-1.4.200.jar \
	-o /home/user/lib/h2.jar
