FROM liquibase/liquibase

COPY changelog.yaml changelog.yaml
COPY migrations/ migrations/

CMD liquibase update \
  --changeLogFile=changelog.yaml \
  --url="jdbc:postgresql://${POSTGRES_HOST}:${POSTGRES_PORT}/${POSTGRES_DB}?sslmode=disable" \
  --username="${POSTGRES_USER}" \
  --password="${POSTGRES_PASSWORD}" \
  --logLevel=info