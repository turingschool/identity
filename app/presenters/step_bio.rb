class Bio
  extend  ActiveModel::Naming
  include ActiveModel::Conversion

  def persisted?
    true
  end
end
