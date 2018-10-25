class ActivityType < ActiveRecord::Base
    validates :name,
        presence: true,
        length: 5..50,
        on: :create,
        allow_nil: false
        
    validates :score,
        presence: true,
        on: :create,
        allow_nil: false
end
