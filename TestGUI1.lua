-- Định nghĩa thư viện UI
local Library = {}

-- Dịch vụ cần thiết
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Hàm tạo cửa sổ chính
function Library:MakeWindow(options)
    local hub = options.Hub or {}
    local key = options.Key or {}
    
    -- ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BananaCatHubGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    -- Main Frame với theme Banana Cat
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 450, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -225, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Vàng chuối
    mainFrame.BorderSizePixel = 2
    mainFrame.BorderColor3 = Color3.fromRGB(255, 165, 0) -- Cam nhạt
    
    -- Tiêu đề với phong cách Banana Cat
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = mainFrame
    titleLabel.Size = UDim2.new(1, 0, 0, 40)
    titleLabel.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Cam nhạt
    titleLabel.Text = (hub.Title or "Banana Cat Hub 🍌🐱") .. " " .. (hub.Animation or "")
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextSize = 18
    titleLabel.Font = Enum.Font.Cartoon
    
    -- Container cho các tab
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = mainFrame
    tabContainer.Size = UDim2.new(1, -10, 1, -50)
    tabContainer.Position = UDim2.new(0, 5, 0, 45)
    tabContainer.BackgroundColor3 = Color3.fromRGB(255, 245, 200) -- Vàng nhạt
    tabContainer.BorderSizePixel = 0
    
    local tabs = {}
    local windowData = {
        Tabs = tabs,
        Container = tabContainer,
        ScreenGui = screenGui
    }
    
    -- Hệ thống key với theme Banana Cat
    if key.KeySystem then
        local keyFrame = Instance.new("Frame")
        keyFrame.Name = "KeyFrame"
        keyFrame.Parent = screenGui
        keyFrame.Size = UDim2.new(0, 300, 0, 180)
        keyFrame.Position = UDim2.new(0.5, -150, 0.5, -90)
        keyFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0) -- Vàng chuối
        keyFrame.BorderSizePixel = 2
        keyFrame.BorderColor3 = Color3.fromRGB(255, 165, 0)
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Parent = keyFrame
        keyTitle.Size = UDim2.new(1, 0, 0, 40)
        keyTitle.Text = key.Title or "Nhập Key Để Tiếp Tục 🍌🐱"
        keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyTitle.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        keyTitle.TextSize = 16
        keyTitle.Font = Enum.Font.Cartoon
        
        local keyDesc = Instance.new("TextLabel")
        keyDesc.Parent = keyFrame
        keyDesc.Size = UDim2.new(1, 0, 0, 20)
        keyDesc.Position = UDim2.new(0, 0, 0, 40)
        keyDesc.Text = key.Description or "Nhập key để mở khóa!"
        keyDesc.TextColor3 = Color3.fromRGB(0, 0, 0)
        keyDesc.BackgroundTransparency = 1
        keyDesc.TextSize = 12
        keyDesc.Font = Enum.Font.Cartoon
        
        local keyInput = Instance.new("TextBox")
        keyInput.Parent = keyFrame
        keyInput.Size = UDim2.new(0.8, 0, 0, 30)
        keyInput.Position = UDim2.new(0.1, 0, 0.45, 0)
        keyInput.Text = ""
        keyInput.PlaceholderText = "Nhập key..."
        keyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyInput.BackgroundColor3 = Color3.fromRGB(255, 245, 200)
        keyInput.BorderColor3 = Color3.fromRGB(255, 165, 0)
        keyInput.Font = Enum.Font.Cartoon
        
        local keyButton = Instance.new("TextButton")
        keyButton.Parent = keyFrame
        keyButton.Size = UDim2.new(0.4, 0, 0, 30)
        keyButton.Position = UDim2.new(0.3, 0, 0.75, 0)
        keyButton.Text = "Xác nhận 🐱"
        keyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        keyButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        keyButton.Font = Enum.Font.Cartoon
        
        keyButton.MouseButton1Click:Connect(function()
            local enteredKey = keyInput.Text
            for _, validKey in pairs(key.Keys or {}) do
                if enteredKey == validKey then
                    keyFrame:Destroy()
                    mainFrame.Visible = true
                    if key.Notifi and key.Notifi.Notifications then
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Thông báo 🍌🐱",
                            Text = key.Notifi.CorrectKey or "Key hợp lệ! Chào mừng bạn!",
                            Duration = 5
                        })
                    end
                    return
                end
            end
            if key.Notifi and key.Notifi.Notifications then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Lỗi 🍌😿",
                    Text = key.Notifi.Incorrectkey or "Key không đúng!",
                    Duration = 5
                })
            end
        end)
        
        mainFrame.Visible = false
    end
    
    return windowData
