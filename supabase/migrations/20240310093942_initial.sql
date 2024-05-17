CREATE TABLE bug (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  deleted_at TIMESTAMP
);

ALTER publication supabase_realtime ADD TABLE bug;