local LogService = game:GetService("LogService")
local RunService = game:GetService("RunService")
local FILE_NAME = "Console.pid"
local isRunning = true
local lastLog = ""
LogService.MessageOut:Connect(function(message, messageType)
	if not isRunning then return end
	local prefix = ""
	if messageType == Enum.MessageType.MessageOutput then
		prefix = "[PRINT] "
	elseif messageType == Enum.MessageType.MessageWarning then
		prefix = "[WARN] "
	elseif messageType == Enum.MessageType.MessageError then
		prefix = "[ERROR] "
	elseif messageType == Enum.MessageType.MessageInfo then
		prefix = "[INFO] "
	end
	lastLog = prefix .. message
	pcall(function()
		writefile(FILE_NAME, lastLog .. "\n")
	end)
end)
task.wait(0.1)
print("NOTHING-X")
task.wait(0.05)
pcall(function()
	writefile(FILE_NAME, lastLog .. "\n")
end)
game:BindToClose(function()
	if isRunning then
		pcall(function()
			writefile(FILE_NAME, lastLog .. "\n")
		end)
	end
end)
