require 'jsl/identity'
require 'jsl/identity/test'

module Jsl::Identity::TestHelpers
  def assert_same_interface(surrogate, actual)
    comparison = Surrogate::ApiComparer.new(surrogate, actual).compare

    # public instance methods
    assert_empty comparison[:instance][:not_on_actual   ] # on the interface that are not on the implementation
    assert_empty comparison[:instance][:not_on_surrogate] # on the implementation that are not on the api
    assert_empty comparison[:instance][:types           ] # on both, but don't take same types of args
    assert_empty comparison[:instance][:names           ] # on both, but the arg names don't match

    # public class methods
    assert_empty comparison[:class   ][:not_on_actual   ] # ditto the above
    assert_empty comparison[:class   ][:not_on_surrogate]
    assert_empty comparison[:class   ][:types           ]
    assert_empty comparison[:class   ][:names           ]
  end
end
