require 'rails_helper'

describe GroupEvent, type: :model do
  context 'validations' do
    it 'should not publish without presence of all attributes' do
      group_event = GroupEvent.new(published: true)
      expect(group_event).to_not be_valid
    end

    it 'should publish with all attributes present' do
      group_event = GroupEvent.new(
        published: true,
        name: 'text',
        description: 'text',
        location: 'text',
        start_at: Date.today,
        end_at: Date.today,
        duration: 0
      )
      expect(group_event).to be_valid
    end

    it 'should not validate presence of attributes when saving a draft' do
      group_event = GroupEvent.new
      expect(group_event).to be_valid
    end
  end

  context 'calculate_missing_attribute' do
    it 'should calculate `start_at` when `end_at` and `duration` are present' do
      group_event = GroupEvent.new(
        end_at: Date.today,
        duration: 1
      )
      group_event.save
      expect(group_event.start_at).to eql Date.yesterday
    end

    it 'should calculate `end_at` when `start` and `duration` are present' do
      group_event = GroupEvent.new(
        start_at: Date.today,
        duration: 1
      )
      group_event.save
      expect(group_event.end_at).to eql Date.tomorrow
    end

    it 'should calculate `duration` when `start_at` and `end_at` are present' do
      group_event = GroupEvent.new(
        start_at: Date.today,
        end_at: Date.tomorrow
      )
      group_event.save
      expect(group_event.duration).to eql 1
    end

    it 'should not calculate any value when all are present' do
      # there is no way to know which two are correct
      group_event = GroupEvent.new(
        start_at: Date.today,
        end_at: Date.tomorrow,
        duration: 5
      )
      group_event.save
      expect(group_event.start_at).to eql Date.today
      expect(group_event.end_at).to eql Date.tomorrow
      expect(group_event.duration).to eql 5
    end
  end
end
