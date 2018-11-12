# frozen_string_literal: true

class User
  include Searchable

  def as_indexed_json(_options = {})
    {
      type: self.type,
      slug: self.slug,
      title: self.name,
      body: self.description,
      user_id: self.id
    }
  end

  def indexed_changed?
    saved_change_to_name? ||
    saved_change_to_description?
  end

  def self.prefix_search(term, user: nil, group: nil, repository: nil, limit: 30)
    following = []
    term = "#{term}%"
    users = User.where(type: "User")
      .where("slug ilike ? or email ilike ? or name ilike ?", term, term, term)
      .limit(limit).to_a

    following = []
    group_members = []
    repository_members = []

    users.unshift(*Array(following))
    users.uniq!
    users.compact!

    users.first(limit)
  end
end
