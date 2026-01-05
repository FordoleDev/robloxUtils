local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local Window = Library:CreateWindow({
	Title = 'LontexHub',
	Center = true,
	AutoShow = true,
	TabPadding = 8
})

local plrs = game:GetService("Players")
local uis = game:GetService("UserInputService")
local light = game:GetService("Lighting")
local rp = game:GetService("ReplicatedStorage")
local camera = workspace.CurrentCamera

local aiming = false
local lplr = plrs.LocalPlayer
local char
local hump
if lplr.Character then
	char = lplr.Character
	if char:FindFirstChild("HumanoidRootPart") then
		hump = char.HumanoidRootPart
	end
end

local Tabs = {
	Main = Window:AddTab('Main'),
	['UI Settings'] = Window:AddTab('UI Settings'),
}

local Aimbot = Tabs.Main:AddLeftGroupbox('Aimbot')

Aimbot:AddLabel('Keybind'):AddKeyPicker('KeyPicker', {
	Default = 'F',
	SyncToggleState = false,


	Mode = 'Toggle',
	
	Text = 'Auto lockpick safes',
	NoUI = false, 

	Callback = function(Value)
		print('[cb] Keybind clicked!', Value)
	end,

	ChangedCallback = function(New)
		print('[cb] Keybind changed!', New)
	end
})

task.spawn(function()
	while true do
		wait(0.1)

		local state = Options.KeyPicker:GetState()
		if state then
			aiming = true
		else
			aiming = false
		end

		if Library.Unloaded then break end
	end
end)

Options.KeyPicker:SetValue({ 'MB2', 'Toggle' })

local function isEnemy(plr)
	if _G.TeamCheck == false then
		return true
	end
	if plr.Team and lplr.Team then
		return plr.Team ~= lplr.Team
	end

	return true
end

local function isAlive(plr)
	if not plr or not plr.Character then
		return false
	end

	local hum = plr.Character:FindFirstChild("Humanoid")
	if not hum then
		return false
	end

	return hum.Health > 0
end

game:GetService("RunService").RenderStepped:Connect(function()
	if lplr.Character then
		if char ~= lplr.Character then
			char = lplr.Character
			if char:FindFirstChild("HumanoidRootPart") then
				hump = char.HumanoidRootPart
			end
		end
	end
	if aiming then
		local closestPlayer = nil
		local closestDist = math.huge

		for _, plr in plrs:GetPlayers() do
			if plr.Character and plr ~= plrs.LocalPlayer then
				if isEnemy(plr) and isAlive(plr) and plr.Character:FindFirstChild("Head") then
					local aimpart = "Head"
					local targetPart = plr.Character:FindFirstChild(aimpart)
					local screenpoint = camera:WorldToViewportPoint(targetPart.Position)

					if screenpoint.Z > 0 then
						local mpos = uis:GetMouseLocation()
						local screenpos = Vector2.new(screenpoint.X, screenpoint.Y)
						if hump then
							local distance = (targetPart.Position - hump.Position).Magnitude
							if (screenpos - mpos).Magnitude <= 50 and distance < closestDist then
								closestPlayer = plr
								closestDist = distance
							end
						end
					end
				end
			end
		end

		if closestPlayer then
			local aimpart = "Head"
			local targetPart = closestPlayer.Character:FindFirstChild(aimpart)
			if targetPart then
				camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
			end
		end
	end
end)

Library:OnUnload(function()
	print('Unloaded!')
	Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind

ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)

SaveManager:IgnoreThemeSettings()

SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })

ThemeManager:SetFolder('MyScriptHub')
SaveManager:SetFolder('MyScriptHub/specific-game')

SaveManager:BuildConfigSection(Tabs['UI Settings'])
ThemeManager:ApplyToTab(Tabs['UI Settings'])
SaveManager:LoadAutoloadConfig()
