class ToolSetter

  def initialize(tool, params={})
    @tool = tool
    @params = params
  end

  def call
    manage_tags
    @tool.attributes = @params
    return @tool
  end

  def manage_tags
    # grab eventual new tags (everything that is neither blank nor an id in params[:tag_ids])
    new_tag_titles = @params["tag_ids"]
      .reject!{|t| t.blank?}
      .reject{|t| Tag.where(id: t.to_i).any? }

    new_tag_ids = new_tag_titles.inject([]) do |array, tag_title|
      t = Tag.where(title: tag_title).first_or_create
      array.push(t.id)
    end

    # replace tag_titles with newly created tags ids
    @params["tag_ids"] = @params["tag_ids"] - new_tag_titles + new_tag_ids
  end


end