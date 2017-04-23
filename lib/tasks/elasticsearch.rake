namespace :elasticsearch do
  desc 'Force recreate indices for all taggable entities'
  task force_reindex: :environment do
    Tag.taggable_kinds.values.each do |t|
      t.__elasticsearch__.create_index!(force: true)
      t.import
    end
  end

  desc 'Update all records in ES'
  task update_all: :environment do
    Tag.taggable_kinds.values.each(&:import)
  end
end
