class ReportsController < ApplicationController
  before_action :set_report, only: %i[ show approve ]
  before_action :set_user
  before_action :authorize

  # GET users/:user_id/reports/submitted
  def submitted
    @reports = Report.find(reports(@user, "submitter")) 

    render json: @reports if @reports
  end

  # GET users/:user_id/reports/review
  def review
    @reports = Report.find(reports(@user, "approver")).select{|r| r.status != "approved"}

    render json: @reports if @reports   
  end

  # PUT users/:user_id/reports/1/approve
  def approve
    if authorized?(@user, ["approver"], @report)
      if Date.current.on_weekday? # can only approve on weekdays
        @report.status = "approved"
        @report.save
        render json: @report
      else
        render json: {message: "Can only approve on weekdays"}, status: 401
      end
    else
      render json: {message: "You don't have permission to approve this report"}, status: 401
    end
  end

  # GET users/:user_id/reports/1
  def show
    # user can view if they are a submitter or approver of the report 
    if authorized?(@user, ["submitter", "approver"], @report)
      render json: @report
    else
      render json: {message: "You don't have permission to view this report"}, status: 401
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_report
      @report = Report.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end
end
