-- Định nghĩa thư viện UI
local Library = {}

-- Dịch vụ cần thiết
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Hàm tạo cửa sổ chính
function Library:MakeWindow(options)
    if not options then
        error("Options không được cung cấp cho MakeWindow")
    end

    local hub = options.Hub or {}
    local key = options.Key or {}
    
    -- Kiểm tra an toàn cho LocalPlayer
    local player = game.Players.LocalPlayer
    if not player then
        error("LocalPlayer không tồn tại")
    end
    local playerGui = player:WaitForChild("PlayerGui", 10)
    if not playerGui then
        error("PlayerGui không tồn tại")
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "RedzHubGui"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Parent = screenGui
    mainFrame.Size = UDim2.new(0, 500, 0, 350)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -175)
    mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30) -- Màu xám đậm giống Redz Hub
    mainFrame.BorderSizePixel = 0
    
    -- Hiệu ứng mở GUI
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 350)})
    openTween:Play()
    
    -- Hỗ trợ kéo thả GUI
    local dragging, dragInput, dragStart, startPos
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    mainFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    local topBar = Instance.new("Frame")
    topBar.Name = "TopBar"
    topBar.Parent = mainFrame
    topBar.Size = UDim2.new(1, 0, 0, 30)
    topBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Màu đen đậm
    topBar.BorderSizePixel = 0
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "Title"
    titleLabel.Parent = topBar
    titleLabel.Size = UDim2.new(1, 0, 1, 0)
    titleLabel.Text = hub.Title or "Redz Hub"
    titleLabel.TextColor3 = Color3.fromRGB(255, 50, 50) -- Màu đỏ
    titleLabel.BackgroundTransparency = 1
    titleLabel.TextSize = 16
    titleLabel.Font = Enum.Font.Gotham
    titleLabel.TextXAlignment = Enum.TextXAlignment.Center
    
    local tabContainer = Instance.new("Frame")
    tabContainer.Name = "TabContainer"
    tabContainer.Parent = mainFrame
    tabContainer.Size = UDim2.new(0, 120, 1, -30)
    tabContainer.Position = UDim2.new(0, 0, 0, 30)
    tabContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 20) -- Màu đen
    tabContainer.BorderSizePixel = 0
    
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Parent = mainFrame
    contentContainer.Size = UDim2.new(1, -120, 1, -30)
    contentContainer.Position = UDim2.new(0, 120, 0, 30)
    contentContainer.BackgroundColor3 = Color3.fromRGB(40, 40, 40) -- Màu xám đậm
    contentContainer.BorderSizePixel = 0
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = tabContainer
    uiListLayout.Padding = UDim.new(0, 5)
    
    local tabs = {}
    local windowData = {
        Tabs = tabs,
        TabContainer = tabContainer,
        ContentContainer = contentContainer,
        ScreenGui = screenGui,
        MainFrame = mainFrame
    }
    
    if key.KeySystem then
        local keyFrame = Instance.new("Frame")
        keyFrame.Name = "KeyFrame"
        keyFrame.Parent = screenGui
        keyFrame.Size = UDim2.new(0, 250, 0, 150)
        keyFrame.Position = UDim2.new(0.5, -125, 0.5, -75)
        keyFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        keyFrame.BorderSizePixel = 0
        
        local keyTitle = Instance.new("TextLabel")
        keyTitle.Parent = keyFrame
        keyTitle.Size = UDim2.new(1, 0, 0, 30)
        keyTitle.Text = key.Title or "Nhập Key"
        keyTitle.TextColor3 = Color3.fromRGB(255, 50, 50)
        keyTitle.BackgroundTransparency = 1
        keyTitle.TextSize = 16
        keyTitle.Font = Enum.Font.Gotham
        keyTitle.TextXAlignment = Enum.TextXAlignment.Center
        
        local keyInput = Instance.new("TextBox")
        keyInput.Parent = keyFrame
        keyInput.Size = UDim2.new(0.8, 0, 0, 30)
        keyInput.Position = UDim2.new(0.1, 0, 0.3, 0)
        keyInput.Text = ""
        keyInput.PlaceholderText = "Nhập key..."
        keyInput.TextColor3 = Color3.fromRGB(255, 50, 50)
        keyInput.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        keyInput.BorderSizePixel = 0
        keyInput.Font = Enum.Font.Gotham
        
        local keyButton = Instance.new("TextButton")
        keyButton.Parent = keyFrame
        keyButton.Size = UDim2.new(0.4, 0, 0, 30)
        keyButton.Position = UDim2.new(0.3, 0, 0.7, 0)
        keyButton.Text = "Xác nhận"
        keyButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        keyButton.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
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
                            Text = key.Notifi.CorrectKey or "Key hợp lệ!",
                            Duration = 5
                        })
                    end
                    return
                end
            end
            if key.Notifi and key.Notifi.Notifications then
                game.StarterGui:SetCore("SendNotification", {
                    Title = "Lỗi",
                    Text = key.Notifi.Incorrectkey or "Key không đúng!",
                    Duration = 5
                })
            end
        end)
        
        mainFrame.Visible = false
    end
    
    return windowData
