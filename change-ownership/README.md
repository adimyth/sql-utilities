# Change Ownership

This folder contains scripts to change the ownership of different database objects -

1. Schemas
2. Tables
3. Seqeuences
4. Triggers

### 1️⃣ Schemas

Fetch all unique schemas & generate alter statements for each schema

```sql
SELECT DISTINCT format(
  'ALTER SCHEMA %I OWNER TO %I;',
  table_schema,
  'new-owner-name'  -- new owner name; put it in quotes
)
FROM information_schema.tables
WHERE table_schema NOT IN ('pg_catalog', 'information_schema');
```

Paste the output of the above sql query & run it in a new transaction.

### 2️⃣ Tables

Fetch all tables from all schemas & generate alter statements to change ownership

```sql
SELECT format(
  'ALTER TABLE %I.%I.%I OWNER TO %I;',
  table_catalog,
  table_schema,
  table_name,
  'new-owner-name'  -- or another just put it in quotes
)
FROM information_schema.tables;
```

Paste the output of the above sql query & run it in a new transaction.

### 3️⃣ Sequences

Fetch all sequences from all schemas & generate alter statements to change ownership

```sql
SELECT format(
  'ALTER SEQUENCE %I.%I.%I OWNER TO %I;',
  sequence_catalog,
  sequence_schema,
  sequence_name,
  'new-owner-name'  -- or another just put it in quotes
)
FROM information_schema.sequences;
```

Paste the output of the above sql query & run it in a new transaction.

### 4️⃣ Triggers

https://www.enterprisedb.com/docs/epas/latest/epas_compat_sql/13_alter_trigger/

Fetch all triggers for all schema-tables & generate alter statements to change ownership

```sql
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
```

Paste the output of the above sql query & run it in a new transaction.
