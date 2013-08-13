module OwnerSlug
  def owner_slug
    owner.name.downcase.tr(' ', '-').gsub(/[^a-z-]/, '')
  end
end
