EnablePrimaryMouseButtonEvents(true)

keyFloor = "x"
keyRoof  = "v"
keyWall  = "z"
keySteps = "c"
keyQuick = "q"
keyEdit  = "n"

setting = {
	arg1 = {
		"mouse1",
	},
	arg2 = {
		"mouse1",
	},
	arg4 = {
		"mouse1",
	},
	arg5 = {
		"mouse1",
	},
	arg6 = {
		"mouse1",
	},
}

function IsNumber(value)
	return nil ~= tonumber(value);
end

pk = {}
for key, btns in pairs(setting) do
	for i, btn in pairs(btns) do
		if IsNumber(btn) then
			btn = "_" .. btn
		end
		pk[btn] = false
	end
end

function ManageFlg(pressed, key, conditionsShift)
	if IsNumber(key) then
		key = "_" .. key
	end
	if pressed ~= pk[key] then
		pk[key] = pressed
		return true
	else
		return false
	end
end

function PressReleaseMouseButtonByFlg(button)
	local noStr = string.gsub(button, "mouse", "")
	local no = tonumber(noStr)
	if pk[button] then
		OutputLogMessage("PressMouseButton: "..no.."\n")
		PressMouseButton(no)
	else
		OutputLogMessage("ReleaseMouseButton: "..no.."\n")
		ReleaseMouseButton(no)
	end
end

function PressReleaseKeyByFlg(key)
	local ch = key
	if IsNumber(key) then
		key = "_" .. key
	end
	if pk[key] then
		OutputLogMessage("PressKey: "..ch.."\n")
		PressKey(ch)
	else
		OutputLogMessage("ReleaseKey: "..ch.."\n")
		ReleaseKey(ch)
	end
end

function PrePress(arg)
	local switchCases = {}
	switchCases[1] = function()
		PressAndReleaseKey(keyFloor)
	end
	switchCases[2] = function()
		PressAndReleaseKey(keyRoof)
	end
	switchCases[4] = function()
		PressAndReleaseKey(keyWall)
	end
	switchCases[5] = function()
		PressAndReleaseKey(keySteps)
	end
	switchCases[6] = function()
		PressAndReleaseKey(keyEdit)
		Sleep(15)
		PressAndReleaseMouseButton(3)
		Sleep(15)
	end
	local switchCase = switchCases[arg]
	if not switchCase then
		return
	end
	switchCase()
end

function OnEvent(event, arg)
	--OutputLogMessage("Event: "..event.." Arg: "..arg.."\n")
	if 0 >= arg then
		return
	end
	local pressed = "MOUSE_BUTTON_PRESSED" == event
	if pressed then
		PrePress(arg)
	end
	for key, btns in pairs(setting) do
		local no_str = string.gsub(key, "arg", "")
		local no = tonumber(no_str)
		if no ~= arg then
			goto continue
		end
		for i, btn in pairs(btns) do
			if nil == btn then
				goto continue
			end
			if not ManageFlg(pressed, btn, 1 ~= i) then
				goto continue
			end
			if nil == string.match(btn, "mouse") then
				PressReleaseKeyByFlg(btn)
			else
				PressReleaseMouseButtonByFlg(btn)
			end
			::continue::
		end
		::continue::
	end
end
