# frozen_string_literal: true

class Doc
  include Searchable

  def as_indexed_json(_options = {})
    {
      slug: self.slug,
      title: self.title,
      body: self.body_plain,
      search_body: self._search_body,
      repository_id: self.repository_id,
      user_id: self.repository.user_id,
      repository: {
        public: self.repository.public?,
      },
      deleted: self.deleted?
    }
  end

  def indexed_changed?
    saved_change_to_deleted_at? ||
    saved_change_to_title? ||
    body.changed?
  end

  def _search_body
    [self.repository&.user&.fullname, self.repository&.fullname, self.to_path, self.body_plain].join("\n\n")
  end
end
