class SeparateStylesToOwnTable < ActiveRecord::Migration[8.0]
  def up
    create_table :styles do |t|
      t.string :text

      t.timestamps
    end

    Beer.distinct.pluck(:style).each do |style|
      Style.create(text: style)
    end

    rename_column :beers, :style, :old_style
    add_reference :beers, :style, foreign_key: true
    Beer.reset_column_information

    Beer.find_each do |beer|
      style = Style.find_by(text: beer.old_style)
      beer.update(style_id: style.id)
    end

    remove_column :beers, :old_style
  end

  def down
    add_column :beers, :str_style, :string

    Beer.find_each do |beer|
      beer.update(str_style: Style.find(beer.style.id).text)
    end

    remove_reference :beers, :style, foreign_key: true
    rename_column :beers, :str_style, :style

    drop_table :styles
  end
end
