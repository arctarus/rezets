namespace :gettext do

  desc "Update pot/po files."
  task :updatepo do
    require 'gettext_rails/tools'  #HERE!
    GetText::ActiveRecordParser.init(:use_classname => false, :db_mode => "development")  # default db_mode is development.
    GetText.update_pofiles("recipemonkey", Dir.glob("{app,lib,bin}/**/*.{rb,erb,rjs}"), "recipemonkey 0.1")
  end

  desc "Create mo-files"
  task :makemo do
    require 'gettext_rails/tools'  #HERE!
    GetText.create_mofiles
  end

end
