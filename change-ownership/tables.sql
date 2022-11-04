SELECT format(
  'ALTER TABLE %I.%I.%I OWNER TO %I;',
  table_catalog,
  table_schema,
  table_name,
  'new-owner-name'  -- or another just put it in quotes
)
FROM information_schema.tables;