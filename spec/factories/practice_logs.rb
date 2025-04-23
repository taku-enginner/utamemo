FactoryBot.define do
  factory :practice_log do
    user { nil }
    memo { nil }
    song { "MyString" }
    placeholder_memo { "MyText" }
    practice_amount { 1 }
    mood { 1 }
    comment { "MyText" }
  end
end
