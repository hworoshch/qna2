class FilesController < ApplicationController
  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    @resource = @file.record_type.constantize.find(@file.record_id)
    @file.purge if current_user&.owner?(@resource)
  end
end
