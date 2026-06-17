local L = pace.LanguageString

pace.Fonts = {}


for i = 1, 7 do
	surface.CreateFont("pac_font_"..i,
	{
		font = "Arial",
		size = 11 + i,
		weight = 50,
		antialias = true,
	})

	table.insert(pace.Fonts, "pac_font_"..i)
end

for i = 8, 32, 4 do
	surface.CreateFont("pac_font_"..i,
	{
		font = "Arial",
		size = 11 + i,
		weight = 50,
		antialias = true,
	})

	table.insert(pace.Fonts, "pac_font_"..i)
end

for i = 1, 7 do
	surface.CreateFont("pac_font_bold_"..i,
	{
		font = "Arial",
		size = 11 + i,
		weight = 800,
		antialias = true,
	})
	table.insert(pace.Fonts, "pac_font_bold_"..i)
end

for i = 8, 32, 4 do
	surface.CreateFont("pac_font_bold_"..i,
	{
		font = "Arial",
		size = 11 + i,
		weight = 50,
		antialias = true,
	})

	table.insert(pace.Fonts, "pac_font_bold_"..i)
end

table.insert(pace.Fonts, "DermaDefault")
table.insert(pace.Fonts, "DermaDefaultBold")

local font_cvar = CreateClientConVar("pac_editor_font", pace.Fonts[1])
-- Separate font for editor UI chrome (menu bar, dropdown menus, settings headers).
-- Defaults to pac_font_5 (size 16) so chrome text stays readable on high-DPI displays.
local ui_font_cvar = CreateClientConVar("pac_editor_ui_font", "pac_font_5")

-- Returns the rendered text height of a font, used to size UI elements so larger
-- fonts are not clipped vertically.
function pace.GetFontHeight(fnt)
	surface.SetFont(fnt or "DermaDefault")
	local _, h = surface.GetTextSize("|")
	return h
end

function pace.SetFont(fnt)
	pace.CurrentFont = fnt or font_cvar:GetString()

	if not table.HasValue(pace.Fonts, pace.CurrentFont) then
		pace.CurrentFont = "DermaDefault"
	end

	RunConsoleCommand("pac_editor_font", pace.CurrentFont)

	if pace.Editor and pace.Editor:IsValid() then
		pace.CloseEditor()
		timer.Simple(0.1, function()
			pace.OpenEditor()
		end)
	end
end

function pace.SetUIFont(fnt)
	pace.CurrentUIFont = fnt or ui_font_cvar:GetString()

	if not table.HasValue(pace.Fonts, pace.CurrentUIFont) then
		pace.CurrentUIFont = "DermaDefault"
	end

	pace.CurrentUIFontHeight = pace.GetFontHeight(pace.CurrentUIFont)

	-- A larger header variant of the UI font for settings category titles. Created
	-- dynamically so it scales with the user-selected UI font size.
	surface.CreateFont("pac_ui_header_font", {
		font = "Arial",
		size = math.Round(pace.CurrentUIFontHeight * 1.4),
		weight = 700,
		antialias = true,
	})
	pace.CurrentUIHeaderFont = "pac_ui_header_font"

	RunConsoleCommand("pac_editor_ui_font", pace.CurrentUIFont)

	if pace.Editor and pace.Editor:IsValid() then
		pace.CloseEditor()
		timer.Simple(0.1, function()
			pace.OpenEditor()
		end)
	end
end

function pace.AddFontsToMenu(menu)
	local menu,pnl = menu:AddSubMenu(L"font")
	pnl:SetImage("icon16/text_bold.png")
	menu.GetDeleteSelf = function() return false end

	for key, val in pairs(pace.Fonts) do
		local pnl = menu:AddOption(L"The quick brown fox jumps over the lazy dog. (" ..val ..")", function()
			pace.SetFont(val)
		end)

		pnl:SetFont(val)
	end
end

function pace.AddUIFontsToMenu(menu)
	local menu,pnl = menu:AddSubMenu(L"UI font")
	pnl:SetImage("icon16/text_smallcaps.png")
	menu.GetDeleteSelf = function() return false end

	for key, val in pairs(pace.Fonts) do
		local pnl = menu:AddOption(L"The quick brown fox jumps over the lazy dog. (" ..val ..")", function()
			pace.SetUIFont(val)
		end)

		pnl:SetFont(val)
	end
end

pace.SetFont()
pace.SetUIFont()