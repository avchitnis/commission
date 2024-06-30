local UserInputService = game:GetService("UserInputService")

-- Function to calculate the direction based on the angle
local function calculateDirection(angle)
	if angle >= 337.5 or angle < 22.5 then
		return "East"
		
	elseif angle >= 22.5 and angle < 67.5 then
		return "North East"
		
	elseif angle >= 67.5 and angle < 112.5 then 
		return "North"
		
	elseif angle >= 112.5 and angle < 157.5 then
		return "North West"
		
	elseif angle >= 157.5 and angle < 202.5 then
		return "West"
		
	elseif angle >= 202.5 and angle < 247.5 then
		return "South West"
		
	elseif angle >= 247.5 and angle < 292.5 then
		return "South"
		
	elseif angle >= 292.5 and angle < 337.5 then
		return "South East"
		
	end
end

-- Function to calculate the angle between two points
local function calculateAngle(startPos, endPos)
	local delta = endPos - startPos
	local angle = math.atan2(-delta.Y, delta.X)  -- Invert the Y-coordinate
	
	-- Convert radians to degrees
	angle = math.deg(angle)
	-- Normalize the angle
	if angle < 0 then
		angle = 360 + angle
		
	end
	
	return angle
end

local dragging = false
local dragStart, dragEnd

--[[
local function startDrag(input, gameProcessed)
	if gameProcessed then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		local startPosition = input.Position
		print("Drag Start Position: ", startPosition)

		local function endDrag(endInput)
			if endInput.UserInputType == Enum.UserInputType.MouseButton1 then
				local endPosition = endInput.Position
				print("Drag End Position: ", endPosition)
			end
		end

		UserInputService.InputEnded:Connect(endDrag)
	end
end

 UserInputService.InputBegan:Connect(startDrag)

]]

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera

-- Function to calculate and set the minimum distance
local function setMinimumDistance()
	local viewportSize = camera.ViewportSize
	local minimumDistance = viewportSize.X / 3  -- 1/3 of the screen width
	
	return minimumDistance
end

-- Call the function initially in case the viewport size changes
setMinimumDistance()

-- Listen to changes in the viewport size to adjust the minimum distance dynamically
camera:GetPropertyChangedSignal("ViewportSize"):Connect(setMinimumDistance)

local dragCooldown = 2 -- Cooldown in seconds between drags
local lastDragTime = 0

local function canDrag()
	local currentTime = os.time() -- Get the current time
	
	if (currentTime - lastDragTime) >= dragCooldown then
		return true
	else
		return false
	end
end

local function updateLastDragTime()
	lastDragTime = os.time()
end

--UserInputService.InputBegan:Connect(function(input, gameProcessed)
--	if gameProcessed then
--		return 
--	end
	
--	if input.UserInputType == Enum.UserInputType.MouseButton1 then
--		dragging = true
--		dragStart = UserInputService:GetMouseLocation()
--    end
--end)

--UserInputService.InputEnded:Connect(function(input, gameProcessed)
--	if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
--		dragging = false
--		dragEnd = UserInputService:GetMouseLocation()
		
--		if canDrag() then
--			local dragDistance = (dragEnd - dragStart).Magnitude
			
--			if dragDistance >= setMinimumDistance() then
--				local angle = calculateAngle(dragStart, dragEnd)
--				local direction = calculateDirection(angle)
--				print("Drag Direction: " .. direction)
--			else
--				print("Drag distance too short.")
--			end
			
--			updateLastDragTime()
--		else
--			print("You must wait before dragging again.")
--		end
--	end
--end)

local scriptEnabled = false

local function onKeyPress(input, gameProcessed)
	if gameProcessed then 
		return 
	end  -- Ignore if the game has already processed this input

	if input.KeyCode == Enum.KeyCode.E then
		scriptEnabled = not scriptEnabled  -- Toggle the script's enabled state
		print("Script toggled:", scriptEnabled)  -- Debugging/confirmation message

		UserInputService.InputBegan:Connect(function(input, gameProcessed)
			if gameProcessed then
				return 
			end

            if scriptEnabled then
				if input.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					dragStart = UserInputService:GetMouseLocation()
				end
			else
				gameProcessed = true
			end
		end)

		UserInputService.InputEnded:Connect(function(input, gameProcessed)
			if scriptEnabled then
			    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
					dragging = false
					dragEnd = UserInputService:GetMouseLocation()

					if canDrag() then
						local dragDistance = (dragEnd - dragStart).Magnitude

						if dragDistance >= setMinimumDistance() then
							local angle = calculateAngle(dragStart, dragEnd)
							local direction = calculateDirection(angle)
							print("Drag Direction: " .. direction)
							
							local moveVector = Vector3.new()
							-- Play animations
							if direction == "North" then
								moveVector = Vector3.new(0, 0, -10)
							elseif direction == "North East" then
								moveVector = Vector3.new(10, 0, -10)
							elseif direction == "East" then
								moveVector = Vector3.new(10, 0, 0)
							elseif direction == "South East" then
								moveVector = Vector3.new(10, 0, 10)
							elseif direction == "South" then
								moveVector = Vector3.new(0, 0, 10)
							elseif direction == "South West" then
								moveVector = Vector3.new(-10, 0, 10)
							elseif direction == "West" then
								moveVector = Vector3.new(-10, 0, 0)
							elseif direction == "North West" then
								moveVector = Vector3.new(-10, 0, -10)
							end
							game.Workspace.Rig:PivotTo(game.Workspace.Rig:GetPivot() + moveVector)
						else
							print("Drag distance too short.")
						end

						updateLastDragTime()
					else
						print("You must wait before dragging again.")
					end
				end
			else
				gameProcessed = true
			end
		end)
	end
end

UserInputService.InputBegan:Connect(onKeyPress)
