local FlightHandler = {}
local Flight = {}

local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local ObjectService = require(script:WaitForChild("ObjectService"))

function Flight:Forward()
	self.Moving = true
end

function Flight:KeyUp(key)
	if key == Enum.KeyCode.W then
		self.Moving = false
	end
end

function Flight:EndFlight()
	self.Humanoid.PlatformStand = false
	self.Gyro:Destroy()
	self.Position:Destroy()
	self.Position = nil
	self.Gyro = nil
end

function Flight:HandleFlight()
	local FlightManager = coroutine.wrap(function()
		while(RunService.RenderStepped:wait()) and self.Gyro and self.Position do
			local Gyro = self.Gyro
			local HumanoidRootPart = self.HumanoidRootPart
			local Camera = Workspace.CurrentCamera
			Gyro.CFrame = Camera.CoordinateFrame * CFrame.Angles(-math.rad(7.5), 0, 0)
			self.newLocation = Gyro.CFrame - Gyro.CFrame.p + self.Position.Position
			if self.Moving then
				self.newLocation = self.newLocation + Camera.CoordinateFrame.lookVector
				self.Position.position = self.newLocation.p
			end
		end
	end)
	self.Manager = FlightManager()
end

function FlightHandler.Begin(Player)
	local Character = Player.Character or Player.CharacterAdded:wait()
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local Humanoid = Character:WaitForChild("Humanoid")
	Humanoid.PlatformStand = true
	local FlightMeta = setmetatable({
		Player = Player,
		HumanoidRootPart = HumanoidRootPart,
		Humanoid = Humanoid,
		Gyro = ObjectService.New("BodyGyro", HumanoidRootPart),
		Position = ObjectService.New("BodyPosition", HumanoidRootPart),
		newLocation = nil,
		Manager = nil,
		Moving = nil,
	}, {
		__index = Flight,
	})
	FlightMeta:HandleFlight()
	return FlightMeta
end

function FlightHandler.Check(Player)
	local Character = Player.Character or Player.CharacterAdded:wait()
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local ray = Ray.new(HumanoidRootPart.Position, Vector3.new(0,-3,0))
	local Hit = Workspace:FindPartOnRay(ray, Character)
	if Hit == nil then
		return true
	else
		return false
	end
end

return FlightHandler
