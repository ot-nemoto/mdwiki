# Loading Summary Cache
file_path = Pathname(Settings.data_path).join(Settings.summary_file)
if FileTest.exist?(file_path)
  File.open(file_path) {|f|
    SUMMARIES = JSON.parse(f.gets, {:symbolize_names => true})
  }
else
  SUMMARIES = Hash.new
end

# Loading Users Cache
users_conf = Pathname(Settings.users_conf_path).join(Settings.users_conf)
if FileTest.exist?(file_path)
  USERS = YAML.load_file(users_conf);
  USERS.symbolize_keys!
  USERS[:users].each{|u|
    u.symbolize_keys!
  }
end
