SELECT DISTINCT format(
        'ALTER SCHEMA %I OWNER TO %I;',
        table_schema,
        'new-owner-name' -- new owner name; put it in quotes
    )
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');