module GreenByPhone
  class Response
    attr_reader :result, :result_description
    attr_reader :verify_result, :verify_result_description
    attr_reader :check_number, :check_id

    def self.new_from_request(options = {})
      self.new(
        :result => options['Result'],
        :result_description => options['ResultDescription'],
        :verify_result => options['VerifyResult'],
        :verify_result_description => options['VerifyResultDescription'],
        :check_number => options['CheckNumber'],
        :check_id => options['Check_ID'])
    end

    def initialize(options = {})
      @result = options[:result]
      @result_description = options[:result_escription]
      @verify_result = options[:verify_result]
      @verify_result_description = options[:verify_result_description]
      @check_number = options[:check_number]
      @check_id = options[:check_id]
    end

    def success?
      @result == 0 && @verification_result == 0
    end
  end
end
