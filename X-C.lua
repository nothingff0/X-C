local LogService = game:GetService("LogService")
local RunService = game:GetService("RunService")
local FILE_NAME = "Console.pid"
local MAX_LINES = 500
local SAVE_INTERVAL = 0.01
local logs = {}
local lastSave = 0
local isRunning = true
LogService.MessageOut:Connect(function(message, messageType)
	if not isRunning then return end
	local prefix = ""
	if messageType == Enum.MessageType.MessageOutput then
		prefix = "[PRINT] "
	elseif messageType == Enum.MessageType.MessageWarning then
		prefix = "[WARN]  "
	elseif messageType == Enum.MessageType.MessageError then
		prefix = "[ERROR] "
	elseif messageType == Enum.MessageType.MessageInfo then
		prefix = "[INFO]  "
	end
	table.insert(logs, prefix .. message)
	if #logs > MAX_LINES then
		table.remove(logs, 1)
	end
end)
RunService.Heartbeat:Connect(function()
	if not isRunning then return end
	local now = tick()
	if now - lastSave >= SAVE_INTERVAL then
		lastSave = now
		if #logs > 0 then
			pcall(function()
				writefile(FILE_NAME, table.concat(logs, "\n") .. "\n")
			end)
		end
	end
end)
game:BindToClose(function()
	if isRunning and #logs > 0 then
		pcall(function()
			writefile(FILE_NAME, table.concat(logs, "\n") .. "\n")
		end)
	end
end)

task.wait(0.05)
print("NOTHING-X")
