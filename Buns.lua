local Icons = loadstring(game:HttpGet("https://raw.githubusercontent.com/ArchIsDead/Arch-Vault/refs/heads/main/lucide-icons.lua"))()

local Library = {
    Flags = {},
    Icons = Icons,
    Themes = {
        dark = {
            bg = Color3.fromRGB(0, 0, 0),
            main = Color3.fromRGB(2, 2, 2),
            surface = Color3.fromRGB(6, 6, 6),
            surface2 = Color3.fromRGB(10, 10, 10),
            border = Color3.fromRGB(15, 15, 15),
            border2 = Color3.fromRGB(30, 30, 30),
            text = Color3.fromRGB(255, 255, 255),
            text2 = Color3.fromRGB(130, 130, 130),
            text3 = Color3.fromRGB(50, 50, 50),
            accent = Color3.fromRGB(88, 101, 242),
            accent2 = Color3.fromRGB(64, 78, 237),
            success = Color3.fromRGB(47, 183, 117),
            error = Color3.fromRGB(248, 81, 73),
            glass = Color3.fromRGB(255, 255, 255)
        }
    }
}

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

local function Create(class, props)
    local obj = Instance.new(class)
    for k, v in pairs(props) do
        if k ~= "Parent" then
            obj[k] = v
        end
    end
    return obj
end

function Library:SetTheme(theme)
    self.Theme = self.Themes[theme] or self.Themes.dark
end

Library:SetTheme("dark")

function Library:CreateIcon(name, size)
    local id = self.Icons[name]
    if not id then return Create("Frame") end
    return Create("ImageLabel", {
        Size = UDim2.new(0, size or 20, 0, size or 20),
        BackgroundTransparency = 1,
        Image = id,
        ImageColor3 = self.Theme.text,
        ScaleType = "Fit"
    })
end

