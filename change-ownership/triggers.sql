WITH INTERIM_TABLE AS (
    SELECT n.nspname AS function_schema,
        p.proname AS function_name
    FROM pg_proc p
        LEFT JOIN pg_namespace n ON p.pronamespace = n.oid
    WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
    ORDER BY function_schema,
        function_name
)
SELECT format(
        'ALTER FUNCTION %I.%I() OWNER TO %I;',
        function_schema,
        function_name,
        'new-owner-name' -- or another just put it in quotes
    )
FROM INTERIM_TABLE;