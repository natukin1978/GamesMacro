EnablePrimaryMouseButtonEvents(true)

setting_ = {
	arg1 = {
		"mouse1",
		"f3",
	},
	arg2 = {
		"mouse3",
		nil,
	},
	arg3 = {
		"p",
		"3",
	},
	arg5 = {
		"q",
		nil,
	},
	arg6 = {
		"tab",
		"m",
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

function IsMouseButtonReleaseOrSleep(arg, time)
	local min = 25
	local count = time // min
	local i = 0
	for i = 1, count do
		Sleep(min)
		if not IsMouseButtonPressed(arg) then
			return true
		end
	end
	return false
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

-- TODO.This function is It's not working properly.
function RapidFireKeyByFlg(arg, key, time)
	if not IsPress(key) then
		return
	end
	repeat
		OutputLogMessage("PressAndReleaseKey: "..key.."\n")
		PressAndReleaseKey(key)
	until IsMouseButtonReleaseOrSleep(arg, time)
end

function OnEvent(event, arg)
	--OutputLogMessage("Event: "..event.." Arg: "..arg.."\n")
	if 0 >= arg then
		return
	end
	local pressed = "MOUSE_BUTTON_PRESSED" == event
	if 4 == arg then
		shifting_ = pressed
	end
	local btns = GetSettingBtns(arg)
	if not btns then
		return
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
