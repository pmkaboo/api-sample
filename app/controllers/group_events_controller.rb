class GroupEventsController < ApplicationController
  before_action :find_group_event, only: %i[show update destroy]

  def index
    render json: { group_events: GroupEvent.published.running.active }
  end

  def show
    render json: { group_event: @group_event }
  end

  def create
    group_event = GroupEvent.new(group_event_params)
    if group_event.save
      render json: {
        message: :group_event_created,
        group_event: group_event
      }
    else
      render json: {
        message: :group_event_create_failed,
        errors: group_event.errors.messages
      }
    end
  end

  def update
    if @group_event.update(group_event_params)
      render json: {
        message: :group_event_updated,
        group_event: @group_event
      }
    else
      render json: {
        message: :group_event_update_failed,
        errors: @group_event.errors.messages
      }
    end
  end

  def destroy
    @group_event.update_attribute :deleted_at, DateTime.now
    render json: { message: :group_event_deleted }
  end

  private

  def group_event_params
    params.require(:group_event).permit(
      :name, :description, :location, :start_at, :end_at, :duration, :published
    )
  end

  def find_group_event
    @group_event = GroupEvent.find_by(id: params[:id])
    return if @group_event

    render json: { message: :group_event_not_found, id: params[:id] }
  end
end
