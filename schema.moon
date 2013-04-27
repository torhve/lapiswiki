db = require "lapis.nginx.postgres"
schema = require "lapis.db.schema"

import types, create_table, create_index, drop_table from schema

make_schema = ->
  {
    :serial
    :varchar
    :text
    :time
    :integer
    :foreign_key
    :boolean
  } = schema.types

  create_table "wiki_pages", {
    {"id", serial}
    {"slug", varchar}
    {"created_at", time}
    {"updated_at", time}

    "PRIMARY KEY (id)"
  }

  create_index "wiki_pages", "slug", unique: true

  create_table "revisions", {
    {"id", serial}
    {"wiki_page_id", foreign_key}
    {"content", text}
    {"created_at", time}
    {"updated_at", time}

    "PRIMARY KEY (id)"
  }

  create_index "revisions", "wiki_page_id"

  destroy_schema = ->
    tbls = {
      "wiki_pages", "revisions"
    }

    for t in *tbls
      drop_table t



{ :make_schema, :destroy_schema }
