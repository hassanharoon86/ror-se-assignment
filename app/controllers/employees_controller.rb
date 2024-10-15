class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_employee_service

  def index
    @employees = @employee_service.fetch_employees(page: params[:page])
  end

  def edit
    @employee = @employee_service.fetch_employee(params[:id])
  end

  def show
    @employee = @employee_service.fetch_employee(params[:id])
  end

  def create
    @employee = @employee_service.create_employee(employee_params)
    redirect_to employee_path(@employee["id"])
  end

  def update
    @employee = @employee_service.update_employee(params[:id], employee_params)
    redirect_to edit_employee_path(@employee["id"])
  end

  private

  def employee_params
    params.slice(:name, :position, :date_of_birth, :salary)
  end

  def initialize_employee_service
    @employee_service = EmployeeService.new
  end
end
