# frozen_string_literal: true

module DummyDataHelper
  def test_plans
    { plans: [
        {
            "id": '123',
            "name": 'plan',
            "age": '13'
        },
        {
            "id": '1234',
            "name": 'plan2',
            "age": '2'
        }
    ] }
  end
end