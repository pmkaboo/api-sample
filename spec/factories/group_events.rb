FactoryBot.define do
  factory :group_event do
    name { 'name' }
    factory :published_group_event do
      published { true }
      description { 'description' }
      location { 'location' }
      start_at { Date.today }
      end_at { Date.tomorrow }
      duration { 1 }
      factory :past_published_group_event do
        end_at { Date.yesterday }
      end
      factory :deleted_published_group_event do
        deleted_at { DateTime.now }
      end
      factory :invalid_published_group_event do
        name { nil }
      end
    end
    factory :unfinished_draft do
      location { 'draft location' }
    end
  end
end
