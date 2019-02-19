local ObjectService = {}

function ObjectService.New(Object, Parent)
	if Object == "BodyPosition" then
		local BodyPosition = Instance.new("BodyPosition")
		local Huge = math.huge
		BodyPosition.MaxForce = Vector3.new(Huge, Huge, Huge)
		BodyPosition.Position = Parent.Position
		BodyPosition.Parent = Parent
		return BodyPosition
	elseif Object == "BodyGyro" then
		local Gyro = Instance.new("BodyGyro")
		Gyro.Parent = Parent
		Gyro.Name = "FlightGyro"
		Gyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		Gyro.CFrame = Parent.CFrame
		return Gyro
	end
end

return ObjectService
