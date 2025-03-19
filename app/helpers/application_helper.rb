# frozen_string_literal: true

module ApplicationHelper
  def remove_invalid_chars(str)
    str.gsub(/[: ?、。！？]/, '')
  end

  def default_meta_tags # rubocop:disable Metyrics/MethodLength
    {
      site: 'UTAMEMO',
      title: 'UTAMEMO',
      reverse: true,
      charset: 'utf-8',
      description: '歌詞にメモを残せるアプリです',
      canonical: request.original_url,
      og: {
        site_name: 'UTAMEMO',
        title: 'UTAMEMO',
        description: '歌詞にメモを残せるアプリです',
        type: 'website',
        url: request.original_url,
        image: image_url('/default_share.png'),
        local: 'ja-JP'
      },
      twitter: {
        card: 'summary_large_image',
        site: '@https://x.com/memo_uta77982',
        image: image_url('/default_share.png')
      }
    }
  end
end
