# Create data directory
FileUtils.mkdir_p(Settings.data_path) \
  unless FileTest.exist?(Settings.data_path)

FileUtils.mkdir_p(Settings.image_path) \
  unless FileTest.exist?(Settings.image_path)
