local player = game:GetService("Players").LocalPlayer
local rs = game:GetService("RunService")

local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "KillAllGUI"
gui.ResetOnSpawn = false

-- إطار الواجهة
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 150, 0, 110)
frame.Position = UDim2.new(0, 50, 0, 150)
frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
frame.BackgroundTransparency = 0.3
frame.Active = true
frame.Draggable = true

-- زر تشغيل/إيقاف القتل
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(1, -10, 0, 30)
toggleBtn.Position = UDim2.new(0, 5, 0, 5)
toggleBtn.Text = "on kill"
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.BackgroundTransparency = 0.2

-- زر الإخفاء
local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(0.5, -7, 0, 25)
hideBtn.Position = UDim2.new(0, 5, 1, -30)
hideBtn.Text = "-"
hideBtn.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
hideBtn.TextColor3 = Color3.new(1,1,1)
hideBtn.BackgroundTransparency = 0.2

-- زر الإغلاق
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0.5, -7, 0, 25)
closeBtn.Position = UDim2.new(0.5, 2, 1, -30)
closeBtn.Text = "×"
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
closeBtn.TextColor3 = Color3.new(1,1,1)
closeBtn.BackgroundTransparency = 0.2

-- الدائرة لإظهار القايمة
local showCircle = Instance.new("TextButton", gui)
showCircle.Size = UDim2.new(0, 50, 0, 50)
showCircle.Position = UDim2.new(0, 10, 0, 10)
showCircle.Text = "OPEN"
showCircle.Visible = false
showCircle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
showCircle.BackgroundTransparency = 0.3
showCircle.TextColor3 = Color3.new(1,1,1)
showCircle.Active = true
showCircle.Draggable = true

-- الإشعار
local notif = Instance.new("TextLabel", gui)
notif.Size = UDim2.new(0, 250, 0, 30)
notif.Position = UDim2.new(0.5, -125, 0, 80)
notif.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
notif.BackgroundTransparency = 0.4
notif.Text = "Activated successfully"
notif.TextColor3 = Color3.new(1,1,1)
notif.Visible = false

-- المتغير لتفعيل السكربت
local enabled = false
local loopConn = nil

toggleBtn.MouseButton1Click:Connect(function()
	enabled = not enabled
	toggleBtn.Text = enabled and "off kill" or "on kill"

	if enabled then
		notif.Visible = true
		task.delay(3, function()
			notif.Visible = false
		end)

		loopConn = rs.RenderStepped:Connect(function()
			local players = game.Players:GetPlayers()
			for _, otherPlayer in ipairs(players) do
				if otherPlayer ~= player and not player:IsFriendsWith(otherPlayer.UserId) then
					local char = otherPlayer.Character
					local myChar = player.Character
					if char and myChar then
						local tool = myChar:FindFirstChildOfClass("Tool")
						if tool and tool:FindFirstChild("Handle") then
							tool:Activate()
							for _, part in ipairs(char:GetChildren()) do
								if part:IsA("BasePart") then
									firetouchinterest(tool.Handle, part, 0)
									firetouchinterest(tool.Handle, part, 1)
								end
							end
						end
					end
				end
			end
		end)
	else
		if loopConn then
			loopConn:Disconnect()
			loopConn = nil
		end
	end
end)

hideBtn.MouseButton1Click:Connect(function()
	frame.Visible = false
	showCircle.Visible = true
end)

showCircle.MouseButton1Click:Connect(function()
	frame.Visible = true
	showCircle.Visible = false
end)

closeBtn.MouseButton1Click:Connect(function()
	if loopConn then loopConn:Disconnect() end
	gui:Destroy()
end)