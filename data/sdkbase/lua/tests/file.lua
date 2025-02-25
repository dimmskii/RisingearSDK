print('\n\n\n')
print(' -- Testing file lib -- ')

print ("file.exists('lua/tests/test_lib_timer.lua')")
print( "=" .. tostring(file.exists('lua/tests/test_lib_timer.lua')) )
print ("file.exists('/lua/tests/test_lib_file.lua')")
print( "=" .. tostring(file.exists('/lua/tests/test_lib_file.lua')) )
print ("file.exists('/lua/')")
print( "=" .. tostring(file.exists('/lua/')) )
print ("file.exists('lua/thisisarandomfilethatprobablydontexist.lua')")
print( "=" .. tostring(file.exists('lua/thisisarandomfilethatprobablydontexist.lua')) )

print ("file.isDir('/lua/tests/test_lib_file.lua')")
print( "=" .. tostring(file.isDir('/lua/tests/test_lib_file.lua')) )
print ("file.isDir('lua')")
print( "=" .. tostring(file.isDir('lua')) )

print ("file.size('default.cfg')")
print( "=" .. tostring(file.size('default.cfg')) )
print ("file.size('/lua/')")
print( "=" .. tostring(file.size('/lua/')) )
print ("file.size('lua\\thisisarandomfilethatprobablydontexistbrah.lua')")
print( "=" .. tostring(file.size('lua\\thisisarandomfilethatprobablydontexistbrah.lua')) )

print ("local list = file.list('lua',true,true,true,true)")
local list = file.list('lua',true,true,true,true)
print( "for k, v in ipairs(list) do print(v) end" )
for k, v in ipairs(list) do print(v) end


print(' -- End test -- ')
print('\n\n\n')