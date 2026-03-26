class ErrorsController < ApplicationController
  # Evitar que requiera el menú lateral o verificación de token en la página de error
  layout false

  def not_found
    render status: :not_found
  end

  def internal_server_error
    render status: :internal_server_error
  end
end