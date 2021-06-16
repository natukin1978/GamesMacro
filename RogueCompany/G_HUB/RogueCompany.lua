EnablePrimaryMouseButtonEvents(true)

setting = {
	arg1 = {
		"mouse1",
		"q",
	},
	arg2 = {
		"mouse3",
		"v",
	},
	arg3 = {
		"p",
		"4",
	},
	arg5 = {
		"lctrl",
		"g",
	},
	arg6 = {
		"m",
		"tab",
	},
}

function GetSettingBtns(arg)
	local key = "arg" .. arg
	return setting[key]
end

function IsNumber(value)
	return nil ~= tonumber(value)
end

function IsPressKey(btn)
	if IsNumber(btn) then
		btn = "_" .. btn
	end
	return pk[btn]
end

function SetPressKey(btn, value)
	if IsNumber(btn) then
		btn = "_" .. btn
	end
	pk[btn] = value
end

pk = {}
for key, btns in pairs(setting) do
	for i, btn in pairs(btns) do
		SetPressKey(btn, false)
	end
end

shifting = false

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
		if conditionsShift == shifting then
			flg = pressed
		end
	else
		flg = pressed
	end
	if nil == flg then
		return false
	end
	if flg ~= IsPressKey(key) then
		SetPressKey(key, flg)
		return true
	else
		return false
	end
end

function PressReleaseMouseButtonByFlg(button)
	local noStr = string.gsub(button, "mouse", "")
	local no = tonumber(noStr)
	if IsPressKey(button) then
		OutputLogMessage("PressMouseButton: "..no.."\n")
		PressMouseButton(no)
	else
		OutputLogMessage("ReleaseMouseButton: "..no.."\n")
		ReleaseMouseButton(no)
	end
end

function PressReleaseKeyByFlg(key)
	if IsPressKey(key) then
		OutputLogMessage("PressKey: "..key.."\n")
		PressKey(key)
	else
		OutputLogMessage("ReleaseKey: "..key.."\n")
		ReleaseKey(key)
	end
end

-- TODO.This function is It's not working properly.
function RapidFireKeyByFlg(arg, key, time)
	if not IsPressKey(key) then
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
		shifting = pressed
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
