edit dockerfile & replace `aarch64` With your platform

edit docker-compose.yml & update path in `device` (last line). put your duckdb file there as `main.db`

```docker-compose up```


postgres runs on port 5449;
```
username postgres
password qwert (or blank)
database name postgres
```

```psql -h localhost -p 5449 -U postgres```

```
CREATE EXTENSION duckdb_fdw;
   
CREATE SERVER duckdb_server                                              
FOREIGN DATA WRAPPER duckdb_fdw                                                     
OPTIONS (database '/pgduck/main.db');

IMPORT FOREIGN SCHEMA main from server duckdb_server into public;
```
more info at https://github.com/alitrack/duckdb_fdw
