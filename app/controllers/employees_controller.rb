class EmployeesController < ApplicationController
  before_action :authenticate_user!
  before_action :initialize_employee_service
  before_action :set_employee, only: %i[edit show update]

  def index
    @employees = @employee_service.fetch_employees(page: params[:page])
  end

  def edit; end

  def show; end

  def create
    @employee = @employee_service.create_employee(employee_params)

    if @employee
      redirect_to employee_path(@employee["id"]), notice: 'Employee was successfully created.'
    else
      flash.now[:alert] = 'Error creating employee.'
      render :new
    end
  end

  def update
    if @employee_service.update_employee(params[:id], employee_params)
      redirect_to employee_path(@employee["id"]), notice: 'Employee was successfully updated.'
    else
      flash.now[:alert] = 'Error updating employee.'
      render :edit
    end
  end

  private

  def employee_params
    params.slice(:name, :position, :date_of_birth, :salary)
  end

  def initialize_employee_service
    @employee_service = EmployeeService.new
  end

  def set_employee
    @employee = @employee_service.fetch_employee(params[:id])
  end
end