function Library:CreateLoader()
    local Loader = {}
    local ScreenGui = Create("ScreenGui", {Name = "LibraryLoader", ResetOnSpawn = false, ZIndexBehavior = "Sibling"})
    local Frame = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = self.Theme.bg,
        BackgroundTransparency = 0.2,
        BorderSizePixel = 0,
        Parent = ScreenGui
    })
    local Left = Create("Frame", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = self.Theme.main,
        BorderSizePixel = 0,
        Parent = Frame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 0), Parent = Left})
    local Right = Create("Frame", {
        Size = UDim2.new(0.5, 0, 1, 0),
        Position = UDim2.new(0.5, 0, 0, 0),
        BackgroundColor3 = self.Theme.main,
        BorderSizePixel = 0,
        Parent = Frame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 0), Parent = Right})
    local Logo = self:CreateIcon("a-large-small", 80)
    Logo.Position = UDim2.new(0.5, -40, 0.5, -70)
    Logo.ImageColor3 = self.Theme.accent
    Logo.Parent = Frame
    local Status = Create("TextLabel", {
        Size = UDim2.new(0, 300, 0, 30),
        Position = UDim2.new(0.5, -150, 0.5, 20),
        BackgroundTransparency = 1,
        Text = "Loading...",
        TextColor3 = self.Theme.text2,
        TextSize = 18,
        Font = "GothamBold",
        Parent = Frame
    })
    local ProgressBar = Create("Frame", {
        Size = UDim2.new(0, 0, 0, 4),
        Position = UDim2.new(0.5, -150, 0.5, 55),
        BackgroundColor3 = self.Theme.accent,
        BorderSizePixel = 0,
        Parent = Frame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = ProgressBar})
    local BarBg = Create("Frame", {
        Size = UDim2.new(0, 300, 0, 4),
        Position = UDim2.new(0.5, -150, 0.5, 55),
        BackgroundColor3 = self.Theme.border,
        BorderSizePixel = 0,
        Parent = Frame
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = BarBg})

    function Loader:SetText(text)
        Status.Text = text
    end

    function Loader:Start()
        ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        TweenService:Create(ProgressBar, TweenInfo.new(0.5), {Size = UDim2.new(0, 300, 0, 4)}):Play()
    end

    function Loader:End()
        TweenService:Create(Status, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
        TweenService:Create(Logo, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
        TweenService:Create(ProgressBar, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        TweenService:Create(BarBg, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
        task.wait(0.2)
        TweenService:Create(Left, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(-0.5, 0, 0, 0)}):Play()
        TweenService:Create(Right, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = UDim2.new(1, 0, 0, 0)}):Play()
        task.wait(0.4)
        Frame:Destroy()
    end
    return Loader
end

function Library:CreateWindow(opts)
    opts = opts or {}
    local Window = {Tabs = {}, Elements = {}, Dragging = {isDragging = false}}
    Window.ScreenGui = Create("ScreenGui", {Name = "LibraryWindow", ResetOnSpawn = false, ZIndexBehavior = "Sibling"})
    Window.Main = Create("Frame", {
        Size = opts.Size or UDim2.new(0, 600, 0, 400),
        Position = opts.Position or UDim2.new(0.5, -300, 0.5, -200),
        BackgroundColor3 = Library.Theme.main,
        BorderSizePixel = 0,
        Parent = Window.ScreenGui,
        Active = true,
        ClipsDescendants = true
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Window.Main})
    Create("UIStroke", {Color = Library.Theme.border, Thickness = 1, Parent = Window.Main})
    Window.Glass = Create("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Library.Theme.glass,
        BackgroundTransparency = 0.985,
        BorderSizePixel = 0,
        Parent = Window.Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Window.Glass})
    Window.TopBar = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = Library.Theme.surface,
        BorderSizePixel = 0,
        Parent = Window.Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Window.TopBar})
    local TopBarFix = Create("Frame", {
        Size = UDim2.new(1, 0, 0, 10),
        Position = UDim2.new(0, 0, 1, -10),
        BackgroundColor3 = Library.Theme.surface,
        BorderSizePixel = 0,
        Parent = Window.TopBar
    })
    Window.Title = Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 45, 0, 0),
        BackgroundTransparency = 1,
        Text = opts.Title or "Library",
        TextColor3 = Library.Theme.text,
        TextSize = 16,
        Font = "GothamBold",
        TextXAlignment = "Left",
        Parent = Window.TopBar
    })
    Window.Subtitle = Create("TextLabel", {
        Size = UDim2.new(0, 200, 1, 0),
        Position = UDim2.new(0, 45, 0, 16),
        BackgroundTransparency = 1,
        Text = opts.SubTitle or "",
        TextColor3 = Library.Theme.text2,
        TextSize = 11,
        Font = "Gotham",
        TextXAlignment = "Left",
        Parent = Window.TopBar
    })
    Window.Version = Create("TextLabel", {
        Size = UDim2.new(0, 50, 1, 0),
        Position = UDim2.new(1, -90, 0, 0),
        BackgroundTransparency = 1,
        Text = opts.Version or "v1.0",
        TextColor3 = Library.Theme.text2,
        TextSize = 12,
        Font = "Gotham",
        Parent = Window.TopBar
    })
    Window.Icon = Library:CreateIcon(opts.Icon or "a-large-small", 20)
    Window.Icon.Position = UDim2.new(0, 15, 0.5, -10)
    Window.Icon.ImageColor3 = Library.Theme.accent
    Window.Icon.Parent = Window.TopBar
    Window.Minimize = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -60, 0.5, -15),
        BackgroundColor3 = Library.Theme.surface2,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = Window.TopBar
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Window.Minimize})
    local MinIcon = Library:CreateIcon("minus", 14)
    MinIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
    MinIcon.ImageColor3 = Library.Theme.text2
    MinIcon.Parent = Window.Minimize
    Window.Close = Create("TextButton", {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -25, 0.5, -15),
        BackgroundColor3 = Library.Theme.surface2,
        BackgroundTransparency = 0.5,
        BorderSizePixel = 0,
        Text = "",
        AutoButtonColor = false,
        Parent = Window.TopBar
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Window.Close})
    local CloseIcon = Library:CreateIcon("x", 14)
    CloseIcon.Position = UDim2.new(0.5, -7, 0.5, -7)
    CloseIcon.ImageColor3 = Library.Theme.text2
    CloseIcon.Parent = Window.Close
    Window.TabContainer = Create("Frame", {
        Size = UDim2.new(0, 120, 1, -50),
        Position = UDim2.new(0, 0, 0, 50),
        BackgroundColor3 = Library.Theme.surface,
        BorderSizePixel = 0,
        Parent = Window.Main
    })
    Create("UICorner", {CornerRadius = UDim.new(0, 0), Parent = Window.TabContainer})
    Window.PageContainer = Create("ScrollingFrame", {
        Size = UDim2.new(1, -130, 1, -50),
        Position = UDim2.new(0, 125, 0, 55),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Library.Theme.border2,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Parent = Window.Main
    })
    Window.Tabs = {}
    Window.Pages = {}
    Window.Dragging = {isDragging = false}
    Window.Main.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Window.Dragging.isDragging = true
            Window.Dragging.dragInput = input
            Window.Dragging.dragStart = input.Position
            Window.Dragging.startPos = Window.Main.Position
        end
    end)
    Window.Main.InputChanged:Connect(function(input)
        if Window.Dragging.isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - Window.Dragging.dragStart
            Window.Main.Position = UDim2.new(Window.Dragging.startPos.X.Scale, Window.Dragging.startPos.X.Offset + delta.X, Window.Dragging.startPos.Y.Scale, Window.Dragging.startPos.Y.Offset + delta.Y)
        end
    end)
    Window.Main.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Window.Dragging.isDragging = false
        end
    end)
    Window.Close.MouseButton1Click:Connect(function()
        Window.ScreenGui:Destroy()
    end)
    Window.Minimize.MouseButton1Click:Connect(function()
        Window.Main.Visible = not Window.Main.Visible
    end)

    function Window:AddTab(name, icon)
        local Tab = {Sections = {}, Elements = {}}
        Tab.Button = Create("TextButton", {
            Size = UDim2.new(1, 0, 0, 35),
            Position = UDim2.new(0, 0, 0, (#Window.Tabs * 35) + 5),
            BackgroundColor3 = Library.Theme.surface2,
            BackgroundTransparency = 0.7,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = Window.TabContainer
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Tab.Button})
        local TabIcon = Library:CreateIcon(icon or "a-large-small", 16)
        TabIcon.Position = UDim2.new(0, 10, 0.5, -8)
        TabIcon.ImageColor3 = Library.Theme.text2
        TabIcon.Parent = Tab.Button
        local TabName = Create("TextLabel", {
            Size = UDim2.new(1, -35, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Library.Theme.text2,
            TextSize = 13,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = Tab.Button
        })
        Tab.Page = Create("ScrollingFrame", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Library.Theme.border2,
            CanvasSize = UDim2.new(0, 0, 0, 0),
            Parent = Window.PageContainer,
            Visible = #Window.Tabs == 0
        })
        Tab.Button.MouseButton1Click:Connect(function()
            for _, t in ipairs(Window.Tabs) do
                t.Page.Visible = false
                TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.7}):Play()
            end
            Tab.Page.Visible = true
            TweenService:Create(Tab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end)
        if #Window.Tabs == 0 then
            TweenService:Create(Tab.Button, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end
        table.insert(Window.Tabs, Tab)
        return Tab
    end

    function Window:AddSection(tab, name)
        local Section = {Elements = {}}
        local Y = #tab.Sections * 100
        Section.Container = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 90),
            Position = UDim2.new(0, 10, 0, Y),
            BackgroundTransparency = 1,
            Parent = tab.Page
        })
        local Title = Create("TextLabel", {
            Size = UDim2.new(0, 100, 0, 20),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Library.Theme.text,
            TextSize = 14,
            Font = "GothamBold",
            TextXAlignment = "Left",
            Parent = Section.Container
        })
        local Divider = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0, 0, 0, 25),
            BackgroundColor3 = Library.Theme.border2,
            BorderSizePixel = 0,
            Parent = Section.Container
        })
        local Content = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 60),
            Position = UDim2.new(0, 0, 0, 30),
            BackgroundTransparency = 1,
            Parent = Section.Container
        })
        Section.Content = Content
        table.insert(tab.Sections, Section)
        tab.Page.CanvasSize = UDim2.new(0, 0, 0, (#tab.Sections * 100))
        return Section
    end

    function Window:AddButton(section, opts)
        opts = opts or {}
        local Button = {}
        local Y = #section.Elements * 35
        Button.Container = Create("TextButton", {
            Size = UDim2.new(0, 150, 0, 30),
            Position = UDim2.new(0, 0, 0, Y),
            BackgroundColor3 = Library.Theme.surface2,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = section.Content
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Button.Container})
        if opts.icon then
            local BtnIcon = Library:CreateIcon(opts.icon, 14)
            BtnIcon.Position = UDim2.new(0, 10, 0.5, -7)
            BtnIcon.ImageColor3 = Library.Theme.text2
            BtnIcon.Parent = Button.Container
        end
        local BtnText = Create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, opts.icon and 30 or 10, 0, 0),
            BackgroundTransparency = 1,
            Text = opts.text or "Button",
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = Button.Container
        })
        Button.Container.MouseEnter:Connect(function()
            TweenService:Create(Button.Container, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
        end)
        Button.Container.MouseLeave:Connect(function()
            TweenService:Create(Button.Container, TweenInfo.new(0.2), {BackgroundTransparency = 0.5}):Play()
        end)
        if opts.callback then
            Button.Container.MouseButton1Click:Connect(opts.callback)
        end
        function Button:SetText(text)
            BtnText.Text = text
        end
        function Button:SetDesc(desc)
            BtnText.Text = opts.text .. " - " .. desc
        end
        function Button:Destroy()
            Button.Container:Destroy()
        end
        table.insert(section.Elements, Button)
        return Button
    end

    function Window:AddToggle(section, opts)
        opts = opts or {}
        local Toggle = {Value = opts.default or false}
        local Y = #section.Elements * 35
        Toggle.Container = Create("Frame", {
            Size = UDim2.new(0, 200, 0, 30),
            Position = UDim2.new(0, 0, 0, Y),
            BackgroundTransparency = 1,
            Parent = section.Content
        })
        local ToggleBtn = Create("TextButton", {
            Size = UDim2.new(0, 44, 0, 22),
            Position = UDim2.new(1, -50, 0.5, -11),
            BackgroundColor3 = Toggle.Value and Library.Theme.accent or Library.Theme.surface2,
            BackgroundTransparency = Toggle.Value and 0.2 or 0.5,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = Toggle.Container
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = ToggleBtn})
        Toggle.Knob = Create("Frame", {
            Size = UDim2.new(0, 18, 0, 18),
            Position = Toggle.Value and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
            BackgroundColor3 = Library.Theme.text,
            BorderSizePixel = 0,
            Parent = ToggleBtn
        })
        Create("UICorner", {CornerRadius = UDim.new(1, 0), Parent = Toggle.Knob})
        local ToggleText = Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = opts.text or "Toggle",
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = Toggle.Container
        })
        local Desc = Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 0, 0, 15),
            BackgroundTransparency = 1,
            Text = opts.desc or "",
            TextColor3 = Library.Theme.text2,
            TextSize = 11,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = Toggle.Container,
            Visible = opts.desc and true or false
        })
        if opts.desc then
            Toggle.Container.Size = UDim2.new(0, 200, 0, 45)
        end
        function Toggle:SetValue(val)
            Toggle.Value = val
            TweenService:Create(ToggleBtn, TweenInfo.new(0.3), {BackgroundColor3 = val and Library.Theme.accent or Library.Theme.surface2, BackgroundTransparency = val and 0.2 or 0.5}):Play()
            TweenService:Create(Toggle.Knob, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = val and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)}):Play()
            if opts.callback then opts.callback(val) end
        end
        ToggleBtn.MouseButton1Click:Connect(function()
            Toggle:SetValue(not Toggle.Value)
        end)
        function Toggle:SetText(text)
            ToggleText.Text = text
        end
        function Toggle:SetDesc(text)
            Desc.Text = text
            Desc.Visible = text and true or false
            Toggle.Container.Size = UDim2.new(0, 200, 0, text and 45 or 30)
        end
        function Toggle:Destroy()
            Toggle.Container:Destroy()
        end
        table.insert(section.Elements, Toggle)
        return Toggle
    end

    function Window:AddSlider(section, opts)
        opts = opts or {}
        local Slider = {Value = opts.default or opts.min or 0, Dragging = false}
        local Y = #section.Elements * 45
        Slider.Container = Create("Frame", {
            Size = UDim2.new(0, 250, 0, 40),
            Position = UDim2.new(0, 0, 0, Y),
            BackgroundTransparency = 1,
            Parent = section.Content
        })
        local SliderText = Create("TextLabel", {
            Size = UDim2.new(1, -80, 0, 20),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = opts.text or "Slider",
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = Slider.Container
        })
        local ValueText = Create("TextLabel", {
            Size = UDim2.new(0, 50, 0, 20),
            Position = UDim2.new(1, -55, 0, 0),
            BackgroundTransparency = 1,
            Text = tostring(Slider.Value),
            TextColor3 = Library.Theme.accent,
            TextSize = 13,
            Font = "GothamBold",
            Parent = Slider.Container
        })
        local SliderBg = Create("Frame", {
            Size = UDim2.new(1, 0, 0, 4),
            Position = UDim2.new(0, 0, 0, 25),
            BackgroundColor3 = Library.Theme.border2,
            BorderSizePixel = 0,
            Parent = Slider.Container
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = SliderBg})
        Slider.Bar = Create("Frame", {
            Size = UDim2.new((Slider.Value - opts.min) / (opts.max - opts.min), 0, 1, 0),
            BackgroundColor3 = Library.Theme.accent,
            BorderSizePixel = 0,
            Parent = SliderBg
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 2), Parent = Slider.Bar})
        Slider.Drag = Create("TextButton", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "",
            Parent = SliderBg
        })
        local function update(val)
            Slider.Value = math.clamp(val, opts.min or 0, opts.max or 100)
            ValueText.Text = tostring(math.floor(Slider.Value))
            TweenService:Create(Slider.Bar, TweenInfo.new(0.1), {Size = UDim2.new((Slider.Value - opts.min) / (opts.max - opts.min), 0, 1, 0)}):Play()
            if opts.callback then opts.callback(Slider.Value) end
        end
        Slider.Drag.MouseButton1Down:Connect(function()
            Slider.Dragging = true
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Slider.Dragging = false
            end
        end)
        RunService.RenderStepped:Connect(function()
            if Slider.Dragging then
                local mousePos = UserInputService:GetMouseLocation()
                local absPos = SliderBg.AbsolutePosition
                local size = SliderBg.AbsoluteSize.X
                local percent = (mousePos.X - absPos.X) / size
                update(opts.min + (opts.max - opts.min) * percent)
            end
        end)
        function Slider:SetValue(val)
            update(val)
        end
        function Slider:SetText(text)
            SliderText.Text = text
        end
        function Slider:Destroy()
            Slider.Container:Destroy()
        end
        table.insert(section.Elements, Slider)
        return Slider
    end

    function Window:AddDropdown(section, opts)
        opts = opts or {}
        local Dropdown = {Open = false, Options = opts.options or {}, Selected = opts.default or (opts.options and opts.options[1])}
        local Y = #section.Elements * 40
        Dropdown.Container = Create("Frame", {
            Size = UDim2.new(0, 200, 0, 35),
            Position = UDim2.new(0, 0, 0, Y),
            BackgroundTransparency = 1,
            Parent = section.Content,
            ClipsDescendants = true
        })
        local DropText = Create("TextLabel", {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = opts.text or "Dropdown",
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = Dropdown.Container
        })
        local SelectBtn = Create("TextButton", {
            Size = UDim2.new(0, 100, 0, 25),
            Position = UDim2.new(1, -105, 0.5, -12.5),
            BackgroundColor3 = Library.Theme.surface2,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = Dropdown.Container
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = SelectBtn})
        local SelectedText = Create("TextLabel", {
            Size = UDim2.new(1, -20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = Dropdown.Selected or "Select",
            TextColor3 = Library.Theme.text,
            TextSize = 12,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = SelectBtn
        })
        local ArrowIcon = Library:CreateIcon("chevron-down", 12)
        ArrowIcon.Position = UDim2.new(1, -15, 0.5, -6)
        ArrowIcon.ImageColor3 = Library.Theme.text2
        ArrowIcon.Parent = SelectBtn
        Dropdown.OptionList = Create("ScrollingFrame", {
            Size = UDim2.new(0, 100, 0, 0),
            Position = UDim2.new(1, -105, 1, 0),
            BackgroundColor3 = Library.Theme.surface,
            BorderSizePixel = 0,
            ScrollBarThickness = 2,
            ScrollBarImageColor3 = Library.Theme.border2,
            CanvasSize = UDim2.new(0, 0, 0, #Dropdown.Options * 25),
            Visible = false,
            Parent = Dropdown.Container,
            ZIndex = 10
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Dropdown.OptionList})
        for i, opt in ipairs(Dropdown.Options) do
            local OptBtn = Create("TextButton", {
                Size = UDim2.new(1, 0, 0, 25),
                Position = UDim2.new(0, 0, 0, (i-1) * 25),
                BackgroundColor3 = Library.Theme.surface2,
                BackgroundTransparency = 0.7,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = Dropdown.OptionList,
                ZIndex = 11
            })
            local OptText = Create("TextLabel", {
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                BackgroundTransparency = 1,
                Text = opt,
                TextColor3 = Library.Theme.text2,
                TextSize = 12,
                Font = "Gotham",
                TextXAlignment = "Left",
                Parent = OptBtn,
                ZIndex = 11
            })
            OptBtn.MouseButton1Click:Connect(function()
                Dropdown.Selected = opt
                SelectedText.Text = opt
                Dropdown.Open = false
                Dropdown.OptionList.Visible = false
                TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
                Dropdown.Container.Size = UDim2.new(0, 200, 0, 35)
                if opts.callback then opts.callback(opt) end
            end)
        end
        SelectBtn.MouseButton1Click:Connect(function()
            Dropdown.Open = not Dropdown.Open
            Dropdown.OptionList.Visible = Dropdown.Open
            TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {Rotation = Dropdown.Open and 180 or 0}):Play()
            if Dropdown.Open then
                Dropdown.Container.Size = UDim2.new(0, 200, 0, 35 + math.min(#Dropdown.Options * 25, 100))
            else
                Dropdown.Container.Size = UDim2.new(0, 200, 0, 35)
            end
        end)
        function Dropdown:SetOptions(opts)
            Dropdown.Options = opts
            for _, v in ipairs(Dropdown.OptionList:GetChildren()) do
                if v:IsA("TextButton") then v:Destroy() end
            end
            for i, opt in ipairs(opts) do
                local OptBtn = Create("TextButton", {
                    Size = UDim2.new(1, 0, 0, 25),
                    Position = UDim2.new(0, 0, 0, (i-1) * 25),
                    BackgroundColor3 = Library.Theme.surface2,
                    BackgroundTransparency = 0.7,
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    Parent = Dropdown.OptionList,
                    ZIndex = 11
                })
                local OptText = Create("TextLabel", {
                    Size = UDim2.new(1, -10, 1, 0),
                    Position = UDim2.new(0, 5, 0, 0),
                    BackgroundTransparency = 1,
                    Text = opt,
                    TextColor3 = Library.Theme.text2,
                    TextSize = 12,
                    Font = "Gotham",
                    TextXAlignment = "Left",
                    Parent = OptBtn,
                    ZIndex = 11
                })
                OptBtn.MouseButton1Click:Connect(function()
                    Dropdown.Selected = opt
                    SelectedText.Text = opt
                    Dropdown.Open = false
                    Dropdown.OptionList.Visible = false
                    TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
                    Dropdown.Container.Size = UDim2.new(0, 200, 0, 35)
                    if opts.callback then opts.callback(opt) end
                end)
            end
            Dropdown.OptionList.CanvasSize = UDim2.new(0, 0, 0, #opts * 25)
        end
        function Dropdown:SetText(text)
            DropText.Text = text
        end
        function Dropdown:Destroy()
            Dropdown.Container:Destroy()
        end
        table.insert(section.Elements, Dropdown)
        return Dropdown
    end

    function Window:AddInput(section, opts)
        opts = opts or {}
        local Input = {Value = opts.default or ""}
        local Y = #section.Elements * 45
        Input.Container = Create("Frame", {
            Size = UDim2.new(0, 250, 0, 40),
            Position = UDim2.new(0, 0, 0, Y),
            BackgroundTransparency = 1,
            Parent = section.Content
        })
        local InputText = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 15),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = opts.text or "Input",
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = Input.Container
        })
        local InputBox = Create("TextBox", {
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 0, 0, 15),
            BackgroundColor3 = Library.Theme.surface2,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = Input.Value,
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "Gotham",
            PlaceholderText = opts.placeholder or "Enter...",
            PlaceholderColor3 = Library.Theme.text3,
            ClearTextOnFocus = false,
            Parent = Input.Container
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = InputBox})
        InputBox.FocusLost:Connect(function()
            Input.Value = InputBox.Text
            if opts.callback then opts.callback(Input.Value) end
        end)
        function Input:SetValue(val)
            Input.Value = val
            InputBox.Text = val
        end
        function Input:SetText(text)
            InputText.Text = text
        end
        function Input:SetPlaceholder(text)
            InputBox.PlaceholderText = text
        end
        function Input:Destroy()
            Input.Container:Destroy()
        end
        table.insert(section.Elements, Input)
        return Input
    end

    function Window:AddParagraph(section, opts)
        opts = opts or {}
        local Y = #section.Elements * 50
        local Paragraph = Create("Frame", {
            Size = UDim2.new(0, 250, 0, 45),
            Position = UDim2.new(0, 0, 0, Y),
            BackgroundTransparency = 1,
            Parent = section.Content
        })
        local ParaText = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 15),
            Position = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            Text = opts.text or "Paragraph",
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "GothamBold",
            TextXAlignment = "Left",
            Parent = Paragraph
        })
        local ParaDesc = Create("TextLabel", {
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 0, 0, 20),
            BackgroundTransparency = 1,
            Text = opts.desc or "",
            TextColor3 = Library.Theme.text2,
            TextSize = 11,
            Font = "Gotham",
            TextXAlignment = "Left",
            TextWrapped = true,
            Parent = Paragraph
        })
        table.insert(section.Elements, Paragraph)
        return Paragraph
    end

    function Window:AddDivider(section)
        local Y = #section.Elements * 25
        local Divider = Create("Frame", {
            Size = UDim2.new(1, -20, 0, 1),
            Position = UDim2.new(0, 10, 0, Y),
            BackgroundColor3 = Library.Theme.border2,
            BorderSizePixel = 0,
            Parent = section.Content
        })
        table.insert(section.Elements, Divider)
        return Divider
    end

    function Window:AddSpace(section, height)
        height = height or 10
        local Y = #section.Elements * height
        local Space = Create("Frame", {
            Size = UDim2.new(1, 0, 0, height),
            Position = UDim2.new(0, 0, 0, Y),
            BackgroundTransparency = 1,
            Parent = section.Content
        })
        table.insert(section.Elements, Space)
        return Space
    end

    function Window:Notification(opts)
        opts = opts or {}
        local Notif = Create("Frame", {
            Size = UDim2.new(0, 300, 0, 0),
            Position = UDim2.new(0.5, -150, 0.5, -75),
            BackgroundColor3 = Library.Theme.surface,
            BorderSizePixel = 0,
            Parent = Window.ScreenGui,
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            ZIndex = 100
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Notif})
        Create("UIStroke", {Color = Library.Theme.border, Thickness = 1, Parent = Notif})
        local NotifTitle = Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Text = opts.title or "Notification",
            TextColor3 = Library.Theme.text,
            TextSize = 14,
            Font = "GothamBold",
            TextXAlignment = "Left",
            Parent = Notif
        })
        local NotifDesc = Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 35),
            BackgroundTransparency = 1,
            Text = opts.desc or "",
            TextColor3 = Library.Theme.text2,
            TextSize = 12,
            Font = "Gotham",
            TextWrapped = true,
            Parent = Notif
        })
        local NotifBtn = Create("TextButton", {
            Size = UDim2.new(0, 100, 0, 30),
            Position = UDim2.new(0.5, -50, 1, -40),
            BackgroundColor3 = Library.Theme.accent,
            BackgroundTransparency = 0.2,
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            Parent = Notif
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = NotifBtn})
        local BtnText = Create("TextLabel", {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Text = "OK",
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "GothamBold",
            Parent = NotifBtn
        })
        Notif.Size = UDim2.new(0, 300, 0, 120)
        TweenService:Create(Notif, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {BackgroundTransparency = 0, Size = UDim2.new(0, 300, 0, 120)}):Play()
        NotifBtn.MouseButton1Click:Connect(function()
            TweenService:Create(Notif, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
            task.wait(0.3)
            Notif:Destroy()
        end)
        return Notif
    end

    function Window:Dialog(opts)
        opts = opts or {}
        local Dialog = Create("Frame", {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Library.Theme.surface,
            BorderSizePixel = 0,
            Parent = Window.ScreenGui,
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            ZIndex = 101
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 8), Parent = Dialog})
        Create("UIStroke", {Color = Library.Theme.border, Thickness = 1, Parent = Dialog})
        local DialogTitle = Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 25),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Text = opts.title or "Dialog",
            TextColor3 = Library.Theme.text,
            TextSize = 16,
            Font = "GothamBold",
            TextXAlignment = "Left",
            Parent = Dialog,
            ZIndex = 102
        })
        local DialogDesc = Create("TextLabel", {
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 40),
            BackgroundTransparency = 1,
            Text = opts.desc or "",
            TextColor3 = Library.Theme.text2,
            TextSize = 13,
            Font = "Gotham",
            TextWrapped = true,
            Parent = Dialog,
            ZIndex = 102
        })
        local BtnY = 90
        for i, btn in ipairs(opts.buttons or {}) do
            local Button = Create("TextButton", {
                Size = UDim2.new(0, 120, 0, 35),
                Position = UDim2.new(0.5, -60, 0, BtnY),
                BackgroundColor3 = btn.accent and Library.Theme.accent or Library.Theme.surface2,
                BackgroundTransparency = 0.3,
                BorderSizePixel = 0,
                Text = "",
                AutoButtonColor = false,
                Parent = Dialog,
                ZIndex = 102
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = Button})
            local BtnText = Create("TextLabel", {
                Size = UDim2.new(1, 0, 1, 0),
                BackgroundTransparency = 1,
                Text = btn.text or "Button",
                TextColor3 = Library.Theme.text,
                TextSize = 13,
                Font = "GothamBold",
                Parent = Button,
                ZIndex = 103
            })
            Button.MouseButton1Click:Connect(function()
                if btn.callback then btn.callback() end
                TweenService:Create(Dialog, TweenInfo.new(0.3), {BackgroundTransparency = 1, Size = UDim2.new(0, 0, 0, 0)}):Play()
                task.wait(0.3)
                Dialog:Destroy()
            end)
            BtnY = BtnY + 45
        end
        TweenService:Create(Dialog, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 300, 0, BtnY + 20), BackgroundTransparency = 0}):Play()
        return Dialog
    end

    function Window:AddColorPicker(section, opts)
        opts = opts or {}
        local ColorPicker = {Value = opts.default or Library.Theme.accent, Open = false}
        local Y = #section.Elements * 40
        ColorPicker.Container = Create("Frame", {
            Size = UDim2.new(0, 200, 0, 35),
            Position = UDim2.new(0, 0, 0, Y),
            BackgroundTransparency = 1,
            Parent = section.Content,
            ClipsDescendants = true
        })
        local ColorText = Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = opts.text or "Color",
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = ColorPicker.Container
        })
        local ColorPreview = Create("Frame", {
            Size = UDim2.new(0, 30, 0, 25),
            Position = UDim2.new(1, -105, 0.5, -12.5),
            BackgroundColor3 = ColorPicker.Value,
            BorderSizePixel = 0,
            Parent = ColorPicker.Container
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 4), Parent = ColorPreview})
        local PickBtn = Create("TextButton", {
            Size = UDim2.new(0, 100, 0, 25),
            Position = UDim2.new(1, -105, 0.5, -12.5),
            BackgroundTransparency = 1,
            Text = "",
            Parent = ColorPicker.Container
        })
        local ArrowIcon = Library:CreateIcon("chevron-down", 12)
        ArrowIcon.Position = UDim2.new(1, -15, 0.5, -6)
        ArrowIcon.ImageColor3 = Library.Theme.text2
        ArrowIcon.Parent = PickBtn
        local function createPicker()
            local pickerFrame = Create("Frame", {
                Size = UDim2.new(0, 150, 0, 150),
                Position = UDim2.new(1, -130, 1, 5),
                BackgroundColor3 = Library.Theme.surface,
                BorderSizePixel = 0,
                Parent = ColorPicker.Container,
                ZIndex = 20,
                Visible = ColorPicker.Open
            })
            Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = pickerFrame})
            for r = 0, 9 do
                for g = 0, 9 do
                    for b = 0, 9 do
                        if r + g + b <= 9 then
                            local color = Color3.fromRGB(r * 28, g * 28, b * 28)
                            local btn = Create("TextButton", {
                                Size = UDim2.new(0, 15, 0, 15),
                                Position = UDim2.new(0, r * 15, 0, g * 15 + b * 50),
                                BackgroundColor3 = color,
                                Text = "",
                                Parent = pickerFrame,
                                ZIndex = 21
                            })
                            btn.MouseButton1Click:Connect(function()
                                ColorPicker.Value = color
                                ColorPreview.BackgroundColor3 = color
                                ColorPicker.Open = false
                                pickerFrame.Visible = false
                                TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {Rotation = 0}):Play()
                                if opts.callback then opts.callback(color) end
                            end)
                        end
                    end
                end
            end
            return pickerFrame
        end
        local PickerFrame = createPicker()
        PickBtn.MouseButton1Click:Connect(function()
            ColorPicker.Open = not ColorPicker.Open
            PickerFrame.Visible = ColorPicker.Open
            TweenService:Create(ArrowIcon, TweenInfo.new(0.2), {Rotation = ColorPicker.Open and 180 or 0}):Play()
        end)
        function ColorPicker:SetValue(color)
            self.Value = color
            ColorPreview.BackgroundColor3 = color
        end
        function ColorPicker:SetText(text)
            ColorText.Text = text
        end
        function ColorPicker:Destroy()
            ColorPicker.Container:Destroy()
        end
        table.insert(section.Elements, ColorPicker)
        return ColorPicker
    end

    function Window:AddKeybind(section, opts)
        opts = opts or {}
        local Keybind = {Value = opts.default or Enum.KeyCode.F, Listening = false}
        local Y = #section.Elements * 35
        Keybind.Container = Create("Frame", {
            Size = UDim2.new(0, 200, 0, 30),
            Position = UDim2.new(0, 0, 0, Y),
            BackgroundTransparency = 1,
            Parent = section.Content
        })
        local KeyText = Create("TextLabel", {
            Size = UDim2.new(1, -60, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = opts.text or "Keybind",
            TextColor3 = Library.Theme.text,
            TextSize = 13,
            Font = "Gotham",
            TextXAlignment = "Left",
            Parent = Keybind.Container
        })
        local KeyBtn = Create("TextButton", {
            Size = UDim2.new(0, 50, 0, 25),
            Position = UDim2.new(1, -55, 0.5, -12.5),
            BackgroundColor3 = Library.Theme.surface2,
            BackgroundTransparency = 0.5,
            BorderSizePixel = 0,
            Text = Keybind.Value.Name,
            TextColor3 = Library.Theme.text,
            TextSize = 11,
            Font = "GothamBold",
            Parent = Keybind.Container
        })
        Create("UICorner", {CornerRadius = UDim.new(0, 6), Parent = KeyBtn})
        KeyBtn.MouseButton1Click:Connect(function()
            Keybind.Listening = true
            KeyBtn.Text = "..."
        end)
        UserInputService.InputBegan:Connect(function(input, gameProcessed)
            if Keybind.Listening and not gameProcessed then
                if input.UserInputType == Enum.UserInputType.Keyboard then
                    Keybind.Value = input.KeyCode
                    KeyBtn.Text = Keybind.Value.Name
                    Keybind.Listening = false
                    if opts.callback then opts.callback(Keybind.Value) end
                elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                    Keybind.Value = Enum.UserInputType.MouseButton1
                    KeyBtn.Text = "Mouse1"
                    Keybind.Listening = false
                    if opts.callback then opts.callback(Keybind.Value) end
                elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                    Keybind.Value = Enum.UserInputType.MouseButton2
                    KeyBtn.Text = "Mouse2"
                    Keybind.Listening = false
                    if opts.callback then opts.callback(Keybind.Value) end
                end
            end
        end)
        function Keybind:SetValue(key)
            self.Value = key
            KeyBtn.Text = key.Name
        end
        function Keybind:SetText(text)
            KeyText.Text = text
        end
        function Keybind:Destroy()
            Keybind.Container:Destroy()
        end
        table.insert(section.Elements, Keybind)
        return Keybind
    end

    Window.ScreenGui.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
    return Window
end

return Library
