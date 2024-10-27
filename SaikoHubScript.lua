-- Saiko Hub for Blox Fruits
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Create the GUI
local ScreenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -100)
MainFrame.Size = UDim2.new(0, 200, 0, 250)

-- Title Label
local TitleLabel = Instance.new("TextLabel", MainFrame)
TitleLabel.Size = UDim2.new(1, 0, 0, 50)
TitleLabel.Text = "Saiko Hub"
TitleLabel.TextColor3 = Color3.new(1, 1, 1)
TitleLabel.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)

-- Variables
local weapons = {"Sword", "Gun", "Staff"}
local selectedWeapon = weapons[1]
local farmingMethod = "Attack"
local actionActive = false

-- Create Buttons
local function createButton(parent, position, size, text, callback)
    local button = Instance.new("TextButton", parent)
    button.Position = position
    button.Size = size
    button.Text = text
    button.MouseButton1Click:Connect(callback)
    return button
end

createButton(MainFrame, UDim2.new(0, 0, 0, 50), UDim2.new(1, 0, 0, 50), "Select Weapon: " .. selectedWeapon, function()
    local weaponChoice = game:GetService("UserInputService"):InputBox("Choose Your Weapon", "Enter weapon name:")
    if table.find(weapons, weaponChoice) then
        selectedWeapon = weaponChoice
        TitleLabel.Text = "Select Weapon: " .. selectedWeapon
    end
end)

createButton(MainFrame, UDim2.new(0, 0, 0, 100), UDim2.new(1, 0, 0, 50), "Current Farming: " .. farmingMethod, function()
    farmingMethod = farmingMethod == "Attack" and "Collect Fruits" or "Attack"
    TitleLabel.Text = "Current Farming: " .. farmingMethod
end)

createButton(MainFrame, UDim2.new(0, 0, 0, 150), UDim2.new(1, 0, 0, 50), "Toggle Action", function()
    actionActive = not actionActive
    if actionActive then
        if farmingMethod == "Attack" then
            attackEnemies()
        else
            collectFruits()
        end
    end
end)

function attackEnemies()
    while actionActive and farmingMethod == "Attack" do
        for _, enemy in pairs(workspace:FindFirstChild("Enemies"):GetChildren()) do
            if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                character:MoveTo(enemy.Position)
                wait(1)
                humanoid:EquipTool(character:FindFirstChild(selectedWeapon))
                wait(1)
            end
        end
        wait(5)
    end
end

function collectFruits()
    while actionActive and farmingMethod == "Collect Fruits" do
        for _, fruit in pairs(workspace:FindFirstChild("Fruits"):GetChildren()) do
            if fruit:IsA("Model") then
                character:MoveTo(fruit.Position)
                wait(1)
                fruit:Destroy()
            end
        end
        wait(5)
    end
end
