print('\n\n\n')
print(' -- Testing timer lib -- ')


print ("local timerSpambot = timer.create(0.333333, -1, function() print('Spambot timer: This happens every 1/3 second forever' ) end, true)")
local timerSpambot = timer.create(0.333333, -1, function() print('Spambot timer: This happens every 1/3 second forever' ) end, true)

print ("local timerTest2 = timer.create(8, 1, function() print('pause!') timer.pause(timerSpambot) end, true, true)")
local timerTest2 = timer.create(8, 1, function() print('pause!') timer.pause(timerSpambot) end, true, true)

print ("local timerTest3 = timer.create(10, 1, function() print('unpause!') timer.unpause(timerSpambot) end, true, false)")
local timerTest3 = timer.create(10, 1, function() print('unpause!') timer.unpause(timerSpambot) end, true, false)

print ("local timerTest4 = timer.create(12, 1, function() print('toggle!') timer.toggle(timerSpambot) end, true, false)")
local timerTest4 = timer.create(12, 1, function() print('toggle!') timer.toggle(timerSpambot) end, true, false)

print ("local timerTest5 = timer.create(\"timer_Test5\", 14, 1, function() print('toggle!') timer.toggle(timerSpambot) end, true, false)")
local timerTest5 = timer.create(14, 1, function() print('toggle!') timer.toggle(timerSpambot) end, true, false)

print ("timer.simple(15, function() print('Gandalf timer: It has been 15 seconds or more due to framerate drop! YOU SHALL NOT PASS! (Hopefully the test did)' ) timer.stop(timerSpambot) end)")
timer.simple(15, function() print('Gandalf timer: It has been 15 seconds or more due to framerate drop! YOU SHALL NOT PASS! (Hopefully the test did)' ) timer.stop(timerSpambot) end)

local function endTest ()
  print ("timer.remove(timerSpambot)")
  print( "=" .. tostring(timer.remove(timerSpambot)) )
  print ("timer.remove(timer_Test2)")
  print( "=" .. tostring(timer.remove(timerTest2)) )
  print ("timer.remove(timer_Test3)")
  print( "=" .. tostring(timer.remove(timerTest3)) )
  print ("timer.remove(timer_Test4)")
  print( "=" .. tostring(timer.remove(timerTest4)) )
  print ("timer.remove(timer_Test5)")
  print( "=" .. tostring(timer.remove(timerTest5)) )
  print ("timer.remove('timer_DoesntExist')")
  print( "=" .. tostring(timer.remove('timerDoesntExist')) )
  print(' -- End test -- ')
  print('\n\n\n')
end

print ("timer.simple(20, endTest)")
timer.simple(20, endTest)