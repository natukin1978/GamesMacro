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

setting_ = {
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

function GetSettingBtns(arg)
	local key = "arg" .. arg
	return setting_[key]
end

function IsPress(btn)
	return press_[btn]
end

function SetPress(btn, value)
	press_[btn] = value
end

function ManageFlg(pressed, key, conditionsShift)
	local flg = nil
	if pressed then
		if conditionsShift == shifting_ then
			flg = pressed
		end
	else
		flg = pressed
	end
	if nil == flg then
		return false
	end
	if flg ~= IsPress(key) then
		SetPress(key, flg)
		return true
	else
		return false
	end
end

function PressReleaseMouseButtonByFlg(button)
	local noStr = string.gsub(button, "mouse", "")
	local no = tonumber(noStr)
	if IsPress(button) then
		OutputLogMessage("PressMouseButton: "..no.."\n")
		PressMouseButton(no)
	else
		OutputLogMessage("ReleaseMouseButton: "..no.."\n")
		ReleaseMouseButton(no)
	end
end

function PressReleaseKeyByFlg(key)
	if IsPress(key) then
		OutputLogMessage("PressKey: "..key.."\n")
		PressKey(key)
	else
		OutputLogMessage("ReleaseKey: "..key.."\n")
		ReleaseKey(key)
	end
end

function PrePress(arg)
	local switchCases = {}
	switchCases[1] = function()
		if shifting_ then
			PressAndReleaseKey(keyTrap)
			Sleep(50) -- safety
		else
			PressAndReleaseKey(keyFloor)
		end
	end
	switchCases[2] = function()
		if shifting_ then
			return;
		end
		PressAndReleaseKey(keyRoof)
	end
	switchCases[4] = function()
		if shifting_ then
			return;
		end
		PressAndReleaseKey(keyWall)
	end
	switchCases[5] = function()
		--if shifting_ then
		--	return;
		--end
		PressAndReleaseKey(keySteps)
	end
	switchCases[6] = function()
		if shifting_ then
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
	shifting_ = IsModifierPressed("lshift")
	local btns = GetSettingBtns(arg)
	if not btns then
		return
	end
	if pressed then
		PrePress(arg)
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
end

shifting_ = false

press_ = {}
for _, btns in pairs(setting_) do
	for _, btn in pairs(btns) do
		SetPress(btn, false)
	end
end
