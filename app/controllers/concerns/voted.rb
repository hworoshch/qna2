module Voted
  extend ActiveSupport::Concern

  def up
    vote = Vote.up(current_user, votable)
    respond_to do |format|
      format.json do
        if vote.nil? || vote.save
          render json: { object_id: votable.id, value: votable.rating, model: votable.class.name.underscore }
        else
          render json: vote.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def down
    vote = Vote.down(current_user, votable)
    respond_to do |format|
      format.json do
        if vote.nil? || vote.save
          render json: { object_id: votable.id, value: votable.rating, model: votable.class.name.underscore }
        else
          render json: vote.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def votable
    send(controller_name.singularize)
  end
end
