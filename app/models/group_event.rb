class GroupEvent < ApplicationRecord
  validates :name, :description, :location,
            :start_at, :end_at, :duration,
            presence: true, if: :published?

  before_save :calculate_missing_attribute

  scope :active, -> { where(deleted_at: nil) }
  scope :running, -> { where('end_at > ?', Date.today) }
  scope :published, -> { where(published: true) }

  def published?
    published
  end

  private

  def calculate_missing_attribute
    calculate_start_at
    calculate_end_at
    calculate_duration
  end

  def calculate_start_at
    return unless end_at.present? && duration.present? && start_at.blank?

    self.start_at = end_at - duration.days
  end

  def calculate_end_at
    return unless start_at.present? && duration.present? && end_at.blank?

    self.end_at = start_at + duration.days
  end

  def calculate_duration
    return unless start_at.present? && end_at.present? && duration.blank?

    self.duration = (end_at - start_at).to_i
  end
end
