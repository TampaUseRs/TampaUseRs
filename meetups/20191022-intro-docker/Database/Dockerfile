FROM postgres
ENV POSTGRES_USER docker
ENV POSTGRES_PASSWORD docker
ENV POSTGRES_DB docker
COPY ./setup.sh /docker-entrypoint-initdb.d/
EXPOSE 5432
