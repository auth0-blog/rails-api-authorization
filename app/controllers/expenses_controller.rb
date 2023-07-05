class ExpensesController < ApplicationController
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
    @expense = Expense.new(expense_params)
    @expense.submitter_id = @user.id

    if @expense.save
      render json: { expense: @expense.as_json.merge(location: user_expense_url(@user, @expense)) }, status: :created
    else
      render json: @expense.errors, status: :unprocessable_entity
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
