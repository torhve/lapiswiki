db = require "lapis.db"

import Model from require "lapis.db.model"
import slugify from require "lapis.util"

local *

class WikiPages extends Model
  @timestamp: true

  @create: (slug) =>

    slug = slugify slug

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

{
      :WikiPages, :Revisions
}
