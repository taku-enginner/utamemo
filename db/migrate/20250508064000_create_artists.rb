# frozen_string_literal: true

class CreateArtists < ActiveRecord::Migration[7.2]
  def change
    create_table :artists do |t|
      t.string :name

      t.timestamps
    end
    reversible do |dir|
      dir.up do
        Artist.reset_column_information
        Artist.create!(name: 'Unknown')
      end
    end
  end
end
