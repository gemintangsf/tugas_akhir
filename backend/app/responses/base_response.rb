class BaseResponse
  def initialize(status, message, data, status_error_code = Constants::ERROR_CODE_VALIDATION, messsage_error_dev = nil, process_name = nil)
    @status = status
    @message = message
    @data = data
    @status_error_code = status_error_code
    @message_error_dev = messsage_error_dev
    @process_name = process_name
  end

  def get_status
    @status
  end

  def get_message
    @message
  end

  def get_data
    @data
  end

  def get_status_error_code
    @status_error_code
  end

  def get_message_error_dev
    @message_error_dev
  end

  def get_process_name
    @process_name
  end
end
  