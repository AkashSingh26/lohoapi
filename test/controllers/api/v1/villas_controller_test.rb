require "test_helper"

class Api::V1::VillasControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get api_v1_villas_index_url
    assert_response :success
  end
end
