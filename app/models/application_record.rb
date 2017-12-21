class ApplicationRecord < ActiveRecord::Base

  self.abstract_class = true

  def generate_token(column)
    begin
      prefix ||= self.class.name[0]
      self[column] = SecureRandom.hex(4)
    end while self.class.exists?(column => self[column])
    self[column]
  end

end
