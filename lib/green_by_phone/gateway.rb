module GreenByPhone
  class Gateway
    API_URL = 'https://www.greenbyphone.com/eCheck.asmx'

    def initialize(options = {})
      @login = options[:login]
      @password = options[:password]
    end

    def one_time_draft(options = {})
      post = {}
      add_customer(post, options)
      add_check(post, options)
      commit(options[:real_time] ? 'OneTimeDraftRTV' : 'OneTimeDraftBV', post)
    end

    def recurring_draft(options = {})
      post = {}
      add_customer(post, options)
      add_check(post, options)
      add_recurring(post, options)
      commit(options[:real_time] ? 'RecurringDraftRTV' : 'RecurringDraftBV', post)
    end

    def verification_result(options = {})
      post = { 'Check_ID' => options[:check_id] }
      commit('VerificationResult', post)
    end

  private

    def add_customer(post, options)
      post['Name'] = options[:name]
      post['EmailAddress'] = options[:email_address]
      post['Phone'] = options[:phone]
      post['PhoneExtension'] = options[:phone_extension]
      post['address1'] = options[:address1]
      post['address2'] = options[:address2]
      post['city'] = options[:city]
      post['state'] = options[:state]
      post['Zip'] = options[:zip]
    end

    def add_check(post, options)
      post['RoutingNumber'] = options[:routing_number]
      post['AccountNumber'] = options[:account_number]
      post['BankName'] = options[:bank_name]
      post['CheckAmount'] = options[:check_amount]
      post['CheckDate'] = options[:check_date]
      post['CheckMemo'] = options[:check_memo]
    end

    def add_recurring(post, options)
      post['RecurringType'] = options[:recurring_type]
      post['RecurringOffset'] = options[:recurring_offset]
      post['RecurringPayments'] = options[:recurring_payments]
    end

    def parse(response)
      Crack::XML.parse(response)
    end

    def commit(action, post)
      post['Client_ID'] = @login
      post['ApiPassword'] = @password

      uri = URI.parse(API_URL + "/#{action}")

      request = Net::HTTP.new(uri.host, 443)
      request.use_ssl = true
      data = parse(request.post(uri.path, post.collect { |k,v| "#{k}=#{v}" }.join('&')).body)

      Response.new_from_request(data['DraftResult'])
    end
  end
end
