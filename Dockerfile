FROM postgres:15

RUN apt-get update && apt-get install -y \
  git \
  build-essential \
  cmake

RUN apt-get install -y postgresql-server-dev-15 postgresql-client-15 wget unzip

RUN git clone -b makefile_version https://github.com/wearpants/duckdb_fdw.git  \
   && cd duckdb_fdw \
   && wget -c https://github.com/duckdb/duckdb/releases/latest/download/libduckdb-linux-aarch64.zip \
   && unzip -d . libduckdb-linux-aarch64.zip \
   && cp libduckdb.so $(pg_config --libdir)  \
   && make USE_PGXS=1 \
   && make install USE_PGXS=1

RUN apt-get install -y pgxnclient \
   && pgxnclient install foreign_table_exposer \
   && echo shared_preload_libraries = 'foreign_table_exposer' >> /var/lib/postgresql/data/postgresql.conf 

ENV POSTGRES_HOST_AUTH_METHOD='trust'
USER postgres
