-- LocalScript (StarterPlayerScripts hoặc StarterGui)

local player = game.Players.LocalPlayer
local camera = workspace.CurrentCamera

-- GUI chính
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "DeadRailsMenuV3"
gui.ResetOnSpawn = false

-- Khung chính
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 400)
frame.Position = UDim2.new(0.5, -160, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
frame.BorderSizePixel = 3
frame.Active = true
frame.Draggable = true

-- Tiêu đề
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(0.6, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.Text = "Hp Team Vp | Dead Rails V3"
title.TextColor3 = Color3.fromRGB(0, 0, 0)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
title.BorderColor3 = Color3.fromRGB(0, 0, 0)
title.BorderSizePixel = 2

-- Nút thu nhỏ
local toggleBtn = Instance.new("TextButton", frame)
toggleBtn.Size = UDim2.new(0.2, -5, 0, 40)
toggleBtn.Position = UDim2.new(0.6, 5, 0, 0)
toggleBtn.Text = "↓"
toggleBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.Font = Enum.Font.SourceSansBold
toggleBtn.TextSize = 20
toggleBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
toggleBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
toggleBtn.BorderSizePixel = 2

-- Nút đóng
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0.2, -5, 0, 40)
closeBtn.Position = UDim2.new(0.8, 5, 0, 0)
closeBtn.Text = "Đóng"
closeBtn.TextColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.Font = Enum.Font.SourceSansBold
closeBtn.TextSize = 18
closeBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
closeBtn.BorderColor3 = Color3.fromRGB(0, 0, 0)
closeBtn.BorderSizePixel = 2
closeBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
end)

-- Container
local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, -10, 1, -50)
content.Position = UDim2.new(0, 5, 0, 45)
content.BackgroundTransparency = 1

-- Hàm tạo button
local function createButton(text, posY, callback)
    local btn = Instance.new("TextButton", content)
    btn.Size = UDim2.new(1, -10, 0, 40)
    btn.Position = UDim2.new(0, 5, posY, 0)
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(0, 0, 0)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 18
    btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    btn.BorderColor3 = Color3.fromRGB(0, 0, 0)
    btn.BorderSizePixel = 2

    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        if active then
            btn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
            callback(true)
        else
            btn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            callback(false)
        end
    end)
end

------------------------------------------------
-- CÁC CHỨC NĂNG
------------------------------------------------

-- Night Vision
createButton("Night Vision", 0, function(state)
    if state then
        game.Lighting.Brightness = 2
        game.Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        game.Lighting.FogEnd = 1e6
    else
        game.Lighting.Brightness = 1
        game.Lighting.Ambient = Color3.fromRGB(0, 0, 0)
        game.Lighting.FogEnd = 1000
    end
end)

-- Bypass demo
createButton("Bypass", 0.12, function(state)
    print("Bypass:", state)
end)

-- Hiện Tên Mod
local showName = false
createButton("Hiện Tên Mod", 0.24, function(state)
    showName = state
end)

-- Hiện Khoảng Cách
local showDistance = false
createButton("Hiện Khoảng Cách", 0.36, function(state)
    showDistance = state
end)

-- Hiện Số Mod (chỉ hostile)
local showCounter = false
createButton("Hiện Số Mod (Hostile)", 0.48, function(state)
    showCounter = state
end)

-- ESP Line
local espLine = false
createButton("ESP Line", 0.60, function(state)
    espLine = state
end)

------------------------------------------------
-- ESP & COUNTER
------------------------------------------------

-- Counter UI
local counterLabel = Instance.new("TextLabel", gui)
counterLabel.Size = UDim2.new(0, 200, 0, 40)
counterLabel.Position = UDim2.new(0.5, -100, 0.05, 0)
counterLabel.BackgroundTransparency = 0.3
counterLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
counterLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
counterLabel.Font = Enum.Font.SourceSansBold
counterLabel.TextSize = 20
counterLabel.Visible = false

-- ESP tạo Billboard (nhỏ hơn nữa)
local function createESP(target)
    if target == player.Character then return end
    local bb = Instance.new("BillboardGui", target)
    bb.Size = UDim2.new(0, 80, 0, 20) -- nhỏ hơn
    bb.Adornee = target:FindFirstChild("HumanoidRootPart")
    bb.AlwaysOnTop = true
    bb.Name = "ESP"

    local text = Instance.new("TextLabel", bb)
    text.Size = UDim2.new(1, 0, 1, 0)
    text.BackgroundTransparency = 1
    text.TextColor3 = Color3.fromRGB(255, 255, 0)
    text.Font = Enum.Font.SourceSansBold
    text.TextSize = 10 -- nhỏ hơn

    task.spawn(function()
        while bb and bb.Parent and target:FindFirstChild("HumanoidRootPart") do
            local info = {}
            if showName then table.insert(info, target.Name) end
            if showDistance then
                local dist = (player.Character.HumanoidRootPart.Position - target.HumanoidRootPart.Position).Magnitude
                table.insert(info, string.format("[%.0f]", dist))
            end
            text.Text = table.concat(info, " ")
            task.wait(0.2)
        end
        if bb then bb:Destroy() end
    end)
end

-- ESP Line (nhỏ hơn, bỏ người chơi)
local function createLine(target)
    if target == player.Character then return end
    local line = Drawing.new("Line")
    line.Thickness = 1
    line.Color = Color3.fromRGB(0, 255, 0)
    line.Transparency = 1

    task.spawn(function()
        while target.Parent and line do
            if espLine then
                local root = target:FindFirstChild("HumanoidRootPart")
                if root then
                    local pos, onScreen = camera:WorldToViewportPoint(root.Position)
                    if onScreen then
                        line.From = Vector2.new(camera.ViewportSize.X/2, 50)
                        line.To = Vector2.new(pos.X, pos.Y)
                        line.Visible = true
                    else
                        line.Visible = false
                    end
                else
                    line.Visible = false
                end
            else
                line.Visible = false
            end
            task.wait(0.03)
        end
        line:Remove()
    end)
end

-- Kiểm tra mob hostile
local function isHostile(mob)
    if mob:FindFirstChild("Humanoid") then
        local n = string.lower(mob.Name)
        if string.find(n, "zombie") or string.find(n, "hostile") or mob:FindFirstChild("Attack") then
            return true
        end
    end
    return false
end

-- Cập nhật số mob hostile
task.spawn(function()
    while true do
        if showCounter then
            local count = 0
            for _, m in pairs(workspace:GetDescendants()) do
                if m:FindFirstChild("HumanoidRootPart") and isHostile(m) then
                    count += 1
                end
            end
            counterLabel.Text = "Hp Team Vp: " .. tostring(count)
            counterLabel.Visible = true
        else
            counterLabel.Visible = false
        end
        task.wait(1)
    end
end)

-- Theo dõi mob mới
workspace.DescendantAdded:Connect(function(obj)
    if obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
        createESP(obj)
        createLine(obj)
    end
end)

-- Quét ban đầu
for _, mob in pairs(workspace:GetDescendants()) do
    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") then
        createESP(mob)
        createLine(mob)
    end
end

------------------------------------------------
-- Nút thu nhỏ
------------------------------------------------
local minimized = false
toggleBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    content.Visible = not minimized
    if minimized then
        toggleBtn.Text = "↑"
        frame.Size = UDim2.new(0, 320, 0, 50)
    else
        toggleBtn.Text = "↓"
        frame.Size = UDim2.new(0, 320, 0, 400)
    end
end)