# frozen_string_literal: true

module PracticeLogHelper
  # rubocop:disable Style/HashLikeCase
  def mood_to_ja(str)
    case str
    when 'good'
      'よかった'
    when 'normal'
      'ふつう'
    when 'not-great'
      'いまいちだった'
    end
  end
end
# rubocop:enable Style/HashLikeCase
