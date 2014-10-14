class FiremanAvailability < ActiveRecord::Base

  belongs_to :station
  belongs_to :fireman

  validates_datetime :availability, :after => Date.today

  validates_presence_of :fireman_id
  validates_presence_of :availability
  validates_presence_of :station_id

  validates_uniqueness_of :fireman_id, :scope => :availability

  before_destroy :check_valid_date

  scope :limit_periods, lambda {|order| { :select => 'count(*) count, availability',
                                          :group => "availability",
                                          :order => order,
                                          :limit => 5}}

  private

  def check_valid_date
    availability > Date.current
  end
end
