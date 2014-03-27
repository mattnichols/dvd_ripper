require 'thread'

c = Thread.current

command = nil
a = Thread.new do
  while true
    command = gets
  end
end

t = Thread.new do
  while true
    sleep 5
    command = "h"
  end
end

Signal.trap("INT") do
  puts "Terminating..."
  t.wakeup
  a.wakeup
  
  t.kill  
  a.kill
  
  t.join
  a.join
  
  c.wakeup
  exit 0
end

while true
  while command.nil?
    sleep 1
  end
  puts "Got #{command}"
  command = nil
end