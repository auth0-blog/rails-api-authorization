class ExpensesController < ApplicationController
  before_action :authorize
  before_action :set_user
  before_action :set_expense, only: %i[ show update destroy ]

  # GET users/:user_id/expenses
  def index
    @expenses = Expense.where(submitter_id: @user.id)

    render json: @expenses
  end

  # GET users/:user_id/expenses/1
  def show
    render json: @expense
  end

  # POST users/:user_id/expenses
  def create
    ActiveRecord::Base.transaction do
      @expense = Expense.new(expense_params)
      @expense.submitter_id = @user.id

      if @expense.save
        Report.create(expense: @expense, submitter_id: @expense.submitter_id)
        render json: @expense, status: :created
      else
        render json: @expense.errors, status: :unprocessable_entity
        raise ActiveRecord::Rollback # Rollback the transaction if saving the expense fails
      end
    end
  end

  # PATCH/PUT users/:user_id/expenses/1
  def update
    if @expense.update(expense_params)
      render json: @expense
    else
      render json: @expense.errors, status: :unprocessable_entity
    end
  end

  # DELETE users/:user_id/expenses/1
  def destroy
    @expense.report.destroy
    @expense.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_expense
      @expense = Expense.find(params[:id])
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    # Only allow a list of trusted parameters through.
    def expense_params
      params.require(:expense).permit(:reason, :date, :amount)
    end
end
