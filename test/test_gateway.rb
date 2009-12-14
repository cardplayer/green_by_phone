require 'helper'

class TestGreenByPhone < Test::Unit::TestCase
  context "Gateway" do
    setup do
      FakeWeb.register_uri(
        :post, /#{GreenByPhone::Gateway::API_URL}*/,
        :body => successful_post_response)

      @gateway = GreenByPhone::Gateway.new(
        :login => fixture(:credentials)[:login],
        :password => fixture(:credentials)[:password])
    end

    should "one time draft bv" do
      response = @gateway.one_time_draft(test_data)

      assert true, response.success?
    end

    should "one time draft rtv" do
      response = @gateway.one_time_draft(test_data(:real_time => true))

      assert true, response.success?
    end

    should "recurring data bv" do
      response = @gateway.recurring_draft(test_data(
        :recurring_type => 'M',
        :recurring_offset => '1',
        :recurring_payments => '-1'))

      assert true, response.success?
    end

    should "recurring data rtv" do
      response = @gateway.recurring_draft(test_data(
        :real_time => true,
        :recurring_type => 'M',
        :recurring_offset => '1',
        :recurring_payments => '-1'))

      assert true, response.success?
    end

    should "verification result" do
      response = @gateway.recurring_draft(:check_id => 12345)

      assert true, response.success?
    end
  end

private

  def test_data(options = {})
    fixture(:data).merge(options)
  end

  def successful_post_response
    <<-EOF
    <DraftResult>
      <Result>0</Result>
      <ResultDescription>Data Accepted.</ResultDescription>
      <VerifyResult>0</VerifyResult>
      <VerifyResultDescription>Success</VerifyResultDescription>
      <CheckNumber>1234567890</CheckNumber>
      <Check_ID>1234567890</Check_ID>
    </DraftResult>
    EOF
  end
end
