-- Định nghĩa thư viện UI
local Library = {}

-- Dịch vụ cần thiết
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Hàm tạo cửa sổ chính
function Library:MakeWindow(options)
    local hub = options.Hub or {}
    local key = options.Key or {}
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "HoangHubGui"
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 500, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(50, 20, 70) -- Màu tím đậm
    mainFrame.BorderSizePixel = 0
    
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Parent = mainFrame
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(70, 30, 90) -- Màu tím nhạt
    topBar.BorderSizePixel = 0
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = topBar
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Text = hub.Title or "Hoàng Hub"
    titleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = topBar
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    closeButton.BackgroundColor3 = Color3.fromRGB(100, 40, 120)
    closeButton.Font = Enum.Font.Gotham
    closeButton.TextSize = 14
    
    closeButton.MouseButton1Click:Connect(function()
        screenGui:Destroy()
    end)
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = mainFrame
    tabContainer.Size = UDim2.new(0, 120, 1, -30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(60, 25, 80)
    tabContainer.BorderSizePixel = 0
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Parent = mainFrame
    contentContainer.Size = UDim2.new(1, -120, 1, -30)
    contentContainer.Position = UDim2.new(0, 120, 0, 30)
    contentContainer.BackgroundColor3 = Color3.fromRGB(40, 15, 60)
    contentContainer.BorderSizePixel = 0
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = tabContainer
    uiListLayout.Padding = UDim.new(0, 5)
    
    local tabs = {}
    local windowData = {
        Tabs = tabs,
        TabContainer = tabContainer,
        ContentContainer = contentContainer,
        ScreenGui = screenGui
    }
    
    if key.KeySystem then
        local keyFrame = Instance.new("Frame")
        keyFrame.Name = "KeyFrame"
        keyFrame.Parent = screenGui
        keyFrame.Size = UDim2.new(0, 250, 0, 150)
        keyFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
        keyFrame.BackgroundColor3 = Color3.fromRGB(50, 20, 70)
        keyFrame.BorderSizePixel = 0
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Parent = keyFrame
        keyTitle.Size = UDim2.new(1, 0, 0, 30)
        keyTitle.Text = key.Title or "Nhập key để tiếp tục🌚🥵"
        keyTitle.TextColor3 = Color3.fromRGB(200, 200, 255)
        keyTitle.BackgroundTransparency = 1
        keyTitle.TextSize = 16
        keyTitle.Font = Enum.Font.Gotham
        keyTitle.TextXAlignment = Enum.TextXAlignment.Center
        
        local keyDesc = Instance.new("TextLabel")
        keyDesc.Parent = keyFrame
        keyDesc.Size = UDim2.new(1, 0, 0, 40)
        keyDesc.Position = UDim2.new(0, 0, 0, 30)
        keyDesc.Text = key.Description or "Được Tạo Bởi: Huỳnh Ngọc Hoàng👑"
        keyDesc.TextColor3 = Color3.fromRGB(200, 200, 255)
        keyDesc.BackgroundTransparency = 1
        keyDesc.TextSize = 12
        keyDesc.Font = Enum.Font.Gotham
        keyDesc.TextWrapped = true
        
        local keyInput = Instance.new("TextBox")
        keyInput.Parent = keyFrame
        keyInput.Size = UDim2.new(0.8, 0, 0, 30)
        keyInput.Position = UDim2.new(0.1, 0, 0.4, 0)
        keyInput.Text = ""
        keyInput.PlaceholderText = "Nhập key..."
        keyInput.TextColor3 = Color3.fromRGB(200, 200, 255)
        keyInput.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
        keyInput.BorderSizePixel = 0
        keyInput.Font = Enum.Font.Gotham
        
        local keyButton = Instance.new("TextButton")
        keyButton.Parent = keyFrame
        keyButton.Size = UDim2.new(0.4, 0, 0, 30)
        keyButton.Position = UDim2.new(0.3, 0, 0.7, 0)
        keyButton.Text = "Xác nhận"
        keyButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        keyButton.BackgroundColor3 = Color3.fromRGB(100, 40, 120)
        keyButton.Font = Enum.Font.Gotham
        keyButton.TextSize = 14
        
        keyButton.MouseButton1Click:Connect(function()
            local enteredKey = keyInput.Text
            for _, validKey in pairs(key.Keys or {}) do
                if enteredKey == validKey then
                    keyFrame:Destroy()
                    mainFrame.Visible = true
                    if key.Notifi and key.Notifi.Notifications then
                        game.StarterGui:SetCore("SendNotification", {
                            Title = "Thông báo",
                            Text = key.Notifi.CorrectKey or "Script Đang Chạy🥵!",
                            Duration = 5
                        })
                    end
                    return
                end
            end
            if key.Notifi and key.Notifi.Notifications then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Lỗi",
                    Text = key.Notifi.Incorrectkey or "Key không tồn tại🥵",
                    Duration = 5
                })
            end
        end)
        
        mainFrame.Visible = false
    end
    
    return windowData
end

