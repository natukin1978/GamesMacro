EnablePrimaryMouseButtonEvents(true)

function IsNumber(value)
	return nil ~= tonumber(value);
end

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
for key, btns in pairs(setting) do
	for i, btn in pairs(btns) do
		if IsNumber(btn) then
			btn = "_" .. btn
		end
		pk[btn] = false
	end
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

-- TODO.This function is It's not working properly.
function RapidFireKeyByFlg(arg, key, time)
	local ch = key
	if IsNumber(key) then
		key = "_" .. key
	end
	if not pk[key] then
		return
	end
	repeat
		OutputLogMessage("PressAndReleaseKey: "..ch.."\n")
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
