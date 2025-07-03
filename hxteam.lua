local plr = game.Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()

-- GUI
local gui = Instance.new("ScreenGui", plr:WaitForChild("PlayerGui"))
gui.Name = "HpTeamGui"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 230, 0, 250)
frame.Position = UDim2.new(0.05, 0, 0.3, 0)
frame.BackgroundTransparency = 0.4
frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

local hideBtn = Instance.new("TextButton", frame)
hideBtn.Size = UDim2.new(0, 60, 0, 25)
hideBtn.Position = UDim2.new(1, -65, 0, 5)
hideBtn.Text = "Thu nhỏ"
hideBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hideBtn.TextColor3 = Color3.new(1, 1, 1)

local showBtn = Instance.new("TextButton", gui)
showBtn.Size = UDim2.new(0, 100, 0, 40)
showBtn.Position = UDim2.new(0.05, 0, 0.85, 0)
showBtn.Text = "Mở menu"
showBtn.Visible = false
showBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
showBtn.TextColor3 = Color3.new(1, 1, 1)

-- Biến bật/tắt
local autoBonds, autoHit, espOn = false, false, false

-- AUTO BONDS
local bondsBtn = Instance.new("TextButton", frame)
bondsBtn.Size = UDim2.new(0, 200, 0, 30)
bondsBtn.Position = UDim2.new(0, 15, 0, 40)
bondsBtn.Text = "🔴 AUTO BONDS: OFF"
bondsBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
bondsBtn.TextColor3 = Color3.new(1, 1, 1)

bondsBtn.MouseButton1Click:Connect(function()
    autoBonds = not autoBonds
    bondsBtn.Text = autoBonds and "🟢 AUTO BONDS: ON" or "🔴 AUTO BONDS: OFF"
end)

-- AUTO ĐÁNH
local hitBtn = Instance.new("TextButton", frame)
hitBtn.Size = UDim2.new(0, 200, 0, 30)
hitBtn.Position = UDim2.new(0, 15, 0, 85)
hitBtn.Text = "🔴 AUTO ĐÁNH: OFF"
hitBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
hitBtn.TextColor3 = Color3.new(1, 1, 1)

hitBtn.MouseButton1Click:Connect(function()
    autoHit = not autoHit
    hitBtn.Text = autoHit and "🟢 AUTO ĐÁNH: ON" or "🔴 AUTO ĐÁNH: OFF"
end)

-- ESP
local espBtn = Instance.new("TextButton", frame)
espBtn.Size = UDim2.new(0, 200, 0, 30)
espBtn.Position = UDim2.new(0, 15, 0, 130)
espBtn.Text = "🔴 ESP BONDS: OFF"
espBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
espBtn.TextColor3 = Color3.new(1, 1, 1)

espBtn.MouseButton1Click:Connect(function()
    espOn = not espOn
    espBtn.Text = espOn and "🟢 ESP BONDS: ON" or "🔴 ESP BONDS: OFF"
end)

-- Anti-AFK
local vu = game:GetService("VirtualUser")
plr.Idled:Connect(function()
    vu:Button2Down(Vector2.new(), workspace.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(), workspace.CurrentCamera.CFrame)
end)

-- Thu nhỏ/Mở menu
hideBtn.MouseButton1Click:Connect(function()
    frame.Visible = false
    showBtn.Visible = true
end)

showBtn.MouseButton1Click:Connect(function()
    frame.Visible = true
    showBtn.Visible = false
end)

-- LOOP chạy tính năng
spawn(function()
    while true do
        wait(0.5)

        -- AUTO BONDS
        if autoBonds then
            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("BasePart") and (string.lower(v.Name):find("bond") or string.lower(v.Name):find("cash") or string.lower(v.Name):find("money")) then
                    pcall(function()
                        char:WaitForChild("HumanoidRootPart").CFrame = v.CFrame + Vector3.new(0, 3, 0)
                    end)
                    wait(0.3)
                end
            end
        end

        -- AUTO HIT
        if autoHit then
            local tool = plr.Backpack:FindFirstChildOfClass("Tool")
            if tool and not plr.Character:FindFirstChild(tool.Name) then
                pcall(function()
                    plr.Character.Humanoid:EquipTool(tool)
                end)
                repeat wait(0.1) until plr.Character:FindFirstChild(tool.Name)
                wait(0.1)
            end

            local activeTool = plr.Character:FindFirstChildOfClass("Tool")
            if activeTool then
                pcall(function()
                    activeTool:Activate()
                end)
            end
        end

        -- ESP BONDS
        if espOn then
            for _, v in pairs(workspace:GetDescendants()) do
                if (v:IsA("BasePart") or v:IsA("MeshPart")) and (string.lower(v.Name):find("bond") or string.lower(v.Name):find("cash")) and not v:FindFirstChild("ESP") then
                    local bill = Instance.new("BillboardGui", v)
                    bill.Name = "ESP"
                    bill.Size = UDim2.new(0, 100, 0, 40)
                    bill.AlwaysOnTop = true
                    bill.Adornee = v
                    local label = Instance.new("TextLabel", bill)
                    label.Size = UDim2.new(1, 0, 1, 0)
                    label.BackgroundTransparency = 1
                    label.Text = "💵 BOND"
                    label.TextColor3 = Color3.new(0, 1, 0)
                    label.TextScaled = true
                end
            end
        end
    end
end)