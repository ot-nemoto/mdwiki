class Attachment

  def self.upload(id, attachment)
    dir_path = Pathname(Settings.image_path).join(id)
    FileUtils.mkdir_p(dir_path) unless FileTest.exists?(dir_path)
    file_path = dir_path.join(attachment.original_filename)
    File.open(file_path, mode = 'wb') {|f|
      f.write(attachment.read)
    }
  end

  def self.remove(id, filename)
    dir_path = Pathname(Settings.image_path).join(id)
    file_path = dir_path.join(filename)
    File.unlink file_path if FileTest.exists?(file_path)
  end

  def self.find(id)
    rt = Array.new
    dir_path = Pathname(Settings.image_path).join(id)
    if FileTest.exists?(dir_path)
      Dir::entries(dir_path).each {|f|
        rt.push(f) if File::ftype(dir_path.join(f)) == 'file'
      }
    end
    return rt
  end

end