-- Hàm thu nhỏ cửa sổ
function Library:MinimizeButton(options)
    local image = options.Image or "rbxassetid://136495663671275"
    local size = options.Size or {25, 25}
    local color = options.Color or Color3.fromRGB(10, 10, 10)
    local corner = options.Corner or true
    local stroke = options.Stroke or false
    local strokeColor = options.StrokeColor or Color3.fromRGB(255, 0, 0)
    
    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Parent = options.Window.ScreenGui.MainFrame.TopBar
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
        options.Window.ContentContainer.Visible = not minimized
        options.Window.ScreenGui.MainFrame.Size = minimized and UDim2.new(0, 500, 0, 30) or UDim2.new(0, 500, 0, 350)
    end)
    
    return minimizeButton
end

-- Hàm tạo tab
function Library:MakeTab(options)
    local name = options.Name or "Tab"
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Button"
    tabButton.Parent = options.Window.TabContainer
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, 5 + (#options.Window.Tabs * 45))
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    tabButton.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.BorderSizePixel = 0
    
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = name .. "Frame"
    tabFrame.Parent = options.Window.ContentContainer
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = tabFrame
    uiListLayout.Padding = UDim.new(0, 5)
    
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

-- Hàm thêm nhãn
function Library:AddLabel(tab, options)
    local text = options.Text or "Label"
    
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Parent = tab
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.Text = text
    label.TextColor3 = Color3.fromRGB(200, 200, 255)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
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
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(200, 200, 255)
    button.BackgroundColor3 = Color3.fromRGB(100, 40, 120)
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BorderSizePixel = 0
    
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
    toggleFrame.Size = UDim2.new(1, -20, 0, 30)
    toggleFrame.BackgroundTransparency = 1
    
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Parent = toggleFrame
    toggleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    toggleLabel.Text = name
    toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextSize = 14
    
    local toggleButton = Instance.new("TextButton")
    toggleButton.Parent = toggleFrame
    toggleButton.Size = UDim2.new(0, 20, 0, 20)
    toggleButton.Position = UDim2.new(0.85, 0, 0.5, -10)
    toggleButton.BackgroundColor3 = default and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
    toggleButton.Text = ""
    toggleButton.BorderSizePixel = 0
    
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
    sliderFrame.Size = UDim2.new(1, -20, 0, 40)
    sliderFrame.BackgroundTransparency = 1
    
    local sliderLabel = Instance.new("TextLabel")
    sliderLabel.Name = "Label"
    sliderLabel.Parent = sliderFrame
    sliderLabel.Size = UDim2.new(1, 0, 0, 20)
    sliderLabel.Text = sliderName .. ": " .. defaultValue
    sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
    sliderLabel.BackgroundTransparency = 1
    sliderLabel.Font = Enum.Font.Gotham
    sliderLabel.TextSize = 14
    
    local sliderBar = Instance.new("Frame")
    sliderBar.Name = "Bar"
    sliderBar.Parent = sliderFrame
    sliderBar.Size = UDim2.new(1, 0, 0, 10)
    sliderBar.Position = UDim2.new(0, 0, 0, 20)
    sliderBar.BackgroundColor3 = Color3.fromRGB(100, 40, 120)
    sliderBar.BorderSizePixel = 0
    
    local sliderButton = Instance.new("TextButton")
    sliderButton.Name = "Button"
    sliderButton.Parent = sliderBar
    sliderButton.Size = UDim2.new(0, 10, 1, 0)
    sliderButton.BackgroundColor3 = Color3.fromRGB(150, 70, 180)
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
            sliderButton.Size = UDim2.new(relativeX, 0, 1, 0)
            sliderLabel.Text = sliderName .. ": " .. value
            callback(value)
        end
    end)

    local defaultRelative = (defaultValue - minValue) / (maxValue - minValue)
    sliderButton.Size = UDim2.new(defaultRelative, 0, 1, 0)
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
    dropdownFrame.Size = UDim2.new(1, -20, 0, 30)
    dropdownFrame.BackgroundTransparency = 1
    
    local dropdownButton = Instance.new("TextButton")
    dropdownButton.Parent = dropdownFrame
    dropdownButton.Size = UDim2.new(1, 0, 1, 0)
    dropdownButton.Text = default
    dropdownButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(100, 40, 120)
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.TextSize = 14
    dropdownButton.BorderSizePixel = 0
    
    local dropdownList = Instance.new("Frame")
    dropdownList.Parent = dropdownFrame
    dropdownList.Size = UDim2.new(1, 0, 0, #opts * 30)
    dropdownList.Position = UDim2.new(0, 0, 1, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(70, 30, 90)
    dropdownList.Visible = false
    dropdownList.BorderSizePixel = 0
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = dropdownList
    
    for i, option in pairs(opts) do
        local optionButton = Instance.new("TextButton")
        optionButton.Parent = dropdownList
        optionButton.Size = UDim2.new(1, -10, 0, 30)
        optionButton.Position = UDim2.new(0, 5, 0, (i-1) * 30)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(200, 200, 255)
        optionButton.BackgroundColor3 = Color3.fromRGB(100, 40, 120)
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 14
        optionButton.BorderSizePixel = 0
        
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
