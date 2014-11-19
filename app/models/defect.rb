class Defect < ActiveRecord::Base
  belongs_to :machine
  
  validate :defects_must_start_before_they_finish
  validate :defects_cant_overlap

  scope :ordered, -> { order(:started_at) }
  scope :before, ->(time) { where('started_at <= ?', time) }
  scope :after, ->(time) { where('started_at >= ?', time) }

  private

  def defects_must_start_before_they_finish
    if started_at > finished_at
      errors.add(:started_at, "Start time cannot be before finish time")
    end
  end

  def defects_cant_overlap
    if self.class.where('machine_id = :machine_id AND started_at >= :started_at AND started_at <= :finished_at', machine_id: machine_id, started_at: started_at, finished_at: finished_at).any? or
        self.class.where('machine_id = :machine_id AND finished_at >= :started_at AND finished_at <= :finished_at', machine_id: machine_id, started_at: started_at, finished_at: finished_at).any? or
        self.class.where('machine_id = :machine_id AND started_at <= :started_at AND finished_at >= :finished_at', machine_id: machine_id, started_at: started_at, finished_at: finished_at).any?

      errors.add(:base, "Defects can't overlap")
    end
  end
end
