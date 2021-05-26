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
		"5",
	},
	arg5 = {
		"c",
		"g",
	},
	arg6 = {
		"m",
		"tab",
	},
}

shifting = false
pk = {}

EnablePrimaryMouseButtonEvents(true)

function IsNumber(value)
	return nil ~= tonumber(value);
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
	if IsNumber(key) then
		key = "_" .. key
	end
	if pressed then
		if conditionsShift == shifting then
			pk[key] = pressed
		end
	else
		pk[key] = pressed
	end
end

function PressReleaseMouseButtonByFlg(button)
	local noStr = string.gsub(button, "mouse", "")
	local no = tonumber(noStr)
	if pk[button] then
		PressMouseButton(no)
	else
		ReleaseMouseButton(no)
	end
end

function PressReleaseKeyByFlg(key)
	local ch = key
	if IsNumber(key) then
		key = "_" .. key
	end
	if pk[key] then
		PressKey(ch)
	else
		ReleaseKey(ch)
	end
end

function RapidFireKeyByFlg(arg, key, time)
	local ch = key
	if IsNumber(key) then
		key = "_" .. key
	end
	if not pk[key] then
		return
	end
	repeat
		PressAndReleaseKey(ch)
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
		return
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
			ManageFlg(pressed, btn, 1 ~= i)
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