end

-- Hàm thu nhỏ cửa sổ (MinimizeButton)
function Library:MinimizeButton(options)
    local image = options.Image or "rbxassetid://6026568198" -- Hình mặc định
    local size = options.Size or {25, 25}
    local color = options.Color or Color3.fromRGB(255, 165, 0) -- Cam nhạt
    local corner = options.Corner or true
    local stroke = options.Stroke or false
    local strokeColor = options.StrokeColor or Color3.fromRGB(255, 165, 0)
    
    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Parent = options.Window.ScreenGui.MainFrame
    minimizeButton.Size = UDim2.new(0, size[1], 0, size[2])
    minimizeButton.Position = UDim2.new(1, -30, 0, 5)
    minimizeButton.BackgroundColor3 = color
    minimizeButton.Image = image
    
    if corner then
        local corner = Instance.new("UICorner")
        corner.Parent = minimizeButton
    end
    
    if stroke then
        local stroke = Instance.new("UIStroke")
        stroke.Color = strokeColor
        stroke.Parent = minimizeButton
    end
    
    local minimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        options.Window.Container.Visible = not minimized
        mainFrame.Size = minimized and UDim2.new(0, 450, 0, 40) or UDim2.new(0, 450, 0, 350)
    end)
    
    return minimizeButton
end

-- Hàm tạo tab
function Library:MakeTab(options)
    local name = options.Name or "Tab"
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Button"
    tabButton.Parent = options.Window.Container.Parent
    tabButton.Size = UDim2.new(0, 110, 0, 35)
    tabButton.Position = UDim2.new(0, #options.Window.Tabs * 115, 0, 5)
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Cam nhạt
    tabButton.Font = Enum.Font.Cartoon
    tabButton.TextSize = 14
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = name .. "Frame"
    tabFrame.Parent = options.Window.Container
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(options.Window.Tabs) do
            tab.Frame.Visible = false
        end
        tabFrame.Visible = true
    end)
    
    local tabData = {
        Name = name,
        Frame = tabFrame,
        Button = tabButton
    }
    table.insert(options.Window.Tabs, tabData)
    
    if #options.Window.Tabs == 1 then
        tabFrame.Visible = true
    end
    
    return tabFrame
end

-- Hàm thêm nhãn (label)
function Library:AddLabel(tab, options)
    local text = options.Text or "Label"
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = tab
    label.Size = UDim2.new(0, 150, 0, 30)
    label.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 35)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(0, 0, 0)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Cartoon
    label.TextSize = 14
    
    return label
end

-- Hàm thêm nút
function Library:AddButton(tab, options)
    local name = options.Name or "Button"
    local callback = options.Callback or function() end
    
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = tab
    button.Size = UDim2.new(0, 160, 0, 35)
    button.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 40)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Cam nhạt
    button.Font = Enum.Font.Cartoon
    button.TextSize = 14
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Hàm thêm toggle
function Library:AddToggle(tab, options)
    local name = options.Name or "Toggle"
    local default = options.Default or false
    local callback = options.Callback or function() end
    
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Name = name
    toggleFrame.Parent = tab
    toggleFrame.Size = UDim2.new(0, 160, 0, 35)
    toggleFrame.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 40)
    toggleFrame.BackgroundTransparency = 1
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Parent = toggleFrame
    toggleLabel.Size = UDim2.new(0.75, 0, 1, 0)
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Font = Enum.Font.Cartoon
    toggleLabel.TextSize = 14
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleFrame
    toggleButton.Size = UDim2.new(0, 25, 0, 25)
    toggleButton.Position = UDim2.new(0.75, 5, 0, 5)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleButton.Text = ""
    
    local state = default
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(state)
    end)
    
    return toggleFrame
