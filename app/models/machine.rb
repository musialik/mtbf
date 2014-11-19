class Machine < ActiveRecord::Base
  has_many :defects

  def self.mtbf(after = nil, before = nil, ids = [])
    queried_machines = ids.any? ? find(ids) : all

    total_mtbfs = queried_machines.reduce(0) do |sum, machine|
      mtbf = machine.mtbf(after, before)
      mtbf ? sum + mtbf : sum
    end

    total_mtbfs / queried_machines.count
  end

  def mtbf(after = nil, before = nil)
    mean_time_between_failures(after, before)
  end

  def mean_time_between_failures(after = nil, before = nil)
    queried_defects = defects
    queried_defects = queried_defects.after(after) if after
    queried_defects = queried_defects.before(before) if before

    return nil if queried_defects.count < 2
    calculate_mtbf_for_defects(queried_defects)
  end

  private

  def calculate_mtbf_for_defects(queried_defects)
    state_changes = map_state_changes_from_defects(queried_defects)

    last_up = nil
    times_between_failures = 0
    total_time_between_failures = 0

    state_changes.each do |change|
      if change[:type] == :up
        last_up = change
      elsif last_up.present? and change[:type] == :down
        times_between_failures += 1
        total_time_between_failures += change[:time] - last_up[:time]
      end
    end

    total_time_between_failures / times_between_failures
  end

  def map_state_changes_from_defects(queried_defects)
    state_changes = []
    queried_defects.ordered.each do |defect, i|
      state_changes << { time: defect.started_at,  type: :down }
      state_changes << { time: defect.finished_at, type: :up }
    end
    return state_changes
  end
end
