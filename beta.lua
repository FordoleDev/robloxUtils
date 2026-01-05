local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local plrs = game:GetService("Players")
local runs = game:GetService("RunService")
local rp = game:GetService("ReplicatedStorage")
local light = game:GetService("Lighting")
local uis = game:GetService("UserInputService")
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

_G.Aimbot = false
_G.Aimpart = "Head"
_G.AimFov = 30
_G.DrawFov = false
_G.AimMethod = "Distance"
--Visuals
_G.Highlight = false
_G.HighlightAOT = true
_G.HighlightColor = Color3.new(1, 1, 1)
_G.Chams = false
_G.ChamsAOT = true
_G.ChamsColor = Color3.new(1, 1, 1)
_G.ChamsTrans = 0
_G.ToggleTime = false
_G.WorldTime = 12
_G.Shadows = false
_G.FogStart = 500
_G.FogEnd = 1000
_G.FogColor = Color3.new(1, 1, 1)

local fov = Drawing.new("Circle")
fov.Radius = _G.AimFov
fov.Thickness = 1
fov.Transparency = 1
fov.Visible = true
fov.Color = Color3.new(255, 255, 255)
fov.Position = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
fov.Filled = false

local Window = Library:CreateWindow({
	Title = 'Example menu',
	Center = true,
	AutoShow = true,
	TabPadding = 8
})

local Tabs = {
	Legit = Window:AddTab("Legit"),
	Visuals = Window:AddTab("Visuals")
}

local AimbotBox = Tabs.Legit:AddLeftGroupbox("Aimbot")

AimbotBox:AddToggle("ToggleAim",{
	Text = "Toggle Aim",
	Default = _G.Aimbot,

	Callback = function(Value)
		_G.Aimbot = Value
	end
})

AimbotBox:AddLabel('Keybind'):AddKeyPicker('AimbotBind', {
	Default = "F",
	SyncToggleState = false,

	Mode = 'Hold',

	Text = 'Aimming on enemies',
	NoUI = false,

	Callback = function(Value)
		
	end,

	ChangedCallback = function(New)
		
	end
})

AimbotBox:AddSlider('AimFov', {
	Text = 'AimBot FOV',
	Default = _G.AimFov,
	Min = 1,
	Max = 180,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		_G.AimFov = Value
	end
})

AimbotBox:AddDropdown('Aimpart', {
	Values = { 'Head', 'HumanoidRootPart'},
	Default = 1,
	Multi = false,

	Text = 'Aim Part',
	Tooltip = 'Part that will be aimed',

	Callback = function(Value)
		_G.Aimpart = Value
	end
})

AimbotBox:AddDropdown('AimMethod', {
	Values = { 'Distance', 'Crosshair'},
	Default = 1,
	Multi = false,

	Text = 'Aim Method',
	Tooltip = 'Method that will be used to aim',

	Callback = function(Value)
		_G.AimMethod = Value
	end
})

AimbotBox:AddToggle("DrawFOV",{
	Text = "Draw FOV",
	Default = _G.DrawFov,
	Tooltip = "Draws aimbot FOV",

	Callback = function(Value)
		_G.DrawFov = Value
	end
})

task.spawn(function()
	while true do
		wait(0.1)

		local state = Options.AimbotBind:GetState()
		if state then
			aiming = true
		else
			aiming = false
		end

		if Library.Unloaded then break end
	end
end)

local HlBox = Tabs.Visuals:AddLeftGroupbox("Glow")

HlBox:AddToggle("ToggleHl",{
	Text = "Toggle Glow",
	Default = _G.Highlight,
	Tooltip = "Highlights player",

	Callback = function(Value)
		_G.Highlight = Value
	end
})

HlBox:AddToggle("HlAOT",{
	Text = "Through walls",
	Default = _G.HighlightAOT,

	Callback = function(Value)
		_G.HighlightAOT = Value
	end
})

