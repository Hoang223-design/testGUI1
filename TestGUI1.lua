-- Cấu hình với độ trong suốt
local Configs_HUB = {
    Cor_Hub = Color3.fromRGB(15, 15, 15),
    Cor_Options = Color3.fromRGB(15, 15, 15),
    Cor_Stroke = Color3.fromRGB(60, 60, 60),
    Cor_Text = Color3.fromRGB(240, 240, 240),
    Cor_DarkText = Color3.fromRGB(140, 140, 140),
    Corner_Radius = UDim.new(0, 4),
    Text_Font = Enum.Font.FredokaOne,
    Transparency = 0.3 -- Độ trong suốt
}

local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Hàm tiện ích
local function Create(instance, parent, props)
    local new = Instance.new(instance, parent)
    if props then
        table.foreach(props, function(prop, value)
            new[prop] = value
        end)
    end
    return new
end

local function SetProps(instance, props)
    if instance and props then
        table.foreach(props, function(prop, value)
            instance[prop] = value
        end)
    end
    return instance
end

local function Corner(parent, props)
    local new = Create("UICorner", parent)
    new.CornerRadius = Configs_HUB.Corner_Radius
    if props then SetProps(new, props) end
    return new
end

local function Stroke(parent, props)
    local new = Create("UIStroke", parent)
    new.Color = Configs_HUB.Cor_Stroke
    new.ApplyStrokeMode = "Border"
    if props then SetProps(new, props) end
    return new
end

local function CreateTween(instance, prop, value, time, tweenWait)
    local tween = TweenService:Create(instance, TweenInfo.new(time, Enum.EasingStyle.Linear), {[prop] = value})
    tween:Play()
    if tweenWait then tween.Completed:Wait() end
end

local function TextSetColor(instance)
    instance.MouseEnter:Connect(function()
        CreateTween(instance, "TextColor3", Color3.fromRGB(28, 120, 212), 0.4, true)
    end)
    instance.MouseLeave:Connect(function()
        CreateTween(instance, "TextColor3", Configs_HUB.Cor_Text, 0.4, false)
    end)
end

-- Thiết lập ScreenGui
local ScreenGui = Create("ScreenGui", CoreGui, {
    Name = "HoangBlackHub",
    IgnoreGuiInset = true
})

if CoreGui:FindFirstChild(ScreenGui.Name) then
    CoreGui:FindFirstChild(ScreenGui.Name):Destroy()
end

-- Hệ thống thông báo
local Menu_Notifi = Create("Frame", ScreenGui, {
    Size = UDim2.new(0, 300, 1, 0),
    Position = UDim2.new(1, 0, 0, 0),
    AnchorPoint = Vector2.new(1, 0),
    BackgroundTransparency = 1
})
Create("UIPadding", Menu_Notifi, {PaddingLeft = UDim.new(0, 25), PaddingTop = UDim.new(0, 25), PaddingBottom = UDim.new(0, 50)})
Create("UIListLayout", Menu_Notifi, {Padding = UDim.new(0, 15), VerticalAlignment = "Bottom"})

function MakeNotifi(Configs)
    local Title = Configs.Title or "HoangBlackHub"
    local text = Configs.Text or "Thông báo"
    local timewait = Configs.Time or 5

    local Frame1 = Create("Frame", Menu_Notifi, {Size = UDim2.new(2, 0, 0, 0), BackgroundTransparency = 1, AutomaticSize = "Y"})
    local Frame2 = Create("Frame", Frame1, {
        Size = UDim2.new(0, Menu_Notifi.Size.X.Offset - 50, 0, 0),
        BackgroundColor3 = Configs_HUB.Cor_Hub,
        BackgroundTransparency = Configs_HUB.Transparency,
        Position = UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0),
        AutomaticSize = "Y"
    })
    Corner(Frame2)

    Create("TextLabel", Frame2, {
        Size = UDim2.new(1, 0, 0, 25),
        Font = Configs_HUB.Text_Font,
        BackgroundTransparency = 1,
        Text = Title,
        TextSize = 20,
        Position = UDim2.new(0, 20, 0, 5),
        TextXAlignment = "Left",
        TextColor3 = Configs_HUB.Cor_Text
    })

    local TextButton = Create("TextButton", Frame2, {
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
        Size = UDim2.new(1, -30, 0, 0),
        Position = UDim2.new(0, 20, 0, TextButton.Size.Y.Offset + 10),
        TextSize = 15,
        TextColor3 = Configs_HUB.Cor_DarkText,
        TextXAlignment = "Left",
        TextYAlignment = "Top",
        AutomaticSize = "Y",
        Text = text,
        Font = Configs_HUB.Text_Font,
        BackgroundTransparency = 1,
        TextWrapped = true
    })

    local FrameSize = Create("Frame", Frame2, {
        Size = UDim2.new(1, 0, 0, 2),
        BackgroundColor3 = Configs_HUB.Cor_Stroke,
        Position = UDim2.new(0, 2, 0, 30),
        BorderSizePixel = 0
    })
    Corner(FrameSize)

    task.spawn(function()
        CreateTween(FrameSize, "Size", UDim2.new(0, 0, 0, 2), timewait, true)
    end)

    TextButton.MouseButton1Click:Connect(function()
        CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.1, true)
        CreateTween(Frame2, "Position", UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0), 0.5, true)
        Frame1:Destroy()
    end)

    task.spawn(function()
        CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.5, true)
        CreateTween(Frame2, "Position", UDim2.new(), 0.1, true)
        task.wait(timewait)
        if Frame2 then
            CreateTween(Frame2, "Position", UDim2.new(0, -20, 0, 0), 0.1, true)
            CreateTween(Frame2, "Position", UDim2.new(0, Menu_Notifi.Size.X.Offset, 0, 0), 0.5, true)
            Frame1:Destroy()
        end
    end)
