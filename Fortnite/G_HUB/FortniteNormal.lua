EnablePrimaryMouseButtonEvents(false)

keyWall  = "z"
keySteps = "c"
keyQuick = "q"
keyEdit  = "g"

keyPin   = "p"

setting_ = {
	arg3 = {
		keySteps, -- keyQuick
		nil,
	},
	arg4 = {
		"mouse1",
		nil,
	},
	arg5 = {
		"mouse1",
		nil,
	},
	arg6 = {
		"mouse1",
		keyPin,
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
	if shifting_ then
		return
	end
	local switchCases = {}
	switchCases[4] = function()
		SetPress(keyWall, true)
		PressAndReleaseKey(keyWall)
	end
	switchCases[5] = function()
		SetPress(keySteps, true)
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

function Released(arg)
	if shifting_ then
		return
	end
	local switchCases = {}
	switchCases[4] = function()
		SetPress(keyWall, false)
	end
	switchCases[5] = function()
		SetPress(keySteps, false)
	end
	local switchCase = switchCases[arg]
	if not switchCase then
		return
	end
	switchCase()
	if not(IsPress(keyWall) or IsPress(keySteps)) then
		PressAndReleaseKey(keyQuick)
	end
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
	if not pressed then
		Released(arg)
	end
end

shifting_ = false

press_ = {}
for _, btns in pairs(setting_) do
	for _, btn in pairs(btns) do
		SetPress(btn, false)
	end
end
