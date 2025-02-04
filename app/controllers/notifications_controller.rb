class NotificationsController < ApplicationController
  def index
    @notifications = Notification.includes(:product).recent
  end

  def mark_as_read
    @notification = Notification.find(params[:id])
    @notification.update(read_at: Time.current, status: :read)

    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to notifications_path }
    end
  end
end
