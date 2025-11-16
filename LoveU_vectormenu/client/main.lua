local PlayerPedId = PlayerPedId
local GetEntityCoords = GetEntityCoords
local GetEntityHeading = GetEntityHeading
local GetGameplayCamCoord = GetGameplayCamCoord
local GetGameplayCamRot = GetGameplayCamRot
local StartShapeTestRay = StartShapeTestRay
local GetShapeTestResult = GetShapeTestResult
local DrawLine = DrawLine
local DrawMarker = DrawMarker
local IsControlJustPressed = IsControlJustPressed

local function round(num, dp)
    local mult = 10 ^ (dp or 0)
    return math.floor(num * mult + 0.5) / mult
end

local function getPlayerData()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)

    return coords.x, coords.y, coords.z, heading
end

local function outputCoords(text)
    if lib and lib.setClipboard then
        lib.setClipboard(text)
        print('^2Copied to clipboard:^7 ' .. text)
    else
        print(text)
    end

    TriggerEvent('chat:addMessage', {
        args = { '^2Coords', text }
    })
end

RegisterCommand('vector3', function()
    local x, y, z = getPlayerData()
    local text = string.format('vector3(%.2f, %.2f, %.2f)', round(x, 2), round(y, 2), round(z, 2))

    outputCoords(text)
end, false)

RegisterCommand('vector4', function()
    local x, y, z, h = getPlayerData()
    local text = string.format('vector4(%.2f, %.2f, %.2f, %.2f)', round(x, 2), round(y, 2), round(z, 2), round(h, 2))

    outputCoords(text)
end, false)

local selecting = false
local selectType = nil
local currentCoords = nil

local function rotationToDirection(rotation)
    local radX = math.rad(rotation.x)
    local radZ = math.rad(rotation.z)
    local cosX = math.cos(radX)
    return vector3(-math.sin(radZ) * cosX, math.cos(radZ) * cosX, math.sin(radX))
end

local function getTargetCoords(distance)
    local camPos = GetGameplayCamCoord()
    local camRot = GetGameplayCamRot(2)
    local direction = rotationToDirection(camRot)
    local destination = camPos + (direction * distance)

    local handle = StartShapeTestRay(
        camPos.x, camPos.y, camPos.z,
        destination.x, destination.y, destination.z,
        -1, -1, 0
    )

    local _, hit, endCoords = GetShapeTestResult(handle)

    if hit == 1 then
        return endCoords
    end

    return destination
end

RegisterCommand('vector', function()
    SetNuiFocus(true, true)
    SendNUIMessage({
        action = 'open'
    })
end, false)

RegisterNUICallback('chooseVector', function(data, cb)
    if data and data.type == 'vector4' then
        selectType = 'vector4'
    else
        selectType = 'vector3'
    end

    selecting = true
    SetNuiFocus(false, false)

    SendNUIMessage({
        action = 'showMini'
    })

    cb('ok')
end)

RegisterNUICallback('closeVector', function(_, cb)
    selecting = false
    selectType = nil
    SetNuiFocus(false, false)

    SendNUIMessage({
        action = 'hideMini'
    })

    cb('ok')
end)

CreateThread(function()
    while true do
        if selecting and selectType then
            local camPos = GetGameplayCamCoord()
            local coords = getTargetCoords(500.0)

            currentCoords = coords

            DrawLine(
                camPos.x, camPos.y, camPos.z,
                coords.x, coords.y, coords.z,
                255, 255, 255, 255
            )

            DrawMarker(
                28,
                coords.x, coords.y, coords.z,
                0.0, 0.0, 0.0,
                0.0, 0.0, 0.0,
                0.1, 0.1, 0.1,
                0, 255, 0, 200,
                false, false, 2, false, nil, nil, false
            )

            if IsControlJustPressed(0, 73) then
                selecting = false
                selectType = nil
                currentCoords = nil

                SendNUIMessage({
                    action = 'hideMini'
                })
            end

            if IsControlJustPressed(0, 74) and currentCoords then
                local x, y, z = currentCoords.x, currentCoords.y, currentCoords.z
                local text

                if selectType == 'vector4' then
                    local heading = GetEntityHeading(PlayerPedId())
                    text = string.format(
                        'vector4(%.2f, %.2f, %.2f, %.2f)',
                        round(x, 2), round(y, 2), round(z, 2), round(heading, 2)
                    )
                else
                    text = string.format(
                        'vector3(%.2f, %.2f, %.2f)',
                        round(x, 2), round(y, 2), round(z, 2)
                    )
                end

                outputCoords(text)

                selecting = false
                selectType = nil
                currentCoords = nil

                SendNUIMessage({
                    action = 'hideMini'
                })
            end
        end

        Wait(0)
    end
end)

