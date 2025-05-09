# frozen_string_literal: true

FactoryBot.define do
  factory :memo do
    title { '本日のメモ' }
    publish { true }
    memo_components { [] }
  end
end
