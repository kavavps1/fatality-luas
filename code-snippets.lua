-- all pasted or done by me, i dont give credits because i dont fuckin care this shit is for my digidonger brain and i can't code for shit, who fuckin even reads alldat lol




--
-- delayed call
--

local delayedCalls = {}
local delayed_call = function(time, callback)
    table.insert(delayedCalls, {reqTime = game.global_vars.cur_time + time, callback = callback})
end

events.present_queue:add(function()
    local curTime = game.global_vars.cur_time
    for i, v in ipairs(delayedCalls) do
        if curTime >= v.reqTime then
            v.callback()
            table.remove(delayedCalls, i)
        end
    end
end)

-- usage
delayed_call(0.550, function()
    print("123")
end)







--
-- get sys time
--

ffi.cdef[[
typedef struct _SYSTEMTIME {
    unsigned short wYear;         // Year
    unsigned short wMonth;        // Month (1-12)
    unsigned short wDayOfWeek;    // Day of the week (0 = Sunday, 6 = Saturday)
    unsigned short wDay;          // Day of the month (1-31)
    unsigned short wHour;         // Hour (0-23, UTC or local time)
    unsigned short wMinute;       // Minute (0-59)
    unsigned short wSecond;       // Second (0-59)
    unsigned short wMilliseconds; // Milliseconds (0-999)
} SYSTEMTIME;
]]

-- Find the exported GetSystemTime and GetLocalTime functions in kernel32.dll
local get_system_time_ptr = utils.find_export("kernel32.dll", "GetSystemTime")
local get_local_time_ptr = utils.find_export("kernel32.dll", "GetLocalTime")

-- Cast the function pointers to callable functions
local GetSystemTime = ffi.cast("void(__stdcall*)(struct _SYSTEMTIME*)", get_system_time_ptr)
local GetLocalTime = ffi.cast("void(__stdcall*)(struct _SYSTEMTIME*)", get_local_time_ptr)

-- Create SYSTEMTIME structures for UTC and local time
local utc_time = ffi.new("SYSTEMTIME")
local local_time = ffi.new("SYSTEMTIME")

-- Call GetSystemTime to populate UTC time
GetSystemTime(utc_time)

-- Call GetLocalTime to populate local time
GetLocalTime(local_time)

-- Function to convert SYSTEMTIME to minutes since midnight for easier comparison
local function systemtime_to_minutes(st)
    return (st.wHour * 60) + st.wMinute
end

-- Calculate the offset in minutes
local utc_minutes = systemtime_to_minutes(utc_time)
local local_minutes = systemtime_to_minutes(local_time)

-- Calculate the UTC offset in hours
local utc_offset = (local_minutes - utc_minutes) / 60

-- Handle day wrapping (crossing midnight between UTC and local time)
if utc_offset > 12 then
    utc_offset = utc_offset - 24
elseif utc_offset < -12 then
    utc_offset = utc_offset + 24
end

-- Print the UTC offset
print(string.format("User's UTC Offset: %+d hours", utc_offset))




--
-- some fuckin RCE
--

if not ffi then
    error('Enable "Allow insecure" in menu!')
    return
end

ffi.cdef[[
    typedef const char* LPCSTR;
    typedef unsigned long HANDLE;
    typedef HANDLE HWND;

    HWND GetActiveWindow(void);

    int ShellExecuteA(HWND hwnd, LPCSTR lpOperation, LPCSTR lpFile, LPCSTR lpParameters, LPCSTR lpDirectory, int nShowCmd);
]]

local GetActiveWindowAddress = utils.find_export("user32.dll", "GetActiveWindow")
if GetActiveWindowAddress == 0 then
    print("GetActiveWindow not found")
    return
end

local ShellExecuteAAddress = utils.find_export("shell32.dll", "ShellExecuteA")
if ShellExecuteAAddress == 0 then
    print("ShellExecuteA not found")
    return
end

local GetActiveWindowPtrType = ffi.typeof("HWND (*)(void)")
local ShellExecuteAPtrType = ffi.typeof("int (*)(HWND, LPCSTR, LPCSTR, LPCSTR, LPCSTR, int)")

local GetActiveWindowPtr = ffi.cast(GetActiveWindowPtrType, GetActiveWindowAddress)
if not GetActiveWindowPtr then
    print("not a valid ptr")
    return
end

local ShellExecuteAPtr = ffi.cast(ShellExecuteAPtrType, ShellExecuteAAddress)
if not ShellExecuteAPtr then
    print("not a valid ptr")
    return
end

local ShellExecuteA = function(_hwnd, _operation, _file, _parameters, _directory, _mode)
    local operation = ffi.new("char[?]", string.len(_operation) + 1, _operation)
    local file = ffi.new("char[?]", string.len(_file) + 1, _file)
    local parameters = ffi.new("char[?]", string.len(_parameters) + 1, _parameters)
    local directory = ffi.new("char[?]", string.len(_directory) + 1, _directory)

    return ShellExecuteAPtr(_hwnd, operation, file, parameters, directory, _mode)
end

local result = ShellExecuteA(GetActiveWindowPtr(), "open", "cmd", "/c start notepad", "", 0)

if result <= 32 then
    print("Error: ShellExecuteA failed with code: " .. result)
    return
end




--
-- gradient
--

function draw.color:to_hex()
    return string.format('%02x%02x%02x%02x', self:get_r(), self:get_g(), self:get_b(), self:get_a())
end

local function create_gradient(s, c1, c2, clock, invert)
    local buffer = {}
    local new_colors = {c1 = {r = c1:get_r(), g = c1:get_g(), b = c1:get_b(), a = c1:get_a()}, c2 = {r = c2:get_r(), g = c2:get_g(), b = c2:get_b(), a = c2:get_a()}}
    local len, div, c3 = #s, 1 / (#s - 1), draw.color(new_colors.c2.r - new_colors.c1.r, new_colors.c2.g - new_colors.c1.g, new_colors.c2.b - new_colors.c1.b, new_colors.c2.a - new_colors.c1.a)
    new_colors.c3 = {r = c3:get_r(), g = c3:get_g(), b = c3:get_b(), a = c3:get_a()}

    for i = 1, len do
        local t = (clock % 2 > 1) and (2 - clock % 2) or (clock % 2)
        buffer[i] = string.format("\f%s%s", draw.color(math.floor(new_colors.c1.r + new_colors.c3.r * t), math.floor(new_colors.c1.g + new_colors.c3.g * t), math.floor(new_colors.c1.b + new_colors.c3.b * t), math.floor(new_colors.c1.a + new_colors.c3.a * t)):to_hex(), s:sub(i, i))

        if invert then
            clock = clock - div
        else
            clock = clock + div
        end
    end

    return table.concat(buffer)
end

    local gradient_text = create_gradient(string.format("Azure [%s] | %s", info.version, info.username), draw.color(255, 255, 255, 255), draw.color(255, 255, 255, 10), game.global_vars.real_time, true)





--
-- GUI notification, i dont even know why the fuck im putting it here, what a skid lol xD
--

gui.notify:add(gui.notification("Title", "Text"));

