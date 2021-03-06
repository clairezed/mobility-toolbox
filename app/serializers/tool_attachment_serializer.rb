# frozen_string_literal: true

class ToolAttachmentSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  include ToolFormatTypeHelper

  attributes  :id,
              :name,
              :size,
              :displayable,
              :url,
              :thumbnail_url,
              :delete_url,
              :admin_delete_url,
              :edit_url,
              :admin_edit_url,
              :format_icon,
              :format_title

  def name
    object.custom_file_name
  end

  def size
    object.asset_file_size
  end

  def displayable
    object.displayable?
  end

  def url
    object.asset.url
  end

  def thumbnail_url
    object.asset.url(:preview)
  end

  def edit_url
    edit_tool_attachment_path(object.assetable.id, object.id)
  end

  def admin_edit_url
    edit_admin_tool_attachment_path(object.assetable.id, object.id)
  end

  def delete_url
    tool_attachment_path(object.assetable.id, object.id)
  end

  def admin_delete_url
    admin_tool_attachment_path(object.assetable.id, object.id)
  end

  def format_icon
    tool_format_type_icon(object.format_type)
  end

  def format_title
    tool_format_type_title(object.format_type)
  end
end
