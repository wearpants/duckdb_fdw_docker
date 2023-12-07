FROM postgres:15

RUN apt-get update && apt-get install -y \
  git \
  build-essential \
  cmake \
  ninja-build

RUN apt-get install -y postgresql-server-dev-15 postgresql-client-15 wget unzip

RUN wget -nv -c -O duckdb-0.9.2.zip https://github.com/duckdb/duckdb/archive/refs/tags/v0.9.2.zip \
   && unzip -d . duckdb-0.9.2.zip \
   && cd duckdb-0.9.2\
   && GEN=ninja make

RUN git clone -b makefile_version https://github.com/wearpants/duckdb_fdw.git  \
   && cd duckdb_fdw \
   && cp ../duckdb-0.9.2/build/release/src/libduckdb.so $(pg_config --libdir)  \
   && make USE_PGXS=1 \
   && make install USE_PGXS=1

ENV POSTGRES_HOST_AUTH_METHOD='trust'
USER postgres
