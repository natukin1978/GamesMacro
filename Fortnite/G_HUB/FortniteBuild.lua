EnablePrimaryMouseButtonEvents(true)

keyFloor = "x"
keyRoof  = "v"
keyWall  = "z"
keySteps = "c"
keyQuick = "q"
keyEdit  = "g"

keyTrap  = "y"
keyCM    = "mouse3"
keyRo    = "r"
keyRe    = "h"

setting = {
	arg1 = {
		"mouse1",
		"mouse1",
	},
	arg2 = {
		"mouse1",
		keyCM,
	},
	arg3 = {
		keyQuick,
		nil,
	},
	arg4 = {
		"mouse1",
		keyRe,
	},
	arg5 = {
		"mouse1",
		keyRo,
	},
	arg6 = {
		"mouse1",
		nil,
	},
}

shifting = false

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
	local flg = nil
	if pressed then
		if conditionsShift == shifting then
			flg = pressed
		end
	else
		flg = pressed
	end
	if nil == flg then
		return false
	end
	if flg ~= pk[key] then
		pk[key] = flg
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
		if shifting then
			PressAndReleaseKey(keyTrap)
			Sleep(50) -- safety
		else
			PressAndReleaseKey(keyFloor)
		end
	end
	switchCases[2] = function()
		if shifting then
			return;
		end
		PressAndReleaseKey(keyRoof)
	end
	switchCases[4] = function()
		if shifting then
			return;
		end
		PressAndReleaseKey(keyWall)
	end
	switchCases[5] = function()
		--if shifting then
		--	return;
		--end
		PressAndReleaseKey(keySteps)
	end
	switchCases[6] = function()
		if shifting then
			return;
		end
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
	shifting = IsModifierPressed("lshift")
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
