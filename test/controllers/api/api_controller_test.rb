require './test/test_helper'

class ApiControllerTest < ActionController::TestCase
  def test_it_is_unauthorized_when_it_fails_basic_auth
    assert_equal 401, get(:marco).status
  end

  def test_it_is_allowed_when_it_passes_basic_auth
    RemoteClient.create! name: 'register_for_class', secret: 'mah secret!'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic
                                          .encode_credentials(
                                            'register_for_class',
                                            'mah secret!'
                                          )
    response = get :marco
    assert_equal 200,    response.status
    assert_equal 'polo', response.body
  end
end
