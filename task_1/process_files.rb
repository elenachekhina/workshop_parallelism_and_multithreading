require 'async/scheduler'

# Генерация файлов для примера
files = 5.times.map do |i|
  filename = "file_#{i}.txt"
  File.open(filename, 'w') { |f| f.puts(Array.new(100_000) { "Line from #{filename}" }) }
  filename
end

def process_file(file)
  File.open(file, 'r') do |f|
    f.each_line { |line| puts line }
  end
end

# puts Sequentially
def process_files_sequentially(files)
  Fiber.schedule do
    files.each do |file|
      Fiber.schedule { process_file(file) }
    end
  end
end

scheduler = Async::Scheduler.new
Fiber.set_scheduler(scheduler)

start_time = Time.now
process_files_sequentially(files)
end_time = Time.now

# было: Время выполнения Sequentially: 5.024249 секунд
File.open('logs', 'w') { |f| f.puts("Время выполнения: #{end_time - start_time} секунд") }
