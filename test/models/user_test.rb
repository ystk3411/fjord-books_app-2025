# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test '#name_or_email when both name and email are present' do
    user = User.new(name: 'Bob', email: 'bob@example.com')
    assert_equal 'Bob', user.name_or_email
  end

  test '#name_or_email when name is blank' do
    user = User.new(name: '', email: 'bob@example.com')
    assert_equal 'bob@example.com', user.name_or_email
  end
end
