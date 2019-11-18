require 'rails_helper'

describe GroupEventsController, type: :controller do
  describe 'GET #index' do
    it 'returns published running active events' do
      create(:group_event)
      published_group_event = create(:published_group_event)
      create(:past_published_group_event)
      create(:deleted_published_group_event)

      get :index
      group_events = JSON.parse(response.body)['group_events']

      expect(group_events.size).to eql 1
      expect(group_events.first['id']).to eql published_group_event.id
    end
  end

  describe 'POST #create' do
    context 'published event' do
      context 'with all attributes' do
        it 'creates the group event' do
          post :create, params: { group_event: attributes_for(:published_group_event) }

          expect(GroupEvent.count).to eql 1
        end
      end

      context 'without all attributes' do
        it 'does not create the group event' do
          post :create, params: { group_event: attributes_for(:invalid_published_group_event) }

          expect(GroupEvent.count).to eql 0
        end
      end
    end

    context 'draft' do
      it 'creates the group event' do
        post :create, params: { group_event: attributes_for(:group_event) }

        expect(GroupEvent.count).to eql 1
      end
    end
  end

  describe 'PUT #update' do
    let(:group_event) { create(:group_event) }

    context 'published event' do
      context 'with all attributes' do
        it 'updates the group event' do
          put :update, params: {
            group_event: attributes_for(:published_group_event),
            id: group_event.id
          }
          message = JSON.parse(response.body)['message']
          group_event.reload

          expect(message).to eql 'group_event_updated'
          expect(group_event.location).to eql 'location'
        end
      end

      context 'without all attributes' do
        it 'does not update the group event' do
          put :update, params: {
            group_event: attributes_for(:invalid_published_group_event),
            id: group_event.id
          }
          message = JSON.parse(response.body)['message']
          group_event.reload

          expect(message).to eql 'group_event_update_failed'
          expect(group_event.location).to be_nil
        end
      end
    end

    context 'draft' do
      it 'updates the group event' do
        put :update, params: {
          group_event: attributes_for(:unfinished_draft),
          id: group_event.id
        }
        message = JSON.parse(response.body)['message']
        group_event.reload

        expect(message).to eql 'group_event_updated'
        expect(group_event.location).to eql 'draft location'
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'flags the event as deleted' do
      group_event = create(:group_event)
      delete :destroy, params: { id: group_event.id }
      message = JSON.parse(response.body)['message']
      group_event.reload

      expect(message).to eql 'group_event_deleted'
      expect(group_event.deleted_at).to_not be_nil
    end
  end

  describe '#find_group_event' do
    it 'renders event not found message' do
      get :show, params: { id: 42 }
      message = JSON.parse(response.body)['message']

      expect(message).to eql 'group_event_not_found'
    end
  end
end
