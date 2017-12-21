class Division < ApplicationRecord

  has_many :teams, dependent: :destroy
  has_many :players, dependent: :destroy

  after_initialize :set_defaults

  def set_defaults
    self[:uuid]   ||= generate_token(:uuid)
    self[:skills] ||= "Pitching,Catching,Overall"
  end

  def to_param
    self.uuid
  end

  def skills_a
    skills.split(',')
  end

end
