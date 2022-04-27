local inputservice = game:GetService("UserInputService")
local runservice = game:GetService("RunService")
local localplayer = game:GetService("Players").LocalPlayer

local library = {
    accentColor = Color3.fromRGB(250, 156, 78),
    currentBind = Enum.KeyCode.RightControl,

    registry = {}
}

function library:gc(Element)
    table.insert(library.registry, Element)
end

function library:setDraggable(Element)
    --// stolen from dev forum xd

    local gui = Element

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        gui.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = gui.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    inputservice.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
end

function library:create(Class, Props)
    local object = Instance.new(Class)

    for i, v in pairs(Props or {}) do
        object[i] = v
    end

    return (object)
end
--// Ignore the code below, i'm so fucking lazy to optimize it / make it look better

function library:init(Title)

    local workspace =
        library:create(
        "ScreenGui",
        {
            Parent = game.CoreGui
        }
    )

    local dragging =
        library:create(
        "Frame",
        {
            Parent = workspace,
            BackgroundColor3 = Color3.fromRGB(17, 17, 17),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            Position = UDim2.new(0.313411087, 0, 0.296158612, 0),
            Size = UDim2.new(0, 738, 0, 36)
        }
    )

    local container =
        library:create(
        "Frame",
        {
            Parent = dragging,
            BackgroundColor3 = Color3.fromRGB(11, 11, 11),
            BorderColor3 = Color3.fromRGB(0, 0, 0),
            Position = UDim2.new(0.00217968225, 0, -0.00572818518, 0),
            Size = UDim2.new(0, 736, 0, 500)
        }
    )

    local watermark =
        library:create(
        "TextLabel",
        {
            Parent = container,
            BackgroundTransparency = 1.000,
            Position = UDim2.new(0.0163043477, 0, 0, 0),
            Size = UDim2.new(0, 94, 0, 38),
            RichText = true,
            Font = Enum.Font.RobotoMono,
            Text = string.format("<smallcaps>%s</smallcaps>", Title),
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Left
        }
    )

    local tabber =
        library:create(
        "Frame",
        {
            Parent = container,
            BackgroundColor3 = Color3.fromRGB(4, 4, 4),
            BorderSizePixel = 0,
            Position = UDim2.new(0.0163043477, 0, 0.0759999976, 0),
            Size = UDim2.new(0, 713, 0, 49)
        }
    )

    local tab_sorter =
        library:create(
        "UIListLayout",
        {
            Parent = tabber,
            FillDirection = Enum.FillDirection.Horizontal,
            SortOrder = Enum.SortOrder.LayoutOrder,
            VerticalAlignment = Enum.VerticalAlignment.Bottom,
            Padding = UDim.new(0, 8)
        }
    )

    local funcs = {}

    function funcs:addTab(Title)
        local tab =
            library:create(
            "Frame",
            {
                Parent = tabber,
                BackgroundTransparency = 1.000,
                Position = UDim2.new(0, 0, -50, 0),
                Size = UDim2.new(0, 105, 0, 51)
            }
        )

        local highlight =
            library:create(
            "Frame",
            {
                Name = "highlight",
                Parent = tab,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                BorderSizePixel = 0,
                Position = UDim2.new(0, 0, 0.946699798, 0),
                Size = UDim2.new(0, 105, 0, 2)
            }
        )
        local name =
            library:create(
            "TextLabel",
            {
                Name = "TabName",
                Parent = highlight,
                BackgroundTransparency = 1.000,
                Position = UDim2.new(0, 0, -24.037735, 0),
                Size = UDim2.new(0, 105, 0, 47),
                Font = Enum.Font.RobotoMono,
                RichText = true,
                Text = string.format("<smallcaps>%s</smallcaps>", Title),
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 16.000
            }
        )

        local selectable =
            library:create(
            "ImageButton",
            {
                Parent = tab,
                BackgroundTransparency = 1.000,
                Position = UDim2.new(0.00952380989, 0, 0.0392156877, 0),
                Size = UDim2.new(0, 104, 0, 49),
                ImageTransparency = 1.000
            }
        )

        selectable.MouseButton1Click:Connect(
            function()
                highlight.BackgroundColor3 = library.accentColor
                name.TextColor3 = library.accentColor
                if (tab:FindFirstChild("leftsection")) then
                    tab.leftsection.Visible = true
                end 
                
                if (tab:FindFirstChild("rightsection")) then
                    tab.rightsection.Visible = true
                end

                for i, v in pairs(tabber:GetChildren()) do
                    if (v ~= tab and v:IsA("Frame")) then
                        v.highlight.TabName.TextColor3 = Color3.fromRGB(255, 255, 255)
                        v.highlight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)

                        if (v:FindFirstChild("leftsection")) then
                            v.leftsection.Visible = false
                        end 
            
                        if (v:FindFirstChild("rightsection")) then
                            v.rightsection.Visible = false
                        end
                    end
                end
            end
        )

        local sections = {}

        function sections:addLeftSection()
            local leftsection =
                library:create(
                "Frame",
                {
                    Visible = false,
                    Name = "leftsection",
                    Parent = tab,
                    BackgroundTransparency = 1.000,
                    Position = UDim2.new(0, 0, 1.2352941, 0),
                    Size = UDim2.new(0, 347, 0, 389)
                }
            )

            local leftsorter =
                library:create(
                "UIListLayout",
                {
                    Parent = leftsection,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 8)
                }
            )

            local mainfuncs = {}

            function mainfuncs:addToggle(title)
                local toggle =
                    library:create(
                    "ImageButton",
                    {
                        Name = title,
                        Parent = leftsection,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Position = UDim2.new(-0.0922190323, 0, 0, 0),
                        Size = UDim2.new(0, 24, 0, 24),
                        AutoButtonColor = false,
                        ImageTransparency = 1.000
                    }
                )

                --// stfu

                local toggled = library:create(
                    "BoolValue",
                    {
                        Name = 'Enabled',
                        Parent = toggle,
                        Value = false,
                    }
                )


                local title =
                    library:create(
                    "TextLabel",
                    {
                        Parent = toggle,
                        BackgroundTransparency = 1.000,
                        Position = UDim2.new(1.41666663, 0, 0, 0),
                        Size = UDim2.new(0, 200, 0, 24),
                        Font = Enum.Font.RobotoMono,
                        RichText = true,
                        Text = string.format("<smallcaps>%s</smallcaps>", title),
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 15.000,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }
                )

                toggle.MouseButton1Click:Connect(
                    function()
                        toggled.Value = not toggled.Value

                        if (toggled.Value) then
                            toggle.BackgroundColor3 = library.accentColor
                        else
                            toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                )
                
                library:gc(toggle)
                return (toggle)
            end

            return (mainfuncs)
        end

        function sections:addRightSection()
            local rightsection =
                library:create(
                "Frame",
                {
                    Visible = false,
                    Name = "rightsection",
                    Parent = tab,
                    BackgroundTransparency = 1.000,
                    Position = UDim2.new(3.4857142, 0, 1.2352941, 0),
                    Size = UDim2.new(0, 347, 0, 389)
                }
            )
            local rightsorter =
                library:create(
                "UIListLayout",
                {
                    Parent = rightsection,
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Padding = UDim.new(0, 8)
                }
            )

            local mainfuncs = {}

            function mainfuncs:addToggle(title)
                local toggle =
                    library:create(
                    "ImageButton",
                    {
                        Name = title,
                        Parent = rightsection,
                        BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                        BorderColor3 = Color3.fromRGB(0, 0, 0),
                        Position = UDim2.new(-0.0922190323, 0, 0, 0),
                        Size = UDim2.new(0, 24, 0, 24),
                        AutoButtonColor = false,
                        ImageTransparency = 1.000
                    }
                )

                --// stfu

                local toggled = library:create(
                    "BoolValue",
                    {
                        Name = 'Enabled',
                        Parent = toggle,
                        Value = false,
                    }
                )

                local title =
                    library:create(
                    "TextLabel",
                    {
                        Parent = toggle,
                        BackgroundTransparency = 1.000,
                        Position = UDim2.new(1.41666663, 0, 0, 0),
                        Size = UDim2.new(0, 200, 0, 24),
                        Font = Enum.Font.RobotoMono,
                        RichText = true,
                        Text = string.format("<smallcaps>%s</smallcaps>", title),
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        TextSize = 15.000,
                        TextXAlignment = Enum.TextXAlignment.Left
                    }
                )

                toggle.MouseButton1Click:Connect(
                    function()
                        toggled.Value = not toggled.Value

                        if (toggled.Value) then
                            toggle.BackgroundColor3 = Color3.fromRGB(60, 105, 255)
                        else
                            toggle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                        end
                    end
                )

                library:gc(toggle)
                return (toggle)
            end

            return (mainfuncs)
        end

        return (sections)
    end
    
    local toggled = true
    inputservice.InputBegan:Connect(function(Bind)

        if (Bind.KeyCode == library.currentBind) then 
            toggled = not toggled 
            
            if (toggled) then 
                dragging.Visible = true
                print('1')
            else
                dragging.Visible = false
                print('2')
            end
        end
    end)

    library:setDraggable(dragging)
    
    return (funcs)
end

return library