HlBox:AddLabel('Color'):AddColorPicker('HlColor', {
	Default = _G.HighlightColor,
	Title = 'Highlight Color',
	Transparency = nil,

	Callback = function(Value)
		_G.HighlightColor = Value
	end
})

local ChamsBox = Tabs.Visuals:AddLeftGroupbox("Chams")

ChamsBox:AddToggle("ToggleChams",{
	Text = "Toggle Chams",
	Default = _G.Chams,
	Tooltip = "Highlights player",

	Callback = function(Value)
		_G.Chams = Value
	end
})

ChamsBox:AddToggle("ChamsAOT",{
	Text = "Through walls",
	Default = _G.ChamsAOT,

	Callback = function(Value)
		_G.ChamsAOT = Value
	end
})

ChamsBox:AddLabel('Color'):AddColorPicker('ChamsColor', {
	Default = _G.ChamsColor,
	Title = 'Chams Color',
	Transparency = nil,

	Callback = function(Value)
		_G.ChamsColor = Value
	end
})

ChamsBox:AddSlider('ChamsTrans', {
	Text = 'Chams Transparency',
	Default = _G.ChamsTrans,
	Min = 0,
	Max = 100,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		_G.ChamsTrans = Value / 100
	end
})

local WorldBox = Tabs.Visuals:AddRightGroupbox("World")

WorldBox:AddToggle("ToggleTime",{
	Text = "Toggle World Time",
	Default = _G.ToggleTime,

	Callback = function(Value)
		_G.ToggleTime = Value
	end
})

WorldBox:AddSlider('WorldTime', {
	Text = 'World Time',
	Default = _G.WorldTime,
	Min = 0,
	Max = 24,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		_G.WorldTime = Value
	end
})

WorldBox:AddToggle("RShadows",{
	Text = "Remove Shadows",
	Default = _G.Shadows,

	Callback = function(Value)
		_G.Shadows = Value
	end
})

local FogBox = Tabs.Visuals:AddRightGroupbox("Fog")

FogBox:AddSlider('FogStart', {
	Text = 'Fog Start',
	Default = _G.FogStart,
	Min = 0,
	Max = 1000,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		_G.FogStart = Value
	end
})

FogBox:AddSlider('FogEnd', {
	Text = 'Fog End',
	Default = _G.FogEnd,
	Min = 0,
	Max = 1000,
	Rounding = 1,
	Compact = false,

	Callback = function(Value)
		_G.FogEnd = Value
	end
})

FogBox:AddLabel('Color'):AddColorPicker('FogColor', {
	Default = _G.FogColor,
	Title = 'Fog Color',
	Transparency = nil,

	Callback = function(Value)
		_G.FogColor = Value
	end
})

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

