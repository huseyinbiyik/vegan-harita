require 'test_helper'

class PlaceTest < ActiveSupport::TestCase
  def setup
    @place = Place.new(name: 'Test Place', address: '123 Test St', place_id: '1', latitude: '40.7128')
  end

  def teardown
    @place = nil
  end

  test 'should be valid' do
    assert @place.valid?
  end

  test 'name should be present' do
    @place.name = ''
    assert_not @place.valid?
    assert_equal ["can't be blank"], @place.errors[:name]
  end

  test 'name should not be too long' do
    @place.name = 'a' * 81
    assert_not @place.valid?
    assert_equal ['is too long (maximum is 80 characters)'], @place.errors[:name]
  end

  test 'address should be present' do
    @place.address = ''
    assert_not @place.valid?
    assert_equal ["can't be blank"], @place.errors[:address]
  end

  test 'address should not be too long' do
    @place.address = 'a' * 501
    assert_not @place.valid?
    assert_equal ['is too long (maximum is 500 characters)'], @place.errors[:address]
  end

  test 'address should be unique' do
    duplicate_place = @place.dup
    @place.save
    assert_not duplicate_place.valid?
    assert_equal ['has already been taken'], duplicate_place.errors[:address]
  end

  test 'place_id should be present' do
    @place.place_id = ''
    assert_not @place.valid?
    assert_equal ["can't be blank"], @place.errors[:place_id]
  end

  test 'place_id should be unique' do
    duplicate_place = @place.dup
    @place.save
    assert_not duplicate_place.valid?
    assert_equal ['has already been taken'], duplicate_place.errors[:place_id]
  end

  test 'latitude should be present' do
    @place.latitude = ''
    assert_not @place.valid?
    assert_equal ['Please pick a location provided by Google Maps for the address you entered'],
                 @place.errors[:latitude]
  end

  test 'instagram_handle should be valid' do
    @place.instagram_handle = 'instagram.com/invalid'
    assert_not @place.valid?
    assert_equal I18n.t('activerecord.attributes.place.instagram_invalid'), @place.errors[:instagram_handle].first
  end

  test 'instagram_handle should not be too long' do
    @place.instagram_handle = 'a' * 31
    assert_not @place.valid?
    assert_equal ['is too long (maximum is 30 characters)'], @place.errors[:instagram_handle]
  end

  test 'instagram_handle can be blank' do
    @place.instagram_handle = ''
    assert @place.valid?
  end

  test 'facebook_handle should be valid' do
    @place.facebook_handle = 'facebook.com/invalid'
    assert_not @place.valid?
    assert_equal I18n.t('activerecord.attributes.place.facebook_invalid'), @place.errors[:facebook_handle].first
  end

  test 'facebook_handle should not be too long' do
    @place.facebook_handle = 'a' * 51
    assert_not @place.valid?
    assert_equal ['is too long (maximum is 50 characters)'], @place.errors[:facebook_handle]
  end

  test 'facebook_handle can be blank' do
    @place.facebook_handle = ''
    assert @place.valid?
  end

  test 'x_handle should be valid' do
    @place.x_handle = 'x.com/invalid'
    assert_not @place.valid?
    assert_equal I18n.t('activerecord.attributes.place.x_invalid'), @place.errors[:x_handle].first
  end

  test 'x_handle should not be too long' do
    @place.x_handle = 'a' * 51
    assert_not @place.valid?
    assert_equal ['is too long (maximum is 50 characters)'], @place.errors[:x_handle]
  end

  test 'x_handle can be blank' do
    @place.x_handle = ''
    assert @place.valid?
  end

  test 'web url should be like google.com' do
    @place.web_url = 'google.com'
    assert @place.valid?
  end

  test 'web_url shouldn not be a simple string' do
    @place.web_url = 'invalid'
    assert_not @place.valid?
    assert_equal ['is invalid'], @place.errors[:web_url]
  end

  test 'web_url should not start with https' do
    @place.web_url = 'https://www.google.com'
    assert_not @place.valid?
    assert_equal ['is invalid'], @place.errors[:web_url]
  end

  test 'web_url should not start with http' do
    @place.web_url = 'http://www.google.com'
    assert_not @place.valid?
    assert_equal ['is invalid'], @place.errors[:web_url]
  end

  test 'web_url should not start with www' do
    @place.web_url = 'www.google.com'
    assert_not @place.valid?
    assert_equal ['is invalid'], @place.errors[:web_url]
  end

  test 'web_url can start with subdomains' do
    @place.web_url = 'subdomain.google.com'
    assert @place.valid?
  end

  test 'web_url can end with a path' do
    @place.web_url = 'google.com/path'
    assert @place.valid?
  end

  test 'web_url can be blank' do
    @place.web_url = ''
    assert @place.valid?
  end

  test 'email should be a simple email address' do
    @place.email = 'huseyin@gmail.com'
    assert @place.valid?
  end

  test 'email should not be a simple string' do
    @place.email = 'invalid'
    assert_not @place.valid?
    assert_equal ['is invalid'], @place.errors[:email]
  end

  test 'email can be blank' do
    @place.email = ''
    assert @place.valid?
  end

  test 'phone should be a valid phone number' do
    @place.phone = '5555555555'
    assert @place.valid?
  end

  test 'phone can be landline' do
    @place.phone = '2125555555'
    assert @place.valid?
  end

  test 'phone can not be more than 10 digits' do
    @place.phone = '55555555555'
    assert_not @place.valid?
    assert_equal ['is invalid'], @place.errors[:phone]
  end

  test 'phone should not be string' do
    @place.phone = 'invalid'
    assert_not @place.valid?
    assert_equal ['is invalid'], @place.errors[:phone]
  end

  test 'phone can be blank' do
    @place.phone = ''
    assert @place.valid?
  end
end