end

-- Hàm tạo tab
function Library:MakeTab(options)
    if not options or not options.Window then
        error("Options hoặc Window không được cung cấp cho MakeTab")
    end

    local name = options.Name or "Tab"
    
    local tabButton = Instance.new("TextButton")
    tabButton.Name = name .. "Button"
    tabButton.Parent = options.Window.TabContainer
    tabButton.Size = UDim2.new(1, -10, 0, 40)
    tabButton.Position = UDim2.new(0, 5, 0, 5 + (#options.Window.Tabs * 45))
    tabButton.Text = name
    tabButton.TextColor3 = Color3.fromRGB(255, 50, 50) -- Màu đỏ
    tabButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50) -- Màu xám đậm
    tabButton.Font = Enum.Font.Gotham
    tabButton.TextSize = 14
    tabButton.BorderSizePixel = 0
    
    local uiCorner = Instance.new("UICorner") -- Thêm viền tròn
    uiCorner.CornerRadius = UDim.new(0, 5)
    uiCorner.Parent = tabButton
    
    -- Thêm hiệu ứng hover
    local originalColor = tabButton.BackgroundColor3
    tabButton.MouseEnter:Connect(function()
        tabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end)
    tabButton.MouseLeave:Connect(function()
        tabButton.BackgroundColor3 = originalColor
    end)
    
    local tabFrame = Instance.new("ScrollingFrame")
    tabFrame.Name = name .. "Frame"
    tabFrame.Parent = options.Window.ContentContainer
    tabFrame.Size = UDim2.new(1, 0, 1, 0)
    tabFrame.BackgroundTransparency = 1
    tabFrame.Visible = false
    tabFrame.ScrollBarThickness = 5
    tabFrame.CanvasSize = UDim2.new(0, 0, 0, 0) -- Sẽ tự động điều chỉnh
    tabFrame.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = tabFrame
    uiListLayout.Padding = UDim.new(0, 5)
    
    -- Thêm padding cho nội dung tab
    local uiPadding = Instance.new("UIPadding")
    uiPadding.Parent = tabFrame
    uiPadding.PaddingLeft = UDim.new(0, 10)
    uiPadding.PaddingRight = UDim.new(0, 10)
    uiPadding.PaddingTop = UDim.new(0, 10)
    uiPadding.PaddingBottom = UDim.new(0, 10)
    
    -- Tự động cập nhật CanvasSize khi nội dung thay đổi
    uiListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        tabFrame.CanvasSize = UDim2.new(0, 0, 0, uiListLayout.AbsoluteContentSize.Y + 20) -- Thêm 20 để có khoảng trống dưới cùng
    end)
    
    tabButton.MouseButton1Click:Connect(function()
        for _, tab in pairs(options.Window.Tabs) do
            tab.Frame.Visible = false
            local fadeOut = TweenService:Create(tab.Frame, TweenInfo.new(0.2), {BackgroundTransparency = 1})
            fadeOut:Play()
        end
        tabFrame.Visible = true
        local fadeIn = TweenService:Create(tabFrame, TweenInfo.new(0.2), {BackgroundTransparency = 0})
        fadeIn:Play()
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

-- Hàm thêm toggle
function Library:AddToggle(tab, options)
    if not tab or not options then
        error("Tab hoặc Options không được cung cấp cho AddToggle")
    end

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
    toggleLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
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
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 5)
    uiCorner.Parent = toggleButton
    
    local state = default
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.BackgroundColor3 = state and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
        callback(state)
    end)
    
    return toggleFrame
end

-- Hàm thêm button
function Library:AddButton(tab, options)
    if not tab or not options then
        error("Tab hoặc Options không được cung cấp cho AddButton")
    end

    local name = options.Name or "Button"
    local callback = options.Callback or function() end
    
    local button = Instance.new("TextButton")
    button.Name = name
    button.Parent = tab
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, 0)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 50, 50)
    button.BackgroundColor3 = Color3.fromRGB(70, 20, 20) -- Màu đỏ đậm
    button.Font = Enum.Font.Gotham
    button.TextSize = 14
    button.BorderSizePixel = 0
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 5)
    uiCorner.Parent = button
    
    -- Thêm hiệu ứng hover
    local originalColor = button.BackgroundColor3
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
    end)
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
    
    button.MouseButton1Click:Connect(callback)
    
    return button
end