runs.RenderStepped:Connect(function()
	if lplr.Character then
		if char ~= lplr.Character then
			char = lplr.Character
			if char:FindFirstChild("HumanoidRootPart") then
				hump = char.HumanoidRootPart
			end
		end
	end
	if _G.DrawFov then
		if fov.Radius ~= _G.AimFov then
			fov.Radius = _G.AimFov
		end
		if fov.Visible ~= _G.DrawFov then
			fov.Visible = _G.DrawFov
		end
	else
		if fov.Visible ~= _G.DrawFov then
			fov.Visible = _G.DrawFov
		end
	end
	if _G.Aimbot and aiming then
		local closestPlayer = nil
		local closestValue = math.huge

		if not char then return end

		if not hump then return end

		local mousePos = uis:GetMouseLocation()

		for _, player in ipairs(plrs:GetPlayers()) do
			if player == plrs.LocalPlayer then continue end

			local character = player.Character
			if not character then continue end

			if not isEnemy(player) then continue end
			if not isAlive(player) then continue end

			local targetPart = character:FindFirstChild(_G.Aimpart)
			if not targetPart then continue end

			local screenPos = camera:WorldToViewportPoint(targetPart.Position)
			if screenPos.Z <= 0 then continue end

			local screenPos2D = Vector2.new(screenPos.X, screenPos.Y)
			local crosshairDistance = (screenPos2D - mousePos).Magnitude

			if crosshairDistance > _G.AimFov then continue end

			local valueToCompare

			if _G.AimMethod == "Distance" then
				valueToCompare = (targetPart.Position - hump.Position).Magnitude

			elseif _G.AimMethod == "Crosshair" then
				valueToCompare = crosshairDistance
			end

			if valueToCompare < closestValue then
				closestPlayer = player
				closestValue = valueToCompare
			end
		end

		if closestPlayer then
			local character = closestPlayer.Character
			if character then
				local targetPart = character:FindFirstChild(_G.Aimpart)
				if targetPart then
					camera.CFrame = CFrame.new(camera.CFrame.Position, targetPart.Position)
				end
			end
		end
	end

	for _, plr in plrs:GetPlayers() do
		if plr ~= game.Players.LocalPlayer then
			if plr then
				local char = plr.Character
				if char then
					--Highlight
					if _G.Highlight then
						if not char:FindFirstChild("hl") then
							local hl = Instance.new("Highlight", char)
							hl.FillTransparency = 1
							hl.OutlineColor = _G.HighlightColor
							hl.Name = "hl"
							if _G.HighlightAOT then
								hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
							else
								hl.DepthMode = Enum.HighlightDepthMode.Occluded
							end
						end
						if char:FindFirstChild("hl") then
							local hl = char.hl
							if hl.OutlineColor ~= _G.HighlightColor then
								hl.OutlineColor = _G.HighlightColor
							end
							if _G.HighlightAOT then
								if hl.DepthMode == Enum.HighlightDepthMode.Occluded then
									hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
								end
							else
								if hl.DepthMode == Enum.HighlightDepthMode.AlwaysOnTop then
									hl.DepthMode = Enum.HighlightDepthMode.Occluded
								end
							end
						end
					else
						if char:FindFirstChild("hl") then
							char.hl:Destroy()
						end
					end
					for _, part in pairs(char:GetChildren()) do
						if part:IsA("Part") or part:IsA("MeshPart") then
							--Chams
							if _G.Chams then
								if not part:FindFirstChild("Chams") then
									local chams = Instance.new("BoxHandleAdornment", part)
									chams.Adornee = part
									chams.Color3 = _G.ChamsColor
									chams.AlwaysOnTop = _G.ChamsAOT
									chams.Transparency = _G.ChamsTrans
									chams.AdornCullingMode = Enum.AdornCullingMode.Never
									chams.Size = part.Size + Vector3.new(0.01, 0.01, 0.01)
									chams.Name = "Chams"
									chams.ZIndex = 4
									if part.Name == "Head" then
										chams.Size = Vector3.new(1.1, 1.1, 1.1)
									end
								end
								if part:FindFirstChild("Chams") then
									local chams = part.Chams
									if chams.Color3 ~= _G.ChamsColor then
										chams.Color3 = _G.ChamsColor
									end
									if chams.Transparency ~= _G.ChamsTrans then
										chams.Transparency = _G.ChamsTrans
									end
									if chams.AlwaysOnTop ~= _G.ChamsAOT then
										chams.AlwaysOnTop = _G.ChamsAOT
									end
								end
							else
								if part:FindFirstChild("Chams") then
									part.Chams:Destroy()
								end
							end
						end
					end
				end
			end
		end
	end
	if _G.ToggleTime then
		if light.ClockTime ~= _G.WorldTime then
			light.ClockTime = _G.WorldTime
		end
	end

	if light.GlobalShadows ~= not _G.Shadows then
		light.GlobalShadows = not _G.Shadows
	end

	if light.GlobalShadows == false then
		light.LightingStyle = Enum.LightingStyle.Realistic
	end

	if light.FogStart ~= _G.FogStart then
		light.FogStart = _G.FogStart
	end
	if light.FogEnd ~= _G.FogEnd then
		light.FogEnd = _G.FogEnd
	end
	if light.FogColor ~= _G.FogColor then
		light.FogColor = _G.FogColor
	end
end)
