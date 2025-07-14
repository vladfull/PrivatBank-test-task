FROM postgres:16

RUN apt-get update \
  && apt-get install -y postgresql-server-dev-16 postgresql-16-cron build-essential git \
  && rm -rf /var/lib/apt/lists/*

RUN echo "shared_preload_libraries = 'pg_cron'" >> /usr/share/postgresql/postgresql.conf.sample