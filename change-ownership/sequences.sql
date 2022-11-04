SELECT format(
  'ALTER SEQUENCE %I.%I.%I OWNER TO %I;',
  sequence_catalog,
  sequence_schema,
  sequence_name,
  'new-owner-name'  -- or another just put it in quotes
)
FROM information_schema.sequences;
