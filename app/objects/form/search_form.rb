# frozen_string_literal: true

# Form object to render form elements and links. Rest is handled in JS.
class SearchForm
  include ActiveModel::Model
  # Turn into quasi ActiveModel #
  extend ActiveModel::Naming
  include Virtus.model
  include ActiveModel::Conversion

  # Extensions #
  extend Enumerize

  # Attributes (since this is not ActiveRecord) #

  attr_accessor :hits, :personal_hits, :remote_hits, :national_hits

  attribute :query, String
  attribute :search_location, String
  attribute :generated_geolocation, String

  ## Hidden Options

  # exact_location: Map had multiple markers on the same location and now the
  # search focusses only on that specific point.
  attribute :exact_location, Boolean, default: false

  # Filters

  CONTACT_TYPES = %i[personal remote].freeze
  attribute :contact_type, String, default: :personal
  enumerize :contact_type, in: CONTACT_TYPES
  ### Language
  attribute :language, String
  enumerize :language, in: LanguageFilter::IDENTIFIER
  ### Audience
  attribute :target_audience, String
  ### Gender
  attribute :exclusive_gender, String
  ### Sort Order
  attribute :sort_order, String, default: :relevance
  enumerize :sort_order, in: %i[nearby relevance]
  ### Section (world)
  attribute :section_identifier, String, default: :family
  ### ResidencyStatus
  attribute :residency_status, String
  enumerize :residency_status, in: TargetAudienceFiltersOffer::RESIDENCY_STATUSES

  # Methods #

  def initialize cookies, *attrs
    super(*attrs)
    return if exact_location
    if search_location.blank? # Blank location => use cookies or default fallback
      load_geolocation_values!(cookies)
    elsif current_location_list.include?(search_location) &&
          generated_geolocation.present? # if geolocation has been set, use it!
      generated_geolocation
    else
      self.generated_geolocation = search_location_instance.geoloc
    end
  end

  private

  def load_geolocation_values! cookies
    if cookies[:saved_search_location] && cookies[:saved_geolocation]
      self.search_location = cookies[:saved_search_location]
      self.generated_geolocation = cookies[:saved_geolocation]
    end
  end

  def search_location_instance
    @_search_location_instance ||=
      SearchLocation.find_or_generate(search_location)
  end

  def current_location_list
    %i[ar de en fa fr pl ru tr].map do |t|
      # I18n.backend.send(:translations)[t][:conf][:current_location]
      I18n.translate('conf.current_location', locale: t)
    end
  end
end
