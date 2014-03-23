class Attachment

  def self.save(id, attachment, image_path = Settings.image_path)
    dir_path = Pathname(image_path).join(id.to_s)
    FileUtils.mkdir_p(dir_path) unless FileTest.exist?(dir_path)
    file_path = dir_path.join(attachment.original_filename)
    File.open(file_path, mode = 'wb') {|f|
      f.write(attachment.read)
    }
  end

  def self.remove_all(id, image_path = Settings.image_path)
    dir_path = Pathname(image_path).join(id.to_s)
    Attachment.find(id.to_s, image_path).each {|f|
      Attachment.remove(id.to_s, f, image_path) 
    }
    Dir.unlink(dir_path) if FileTest.exist?(dir_path)
  end

  def self.remove(id, filename, image_path = Settings.image_path)
    dir_path = Pathname(image_path).join(id.to_s)
    file_path = dir_path.join(filename)
    File.unlink file_path if FileTest.exist?(file_path)
  end

  def self.find(id, image_path = Settings.image_path)
    rt = Array.new
    dir_path = Pathname(image_path).join(id.to_s)
    if FileTest.exist?(dir_path)
      Dir::entries(dir_path).each {|f|
        rt.push(f) if FileTest.file?(dir_path.join(f))
      }
    end
    return rt
  end
end
