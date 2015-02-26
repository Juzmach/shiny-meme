    def load_file (file_path)
        content = []
        if File.exists? file_path
            file = File.open(file_path)
            file.each_line { |line| content << line.strip }
        end
        content
    end
