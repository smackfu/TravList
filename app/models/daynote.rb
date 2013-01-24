class Daynote < ActiveRecord::Base
  belongs_to :userplace
  belongs_to :notetype
  validates_presence_of :comment
end
