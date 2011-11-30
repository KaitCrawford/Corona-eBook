function wrap(str, limit, indent, indent1)
	indent = indent or ""
	indent1 = indent1 or indent
	limit = limit or 72
	local here = 1--#indent1
	return indent1..str:gsub("(%s+)()(%S+)()",
							function(sp, st, word, fi)
								if fi-here > limit then
									here = st - #indent
									return "\n"..indent..word
								end
							end)
end

function reflow(str, limit, indent, indent1)
  return (str:gsub("%s*\n%s+", "\n")
             :gsub("%s%s+", " ")
             :gsub("[^\n]+",
                   function(line)
                     return wrap(line, limit, indent, indent1)
                   end))
end

function wrappedText(str, limit, size, color, indent, indent1) 
	--apply line breaks using the wrapping function 
	str = reflow(str, limit, indent, indent1)
	size = size or 12
	color = color or {255, 255, 255}
	
	--search for each line that ends with a line break and add to an array
	local pos, arr = 0, {}
	for st,sp in function() return string.find(str,"\n",pos,true) end do
		table.insert(arr,string.sub(str,pos,st-1))
		pos = sp + 1
	end
	table.insert(arr,string.sub(str,pos))
	
	--iterate through the array and add each item as a display object to the group
	local g = display.newGroup()
	local i = 1 
    while i <= #arr do
		local t = display.newText( arr[i], 0, 0, 0, size )
		t:setTextColor( color[1], color[2], color[3] )
		t.xReference = -t.width/2
		t.x = 0
		t.yReference = -t.height/2 -20
		t.y = 14*(i-1)
		g:insert(t)
		i = i + 1
	end
	return g 
end


--[[local myText = display.newText( "Hello, World",0,0, nil, 36 )
local screenWidth = display.viewableContentWidth
local screenHeight = display.viewableContentHeight
myText.x = screenWidth / 2
myText.y = screenHeight / 6
myText:setTextColor(130,25,150)
local myText_startx = myText.x
local myText_starY = myText.y--]]

local path = system.pathForFile("WithinTemptation.txt", system.DocumentsDirectory)
local file, errStr = io.open(path, "r")

local pageContents = ""

--[[function fileRead()
	local pageText = ""
	local line = file:read("*l")
	local count = 1
	--while line and line ~= "#######################" do
	while count < 4 do
		pageText = pageText.."\n"..line
		line = file:read("*l")
		count = count +1
	end
	pageText = wrap(pageText, 48)
	return pageText
end--]]

if file then
	pageContents = file:read("*a") --fileRead()
	io.close(file)
	--myText.text = pageContents
else
	pageContents=errStr --myText.text = errStr
end

local myTextObject = wrappedText(pageContents, 55, 36)
local myGroup = display.newGroup()
myGroup:insert(myTextObject)

--[[local myText2 = display.newText("welcome", 0, 0, nil, 36)
myText2.alpha = 0
myText2.x = screenWidth
myText2.y = screenHeight / 6
local myText2_startx = myText2.x
local myText2_starY = myText2.y

local button = display.newImage("Icon.png")
button.x = screenWidth/2
button.y = screenHeight-50

function button:tap(event)
	transition.to(myText, {time=2000, alpha = 0, x = myText.x-screenWidth/2})
	transition.to(myText2, {time = 2000, alpha = 1, x = myText_startx})
	myText = myText2
	--mytext2 = some file input
	--for later when I actually have some free time. 
end

button:addEventListener("tap", button)--]]

