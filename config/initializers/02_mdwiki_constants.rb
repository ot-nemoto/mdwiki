# Loading Summary Cache
file_path = Pathname(Settings.data_path).join(Settings.summary_file)
if FileTest.exist?(file_path)
  File.open(file_path) {|f|
    SUMMARIES = JSON.parse(f.gets, {:symbolize_names => true})
  }
else
  SUMMARIES = Hash.new
end
