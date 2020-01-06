# frozen_string_literal: true

module Wellness
  RSpec.describe 'WellnessRouting', type: :routing do
    describe 'routing' do
      context 'Wellness Plans' do
        it 'routes to wellness plans #index' do
          expect(get: '/wellness/plans').to route_to('wellness/plans#index')
        end

        it 'routes to wellness plans #show' do
          expect(get: '/wellness/plans/1').to route_to('wellness/plans#show', id: '1')
        end
      end

      context 'Plan Services' do
        it 'routes to plan_services #index' do
          expect(get: '/wellness/plan_services').to route_to('wellness/plan_services#index')
        end

        it 'routes to plan_services #show' do
          expect(get: '/wellness/plan_services/1').to route_to('wellness/plan_services#show', id: '1')
        end
      end

      context 'Contract Applications' do
        it 'routes to contract_applications #index' do
          expect(get: '/wellness/contract_applications').to route_to('wellness/contract_applications#index')
        end

        it 'routes to contract_applications #show' do
          expect(get: '/wellness/contract_applications/1').to route_to('wellness/contract_applications#show', id: '1')
        end

        it 'routes to contract_applications #create' do
          expect(post: '/wellness/contract_applications').to route_to('wellness/contract_applications#create')
        end

        it 'routes to contract_applications #update' do
          expect(put: '/wellness/contract_applications/1').to route_to('wellness/contract_applications#update', id: '1')
        end
      end

      context 'Agreements' do
        it 'routes to contract_applications agreements #show' do
          expect(get: '/wellness/contract_applications/agreements/1').to route_to('wellness/agreements#show', id: '1')
        end

        it 'routes to contract_applications agreements #update' do
          expect(put: '/wellness/contract_applications/agreements/1').to route_to('wellness/agreements#update', id: '1')
        end
      end

      context 'Contract Services' do
        it 'routes to contract_services #index' do
          expect(get: '/wellness/contract_applications/agreements/1').to route_to('wellness/agreements#show', id: '1')
        end

        it 'routes to contract_applications agreements #update' do
          expect(put: '/wellness/contract_applications/agreements/1').to route_to('wellness/agreements#update', id: '1')
        end
      end

      context 'Contracts' do
        it 'routes to contracts #index' do
          expect(get: '/wellness/contracts').to route_to('wellness/contracts#index')
        end

        it 'routes to contracts #show' do
          expect(get: '/wellness/contracts/1').to route_to('wellness/contracts#show', id: '1')
        end
      end

      context 'Application Workflows' do
        it 'routes to application_workflows application workflows #create' do
          expect(post: '/wellness/initiate_application').to route_to('wellness/application_workflows#create')
        end
      end
    end
  end
end
