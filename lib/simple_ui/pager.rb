module SimpleUi
  class Pager
    def show(data_holder)
      puts "read '#{data_holder.title}'"

      file_path = configatron.simple_ui.buffer_path
      file = File.open(file_path, 'w') {|f| f.puts data_holder.content }
      system("#{configatron.simple_ui.pager} #{file_path}")

    end
  end
end