end

function MakeWindow(Configs)
    local title = Configs.Hub.Title or "HoangBlackHub Beta v0.2"
    local Anim_Title = Configs.Hub.Animation or "Cre: NgọcHoàng20?👑"
    local KeySystem = Configs.Key.KeySystem or false
    local KeyTitle = Configs.Key.Title or "Hệ thống khóa"
    local KeyDescription = Configs.Key.Description or "Nhập key để tiếp tục"
    local KeyKey = Configs.Key.Keys or {"hoang123"}
    local KeyLink = Configs.Key.KeyLink or "https://link-to-key.com"
    local KeyNotifications = Configs.Key.Notifi.Notifications or true
    local KeyNotSuccess = Configs.Key.Notifi.Incorrectkey or "Key không đúng!"
    local KeySuccess = Configs.Key.Notifi.CorrectKey or "Đang chạy script..."
    local KeyCopyKeyLink = Configs.Key.Notifi.CopyKeyLink or "Đã sao chép link!"

    -- Hệ thống khóa (KeySystem)
    if KeySystem then
        local KeyMenu = Create("Frame", ScreenGui, {
            Size = UDim2.new(0, 400, 0, 220),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            BackgroundTransparency = Configs_HUB.Transparency,
            AnchorPoint = Vector2.new(0.5, 0.5),
            Active = true,
            Draggable = true
        })
        Corner(KeyMenu)

        local CloseButton = Create("TextButton", KeyMenu, {
            Size = UDim2.new(0, 30, 0, 30),
            Position = UDim2.new(1, -10, 0, 5),
            AnchorPoint = Vector2.new(1, 0),
            Text = "X",
            Font = Enum.Font.FredokaOne,
            TextScaled = true,
            TextColor3 = Color3.fromRGB(240, 0, 0),
            BackgroundTransparency = 1
        })

        local Title = Create("TextLabel", KeyMenu, {
            Size = UDim2.new(1, -80, 0, 20),
            Position = UDim2.new(0, 20, 0, 5),
            Text = KeyTitle,
            Font = Configs_HUB.Text_Font,
            TextScaled = true,
            TextColor3 = Configs_HUB.Cor_Text,
            TextXAlignment = "Left",
            BackgroundTransparency = 1
        })

        local Description = Create("TextLabel", KeyMenu, {
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
            Text = "Xác nhận",
            Font = Configs_HUB.Text_Font,
            TextSize = 20,
            TextColor3 = Configs_HUB.Cor_Text,
            Size = UDim2.new(0, 150, 0, 40),
            AnchorPoint = Vector2.new(1, 0),
            Position = UDim2.new(1, -35, 0, 140),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency
        })
        Corner(ConfirmButton)

        local GetKeyLink = Create("TextButton", KeyMenu, {
            Text = "Lấy link key",
            Font = Configs_HUB.Text_Font,
            TextSize = 20,
            TextColor3 = Configs_HUB.Cor_Text,
            Size = UDim2.new(0, 150, 0, 40),
            Position = UDim2.new(0, 35, 0, 140),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency
        })
        Corner(GetKeyLink)

        local TextBox = Create("TextBox", KeyMenu, {
            Size = UDim2.new(1, -70, 0, 40),
            Position = UDim2.new(0, 35, 0, 90),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency,
            PlaceholderText = "Nhập key vào đây",
            Text = "",
            TextColor3 = Configs_HUB.Cor_Text,
            Font = Configs_HUB.Text_Font,
            TextSize = 25
        })
        Corner(TextBox)

        local KeyVerify = false
        CloseButton.MouseButton1Click:Connect(function()
            local UIScale = Create("UIScale", ScreenGui)
            CreateTween(UIScale, "Scale", 0, 0.20, true)
            ScreenGui:Destroy()
        end)

        ConfirmButton.MouseButton1Click:Connect(function()
            for _, v in pairs(KeyKey) do
                if TextBox.Text == v then
                    KeyVerify = true
                end
            end
            if KeyNotifications and not KeyVerify then
                MakeNotifi({Title = KeyTitle, Text = KeyNotSuccess, Time = 5})
            elseif KeyNotifications then
                MakeNotifi({Title = KeyTitle, Text = KeySuccess, Time = 5})
            end
        end)

        GetKeyLink.MouseButton1Click:Connect(function()
            if KeyNotifications then
                setclipboard(KeyLink)
                MakeNotifi({Title = KeyTitle, Text = KeyCopyKeyLink, Time = 5})
            end
        end)

        repeat task.wait() until KeyVerify
        local UIScale = Create("UIScale", KeyMenu)
        CreateTween(UIScale, "Scale", 0, 0.40, true)
        KeyMenu:Destroy()
    end

    -- Cửa sổ chính
    local Menu = Create("Frame", ScreenGui, {
        BackgroundColor3 = Configs_HUB.Cor_Hub,
        BackgroundTransparency = Configs_HUB.Transparency,
        Position = UDim2.new(0.5, -500/2, 0.5, -270/2),
        Size = UDim2.new(0, 500, 0, 270),
        Active = true,
        Draggable = true
    })
    Corner(Menu)

    -- Thêm hình nền
    local BackgroundImage = Create("ImageLabel", Menu, {
        Image = "rbxassetid://93018818295521",
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ImageTransparency = 0.5
    })

    local TopBar = Create("Frame", Menu, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 35)
    })

    local Title = Create("TextLabel", TopBar, {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 20, 0, 0),
        TextColor3 = Configs_HUB.Cor_Text,
        Font = Configs_HUB.Text_Font,
        TextXAlignment = "Left",
        Text = title,
        TextSize = 20,
        BackgroundTransparency = 1
    })

    local ButtonsFrame = Create("Frame", TopBar, {
        Size = UDim2.new(0, 60, 1, -5),
        Position = UDim2.new(1, -10, 0, 2.5),
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1
    })

    local Minimize_BTN = Create("TextButton", ButtonsFrame, {
        Text = "-",
        TextColor3 = Configs_HUB.Cor_Text,
        Size = UDim2.new(0.5, 0, 1, 0),
        BackgroundTransparency = 1,
        Font = Configs_HUB.Text_Font,
        TextYAlignment = "Bottom",
        TextSize = 25
    })

    local Close_Button = Create("TextButton", ButtonsFrame, {
        Text = "×",
        TextYAlignment = "Bottom",
        TextColor3 = Configs_HUB.Cor_Text,
        Size = UDim2.new(0.5, 0, 1, 0),
        AnchorPoint = Vector2.new(1, 0),
        Position = UDim2.new(1, 0, 0, 0),
        BackgroundTransparency = 1,
        Font = Configs_HUB.Text_Font,
        TextSize = 25
    })

    local IsMinimized = false
    Minimize_BTN.MouseButton1Click:Connect(function()
        Minimize_BTN.Text = not IsMinimized and "+" or "-"
        if IsMinimized then
            IsMinimized = false
            CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.15, false)
        else
            IsMinimized = true
            CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 35), 0.15, true)
        end
    end)

    local function CreateClose()
        IsMinimized = false
        CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.3, false)
        local CloseGui = Create("TextButton", Menu, {
            BackgroundTransparency = 0.5,
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            Size = UDim2.new(1, 0, 1, 0),
            AutoButtonColor = false,
            Text = "",
            Visible = false
        })
        Corner(CloseGui)

        local CloseMenu = Create("Frame", CloseGui, {
            Size = UDim2.new(),
            AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.new(0.5, 0, 0.5, 0),
            BackgroundTransparency = Configs_HUB.Transparency,
            BackgroundColor3 = Configs_HUB.Cor_Hub
        })
        Corner(CloseMenu)
        Stroke(CloseMenu)

        local Mensage = Create("TextLabel", CloseMenu, {
            Size = UDim2.new(0.8, 0, 0.25, 0),
            Text = "Bạn có muốn đóng không?",
            Position = UDim2.new(0.1, 0, 0.2),
            TextColor3 = Configs_HUB.Cor_Text,
            Font = Configs_HUB.Text_Font,
            TextScaled = true,
            BackgroundTransparency = 1
        })

        local Confirm = Create("TextButton", CloseMenu, {
            Size = UDim2.new(0.35, 0, 0.3, 0),
            Position = UDim2.new(0.1, 0, 0.5, 0),
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            BackgroundTransparency = Configs_HUB.Transparency,
            Text = "Đóng Script",
            Font = Configs_HUB.Text_Font,
            TextColor3 = Color3.fromRGB(240, 0, 0),
            TextSize = 20
        })
        Corner(Confirm)
        Stroke(Confirm)

        local Cancel = Create("TextButton", CloseMenu, {
            Size = UDim2.new(0.35, 0, 0.3, 0),
            Position = UDim2.new(0.9, 0, 0.5, 0),
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            BackgroundTransparency = Configs_HUB.Transparency,
            Text = "Hủy",
            Font = Configs_HUB.Text_Font,
            TextColor3 = Color3.fromRGB(0, 240, 0),
            TextSize = 20
        })
        Corner(Cancel)
        Stroke(Cancel)

        local function SetVisible()
            if Menu.Size.Y.Offset > 100 then
                CloseGui.Visible = true
            else
                CloseGui.Visible = false
            end
        end

        SetVisible()
        Menu:GetPropertyChangedSignal("Size"):Connect(SetVisible)

        CreateTween(CloseMenu, "Size", UDim2.new(0.7, 0, 0.7, 0), 0.2, false)

        Cancel.MouseButton1Click:Connect(function()
            CreateTween(CloseMenu, "Size", UDim2.new(), 0.2, true)
            CloseGui:Destroy()
        end)

        Confirm.MouseButton1Click:Connect(function()
            CloseGui:Destroy()
            CreateTween(Menu, "Size", UDim2.new(), 0.3, true)
            ScreenGui:Destroy()
        end)

        CloseGui.MouseButton1Click:Connect(function()
            CreateTween(CloseMenu, "Size", UDim2.new(), 0.2, true)
            CloseGui:Destroy()
        end)
    end

    Close_Button.MouseButton1Click:Connect(CreateClose)

    local ScrollBar = Create("ScrollingFrame", Menu, {
        Size = UDim2.new(0, 140, 1, -35),
        Position = UDim2.new(0, 0, 1, 0),
        AnchorPoint = Vector2.new(0, 1),
        CanvasSize = UDim2.new(),
        ScrollingDirection = "Y",
        AutomaticCanvasSize = "Y",
        BackgroundTransparency = 1,
        ScrollBarThickness = 2
    })
    Create("UIPadding", ScrollBar, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
    Create("UIListLayout", ScrollBar, {Padding = UDim.new(0, 5)})

    local Containers = Create("Frame", Menu, {
        Size = UDim2.new(1, -142, 1, -35),
        AnchorPoint = Vector2.new(1, 1),
        Position = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1
    })
    Corner(Containers)

    local line_Containers = Create("Frame", Menu, {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0)
    })
    local line1 = Create("Frame", line_Containers, {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 35), BackgroundColor3 = Configs_HUB.Cor_Stroke, BorderSizePixel = 0})
    local line2 = Create("Frame", line_Containers, {Size = UDim2.new(0, 1, 1, -36), Position = UDim2.new(0, 140, 0, 35), BackgroundColor3 = Configs_HUB.Cor_Stroke, BorderSizePixel = 0})

    local firstVisible = true
    local textsize = 15
    local textcolor = Configs_HUB.Cor_Text

    function MinimizeButton(Configs)
        local Button = Create("ImageButton", ScreenGui, {
            Size = UDim2.new(0, Configs.Size[1], 0, Configs.Size[2]),
            Position = UDim2.new(0.15, 0, 0.15, 0),
            BackgroundColor3 = Configs.Color,
            Image = Configs.Image,
            Active = true,
            Draggable = true,
            BackgroundTransparency = Configs_HUB.Transparency
        })
        if Configs.Corner then Corner(Button) end
        if Configs.Stroke then Stroke(Button, {Color = Configs.StrokeColor}) end

        local minimize = false
        Button.MouseButton1Click:Connect(function()
            Menu.Visible = not minimize
            minimize = not minimize
            if not minimize and not IsMinimized then
                CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 270), 0.3, false)
            elseif not minimize then
                CreateTween(Menu, "Size", UDim2.new(0, 500, 0, 35), 0.3, false)
            end
        end)
    end

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
            TextColor3 = textcolor,
            TextSize = textsize,
            Text = TabName
        })

        local Container = Create("ScrollingFrame", Containers, {
            Size = UDim2.new(1, 0, 1, 0),
            ScrollingDirection = "Y",
            AutomaticCanvasSize = "Y",
            CanvasSize = UDim2.new(),
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = firstVisible
        })
        Create("UIPadding", Container, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
        Create("UIListLayout", Container, {Padding = UDim.new(0, 5)})

        TextButton.MouseButton1Click:Connect(function()
            for _, container in pairs(Containers:GetChildren()) do
                if container:IsA("ScrollingFrame") then container.Visible = false end
            end
            for _, frame in pairs(ScrollBar:GetChildren()) do
                if frame:IsA("Frame") and frame:FindFirstChild("TextLabel") and frame.TextLabel ~= TextLabel then
                    CreateTween(frame.TextLabel, "TextColor3", Configs_HUB.Cor_DarkText, 0.3, false)
                    frame.TextLabel.TextSize = 14
                end
            end
            Container.Visible = true
            CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.3, false)
            TextLabel.TextSize = 15
        end)

        firstVisible = false
        textsize = 14
        textcolor = Configs_HUB.Cor_DarkText
        return Container
    end

    function AddButton(parent, Configs)
        local TextButton = Create("TextButton", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency,
            Text = "",
            AutoButtonColor = false
        })
        Corner(TextButton)
        Stroke(TextButton)

        local TextLabel = Create("TextLabel", TextButton, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = Configs.Name,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })

        local ImageLabel = Create("ImageLabel", TextButton, {
            Image = "rbxassetid://15155219405",
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0, 2.5),
            BackgroundTransparency = 1,
            ImageColor3 = Configs_HUB.Cor_Stroke
        })

        TextButton.MouseButton1Click:Connect(function()
            Configs.Callback()
            CreateTween(ImageLabel, "ImageColor3", Color3.fromRGB(28, 120, 212), 0.2, true)
            CreateTween(ImageLabel, "ImageColor3", Configs_HUB.Cor_Stroke, 0.2, false)
        end)
        TextSetColor(TextLabel)
    end

    function AddToggle(parent, Configs)
        local TextButton = Create("TextButton", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency,
            Text = "",
            AutoButtonColor = false
        })
        Corner(TextButton)
        Stroke(TextButton)

        local TextLabel = Create("TextLabel", TextButton, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = Configs.Name,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })

        local Frame1 = Create("Frame", TextButton, {Size = UDim2.new(0, 25, 0, 15), Position = UDim2.new(0, 5, 0, 5), BackgroundTransparency = 1})
        Corner(Frame1, {CornerRadius = UDim.new(1, 0)})
        local StrokeToggle = Stroke(Frame1, {Thickness = 2})

        local Frame2 = Create("Frame", Frame1, {
            Size = UDim2.new(0, 13, 0, 13),
            Position = UDim2.new(0, 2, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Configs_HUB.Cor_Stroke
        })
        Corner(Frame2, {CornerRadius = UDim.new(1, 0)})

        local OnOff = Configs.Default or false
        if OnOff then
            CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false)
            CreateTween(Frame2, "BackgroundColor3", Color3.fromRGB(28, 120, 212), 0.2, false)
            CreateTween(StrokeToggle, "Color", Color3.fromRGB(28, 120, 212), 0.2, false)
            CreateTween(TextLabel, "TextColor3", Color3.fromRGB(28, 120, 212), 0.2, false)
        end
        Configs.Callback(OnOff)

        TextButton.MouseButton1Click:Connect(function()
            OnOff = not OnOff
            if OnOff then
                CreateTween(Frame2, "Position", UDim2.new(0, 10, 0.5, 0), 0.2, false)
                CreateTween(Frame2, "BackgroundColor3", Color3.fromRGB(28, 120, 212), 0.2, false)
                CreateTween(StrokeToggle, "Color", Color3.fromRGB(28, 120, 212), 0.2, false)
                CreateTween(TextLabel, "TextColor3", Color3.fromRGB(28, 120, 212), 0.2, false)
            else
                CreateTween(Frame2, "Position", UDim2.new(0, 2, 0.5, 0), 0.2, false)
                CreateTween(Frame2, "BackgroundColor3", Configs_HUB.Cor_Stroke, 0.2, false)
                CreateTween(StrokeToggle, "Color", Configs_HUB.Cor_Stroke, 0.2, false)
                CreateTween(TextLabel, "TextColor3", Configs_HUB.Cor_Text, 0.2, false)
            end
            Configs.Callback(OnOff)
        end)
        return {Frame2, StrokeToggle, OnOff, Configs.Callback}
    end

    function AddSlider(parent, Configs)
        local SliderName = Configs.Name or "Thanh trượt"
        local Increase = Configs.Increase or 1
        local MinValue = Configs.MinValue / Increase or 10 / Increase
        local MaxValue = Configs.MaxValue / Increase or 100 / Increase
        local Default = Configs.Default or 25
        local Callback = Configs.Callback or function() end

        local Frame = Create("TextButton", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency,
            Text = "",
            AutoButtonColor = false
        })
        Corner(Frame)
        Stroke(Frame)

        local TextLabel = Create("TextButton", Frame, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = SliderName,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 150, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })
        TextSetColor(TextLabel)

        local TextLabelNumber = Create("TextLabel", Frame, {
            Font = Configs_HUB.Text_Font,
            Size = UDim2.new(0, 20, 0, 20),
            Text = tostring(Default * Increase),
            Position = UDim2.new(0, 5, 0, 2.5),
            TextScaled = true,
            TextColor3 = Configs_HUB.Cor_Text,
            BackgroundTransparency = 1
        })

        local SliderBar1 = Create("TextLabel", Frame, {
            Size = UDim2.new(0, 100, 0, 7.5),
            Position = UDim2.new(0, 35, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            BackgroundColor3 = Configs_HUB.Cor_Stroke,
            Text = ""
        })
        Corner(SliderBar1)

        local SavePos = Create("Frame", SliderBar1, {Size = UDim2.new(0, 1, 0, 0), Visible = false})

        local Slider = Create("Frame", SliderBar1, {
            BackgroundColor3 = Configs_HUB.Cor_Text,
            Size = UDim2.new(0, 7.5, 0, 15),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            Active = true,
            Draggable = true
        })
        Corner(Slider)

        local SliderBar2 = Create("Frame", SliderBar1, {
            BackgroundColor3 = Color3.fromRGB(28, 120, 212),
            Size = UDim2.new(0, Slider.Position.X.Offset, 1, 0)
        })
        Corner(SliderBar2)

        local function UpdCounter(Value)
            local String = tostring(Value * Increase)
            if string.find(String, ".") then String = String:sub(1, 5) end
            TextLabelNumber.Text = String
            Callback(Value * Increase)
        end

        local MouseEnterOrLeave = false
        Frame.MouseButton1Down:Connect(function()
            MouseEnterOrLeave = true
            while MouseEnterOrLeave do task.wait()
                local MousePos = UserInputService:GetMouseLocation().X - SavePos.AbsolutePosition.X
                Slider.Position = UDim2.new(0, MousePos, 0.5, 0)
            end
        end)
        Frame.MouseLeave:Connect(function() MouseEnterOrLeave = false end)

        local function SliderSet(NewValue)
            local max, min = MaxValue * Increase, MinValue * Increase
            local SliderPos = (NewValue - min) / (max - min)
            local X_Offset = SliderPos * 100
            CreateTween(Slider, "Position", UDim2.new(0, X_Offset + 1, 0, 0), 0.5, false)
        end
        SliderSet(Default)

        Slider.Changed:Connect(function(prop)
            if prop == "Position" then
                Slider.Position = UDim2.new(0, math.clamp(Slider.Position.X.Offset, 0, 100), 0.5, 0)
                SliderBar2.Size = UDim2.new(0, Slider.Position.X.Offset, 1, 0)
                local SliderPos = Slider.Position.X.Offset / 100
                local A_1 = math.floor(((SliderPos * MaxValue) / MaxValue) * (MaxValue - MinValue) + MinValue)
                UpdCounter(A_1)
            end
        end)
        return {Slider, Increase, MaxValue, MinValue}
    end

    function UpdateSlider(Slider, NewValue)
        local Frame = Slider[1]
        local Increase = Slider[2]
        local Max = Slider[3] * Increase
        local Min = Slider[4] * Increase
        local SliderPos = (NewValue - Min) / (Max - Min)
        local X_Offset = SliderPos * 100
        CreateTween(Frame, "Position", UDim2.new(0, X_Offset + 1, 0, 0), 0.5, false)
    end

    function AddKeybind(parent, Configs)
        local KeybindName = Configs.Name or "Phím tắt"
        local KeyCode = Configs.KeyCode or "E"
        local Default = Configs.Default or false
        local Callback = Configs.Callback or function() end

        local Frame = Create("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency
        })
        Corner(Frame)
        Stroke(Frame)

        local TextLabel = Create("TextButton", Frame, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = KeybindName,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })

        local Keybind = Create("TextLabel", Frame, {
            Font = Configs_HUB.Text_Font,
            Size = UDim2.new(0, 18, 0, 18),
            Text = KeyCode,
            Position = UDim2.new(0, 5, 0, 3.5),
            TextScaled = true,
            TextColor3 = Configs_HUB.Cor_Text,
            BackgroundTransparency = 1
        })
        Corner(Keybind)
        Stroke(Keybind)

        local OnOff = Default
        UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode[KeyCode] then
                OnOff = not OnOff
                Callback(OnOff)
            end
        end)
        TextSetColor(TextLabel)
    end

    function AddTextBox(parent, Configs)
        local TextBoxName = Configs.Name or "Hộp văn bản"
        local Default = Configs.Default or "Nhập text"
        local placeholderText = Configs.PlaceholderText or "Nhập text"
        local ClearText = Configs.ClearText or false
        local Callback = Configs.Callback or function() end

        local Frame = Create("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency
        })
        Corner(Frame)
        Stroke(Frame)

        local TextLabel = Create("TextButton", Frame, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = TextBoxName,
            Size = UDim2.new(1, 0, 1, 0),
            Position = UDim2.new(0, 150, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })
        TextSetColor(TextLabel)

        local TextBox = Create("TextBox", Frame, {
            Size = UDim2.new(0, 120, 0, 20),
            Position = UDim2.new(0, 15, 0, 2.5),
            TextColor3 = Configs_HUB.Cor_Text,
            Text = Default,
            ClearTextOnFocus = ClearText,
            PlaceholderText = placeholderText,
            TextScaled = true,
            Font = Configs_HUB.Text_Font,
            BackgroundTransparency = 1
        })

        local Line = Create("Frame", TextBox, {
            Size = UDim2.new(1, 0, 0, 1),
            Position = UDim2.new(0.5, 0, 1, 0),
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = Configs_HUB.Cor_Stroke,
            BorderSizePixel = 0
        })

        TextBox.MouseEnter:Connect(function()
            CreateTween(Line, "Size", UDim2.new(0, 0, 0, 1), 0.3, true)
            CreateTween(Line, "Size", UDim2.new(1, 0, 0, 1), 0.3, true)
        end)

        TextBox.FocusLost:Connect(function()
            Callback(TextBox.Text)
        end)
    end

    function AddColorPicker(parent, Configs)
        local name = Configs.Name or "Chọn màu"
        local Default = Configs.Default or Color3.fromRGB(0, 0, 200)
        local Callback = Configs.Callback or function() end
        local ColorH, ColorS, ColorV = Color3.toHSV(Default)
        Callback(Default)

        local TextButton = Create("Frame", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency
        })
        Stroke(TextButton)
        Corner(TextButton)

        local click = Create("TextButton", TextButton, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundTransparency = 1,
            AutoButtonColor = false,
            Text = ""
        })

        local TextLabel = Create("TextLabel", TextButton, {
            Size = UDim2.new(1, -10, 0, 25),
            Position = UDim2.new(0, 35, 0, 0),
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            TextXAlignment = "Left",
            Text = name,
            Font = Configs_HUB.Text_Font,
            BackgroundTransparency = 1
        })

        local picker = Create("Frame", TextButton, {
            Size = UDim2.new(0, 20, 0, 20),
            Position = UDim2.new(0, 5, 0, 2.5),
            BackgroundColor3 = Default
        })
        Corner(picker)
        Stroke(picker)

        local UI_Grade = Create("ImageButton", TextButton, {
            Size = UDim2.new(1, -100, 1, -45),
            Position = UDim2.new(0, 10, 0, 35),
            Visible = false,
            Image = "rbxassetid://4155801252"
        })
        Corner(UI_Grade)
        Stroke(UI_Grade)
        local SavePos = Create("Frame", UI_Grade, {Visible = false})

        local grade = Create("TextButton", TextButton, {
            Size = UDim2.new(0, 30, 1, -45),
            Position = UDim2.new(1, -10, 0, 35),
            AnchorPoint = Vector2.new(1, 0),
            Visible = false,
            Text = ""
        })
        Corner(grade)
        Stroke(grade)
        Create("UIGradient", grade, {
            Rotation = 90,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 4)),
                ColorSequenceKeypoint.new(0.20, Color3.fromRGB(234, 255, 0)),
                ColorSequenceKeypoint.new(0.40, Color3.fromRGB(21, 255, 0)),
                ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 255, 255)),
                ColorSequenceKeypoint.new(0.80, Color3.fromRGB(0, 17, 255)),
                ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 251)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 4))
            })
        })
        local SavePos2 = Create("Frame", grade, {Visible = false, Size = UDim2.new(1, 0, 0, 0)})

        local Select1 = Create("Frame", grade, {
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0, ColorH * 80),
            BackgroundTransparency = 1,
            Active = true,
            Draggable = true
        })
        Corner(Select1, {CornerRadius = UDim.new(2, 0)})
        Stroke(Select1, {Color = Color3.fromRGB(255, 255, 255)})

        local Select2 = Create("Frame", UI_Grade, {
            Size = UDim2.new(0, 15, 0, 15),
            Position = UDim2.new(0, (1 - ColorS) * 215, 0, (1 - ColorV) * 75),
            BackgroundTransparency = 1,
            Active = true,
            Draggable = true
        })
        Corner(Select2, {CornerRadius = UDim.new(2, 0)})
        Stroke(Select2, {Color = Color3.fromRGB(255, 255, 255)})

        UI_Grade.MouseButton1Click:Connect(function()
            local mouse = UserInputService:GetMouseLocation()
            local savepos = SavePos.AbsolutePosition
            CreateTween(Select2, "Position", UDim2.new(0, mouse.X - savepos.X, 0, mouse.Y - savepos.Y - 35), 0.3, false)
        end)

        grade.MouseButton1Click:Connect(function()
            local mouse = UserInputService:GetMouseLocation().Y - 35
            local savepos = SavePos2.AbsolutePosition.Y
            CreateTween(Select1, "Position", UDim2.new(0, 0, 0, mouse - savepos), 0.3, false)
        end)

        local function updcolorpicker()
            ColorH = math.clamp(Select1.Position.Y.Offset / 80, 0, 1)
            ColorS = math.clamp(1 - (Select2.Position.X.Offset / 215), 0, 1)
            ColorV = math.clamp(1 - (Select2.Position.Y.Offset / 75), 0, 1)
            UI_Grade.ImageColor3 = Color3.fromHSV(ColorH, 1, 1)
            picker.BackgroundColor3 = Color3.fromHSV(ColorH, ColorS, ColorV)
            Callback(Color3.fromHSV(ColorH, ColorS, ColorV))
        end

        updcolorpicker()

        Select1.Changed:Connect(function(prop)
            if prop == "Position" then
                Select1.Position = UDim2.new(0, 0, 0, math.clamp(Select1.Position.Y.Offset, 0, 80))
                updcolorpicker()
            end
        end)

        Select2.Changed:Connect(function(prop)
            if prop == "Position" then
                Select2.Position = UDim2.new(0, math.clamp(Select2.Position.X.Offset, 0, 215), 0, math.clamp(Select2.Position.Y.Offset, 0, 75))
                updcolorpicker()
            end
        end)

        local onoff = false
        click.MouseButton1Click:Connect(function()
            onoff = not onoff
            if onoff then
                CreateTween(TextButton, "Size", UDim2.new(1, 0, 0, 140), 0.2, true)
                UI_Grade.Visible = true
                grade.Visible = true
            else
                CreateTween(TextButton, "Size", UDim2.new(1, 0, 0, 25), 0.2, true)
                UI_Grade.Visible = false
                grade.Visible = false
            end
        end)
    end

    function AddDropdown(parent, Configs)
        local TextButton = Create("TextButton", parent, {
            Size = UDim2.new(1, 0, 0, 25),
            BackgroundColor3 = Configs_HUB.Cor_Options,
            BackgroundTransparency = Configs_HUB.Transparency,
            Text = "",
            AutoButtonColor = false
        })
        Corner(TextButton)
        Stroke(TextButton)

        local TextLabel = Create("TextLabel", TextButton, {
            TextSize = 12,
            TextColor3 = Configs_HUB.Cor_Text,
            Text = Configs.Name,
            Size = UDim2.new(1, 0, 0, 25),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            TextXAlignment = "Left",
            Font = Configs_HUB.Text_Font
        })
        TextSetColor(TextLabel)

        local Arrow = Create("ImageLabel", TextButton, {
            Image = "rbxassetid://6031090990",
            Size = UDim2.new(0, 25, 0, 25),
            Position = UDim2.new(0, 5, 0, 0),
            BackgroundTransparency = 1
        })

        local DefaultText = Create("TextLabel", TextButton, {
            BackgroundColor3 = Configs_HUB.Cor_Hub,
            BackgroundTransparency = Configs_HUB.Transparency,
            Position = UDim2.new(1, -20, 0, 2.5),
            AnchorPoint = Vector2.new(1, 0),
            Size = UDim2.new(0, 100, 0, 20),
            TextColor3 = Configs_HUB.Cor_DarkText,
            TextScaled = true,
            Font = Configs_HUB.Text_Font,
            Text = Configs.Default
        })
        Corner(DefaultText)
        Stroke(DefaultText)

        local ScrollBar = Create("ScrollingFrame", TextButton, {
            Size = UDim2.new(1, 0, 1, -25),
            Position = UDim2.new(0, 0, 0, 25),
            CanvasSize = UDim2.new(),
            ScrollingDirection = "Y",
            AutomaticCanvasSize = "Y",
            BackgroundTransparency = 1,
            ScrollBarThickness = 2,
            Visible = false
        })
        Create("UIPadding", ScrollBar, {PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10), PaddingTop = UDim.new(0, 10), PaddingBottom = UDim.new(0, 10)})
        Create("UIListLayout", ScrollBar, {Padding = UDim.new(0, 5)})

        local function AddOption(OptionName)
            local OptionButton = Create("TextButton", ScrollBar, {
                Size = UDim2.new(1, 0, 0, 15),
                Text = OptionName,
                Font = Configs_HUB.Text_Font,
                TextSize = 12,
                TextColor3 = OptionName == Configs.Default and Configs_HUB.Cor_Text or Color3.fromRGB(180, 180, 180),
                BackgroundTransparency = OptionName == Configs.Default and 0.8 or 1
            })
            Corner(OptionButton)

            OptionButton.MouseButton1Click:Connect(function()
                for _, v in pairs(ScrollBar:GetChildren()) do
                    if v:IsA("TextButton") then
                        v.BackgroundTransparency = 1
                        v.TextColor3 = Color3.fromRGB(180, 180, 180)
                    end
                end
                DefaultText.Text = OptionName
                Configs.Callback(OptionName)
                OptionButton.BackgroundTransparency = 0.8
                OptionButton.TextColor3 = Configs_HUB.Cor_Text
            end)
        end

        for _, v in pairs(Configs.Options) do AddOption(v) end

        local DropOnOff = false
        TextButton.MouseButton1Click:Connect(function()
            DropOnOff = not DropOnOff
            ScrollBar.Visible = DropOnOff
            if DropOnOff then
                local OptionSize = 25 + (#Configs.Options * 20)
                CreateTween(TextButton, "Size", UDim2.new(1, 0, 0, math.min(OptionSize, 100)), 0.3, false)
                CreateTween(Arrow, "Rotation", 180, 0.3, false)
            else
                CreateTween(TextButton, "Size", UDim2.new(1, 0, 0, 25), 0.3, false)
                CreateTween(Arrow, "Rotation", 0, 0.3, true)
            end
        end)
        return {ScrollBar, Configs.Default, Configs.Callback, DefaultText}
    end

    function UpdateDropdown(Dropdown, NewOptions)
        local ScrollBar = Dropdown[1]
        local Default = Dropdown[2]
        local Callback = Dropdown[3]
        local DefaultText = Dropdown[4]

        for _, v in pairs(ScrollBar:GetChildren()) do
            if v:IsA("TextButton") then v:Destroy() end
        end

        local function AddOption(OptionName)
            local TextButton = Create("TextButton", ScrollBar, {
                Size = UDim2.new(1, 0, 0, 15),
                Text = OptionName,
                Font = Configs_HUB.Text_Font,
                TextSize = 12,
                TextColor3 = OptionName == Default and Configs_HUB.Cor_Text or Color3.fromRGB(180, 180, 180),
                BackgroundTransparency = OptionName == Default and 0.8 or 1
            })
            Corner(TextButton)

            TextButton.MouseButton1Click:Connect(function()
                for _, v in pairs(ScrollBar:GetChildren()) do
                    if v:IsA("TextButton") then
                        v.BackgroundTransparency = 1
                        v.TextColor3 = Color3.fromRGB(180, 180, 180)
                    end
                end
                DefaultText.Text = OptionName
                Callback(OptionName)
                TextButton.BackgroundTransparency = 0.8
                TextButton.TextColor3 = Configs_HUB.Cor_Text
            end)
        end

        for _, v in pairs(NewOptions) do AddOption(v) end
    end

    -- Hiệu ứng động
    local AnimMenu = Create("Frame", ScreenGui, {
        Position = UDim2.new(0.5, 0, 0.5, 0),
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Configs_HUB.Cor_Hub,
        BackgroundTransparency = Configs_HUB.Transparency
    })
    Corner(AnimMenu, {CornerRadius = UDim.new(0, 6)})

    local Anim_Credits = Create("TextLabel", AnimMenu, {
        Text = Anim_Title,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Visible = false,
        Font = Configs_HUB.Text_Font,
        TextTransparency = 1,
        TextColor3 = Configs_HUB.Cor_Text,
        Position = UDim2.new(0, 10, 0, 0),
        TextXAlignment = "Left",
        TextSize = 15
    })

    CreateTween(AnimMenu, "Size", UDim2.new(0, 0, 0, 35), 0.5, true)
    CreateTween(AnimMenu, "Size", UDim2.new(0, 150, 0, 35), 0.5, true)
    Anim_Credits.Visible = true
    task.wait(0.5)
    for i = 1, 0, -0.1 do task.wait() Anim_Credits.TextTransparency = i end
    task.wait(1)
    for i = 0, 1, 0.1 do task.wait() Anim_Credits.TextTransparency = i end
    AnimMenu:Destroy()

    return Menu
end
