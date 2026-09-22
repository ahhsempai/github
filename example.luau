local SourceUrl = "https://raw.githubusercontent.com/ahhsempai/github/main/Source.luau"
local Source = assert(game:HttpGet(SourceUrl))
local Loader = assert(loadstring(Source))
local Airflow = Loader()
assert(type(Airflow) == "table", "Source.luau did not return the Airflow library")
assert(type(Airflow.LoadFont) == "function", "Source.luau is not the modified library version")

Airflow:LoadFont({ Name = "ValleySans" })

local Window = Airflow:CreateWindow({
    Name = "Airflow",
    LoadingSubtitle = "Example",
    ToggleUIKeybind = "RightControl",

    ConfigurationSaving = { Enabled = true, FolderName = "AirflowExample", FileName = "default" },
    Home = {
        Name = "Home",
        Stats = { "FPS", "Ping", "Executor", "Game", "Region", "Time" },
        Pages = {
            {
                Name = "Changelog",
                Icon = "scroll-text",
                Entries = {
                    { Title = "v1.2", Tag = "Latest", Changes = { "Added the home tab", "Smaller input boxes that grow", "Faster dropdowns" } },
                    { Title = "v1.1", Tag = "Aug 30", Changes = { "Config manager", "Stepper and progress elements" } },
                },
            },
            {
                Name = "Info",
                Icon = "info",
                Content = "Airflow UI example. Everything on the Elements tab just prints, so you can click around safely.",
            },
        },
    }
})

local Elements = Window:CreateTab({ Name = "Elements", Desc = "One of everything", Icon = "layout-grid" })

Elements:CreateSection("Example section")

Elements:CreateButton({
    Name = "Example button",
    Desc = "Example description",
    Icon = "mouse-pointer-click",
    Callback = function()
        print("button")
    end,
})

Elements:CreateButton({
    Name = "Example primary button",
    Style = "Primary",
    Callback = function()
        print("primary button")
    end,
})

Elements:CreateToggle({
    Name = "Example toggle",
    Desc = "Example description",
    CurrentValue = false,
    Flag = "ExampleToggle",
    Callback = function(Value)
        print("toggle", Value)
    end,
})

Elements:CreateSlider({
    Name = "Example slider",
    Range = { 0, 100 },
    Increment = 1,
    Suffix = "%",
    CurrentValue = 50,
    Flag = "ExampleSlider",
    Callback = function(Value)
        print("slider", Value)
    end,
})

Elements:CreateStepper({
    Name = "Example stepper",
    Range = { 0, 10 },
    Increment = 1,
    CurrentValue = 5,
    Flag = "ExampleStepper",
    Callback = function(Value)
        print("stepper", Value)
    end,
})

Elements:CreateProgress({
    Name = "Example progress",
    CurrentValue = 0.65,
})

Elements:CreateDropdown({
    Name = "Example dropdown",
    Options = { "Option 1", "Option 2", "Option 3" },
    CurrentOption = "Option 1",
    Flag = "ExampleDropdown",
    Callback = function(Option)
        print("dropdown", Option)
    end,
})

Elements:CreateDropdown({
    Name = "Example multi dropdown",
    Options = { "Option 1", "Option 2", "Option 3", "Option 4" },
    MultipleOptions = true,
    CurrentOption = { "Option 1" },
    Flag = "ExampleMultiDropdown",
    Callback = function(Options)
        print("multi dropdown", table.concat(Options, ", "))
    end,
})

Elements:CreateInput({
    Name = "Example input",
    PlaceholderText = "Type here",
    Flag = "ExampleInput",
    Callback = function(Text, EnterPressed)
        print("input", Text, EnterPressed)
    end,
})

Elements:CreateKeybind({
    Name = "Example keybind",
    CurrentKeybind = "F",
    Flag = "ExampleKeybind",
    Callback = function(Key)
        print("keybind", Key.Name)
    end,
})

Elements:CreateColorPicker({
    Name = "Example color picker",
    Color = Color3.fromRGB(235, 199, 246),
    Flag = "ExampleColor",
    Callback = function(Color)
        print("color", Color)
    end,
})

Elements:CreateDivider()

Elements:CreateLabel("Example label")

Elements:CreateParagraph({
    Title = "Example paragraph",
    Content = "Longer text that wraps across several lines.",
})

local Popups = Window:CreateTab({ Name = "Popups", Desc = "Notifications and dialogs", Icon = "bell" })

Popups:CreateButton({
    Name = "Example notification",
    Callback = function()
        Airflow:Notify({
            Title = "Example",
            Content = "Example notification",
            Icon = "bell",
            Type = "Success",
            Duration = 3,
        })
    end,
})

Popups:CreateButton({
    Name = "Example confirm",
    Callback = function()
        Airflow:Confirm({
            Title = "Example confirm",
            Content = "Are you sure?",
            ConfirmText = "Yes",
            CancelText = "No",
            Callback = function()
                print("confirmed")
            end,
        })
    end,
})

Popups:CreateButton({
    Name = "Example dialog",
    Callback = function()
        Airflow:Dialog({
            Title = "Example dialog",
            Content = "Pick one.",
            Buttons = {
                { Title = "One", Callback = function() print("one") end },
                { Title = "Two", Callback = function() print("two") end },
                { Title = "Three", Variant = "Primary", Callback = function() print("three") end },
            },
        })
    end,
})

Window:CreateTab({ Name = "Empty", Desc = "Nothing in here", Icon = "package" })

local Settings = Window:CreateTab({ Name = "Settings", Icon = "settings" })

Settings:CreateSection("Appearance")

local ThemeSelector = Settings:CreateDropdown({
    Name = "UI Theme",
    Desc = "Change the interface theme instantly",
    Options = Airflow:GetThemeNames(),
    CurrentOption = Airflow.CurrentTheme,
    Flag = "UITheme",
    Callback = function(ThemeName)
        Airflow:SetTheme(ThemeName)
    end,
})

local CustomThemeColor = Settings:CreateColorPicker({
    Name = "Custom theme color",
    Desc = "Choose your own accent color for Custom",
    Color = Airflow.CustomThemeColor,
    Flag = "UIThemeColor",
    Callback = function(Color)
        Airflow:SetCustomTheme(Color)
        ThemeSelector:Set("Custom", true)
        Window:_autoSave()
    end,
})

Settings:CreateKeybind({
    Name = "Toggle UI",
    CurrentKeybind = "RightControl",
    OnChanged = function(Key)
        Window:SetKeybind(Key)
    end,
})

Settings:CreateConfigManager({ Name = "Configs" })

Settings:CreateButton({
    Name = "Unload",
    Icon = "power",
    Callback = function()
        Airflow:Confirm({
            Title = "Unload?",
            ConfirmText = "Unload",
            Callback = function()
                Window:Destroy()
            end,
        })
    end,
})

Window:LoadConfig()

local SavedTheme = ThemeSelector:Get() or "Default"
if SavedTheme == "Custom" then
    Airflow:SetCustomTheme(CustomThemeColor:Get() or Airflow.CustomThemeColor)
else
    Airflow:SetTheme(SavedTheme)
end

