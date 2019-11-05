# frozen_string_literal: true

module Wellness
  RSpec.describe 'WellnessRouting', type: :routing do
    describe 'routing' do
      it 'routes to wellness plans #index' do
        expect(get: '/wellness/plans').to route_to('wellness/plans#index')
      end

      it 'routes to plan_services #index' do
        expect(get: '/wellness/plan_services').to route_to('wellness/plan_services#index')
      end

      it 'routes to contract_applications #index' do
        expect(get: '/wellness/contract_applications').to route_to('wellness/contract_applications#index')
      end

      it 'routes to contract_applications #show' do
        expect(get: '/wellness/contract_applications/1').to route_to('wellness/contract_applications#show', id: '1')
      end

      it 'routes to contract_applications #create' do
        expect(post: '/wellness/contract_applications').to route_to('wellness/contract_applications#create')
      end

      it 'routes to contract_applications agreements #show' do
        expect(get: '/wellness/contract_applications/agreements/1').to route_to('wellness/agreements#show', id: '1')
      end
    end
  end
end
