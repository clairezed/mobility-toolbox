class ToolHelp < ApplicationRecord
  
  # Configurations =============================================================


  # Associations ===============================================================

  # Callbacks ==================================================================

  # Scopes =====================================================================

  
  # Class Methods ==============================================================

  def self.get(field)
    self.where(field: field).first
  end
  
  # Instance Methods ===========================================================

  def with_content?
    return !self.content.blank?
  end

  private #=====================================================================
  
end
