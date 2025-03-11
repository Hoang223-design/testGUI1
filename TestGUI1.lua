local Configs_HUB = {
    Cor_Hub = Color3.fromRGB(15, 15, 15),
    Cor_Options = Color3.fromRGB(15, 15, 15),
    Cor_Stroke = Color3.fromRGB(60, 60, 60),
    Cor_Text = Color3.fromRGB(240, 240, 240),
    Cor_DarkText = Color3.fromRGB(140, 140, 140),
    Corner_Radius = UDim.new(0, 4),
    Text_Font = Enum.Font.FredokaOne
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local function Create(instance, parent, props)
    local new = Instance.new(instance)
    new.Parent = parent
    if props then
        for prop, value in pairs(props) do
            new[prop] = value
        end
    end
    return new
end

local function SetProps(instance, props)
    if instance and props then
        for prop, value in pairs(props) do
            instance[prop] = value
        end
    end
    return instance
end

local function Corner(parent, props)
    local new = Create("UICorner", parent)
    new.CornerRadius = Configs_HUB.Corner_Radius
    if props then
        SetProps(new, props)
    end
    return new
end

local function Stroke(parent, props)
    local new = Create("UIStroke", parent)
    new.Color = Configs_HUB.Cor_Stroke
    new.ApplyStrokeMode = "Border"
    if props then
        SetProps(new, props)
    end
    return new
end

local function CreateTween(instance, prop, value, time, tweenWait)
    local tween = TweenService:Create(instance, TweenInfo.new(time, Enum.EasingStyle.Linear), {[prop] = value})
    tween:Play()
    if tweenWait then
        tween.Completed:Wait()
    end
    return tween
end

local function TextSetColor(instance)
    instance.MouseEnter:Connect(function()
        CreateTween(instance, "TextColor3", Color3.fromRGB(28, 120, 212), 0.4, false)
    end)
    instance.MouseLeave:Connect(function()
        CreateTween(instance, "TextColor3", Configs_HUB.Cor_Text, 0.4, false)
    end)
end

local ScreenGui = Create("ScreenGui", CoreGui, {Name = "REDz HUB library"})
if CoreGui:FindFirstChild(ScreenGui.Name) and CoreGui:FindFirstChild(ScreenGui.Name) ~= ScreenGui then
    CoreGui:FindFirstChild(ScreenGui.Name):Destroy()
end

function DestroyScript()
    ScreenGui:Destroy()
end

local Menu_Notifi = Create("Frame", ScreenGui, {
    Size = UDim2.new(0, 300, 1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundTransparency = 1
})

Create("UIPadding", Menu_Notifi, {PaddingLeft = UDim.new(0, 25), PaddingTop = UDim.new(0, 25), PaddingBottom = UDim.new(0, 50)})
Create("UIListLayout", Menu_Notifi, {Padding = UDim.new(0, 15), VerticalAlignment = "Bottom"})

function MakeNotifi(Configs)
    local Title = Configs.Title or "REDz HUB"
    local Text = Configs.Text or "Notification"
    local Time = Configs.Time or 5
    
    local Frame1 = Create("Frame", Menu_Notifi, {Size = UDim2.new(1, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = "Y"})
    local Frame2 = Create("Frame", Frame1, {Size = UDim2.new(0, 250, 0, 0), BackgroundColor3 = Configs_HUB.Cor_Hub, Position = UDim2.new(1, 0, 0, 0), AutomaticSize = "Y"})
    Corner(Frame2)
    
    Create("TextLabel", Frame2, {
        Size = UDim2.new(1, -40, 0, 25),
        Font = Configs_HUB.Text_Font,
        BackgroundTransparency = 1,
        Text = Title,
        TextSize = 20,
        Position = UDim2.new(0, 10, 0, 5),
        TextXAlignment = "Left",
        TextColor3 = Configs_HUB.Cor_Text
    })
    
    local CloseButton = Create("TextButton", Frame2, {
        Text = "X",
        Font = Configs_HUB.Text_Font,
        TextSize = 20,
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(200, 200, 200),
        Position = UDim2.new(1, -5, 0, 5),
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.new(0, 25, 0, 25)
    })
    
    Create("TextLabel", Frame2, {
        Size = UDim2.new(1, -20, 0, 0),
        Position = UDim2.new(0, 10, 0, 35),
        TextSize = 15,
        TextColor3 = Configs_HUB.Cor_DarkText,
        TextXAlignment = "Left",
        TextYAlignment = "Top",
        AutomaticSize = "Y",
        Text = Text,
        Font = Configs_HUB.Text_Font,
        BackgroundTransparency = 1,
        TextWrapped = true
    })
    
    local ProgressBar = Create("Frame", Frame2, {
        Size = UDim2.new(1, -4, 0, 2),
        BackgroundColor3 = Configs_HUB.Cor_Stroke,
        Position = UDim2.new(0, 2, 0, 28),
        BorderSizePixel = 0
    })
    Corner(ProgressBar)
    
    Create("Frame", Frame2, {Size = UDim2.new(0, 0, 0, 5), Position = UDim2.new(0, 0, 1, 5), BackgroundTransparency = 1})
    
    task.spawn(function()
        CreateTween(ProgressBar, "Size", UDim2.new(0, 0, 0, 2), Time, true)
        if Frame2 then
            CreateTween(Frame2, "Position", UDim2.new(1, 0, 0, 0), 0.5, true)
            Frame1:Destroy()
        end
    end)
    
    CreateTween(Frame2, "Position", UDim2.new(0, 0, 0, 0), 0.5, false)
    
    CloseButton.MouseButton1Click:Connect(function()
        CreateTween(Frame2, "Position", UDim2.new(1, 0, 0, 0), 0.5, true)
        Frame1:Destroy()
    end)
end

function MakeWindow(Configs)
    local title = Configs.Hub.Title or "REDz HUB"
    local Anim_Title = Configs.Hub.Animation or "by : redz9999"
    
    local KeySystem = Configs.Key.KeySystem or false
    local KeyTitle = Configs.Key.Title or "Key System"
    local KeyDescription = Configs.Key.Description or ".-."
    local KeyKey = Configs.Key.Keys or {"123", "321"}
    local KeyLink = Configs.Key.KeyLink or ""
    local KeyNotifications = Configs.Key.Notifi.Notifications or true
    local KeyNotSuccess = Configs.Key.Notifi.Incorrectkey or "The key is incorrect"
    local KeySuccess = Configs.Key.Notifi.CorrectKey or "Running the Script..."
    local KeyCopyKeyLink = Configs.Key.Notifi.CopyKeyLink or "Copied to Clipboard"
    
    if KeySystem then
        local KeyMenu = Create("Frame", ScreenGui, {
            Size = UDim2.new(0, 400, 0, 220),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Active = true,
            Draggable = true
        })
        Corner(KeyMenu)
        Stroke(KeyMenu)
        
        local CloseButton = Create("TextButton", KeyMenu, {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -10, 0, 5),
            AnchorPoint = Vector2.new(1, 0),
            Text = "X",
            Font = Configs_HUB.Text_Font,
            TextScaled = true,
            TextColor3 = Color3.fromRGB(240, 0, 0),
            BackgroundTransparency = 1
        })
        
        Create("TextLabel", KeyMenu, {
            Size = UDim2.new(1, -80, 0, 20),
            Position = UDim2.new(0, 20, 0, 5),
            Text = KeyTitle,
            Font = Configs_HUB.Text_Font,
            TextScaled = true,
            TextColor3 = Configs_HUB.Cor_Text,
            TextXAlignment = "Left",
            BackgroundTransparency = 1
        })
        
        Create("TextLabel", KeyMenu, {
            Size = UDim2.new(1, -80, 0, 0),
            Text = KeyDescription,
            TextSize = 17,
            TextColor3 = Configs_HUB.Cor_DarkText,
            Font = Configs_HUB.Text_Font,
            Position = UDim2.new(0, 20, 0, 25),
            TextXAlignment = "Left",
            AutomaticSize = "Y",
            TextYAlignment = "Top",
            BackgroundTransparency = 1
        })
        
        local ConfirmButton = Create("TextButton", KeyMenu, {
            Text = "Confirm",
            Font = Configs_HUB.Text_Font,
            TextSize = 20,
            TextColor3 = Configs_HUB.Cor_Text,
            Size = UDim2.new(0, 150, 0, 40),
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -35, 0, 140),
            BackgroundColor3 = Configs_HUB.Cor_Options
        })
        Corner(ConfirmButton)
        Stroke(ConfirmButton)
        
        local GetKeyLink = Create("TextButton", KeyMenu, {
            Text = "Get Key Link",
            Font = Configs_HUB.Text_Font,
            TextSize = 20,
            TextColor3 = Configs_HUB.Cor_Text,
            Size = UDim2.new(0, 150, 0, 40),
            Position = UDim2.new(0, 35, 0, 140),
            BackgroundColor3 = Configs_HUB.Cor_Options
        })
        Corner(GetKeyLink)
        Stroke(GetKeyLink)
        
        local TextBox = Create("TextBox", KeyMenu, {
            Size = UDim2.new(1, -70, 0, 40),
            Position = UDim2.new(0, 35, 0, 90),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            PlaceholderText = "Put the Key here",
            Text = "",
            TextColor3 = Configs_HUB.Cor_Text,
            Font = Configs_HUB.Text_Font,
            TextSize = 25
        })
        Corner(TextBox)
        Stroke(TextBox)
        
        local KeyVerify = false
        CloseButton.MouseButton1Click:Connect(function()
            CreateTween(KeyMenu, "Size", UDim2.new(0, 0, 0, 0), 0.2, true)
            KeyMenu:Destroy()
        end)
        
        ConfirmButton.MouseButton1Click:Connect(function()
            for _, v in pairs(KeyKey) do
                if TextBox.Text == v then
                    KeyVerify = true
                    break
                end
            end
            if KeyNotifications then
                MakeNotifi({
                    Title = KeyTitle,
                    Text = KeyVerify and KeySuccess or KeyNotSuccess,
                    Time = 5
                })
            end
            if KeyVerify then
                CreateTween(KeyMenu, "Size", UDim2.new(0, 0, 0, 0), 0.4, true)
                KeyMenu:Destroy()
            end
        end)
        
        GetKeyLink.MouseButton1Click:Connect(function()
            if KeyNotifications then
                setclipboard(KeyLink)
                MakeNotifi({Title = KeyTitle, Text = KeyCopyKeyLink, Time = 5})
            end
        end)
        
        repeat task.wait() until KeyVerify
    end
    
    local Menu = Create("Frame", ScreenGui, {
        BackgroundColor3 = Configs_HUB.Cor_Hub,
        Position = UDim2.new(0.5, -250, 0.5, -135),
        Size = UDim2.new(0, 500, 0, 270),
        Active = true,
        Draggable = true
    })
    Corner(Menu)
    Stroke(Menu)
    
    local TopBar = Create("Frame", Menu, {BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 25)})
    
    local ButtonsFrame = Create("Frame", TopBar, {
        Size = UDim2.new(0, 40, 1, -5),
        Position = UDim2.new(1, -10, 0, 2.5),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1
    })
    
    Create("TextLabel", TopBar, {
        Size = UDim2.new(1, -50, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        TextColor3 = Configs_HUB.Cor_Text,
        Font = Configs_HUB.Text_Font,
        TextXAlignment = "Left",
        Text = title,
        TextSize = 20,
        BackgroundTransparency = 1
    })
    
    local MinimizeBTN = Create("TextButton", ButtonsFrame, {
        Text = "-",
        TextColor3 = Configs_HUB.Cor_Text,
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Configs_HUB.Text_Font,
        TextSize = 25
    })
    
    local IsMinimized = false
    MinimizeBTN.MouseButton1Click:Connect(function()
        IsMinimized = not IsMinimized
        MinimizeBTN.Text = IsMinimized and "+" or "-"
        CreateTween(Menu, "Size", UDim2.new(0, 500, 0, IsMinimized and 25 or 270), 0.15, true)
    end)
    
    local CloseButton = Create("TextButton", ButtonsFrame, {
        Text = "×",
        TextColor3 = Configs_HUB.Cor_Text,
        Size = UDim2.new(0.5, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Configs_HUB.Text_Font,
        TextSize = 25
    })
    
    CloseButton.MouseButton1Click:Connect(function()
        local CloseGui = Create("Frame", Menu, {
            BackgroundTransparency = 0.5,
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            Size = UDim2.new(1, 0, 1, 0)
        })
        Corner(CloseGui)
        
        local CloseMenu = Create("Frame", CloseGui, {
            Size = UDim2.new(0, 300, 0, 150),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = Configs_HUB.Cor_Hub
        })
        Corner(CloseMenu)
        Stroke(CloseMenu)
        
        Create("TextLabel", CloseMenu, {
            Size = UDim2.new(0.8, 0, 0, 40),
            Text = "Are you sure you want to close?",
            Position = UDim2.new(0.1, 0, 0, 20),
            TextColor3 = Configs_HUB.Cor_Text,
            Font = Configs_HUB.Text_Font,
            TextScaled = true,
            BackgroundTransparency = 1
        })
        
        local Confirm = Create("TextButton", CloseMenu, {
            Size = UDim2.new(0.35, 0, 0, 40),
            Position = UDim2.new(0.1, 0, 0, 90),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            Text = "Close",
            Font = Configs_HUB.Text_Font,
            TextColor3 = Color3.fromRGB(240, 0, 0),
            TextSize = 20
        })
        Corner(Confirm)
        Stroke(Confirm)
        
        local Cancel = Create("TextButton", CloseMenu, {
            Size = UDim2.new(0.35, 0, 0, 40),
            Position = UDim2.new(0.9, 0, 0, 90),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            Text = "Cancel",
            Font = Configs_HUB.Text_Font,
            TextColor3 = Color3.fromRGB(0, 240, 0),
            TextSize = 20
        })
        Corner(Cancel)
        Stroke(Cancel)
        
        Confirm.MouseButton1Click:Connect(function()
            CreateTween(Menu, "Size", UDim2.new(0, 0, 0, 0), 0.3, true)
            DestroyScript()
        end)
        
        Cancel.MouseButton1Click:Connect(function()
            CloseGui:Destroy()
        end)
    end)
    
    local AnimMenu = Create("Frame", ScreenGui, {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Configs_HUB.Cor_Hub,
        Size = UDim2.new(0, 0, 0, 35)
    })
    Corner(AnimMenu)
    
    local AnimCredits = Create("TextLabel", AnimMenu, {
        Text = Anim_Title,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Font = Configs_HUB.Text_Font,
        TextTransparency = 1,
        TextColor3 = Configs_HUB.Cor_Text,
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = "Left",
        TextSize = 15
    })
    
    CreateTween(AnimMenu, "Size", UDim2.new(0, 150, 0, 35), 0.5, true)
    AnimCredits.TextTransparency = 0
    task.wait(1.5)
    CreateTween(AnimCredits, "TextTransparency", 1, 0.5, true)
    AnimMenu:Destroy()
    
    local ScrollBar = Create("ScrollingFrame", Menu, {
        Size = UDim2.new(0, 140, 1, -25),
        Position = UDim2.new(0, 0, 0, 25),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        ScrollingDirection = "Y",
        AutomaticCanvasSize = "Y",
        BackgroundTransparency = 1,
        ScrollBarThickness = 2
    })
    Create("UIPadding", ScrollBar, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10)})
    Create("UIListLayout", ScrollBar, {Padding = UDim.new(0, 5)})
    
    local Containers = Create("Frame", Menu, {
        Size = UDim2.new(1, -142, 1, -25),
        Position = UDim2.new(1, 0, 0, 25),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1
    })
    
    local Line = Create("Frame", Menu, {
        Size = UDim2.new(0, 1, 1, -25),
        Position = UDim2.new(0, 140, 0, 25),
        BackgroundColor3 = Configs_HUB.Cor_Stroke,
        BorderSizePixel = 0
    })
    
    Menu:GetPropertyChangedSignal("Size"):Connect(function()
        ScrollBar.Visible = Menu.Size.Y.Offset > 25
        Containers.Visible = Menu.Size.Y.Offset > 25
        Line.Visible = Menu.Size.Y.Offset > 25
    end)
    
    function MinimizeButton(Configs)
        local image = Configs.Image or ""
        local size = Configs.Size or {30, 30}
        local color = Configs.Color or Configs_HUB.Cor_Hub
        local corner = Configs.Corner or true
        local stroke = Configs.Stroke or false
        local strokecolor = Configs.StrokeColor or Configs_HUB.Cor_Stroke
        
        local Button = Create("ImageButton", ScreenGui, {
            Size = UDim2.new(0, size[1], 0, size[2]),
            Position = UDim2.new(0.15, 0, 0.15, 0),
            BackgroundColor3 = color,
            Image = image,
            Active = true,
            Draggable = true
        })
        if corner then Corner(Button) end
        if stroke then Stroke(Button, {Color = strokecolor}) end
        
        local minimized = false
        Button.MouseButton1Click:Connect(function()
            minimized = not minimized
            Menu.Visible = not minimized
            if not minimized then
                CreateTween(Menu, "Size", UDim2.new(0, 500, 0, IsMinimized and 25 or 270), 0.3, false)
            end
        end)
    end
    
    local FirstTab = true
    function MakeTab(Configs)
        local TabName = Configs.Name or "Tab"
        
        local Frame = Create("Frame", ScrollBar, {Size = UDim2.new(1, 0, 0, 25), BackgroundTransparency = 1})
        Corner(Frame)
        Stroke(Frame)
        
        local TextButton = Create("TextButton", Frame, {Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, Text = ""})
        local TextLabel = Create("TextLabel", Frame, {
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundTransparency = 1,
            Font = Configs_HUB.Text_Font,
            TextColor3 = FirstTab and Configs_HUB.Cor_Text or Configs_HUB.Cor_DarkText,
            TextSize = FirstTab and 15 or 14,
            Text = TabName
        })
        
        local Container = Create("ScrollingFrame", Containers, {
            Size = UDim2.new(1, 0, 1, 0),
            ScrollingDirection = "Y",
            AutomaticCanvasSize = "Y",
            CanvasSize = UDim2.new(0, 0, 0, 0),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = FirstTab
        })
        Create("UIPadding", Container, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10)})
        Create("UIListLayout", Container, {Padding = UDim.new(0, 5)})
        
        TextButton.MouseButton1Click:Connect(function()
            for _, container in pairs(Containers:GetChildren()) do
                if container:IsA("ScrollingFrame") then
                    container.Visible = false
                end
            end
            for _, frame in pairs(ScrollBar:GetChildren()) do
                if frame:IsA("Frame") and frame:FindFirstChild("TextLabel") then
                    CreateTween(frame.TextLabel, "TextColor3", Configs_HUB.Cor_DarkText, 0.3, false)
                    frame.TextLabel.TextSize = 14
                end
            end
            Container.Visible = true
            CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.3, false)
            TextLabel.TextSize = 15
        end)
        
        FirstTab = false
        return Container
    end
    
    function AddButton(parent, Configs)
        local ButtonName = Configs.Name or "Button"
        local Callback = Configs.Callback or function() end
        
        local TextButton = Create("TextButton", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            Text = ""
        })
        Corner(TextButton)
        Stroke(TextButton)
        
        local TextLabel = Create("TextLabel", TextButton, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = ButtonName,
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })
        
        local Icon = Create("ImageLabel", TextButton, {
            Image = "rbxassetid://15155219405",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0, 2.5),
            BackgroundTransparency = 1,
            ImageColor3 = Configs_HUB.Cor_Stroke
        })
        
        TextButton.MouseButton1Click:Connect(function()
            Callback()
            CreateTween(Icon, "ImageColor3", Color3.fromRGB(28, 120, 212), 0.2, true)
            CreateTween(Icon, "ImageColor3", Configs_HUB.Cor_Stroke, 0.2, false)
        end)
        
        TextSetColor(TextLabel)
    end
    
    function AddToggle(parent, Configs)
        local ToggleName = Configs.Name or "Toggle"
        local Default = Configs.Default or false
        local Callback = Configs.Callback or function() end
        
        local TextButton = Create("TextButton", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            Text = ""
        })
        Corner(TextButton)
        Stroke(TextButton)
        
        local TextLabel = Create("TextLabel", TextButton, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = ToggleName,
            Size = UDim2.new(1, -30, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })
        
        local ToggleFrame = Create("Frame", TextButton, {
            Size = UDim2.new(0, 25, 0, 15),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1
        })
        Corner(ToggleFrame, {CornerRadius = UDim.new(1, 0)})
        local ToggleStroke = Stroke(ToggleFrame, {Thickness = 2})
        
        local ToggleIndicator = Create("Frame", ToggleFrame, {
            Size = UDim2.new(0, 13, 0, 13),
            Position = UDim2.new(0, Default and 10 or 2, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Default and Color3.fromRGB(28, 120, 212) or Configs_HUB.Cor_Stroke
        })
        Corner(ToggleIndicator, {CornerRadius = UDim.new(1, 0)})
        
        local OnOff = Default
        if Default then
            ToggleStroke.Color = Color3.fromRGB(28, 120, 212)
            TextLabel.TextColor3 = Color3.fromRGB(28, 120, 212)
        end
        Callback(OnOff)
        
        TextButton.MouseButton1Click:Connect(function()
            OnOff = not OnOff
            CreateTween(ToggleIndicator, "Position", UDim2.new(0, OnOff and 10 or 2, 0.5, 0), 0.2, false)
            CreateTween(ToggleIndicator, "BackgroundColor3", OnOff and Color3.fromRGB(28, 120, 212) or Configs_HUB.Cor_Stroke, 0.2, false)
            CreateTween(ToggleStroke, "Color", OnOff and Color3.fromRGB(28, 120, 212) or Configs_HUB.Cor_Stroke, 0.2, false)
            CreateTween(TextLabel, "TextColor3", OnOff and Color3.fromRGB(28, 120, 212) or Configs_HUB.Cor_Text, 0.2, false)
            Callback(OnOff)
        end)
        
        return {Toggle = ToggleIndicator, Stroke = ToggleStroke, State = OnOff, Callback = Callback}
    end
    
    function UpdateToggle(toggle, value)
        local ToggleIndicator = toggle.Toggle
        local ToggleStroke = toggle.Stroke
        local Callback = toggle.Callback
        
        CreateTween(ToggleIndicator, "Position", UDim2.new(0, value and 10 or 2, 0.5, 0), 0.2, false)
        CreateTween(ToggleIndicator, "BackgroundColor3", value and Color3.fromRGB(28, 120, 212) or Configs_HUB.Cor_Stroke, 0.2, false)
        CreateTween(ToggleStroke, "Color", value and Color3.fromRGB(28, 120, 212) or Configs_HUB.Cor_Stroke, 0.2, false)
        Callback(value)
    end
    
    function AddDropdown(parent, Configs)
        local DropdownName = Configs.Name or "Dropdown"
        local Options = Configs.Options or {"Option 1", "Option 2", "Option 3"}
        local Default = Configs.Default or Options[1]
        local Callback = Configs.Callback or function() end
        
        local Frame = Create("TextButton", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            Text = ""
        })
        Corner(Frame)
        Stroke(Frame)
        
        local TextLabel = Create("TextLabel", Frame, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = DropdownName,
            Size = UDim2.new(1, -100, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })
        TextSetColor(TextLabel)
        
        local SelectedLabel = Create("TextLabel", Frame, {
            Size = UDim2.new(0, 70, 1, 0),
            Position = UDim2.new(1, -25, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            Text = Default,
            TextColor3 = Configs_HUB.Cor_DarkText,
            TextSize = 12,
            BackgroundTransparency = 1,
            Font = Configs_HUB.Text_Font
        })
        
        local Arrow = Create("ImageLabel", Frame, {
            Image = "rbxassetid://6031090990",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0, 2.5),
            BackgroundTransparency = 1
        })
        
        local DropdownList = Create("ScrollingFrame", Frame, {
            Size = UDim2.new(1, 0, 0, 0),
            Position = UDim2.new(0, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            ScrollingDirection = "Y",
            AutomaticCanvasSize = "Y",
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = false
        })
        Create("UIPadding", DropdownList, {PaddingLeft = UDim.new(0, 5), PaddingTop = UDim.new(0, 5)})
        Create("UIListLayout", DropdownList, {Padding = UDim.new(0, 5)})
        
        local function AddOption(option)
            local OptionButton = Create("TextButton", DropdownList, {
                Size = UDim2.new(1, 0, 0, 20),
                Text = option,
                Font = Configs_HUB.Text_Font,
                TextSize = 12,
                TextColor3 = Configs_HUB.Cor_Text,
                BackgroundTransparency = 1
            })
            Corner(OptionButton)
            
            OptionButton.MouseButton1Click:Connect(function()
                SelectedLabel.Text = option
                Callback(option)
                DropdownList.Visible = false
                CreateTween(Frame, "Size", UDim2.new(1, 0, 0, 25), 0.3, true)
                CreateTween(Arrow, "Rotation", 0, 0.3, false)
            end)
        end
        
        for _, option in pairs(Options) do
            AddOption(option)
        end
        
        local IsOpen = false
        Frame.MouseButton1Click:Connect(function()
            IsOpen = not IsOpen
            DropdownList.Visible = IsOpen
            CreateTween(Frame, "Size", UDim2.new(1, 0, 0, IsOpen and (25 + math.min(#Options * 25, 100)) or 25), 0.3, true)
            CreateTween(Arrow, "Rotation", IsOpen and 180 or 0, 0.3, false)
        end)
        
        Callback(Default)
        return {Dropdown = DropdownList, Selected = SelectedLabel, Callback = Callback}
    end
    
    function UpdateDropdown(dropdown, NewOptions)
        local DropdownList = dropdown.Dropdown
        local SelectedLabel = dropdown.Selected
        local Callback = dropdown.Callback
        
        DropdownList:ClearAllChildren()
        Create("UIPadding", DropdownList, {PaddingLeft = UDim.new(0, 5), PaddingTop = UDim.new(0, 5)})
        Create("UIListLayout", DropdownList, {Padding = UDim.new(0, 5)})
        
        for _, option in pairs(NewOptions) do
            local OptionButton = Create("TextButton", DropdownList, {
                Size = UDim2.new(1, 0, 0, 20),
                Text = option,
                Font = Configs_HUB.Text_Font,
                TextSize = 12,
                TextColor3 = Configs_HUB.Cor_Text,
                BackgroundTransparency = 1
            })
            Corner(OptionButton)
            
            OptionButton.MouseButton1Click:Connect(function()
                SelectedLabel.Text = option
                Callback(option)
                DropdownList.Visible = false
            end)
        end
        
        SelectedLabel.Text = NewOptions[1] or "Select"
        Callback(NewOptions[1] or nil)
    end
    
    function AddSlider(parent, Configs)
        local SliderName = Configs.Name or "Slider"
        local MinValue = Configs.MinValue or 0
        local MaxValue = Configs.MaxValue or 100
        local Default = Configs.Default or MinValue
        local Callback = Configs.Callback or function() end
        
        local Frame = Create("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options
        })
        Corner(Frame)
        Stroke(Frame)
        
        local TextLabel = Create("TextLabel", Frame, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = SliderName,
            Size = UDim2.new(0, 100, 1, 0),
            Position = UDim2.new(0, 30, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })
        TextSetColor(TextLabel)
        
        local ValueLabel = Create("TextLabel", Frame, {
            Size = UDim2.new(0, 30, 1, 0),
            Position = UDim2.new(1, -35, 0, 0),
            AnchorPoint = Vector2.new(1, 0),
            Text = tostring(Default),
            TextColor3 = Configs_HUB.Cor_Text,
            TextSize = 12,
            BackgroundTransparency = 1,
            Font = Configs_HUB.Text_Font
        })
        
        local SliderBar = Create("Frame", Frame, {
            Size = UDim2.new(0, 100, 0, 5),
            Position = UDim2.new(0, 135, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Configs_HUB.Cor_Stroke
        })
        Corner(SliderBar)
        
        local SliderFill = Create("Frame", SliderBar, {
            Size = UDim2.new((Default - MinValue) / (MaxValue - MinValue), 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(28, 120, 212)
        })
        Corner(SliderFill)
        
        local SliderKnob = Create("Frame", SliderBar, {
            Size = UDim2.new(0, 10, 0, 15),
            Position = UDim2.new((Default - MinValue) / (MaxValue - MinValue), 0, 0.5, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Configs_HUB.Cor_Text
        })
        Corner(SliderKnob)
        
        local Dragging = false
        SliderKnob.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = true
            end
        end)
        
        SliderKnob.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                Dragging = false
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if Dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local mouseX = UserInputService:GetMouseLocation().X
                local barX = SliderBar.AbsolutePosition.X
                local barWidth = SliderBar.AbsoluteSize.X
                local newX = math.clamp((mouseX - barX) / barWidth, 0, 1)
                local value = MinValue + (newX * (MaxValue - MinValue))
                SliderKnob.Position = UDim2.new(newX, 0, 0.5, 0)
                SliderFill.Size = UDim2.new(newX, 0, 1, 0)
                ValueLabel.Text = math.floor(value)
                Callback(math.floor(value))
            end
        end)
        
        Callback(Default)
        return {Knob = SliderKnob, Fill = SliderFill, ValueLabel = ValueLabel, Min = MinValue, Max = MaxValue, Callback = Callback}
    end
    
    function UpdateSlider(slider, NewValue)
        local Knob = slider.Knob
        local Fill = slider.Fill
        local ValueLabel = slider.ValueLabel
        local Min = slider.Min
        local Max = slider.Max
        local Callback = slider.Callback
        
        local newX = (NewValue - Min) / (Max - Min)
        CreateTween(Knob, "Position", UDim2.new(newX, 0, 0.5, 0), 0.2, false)
        CreateTween(Fill, "Size", UDim2.new(newX, 0, 1, 0), 0.2, false)
        ValueLabel.Text = tostring(NewValue)
        Callback(NewValue)
    end
    
    return Menu
end
