FROM amazeeio/python:2.7-ckan

ENV DOCKERIZE_VERSION v0.6.1
RUN wget https://github.com/jwilder/dockerize/releases/download/$DOCKERIZE_VERSION/dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && tar -C /usr/local/bin -xzvf dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz \
    && rm dockerize-alpine-linux-amd64-$DOCKERIZE_VERSION.tar.gz

# Copy CKAN core into container and install
COPY ckan/ckan_core/ /app/ckan/default/src/ckan

RUN . /app/ckan/default/bin/activate \
	&& cd /app/ckan/default/src/ckan \
	&& pip install -e /app/ckan/default/src/ckan/ \
	&& sed -i 's/psycopg2==2.4.5/psycopg2==2.7.7/g' /app/ckan/default/src/ckan/requirements.txt \
	&& pip install -r '/app/ckan/default/src/ckan/requirements.txt' \
	&& ln -s /app/ckan/default/src/ckan/who.ini /app/ckan/default/who.ini \
	&& deactivate
