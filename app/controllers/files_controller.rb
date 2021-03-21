class FilesController < ApplicationController
  before_action :authenticate_user!
  after_action :verify_authorized

  def destroy
    @file = ActiveStorage::Attachment.find(params[:id])
    authorize @file.record, policy_class: FilePolicy
    @file.purge
  end
end
