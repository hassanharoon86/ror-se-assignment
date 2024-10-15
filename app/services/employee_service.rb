require 'net/http'
require 'net/https'

class EmployeeService
  BASE_URL = 'https://dummy-employees-api-8bad748cda19.herokuapp.com/employees'.freeze

  def initialize
    @uri = URI(BASE_URL)
  end

  def fetch_employees(page: nil)
    uri = page ? URI("#{BASE_URL}?page=#{page}") : @uri
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def fetch_employee(id)
    uri = URI("#{BASE_URL}/#{id}")
    response = Net::HTTP.get(uri)
    JSON.parse(response)
  end

  def create_employee(employee_params)
    uri = URI(BASE_URL)
    request = Net::HTTP::Post.new(uri, 'Content-Type' => 'application/json')
    request.body = employee_params.to_json

    response = make_request(uri, request)
    JSON.parse(response.body)
  end

  def update_employee(id, employee_params)
    uri = URI("#{BASE_URL}/#{id}")
    request = Net::HTTP::Put.new(uri, 'Content-Type' => 'application/json')
    request.body = employee_params.to_json

    response = make_request(uri, request)
    JSON.parse(response.body)
  end

  private

  def make_request(uri, request)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    http.request(request)
  end
end
