#!/bin/bash
set -euo pipefail

: "${ORACLE_APP_PASSWORD:?ORACLE_APP_PASSWORD must be set}"

case "$ORACLE_APP_PASSWORD" in
  *"'"*|*'"'*)
    echo "ORACLE_APP_PASSWORD cannot contain quotes" >&2
    exit 1
    ;;
esac

sqlplus -s "system/${ORACLE_PWD}@FREEPDB1" <<SQL
WHENEVER SQLERROR EXIT SQL.SQLCODE
DECLARE
  user_count INTEGER;
BEGIN
  SELECT COUNT(*) INTO user_count FROM dba_users WHERE username = 'LECTURE_APP';
  IF user_count = 0 THEN
    EXECUTE IMMEDIATE 'CREATE USER lecture_app IDENTIFIED BY ${ORACLE_APP_PASSWORD}';
  END IF;
END;
/
GRANT CREATE SESSION TO lecture_app;
EXIT;
SQL
