local find = import('utils/find')
local monitors = import('utils/monitors').configured_monitors
local position = import('utils/position')

local function get_window(arrangement_table)
    if arrangement_table.app_title ~= nil then
        return find.window.by_application_title(arrangement_table.app_title)
    end

    if arrangement_table.title ~= nil then
        return find.window.by_title(arrangement_table.app_title)
    end

    error("Arrangement table needs: app_title or title to be set")
end


local function arrange(arrangement)
    fnutils.map(arrangement, function(item)

        local window = get_window(item)
        if window == nil then
            return
        end

        local monitor = item.monitor
        local item_position = item.position

        if monitor == nil then
            error("arrangement table does not have monitor")
        end

        if item_position == nil then
            error("arrangement table does not have position")
        end

        if monitors[monitor] == nil then
            error("monitor " .. monitor .. " does not exist")
        end

        if type(item_position) == "string" then
            window:setframe(position[item_position](monitors[monitor].dimensions))

        elseif type(item_position) == "function" then
            window:setframe(monitors[monitor].dimensions:relative_to(item_position(monitors[monitor].dimensions, {
                monitor = monitors[monitor],
                window = window,
                position = position
            })))

        elseif type(item_position) == "table" then
            window:setframe(monitors[monitor].dimensions:relative_to(item_position))

        else
            error("position cannot be a " .. type(item_position))
        end
    end)
end

local function handle_arrangement(arrangement)
    arrange(arrangement.arrangement)

    if arrangement.alert == true then
        hydra.alert("Arranged monitors with: " .. (arrangement.name or "unnamed arrangement"), 1.0)
    end
end

local function init_module()
    if config.arrangements == nil then
        notify.show("Arrangements has no available configs", "", "Set some configs set in config.arrangements or unload this module", "")
        return
    end

    for _, arrangement in ipairs(config.arrangements) do
        if arrangement.key == nil and arrangement.menu ~= true then
            error("Arrangement is missing a key value, and isn't bound to the menu.")
        end

        if arrangement.key ~= nil then
            hotkey.bind(arrangement.mash or { "cmd", "ctrl", "alt" }, arrangement.key, function()
                handle_arrangement(arrangement)
            end)
        end
    end
end

local function init_menu()
    if config.arrangements == nil then
        return
    end

    local menu = {}

    for _, arrangement in ipairs(config.arrangements) do
        if arrangement.menu == true then
            table.insert(menu, {
                title = "Arrange: " .. arrangement.name,
                fn = function()
                    handle_arrangement(arrangement)
                end
            })
        end
    end

    if #menu > 0 then
        return fnutils.concat(menu, { { title = "-" } })
    else
        return menu
    end
end

return {
    init = init_module,
    menu = init_menu
}