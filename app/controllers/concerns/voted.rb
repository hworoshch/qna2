module Voted
  extend ActiveSupport::Concern

  def up
    vote = Vote.up(current_user, votable)
    respond_vote(vote)
  end

  def down
    vote = Vote.down(current_user, votable)
    respond_vote(vote)
  end

  private

  def votable
    @resource, @resource_id = request.path.split('/')[1, 2]
    @resource = @resource.singularize
    votable = @resource.classify.constantize.find(@resource_id)
    authorize votable, policy_class: VotePolicy
  end

  def respond_vote(vote)
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
end
