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

  -- WikiPages
  create_table "wiki_pages", {
    {"id", serial}
    {"slug", varchar}
    {"created_at", time}
    {"updated_at", time}

    "PRIMARY KEY (id)"
  }

  create_index "wiki_pages", "slug", unique: true

  -- Revisions
  create_table "revisions", {
    {"id", serial}
    {"wiki_page_id", foreign_key}
    {"content", text}
    {"creator_ip", varchar}
    {"created_at", time}
    {"updated_at", time}

    "PRIMARY KEY (id)"
  }

  create_index "revisions", "wiki_page_id"

  -- Tags
  create_table "tags", {
      {"id", serial}
      {"name", varchar}

      "PRIMARY KEY (id)"
  }
  create_index "tags", "name", unique: true
  
  -- Tag membership
  create_table "tags_page_relation", {
      {"id", serial}
      {"wiki_page_id", foreign_key}
      {"tags_id", foreign_key}

      "PRIMARY KEY (id)"
    }
  create_index "tags_page_relation", "wiki_page_id", "tags_id", unique: true

destroy_schema = ->
    tbls = {
        "wiki_pages", "revisions", "tags", "tags_page_relation"
    }

    for t in *tbls
        drop_table t



{ :make_schema, :destroy_schema }
