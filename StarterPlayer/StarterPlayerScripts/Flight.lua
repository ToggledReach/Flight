local Player = game:GetService("Players").LocalPlayer
local Character = Player.Character or Player.CharacterAdded:wait()
local Humanoid = Character:WaitForChild("Humanoid")
local UserInputService = game:GetService("UserInputService")

local FlightHandler = require(game:GetService("ReplicatedStorage"):WaitForChild("FlightHandler"))
local Debounce = false
local TotalJumps

local Flight

UserInputService.InputBegan:connect(function(input, Processed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		if key == Enum.KeyCode.W and Flight then
			Flight:Forward()
		end
	end
end)

UserInputService.InputEnded:connect(function(input, Processed)
	if input.UserInputType == Enum.UserInputType.Keyboard then
		local key = input.KeyCode
		if key == Enum.KeyCode.W and Flight then
			Flight:KeyUp(key)
		end
	end
end)

Humanoid.StateChanged:connect(function(old, new)
	if new == Enum.HumanoidStateType.Landed then
		TotalJumps = 0
	end
end)

UserInputService.JumpRequest:Connect(function()
	if Debounce == false then
		Debounce = true
		TotalJumps = TotalJumps + 1
		spawn(function()
			wait(0.5)
			TotalJumps = 0
		end)
		local Response = FlightHandler.Check(Player)
		if Response == true and TotalJumps >= 2 then
			if Flight then
				Flight:EndFlight()
				Flight = nil
			else
				TotalJumps = 0
				Flight = FlightHandler.Begin(Player)
			end
		end
		wait(0.1)
		Debounce = false
	end
end)