-- Hàm thêm dropdown
function Library:AddDropdown(tab, options)
    if not tab or not options then
        error("Tab hoặc Options không được cung cấp cho AddDropdown")
    end

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
    dropdownButton.TextColor3 = Color3.fromRGB(255, 50, 50)
    dropdownButton.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
    dropdownButton.Font = Enum.Font.Gotham
    dropdownButton.TextSize = 14
    dropdownButton.BorderSizePixel = 0
    
    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 5)
    uiCorner.Parent = dropdownButton
    
    -- Thêm hiệu ứng hover
    local originalColor = dropdownButton.BackgroundColor3
    dropdownButton.MouseEnter:Connect(function()
        dropdownButton.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
    end)
    dropdownButton.MouseLeave:Connect(function()
        dropdownButton.BackgroundColor3 = originalColor
    end)
    
    local dropdownList = Instance.new("ScrollingFrame")
    dropdownList.Parent = dropdownFrame
    dropdownList.Size = UDim2.new(1, 0, 0, math.min(#opts * 30, 120)) -- Giới hạn chiều cao tối đa
    dropdownList.Position = UDim2.new(0, 0, 1, 0)
    dropdownList.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdownList.Visible = false
    dropdownList.BorderSizePixel = 0
    dropdownList.ScrollBarThickness = 5
    dropdownList.CanvasSize = UDim2.new(0, 0, 0, #opts * 30)
    dropdownList.ScrollBarImageColor3 = Color3.fromRGB(255, 50, 50)
    
    local uiListLayout = Instance.new("UIListLayout")
    uiListLayout.Parent = dropdownList
    
    for i, option in pairs(opts) do
        local optionButton = Instance.new("TextButton")
        optionButton.Parent = dropdownList
        optionButton.Size = UDim2.new(1, -10, 0, 30)
        optionButton.Position = UDim2.new(0, 5, 0, (i-1) * 30)
        optionButton.Text = option
        optionButton.TextColor3 = Color3.fromRGB(255, 50, 50)
        optionButton.BackgroundColor3 = Color3.fromRGB(70, 20, 20)
        optionButton.Font = Enum.Font.Gotham
        optionButton.TextSize = 14
        optionButton.BorderSizePixel = 0
        
        local uiCornerOpt = Instance.new("UICorner")
        uiCornerOpt.CornerRadius = UDim.new(0, 5)
        uiCornerOpt.Parent = optionButton
        
        -- Hiệu ứng hover cho option button
        local optOriginalColor = optionButton.BackgroundColor3
        optionButton.MouseEnter:Connect(function()
            optionButton.BackgroundColor3 = Color3.fromRGB(90, 40, 40)
        end)
        optionButton.MouseLeave:Connect(function()
            optionButton.BackgroundColor3 = optOriginalColor
        end)
        
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

-- Hàm MinimizeButton (và nút Close)
function Library:MinimizeButton(options)
    if not options or not options.Window then
        error("Options hoặc Window không được cung cấp cho MinimizeButton")
    end

    local minimizeImage = options.MinimizeImage or "http://www.roblox.com/asset/?id=6023426926" -- Dấu gạch ngang
    local closeImage = options.CloseImage or "http://www.roblox.com/asset/?id=6023426915" -- Dấu X
    local size = options.Size or {25, 25}
    local color = options.Color or Color3.fromRGB(70, 20, 20)
    local corner = options.Corner or false
    local stroke = options.Stroke or false
    local strokeColor = options.StrokeColor or Color3.fromRGB(255, 0, 0)
    
    -- Nút Minimize
    local minimizeButton = Instance.new("ImageButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Parent = options.Window.MainFrame
    minimizeButton.Size = UDim2.new(0, size[1], 0, size[2])
    minimizeButton.Position = UDim2.new(1, -55, 0, 5)
    minimizeButton.BackgroundColor3 = color
    minimizeButton.Image = minimizeImage
    minimizeButton.BorderSizePixel = 0
    
    if corner then
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 5)
        uiCorner.Parent = minimizeButton
    end
    
    if stroke then
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Parent = minimizeButton
        uiStroke.Color = strokeColor
    end
    
    local isMinimized = false
    minimizeButton.MouseButton1Click:Connect(function()
        isMinimized = not isMinimized
        options.Window.MainFrame.Visible = not isMinimized
    end)
    
    -- Nút Close
    local closeButton = Instance.new("ImageButton")
    closeButton.Name = "CloseButton"
    closeButton.Parent = options.Window.MainFrame
    closeButton.Size = UDim2.new(0, 20, 0, 20)
    closeButton.Position = UDim2.new(1, -25, 0, 5)
    closeButton.BackgroundColor3 = color
    closeButton.Image = closeImage
    closeButton.BorderSizePixel = 0
    
    if corner then
        local uiCorner = Instance.new("UICorner")
        uiCorner.CornerRadius = UDim.new(0, 5)
        uiCorner.Parent = closeButton
    end
    
    if stroke then
        local uiStroke = Instance.new("UIStroke")
        uiStroke.Parent = closeButton
        uiStroke.Color = strokeColor
    end
    
    closeButton.MouseButton1Click:Connect(function()
        options.Window.ScreenGui:Destroy()
    end)
end

-- Gán tên hàm để tương thích với script của bạn
Library.MakeWindow = Library.MakeWindow
Library.MakeTab = Library.MakeTab
Library.AddToggle = Library.AddToggle
Library.AddButton = Library.AddButton
Library.AddDropdown = Library.AddDropdown
Library.MinimizeButton = Library.MinimizeButton

-- Trả về thư viện
return Library
