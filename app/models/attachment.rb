class Attachment

  def self.upload(id, attachment)
    dir_path = Pathname(Settings.image_path).join(id.to_s)
    FileUtils.mkdir_p(dir_path) unless FileTest.exists?(dir_path)
    file_path = dir_path.join(attachment.original_filename)
    File.open(file_path, mode = 'wb') {|f|
      f.write(attachment.read)
    }
  end

  def self.remove(id, filename = nil)
    dir_path = Pathname(Settings.image_path).join(id.to_s)
    if filename != nil
      file_path = dir_path.join(filename)
      File.unlink file_path if FileTest.exists?(file_path)
      return
    end
    Attachment.find(id.to_s).each {|f|
      file_path = dir_path.join(f)
      File.unlink file_path if FileTest.exists?(file_path)
    }
    Dir.unlink(dir_path) if FileTest.exists?(dir_path)
  end

  def self.find(id)
    rt = Array.new
    dir_path = Pathname(Settings.image_path).join(id.to_s)
    if FileTest.exists?(dir_path)
      Dir::entries(dir_path).each {|f|
        rt.push(f) if File::ftype(dir_path.join(f)) == 'file'
      }
    end
    return rt
  end

end
