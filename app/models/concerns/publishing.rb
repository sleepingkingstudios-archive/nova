# subl app/models/concerns/publishing.rb

module Publishing
  class << self
    def included other
      other.send :field, :published_at, :type => ActiveSupport::TimeWithZone

      other.send :scope, :published, ->() { other.where(:published_at.lt => Time.current) }
    end # class method included
  end # eigenclass

  def publish
    self.published_at = Time.current
  end # method publish

  def published?
    !published_at.blank? && published_at < Time.current
  end # method published?
end # module
