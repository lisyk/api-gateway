# frozen_string_literal: true

REQUEST_MAPPER = {
  'agreements' => {
    'index' => {
      method: 'get',
      resource: 'contractApplication'
    },
    'show' => {
      method: 'get',
      resource: 'contractApplicationAgreement'
    }
  },
  'contract_applications' => {
    'index' => {
      method: 'get',
      resource: 'contractApplication'
    },
    'show' => {
      method: 'get',
      resource: 'contractApplication'
    }
  },
  'wellness_plans' => {
    'index' => {
      method: 'get',
      resource: 'plans'
    }
  }
}.freeze
