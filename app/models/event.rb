class Event < ActiveRecord::Base
  attr_accessible :content, :source, :tag

  validates_presence_of :tag, :content

  validates_inclusion_of :tag, in: %w{notice error warning}

  class << self
    def notices
      where{tag = 'notice'}
    end

    def errors
      where{tag = 'error'}
    end

    def warnings
      where{tag = 'warning'}
    end
  end
end
