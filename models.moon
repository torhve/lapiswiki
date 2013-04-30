db = require "lapis.db"

import Model from require "lapis.db.model"

local *

class WikiPages extends Model
  @timestamp: true

  @create: (slug) =>

    --if @check_unique_constraint 'slug', slug
    --  return nil, "Page already exists"

    Model.create @, {
      slug: slug
    }

  @current: =>
    Revision\select "where page_id = ?", @id

class Revisions extends Model
  @timestamp: true

  @create: (page, content, ip) =>

    Model.create @, {
      wiki_page_id: page.id
      content: content
      creator_ip: ip
    }

class Tags extends Model
  @create: (name) =>

    Model.create @, {
      name: name\lower!
    }

class TagsPageRelation extends Model
  @create: (wiki_page_id, tags_id) =>

    Model.create @, {
        wiki_page_id: wiki_page_id
        tags_id: tags_id
    }
{
      :WikiPages, :Revisions, :Tags, :TagsPageRelation
}
