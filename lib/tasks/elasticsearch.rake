# frozen_string_literal: true
namespace :elasticsearch do
  desc 'Force recreate indices for all taggable entities'
  task force_reindex: :environment do
    Events::EsManage.call(:force_reindex)
  end

  desc 'Update all records in ES'
  task update_all: :environment do
    Events::EsManage.call(:update_all)
  end
end