end

-- Hàm thêm slider
function Library:AddSlider(tab, options)
    local sliderName = options.Name or "Slider"
    local minValue = options.Min or 0
    local maxValue = options.Max or 100
    local defaultValue = options.Default or minValue
    local callback = options.Callback or function() end

    local sliderFrame = Instance.new("Frame")
    sliderFrame.Name = sliderName
    sliderFrame.Parent = tab
    sliderFrame.Size = UDim2.new(0, 200, 0, 50)
    sliderFrame.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 40)
    sliderFrame.BackgroundTransparency = 1

    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Parent = sliderFrame
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Position = UDim2.new(0, 0, 0, 0)
    sliderLabel.Text = sliderName .. ": " .. defaultValue
    sliderLabel.TextColor3 = Color3.fromRGB(0, 0, 0)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Font = Enum.Font.Cartoon
    sliderLabel.TextSize = 14

    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "Bar"
    sliderBar.Parent = sliderFrame
    sliderBar.Size = UDim2.new(0.9, 0, 0, 10)
    sliderBar.Position = UDim2.new(0.05, 0, 0, 30)
    sliderBar.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Cam nhạt
    sliderBar.BorderSizePixel = 0

    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Button"
    sliderButton.Parent = sliderBar
    sliderButton.Size = UDim2.new(0, 12, 0, 12)
    sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sliderButton.Text = ""
    sliderButton.BorderSizePixel = 0

    local dragging = false
    sliderButton.MouseButton1Down:Connect(function()
        dragging = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)

    sliderButton.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local relativeX = math.clamp((input.Position.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            local value = math.floor(minValue + (maxValue - minValue) * relativeX)
            sliderButton.Position = UDim2.new(relativeX, -6, 0, -1)
            sliderLabel.Text = sliderName .. ": " .. value
            callback(value)
        end
    end)

    local defaultRelative = (defaultValue - minValue) / (maxValue - minValue)
    sliderButton.Position = UDim2.new(defaultRelative, -6, 0, -1)
    sliderLabel.Text = sliderName .. ": " .. defaultValue
    callback(defaultValue)

    return sliderFrame
end

-- Hàm thêm dropdown
function Library:AddDropdown(tab, options)
    local name = options.Name or "Dropdown"
    local default = options.Default or "Select"
    local opts = options.Options or {}
    local callback = options.Callback or function() end
    
    local dropdownFrame = Instance.new("Frame")
    dropdownFrame.Name = name
    dropdownFrame.Parent = tab
    dropdownFrame.Size = UDim2.new(0, 160, 0, 35)
    dropdownFrame.Position = UDim2.new(0, 10, 0, #tab:GetChildren() * 40)
    dropdownFrame.BackgroundTransparency = 1
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Parent = dropdownFrame
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.Text = default
    dropdownButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0) -- Cam nhạt
    dropdownButton.Font = Enum.Font.Cartoon
    dropdownButton.TextSize = 14
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Parent = dropdownFrame
    dropdownList.Size = UDim2.new(1, 0, 0, #opts * 35)
    dropdownList.Position = UDim2.new(0, 0, 1, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(255, 245, 200) -- Vàng nhạt
    dropdownList.Visible = false
    
    for i, option in pairs(opts) do
        local optionButton = Instance.new("TextButton")
        optionButton.Parent = dropdownList
        optionButton.Size = UDim2.new(1, 0, 0, 35)
        optionButton.Position = UDim2.new(0, 0, 0, (i-1) * 35)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
        optionButton.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
        optionButton.Font = Enum.Font.Cartoon
        optionButton.TextSize = 14
        
        optionButton.MouseButton1Click:Connect(function()
            dropdownButton.Text = option
            dropdownList.Visible = false
            callback(option)
        end)
    end
    
    dropdownButton.MouseButton1Click:Connect(function()
        dropdownList.Visible = not dropdownList.Visible
    end)
    
    return dropdownFrame
end

-- Trả về thư viện
return Library