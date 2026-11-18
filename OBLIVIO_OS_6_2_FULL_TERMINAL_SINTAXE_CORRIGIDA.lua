-- OBLIVIO OS 6.2 FULL / REPAIRED LUA SYNTAX
-- Consolidated 27 modules; existing data and config preserved.
local files={}
files['central.lua']=[====[-- OBLIVIO OS 5.1 / CENTRAL COMMAND
local UI = dofile("lib/ui.lua")
local Net = dofile("lib/net.lua")
local Log = dofile("lib/log.lua")
local Data = dofile("lib/data.lua")
local Control = dofile("lib/control.lua")
local Peripherals = dofile("lib/peripherals.lua")
local Personnel = dofile("lib/personnel.lua")
local Intelligence = dofile("lib/intelli]====] ..
[====[gence.lua")
local Alert = dofile("lib/alert.lua")
local Access = dofile("lib/access.lua")
local Links = dofile("lib/links.lua")
local Report = dofile("lib/report.lua")
local Secure = dofile("lib/secure.lua")
local cfg = dofile("config.lua")
local PocketServer = dofile("lib/pocket_server.lua")

math.randomseed(os.epoch("utc"))
Data.init()
Log.setAct]====] ..
[====[or(nil)
local opened = Net.openAll()
local running = true
local authenticatedNodes = {}
local nodeNonces = {}
local bootClock = os.clock()
local session = { name = "NONE", level = 0 }

local threatColors = { [0] = colors.lime, colors.green, colors.cyan, colors.yellow, colors.orange, colors.red }

----------------------------------------------------]====] ..
[====[------------ helpers
local function note(text, color)
    UI.block({ { text = text, color = color or colors.lightGray } }, 'NOTICE')
end

local function isAuth(sender)
    local expires = authenticatedNodes[sender]
    if expires and os.clock() < expires then
        authenticatedNodes[sender] = os.clock() + 900
        return true
    end
    auth]====] ..
[====[enticatedNodes[sender] = nil
    return false
end

local function uptime()
    local s = math.floor(os.clock() - bootClock)
    return string.format("%02d:%02d:%02d", math.floor(s / 3600), math.floor(s / 60) % 60, s % 60)
end

local function ask(label, default, complete)
    term.setTextColor(colors.lightGray)
    write(label .. (default ~= nil and]====] ..
[====[ (' [' .. tostring(default) .. ']') or '') .. ': ')
    term.setTextColor(colors.white)
    local v = UI.fieldInput(default, complete)
    if v == nil then return default or '' end
    if v == '' and default ~= nil then return default end
    return v
end

-- TAB completion: built-in presets plus values already used in that field.
local function co]====] ..
[====[mpleter(kind, key, presets)
    local values, seen = {}, {}
    local function add(v)
        if type(v) ~= 'string' or v == '' then return end
        local n = v:lower()
        if not seen[n] then seen[n] = true; values[#values + 1] = v end
    end
    for _, v in ipairs(presets or {}) do add(v) end
    local common = {
      department = {'SPEC]====] ..
[====[IAL OPERATIONS','BLACK OPS','HUNTER DIVISION','EXECUTION DIVISION','SEARCH & TERMINATION','SHADOW OPERATIONS','TACTICAL ENFORCEMENT','COMBAT OPERATIONS','TACTICAL RESPONSE','RECONNAISSANCE','INTELLIGENCE','COUNTERINTELLIGENCE','INFILTRATION','SURVEILLANCE','SECURITY','FACILITY SECURITY','CONTAINMENT','DETENTION','INTERROGATION','CAPTURE & RECOVERY']====] ..
[====[,'TARGET ACQUISITION','SEARCH & RESCUE','EXTRACTION','COMMAND','HIGH COMMAND','STRATEGIC OPERATIONS','SCIENCE','RESEARCH','EXPERIMENTAL DIVISION','ADVANCED RESEARCH','MAGIOLOGY','ARCANE RESEARCH','ANOMALOUS STUDIES','BIOENGINEERING','GENETICS','CYBERNETICS','ROBOTICS','ARTIFICIAL INTELLIGENCE','ENGINEERING','MECHANICAL ENGINEERING','SYSTEMS ENGINEE]====] ..
[====[RING','MAINTENANCE','LOGISTICS','SUPPLY','MEDICAL','FIELD MEDICINE','PSYCHOLOGICAL RESEARCH','FORENSICS','CHEMICAL RESEARCH','PHYSICS','ENERGY RESEARCH','ARCHIVES','DATA ANALYSIS','COMMUNICATIONS','DIPLOMACY','EXPLORATION','FIELD RESEARCH','TECHNOLOGY DEVELOPMENT','WEAPONS RESEARCH','RISK ASSESSMENT','INTERNAL AFFAIRS','PERSONNEL','ADMINISTRATION',]====] ..
[====['TRAINING','REPLIKA DEVELOPMENT','REPLIKA OPERATIONS','KORPS INTELLIGENCE'},
      rank = {'EXECUTIONER','HUNTER','TRACKER','FIELD OPERATIVE','BLACK OPS AGENT','SPECIAL OPERATIONS OFFICER','TACTICAL COMMANDER','SQUAD LEADER','COMBAT SPECIALIST','RECON SPECIALIST','INFILTRATOR','INTELLIGENCE OFFICER','INTERROGATOR','DETENTION OFFICER','CAPTURE SPECI]====] ..
[====[ALIST','EXTRACTION SPECIALIST','ASSASSIN','COMMANDER','CO-COMMANDER','DIRECTOR','DEPARTMENT CHIEF','SCIENTIST','LEAD SCIENTIST','RESEARCHER','SENIOR RESEARCHER','MAGIOLOGIST','ARCANE ANALYST','BIOENGINEER','CYBERNETICS ENGINEER','MECHANICAL ENGINEER','ROBOTICS ENGINEER','TECHNICIAN','FIELD MEDIC','MEDICAL OFFICER','FORENSIC ANALYST','DATA ANALYST',]====] ..
[====['SECURITY OFFICER','GUARD','REPLIKA HANDLER','REPLIKA OPERATOR','EXPLORER','NAVIGATOR','LOGISTICS OFFICER','SYSTEM ADMINISTRATOR','ARCHIVIST','RECRUIT'},
      status = {'ACTIVE','INACTIVE','MISSING','SUSPENDED','DECEASED','UNKNOWN','ON MISSION','ON LEAVE','UNDER INVESTIGATION','CLASSIFIED','DETACHED','REASSIGNED','IN TRAINING','INJURED','CAPTURED']====] ..
[====[,'RETIRED','AWAITING ORDERS'},
      clearance = {'1','2','3','4','5'},
      threat = {'0','1','2','3','4','5'},
      classification = {'PUBLIC','RESTRICTED','CONFIDENTIAL','SECRET','TOP SECRET'},
      alignment = {'ALLY','NEUTRAL','HOSTILE','UNKNOWN'},
      korps_branch = {'COMBATENTES','MAGIOLOGOS','EXPLORADORES','MAQUINARIOS'}
    }
    for ]====] ..
[====[_,v in ipairs(common[key] or {}) do add(v) end
    if kind then
        for _, r in ipairs(Data.list(kind)) do add(r[key]) end
    end
    return function(input)
        local out = {}
        local lower = input:lower()
        for _, v in ipairs(values) do
            if v:lower():sub(1, #lower) == lower and #v > #input then out[#out + 1] = v:sub]====] ..
[====[(#input + 1) end
        end
        return out
    end
end

local function recordForm(title, fields, old, kind)

    local rec = {}
    if old then for k, v in pairs(old) do rec[k] = v end end
    for idx, f in ipairs(fields) do
        UI.header((old and 'EDIT ' or 'NEW ') .. title, string.format('FIELD %02d / %02d',idx,#fields))
        term.set]====] ..
[====[CursorPos(3,7)
        term.setTextColor(colors.yellow)
        print(tostring(f[2]):sub(1,math.max(1,select(1,term.getSize())-5)))
        term.setCursorPos(3,9)
        term.setTextColor(colors.white)
        local value
        while true do
            value = UI.fieldInput(old and old[f[1]] or nil, completer(kind, f[1], f[3]))
            loca]====] ..
[====[l n = tonumber(value)
            if f[1] == 'threat' and value ~= '' and (not n or n < 0 or n > 5 or n % 1 ~= 0) then
                term.setTextColor(colors.red); print('THREAT LEVEL MUST BE 0 TO 5')
            else break end
        end
        rec[f[1]] = value
    end
    return rec
end

local function genericView(r, title)
    local list = ]====] ..
[====[{}
    for k in pairs(r) do if k ~= 'name' then list[#list + 1] = k end end
    table.sort(list)
    local lines = { { text = tostring(r.name or r.codename or 'UNNAMED'), color = UI.accent() } }
    for _, k in ipairs(list) do
        local v = r[k]
        if type(v) == 'table' then v = textutils.serialize(v):gsub('%s+', ' ') end
        lines[#li]====] ..
[====[nes + 1] = { text = tostring(k):upper():gsub('_', ' ') .. ': ' .. tostring(v) }
    end
    UI.block(lines, title or 'FILE VIEWER')
end

---------------------------------------------------------------- authentication
local function authenticateLocal()
    for attempt = 1, 3 do
        UI.header("CENTRAL AUTHENTICATION", "ATTEMPT " .. attempt .. " /]====] ..
[====[ 3")
        term.setCursorPos(2, 7)
        term.setTextColor(colors.gray)
        term.write("ACCESS CODE: ")
        term.setTextColor(colors.white)
        local pin = read("*")
        if cfg.pin ~= nil and pin == tostring(cfg.pin) then
            session = { name = "ADMIN", level = 5 }
        else
            local op = Access.identify(pin)]====] ..
[====[
            if op then session = op end
        end
        if session.level > 0 then
            Log.setActor(session.name)
            Log.write("AUTH", "Local login: " .. session.name .. " (L" .. session.level .. ")")
            return true
        end
        Log.write("AUTH", "Local authentication failure (" .. attempt .. "/3)")
        term]====] ..
[====[.setCursorPos(2, 9)
        term.setTextColor(colors.red)
        term.write("ACCESS DENIED")
        sleep(attempt)
    end
    Log.write("AUTH", "Local authentication lockout")
    return false
end

---------------------------------------------------------------- system screens
local function status()
    local sensors = Control.readSensors(cfg.s]====] ..
[====[ensors or {})
    local outputs = Control.outputStatus(cfg.outputs or {})
    local _, info = Alert.info()
    local lines = {
        { text = 'CORE: ONLINE  |  UPTIME ' .. uptime(), color = colors.lime },
        { text = Alert.label(), color = info.color },
        { text = 'OPERATOR: ' .. session.name .. '  (L' .. session.level .. ' ' .. tostri]====] ..
[====[ng(Access.levels[session.level]) .. ')' },
        { text = 'COMPUTER ID: ' .. os.getComputerID() .. '  LABEL: ' .. tostring(os.getComputerLabel() or 'UNNAMED') },
        { text = 'REDNET MODEMS: ' .. #opened .. '  PERIPHERALS: ' .. #peripheral.getNames() },
        { text = 'FREE DISK: ' .. tostring(fs.getFreeSpace('/')) .. ' BYTES' },
        { ]====] ..
[====[text = 'PROJECTS: ' .. Data.count('projects') .. '  EXPERIMENTS: ' .. Data.count('experiments') },
        { text = 'MISSIONS: ' .. Data.count('missions') .. '  PERSONNEL: ' .. Data.count('personnel') },
        { text = 'OUTPUT STATES', color = UI.accent() }
    }
    local names = {}
    for name in pairs(outputs) do names[#names + 1] = name end
]====] ..
[====[    table.sort(names)
    for _, name in ipairs(names) do
        local state = outputs[name]
        lines[#lines + 1] = { text = name .. ': ' .. (state and 'ON' or 'OFF'), color = state and colors.lime or colors.gray }
    end
    lines[#lines + 1] = { text = 'SENSOR STATES', color = UI.accent() }
    names = {}
    for name in pairs(sensors) do ]====] ..
[====[names[#names + 1] = name end
    table.sort(names)
    for _, name in ipairs(names) do
        local state = sensors[name]
        lines[#lines + 1] = { text = name .. ': ' .. (state and 'TRIGGERED' or 'CLEAR'), color = state and colors.red or colors.lime }
    end
    UI.block(lines, 'SYSTEM STATUS')
end

local function outputMenu()
    local name]====] ..
[====[s = {}
    for name in pairs(cfg.outputs or {}) do names[#names + 1] = name end
    table.sort(names)
    if #names == 0 then
        note('NO OUTPUTS CONFIGURED', colors.gray)
        return
    end
    while true do
        local states = Control.outputStatus(cfg.outputs or {})
        local labels = {}
        for i, name in ipairs(names) do
   ]====] ..
[====[         local item = cfg.outputs[name]
            local tag = (item and item.mode == 'pulse') and 'PULSE' or (states[name] and 'ON' or 'OFF')
            labels[i] = name .. '  [' .. tag .. ']'
        end
        local choice = UI.menu("INFRASTRUCTURE / OUTPUT CONTROL", labels)
        if not choice then return end
        local _, msg = Control]====] ..
[====[.toggle(cfg.outputs, names[choice])
        Log.write("CONTROL", msg)
    end
end

local function sensorsMenu()
    local lines = {}
    local sensors = Control.readSensors(cfg.sensors or {})
    local names = {}
    for name in pairs(sensors) do names[#names + 1] = name end
    table.sort(names)
    for _, name in ipairs(names) do
        local st]====] ..
[====[ate = sensors[name]
        lines[#lines + 1] = { text = name .. ' : ' .. (state and 'TRIGGERED' or 'CLEAR'), color = state and colors.red or colors.lime }
    end
    if #lines == 0 then lines[1] = { text = 'NO SENSORS CONFIGURED' } end
    UI.block(lines, 'SECURITY & SENSORS')
end

local function defconMenu()
    while true do
        local level]====] ..
[====[, info, by, at = Alert.info()
        local options = {}
        for lv = 5, 1, -1 do
            options[#options + 1] = 'DEFCON ' .. lv .. ' / ' .. Alert.levels()[lv].name .. (lv == level and '   <ACTIVE>' or '')
        end
        options[#options + 1] = 'RETURN'
        local title = 'DEFCON ' .. level .. ' ' .. info.name .. (at and ('  |  ' .]====] ..
[====[. tostring(by) .. ' ' .. tostring(at):sub(12)) or '')
        local n = UI.menu(title, options)
        if not n or n == #options then return end
        local lv = 6 - n
        if lv ~= level then
            local go = true
            if lv == 1 then go = UI.confirm('ENGAGE DEFCON 1? LOCKDOWN OUTPUTS WILL ACTIVATE', 'MAXIMUM ALERT') end
       ]====] ..
[====[     if go then Alert.change(lv, session.name) end
        end
    end
end

local function inventoryMenu()
    local inventories = Peripherals.inventories()
    local lines = {}
    if #inventories == 0 then lines[1] = { text = 'NO COMPATIBLE INVENTORIES' } end
    for _, inv in ipairs(inventories) do lines[#lines + 1] = { text = inv.name .. ' | IT]====] ..
[====[EMS: ' .. inv.itemCount } end
    UI.block(lines, 'LOGISTICS / STORAGE')
end

local function devicesMenu()
    local devices = Peripherals.list()
    local lines = {}
    for _, d in ipairs(devices) do lines[#lines + 1] = { text = d.name .. ' | ' .. d.type } end
    if #lines == 0 then lines[1] = { text = 'NO DEVICES FOUND' } end
    UI.block(lines]====] ..
[====[, 'DEVICE REGISTRY')
end

---------------------------------------------------------------- projects / experiments
local statusPresets = { 'PLANNING', 'ACTIVE', 'ON HOLD', 'COMPLETE', 'CANCELLED' }
local classPresets = { 'PUBLIC', 'RESTRICTED', 'CONFIDENTIAL', 'SECRET', 'TOP SECRET' }
local projectFields = {
    { 'name', 'NAME' }, { 'classification]====] ..
[====[', 'CLASSIFICATION', classPresets },
    { 'description', 'DESCRIPTION' }, { 'status', 'STATUS', statusPresets }
}

local function recordView(title, r)
    UI.block({
        { text = tostring(r.name or 'UNNAMED'), color = UI.accent() },
        { text = 'ID: ' .. tostring(r.id) },
        { text = 'CLASSIFICATION: ' .. tostring(r.classification or]====] ..
[====[ '-') },
        { text = 'DESCRIPTION: ' .. tostring(r.description or '-') },
        { text = 'STATUS: ' .. tostring(r.status or '-') },
        { text = 'OWNER: ' .. tostring(r.owner or '-') },
        { text = 'CREATED: ' .. tostring(r.created or '-') },
        { text = 'UPDATED: ' .. tostring(r.updated or '-') }
    }, title .. ' / RECORD')
e]====] ..
[====[nd

local function confirmDelete(r)
    UI.header('DELETE / CONFIRMATION')
    term.setCursorPos(1, 6)
    print('Delete ' .. tostring(r.name or r.codename) .. '?')
    print('The file is moved to data/archives (recoverable).')
    write('Type DELETE: ')
    return read() == 'DELETE'
end

local function projectActions(kind, title, r)
    while r do]====] ..
[====[
        local n = UI.menu(title .. ' / ' .. tostring(r.name or 'UNNAMED'),
            { 'VIEW RECORD', 'EDIT RECORD', 'DELETE RECORD', 'RETURN' })
        if not n or n == 4 then return end
        if n == 1 then
            recordView(title, r)
        elseif n == 2 then
            local new = recordForm(title, projectFields, r, kind)
         ]====] ..
[====[   if tostring(new.name or ''):match('^%s*$') then
                note('NAME IS REQUIRED', colors.red)
            elseif Data.update(kind, r.id, new) then
                r = Data.read(kind, r.id) or r
                note('RECORD UPDATED', colors.lime)
            else
                note('SAVE FAILED', colors.red)
            end
        elsei]====] ..
[====[f n == 3 then
            if confirmDelete(r) then
                if Data.delete(kind, r.id) then
                    note('RECORD DELETED', colors.lime)
                    return
                end
                note('DELETE FAILED', colors.red)
            end
        end
    end
end

local function projectMenu(kind, title)
    while true do]====] ..
[====[
        local choice = UI.menu(title, { 'REGISTER NEW RECORD', 'LIST / OPEN RECORDS', 'RETURN' })
        if not choice or choice == 3 then return end
        if choice == 1 then
            local rec = recordForm(title, projectFields, nil, kind)
            if tostring(rec.name or ''):match('^%s*$') then
                note('NAME IS REQUIRED', c]====] ..
[====[olors.red)
            else
                rec.owner = session.name
                local ok, id = Data.create(kind, rec)
                note(ok and ('RECORD CREATED: ' .. tostring(id)) or 'SAVE FAILED', ok and colors.lime or colors.red)
            end
        else
            while true do
                local records = Data.list(kind)
       ]====] ..
[====[         if #records == 0 then note('NO RECORDS FOUND', colors.gray); break end
                local options = {}
                for _, r in ipairs(records) do
                    options[#options + 1] = tostring(r.name or 'UNNAMED') .. ' [' .. tostring(r.status or '-') .. ']'
                end
                local selected = UI.menu(title .. ]====] ..
[====[' / ' .. #records .. ' RECORDS', options)
                if not selected then break end
                projectActions(kind, title, records[selected])
            end
        end
    end
end

---------------------------------------------------------------- missions
local missionStatus = { 'PLANNED', 'ACTIVE', 'ON HOLD', 'COMPLETE', 'FAILED', 'ABOR]====] ..
[====[TED' }
local missionFields = {
    { 'name', 'MISSION NAME' }, { 'objective', 'OBJECTIVE' }, { 'location', 'AREA / LOCATION' },
    { 'commander', 'COMMANDER' }, { 'threat', 'THREAT LEVEL (0-5)' },
    { 'status', 'STATUS', missionStatus }, { 'briefing', 'BRIEFING' }
}

local function splitTeam(text)
    local out = {}
    for part in tostring(text]====] ..
[====[ or ''):gmatch('[^,]+') do
        local t = part:gsub('^%s+', ''):gsub('%s+$', '')
        if t ~= '' then out[#out + 1] = t end
    end
    return out
end

local function assignTeam(m)
    while true do
        local team = splitTeam(m.team)
        local inTeam = {}
        for _, n in ipairs(team) do inTeam[n] = true end
        local people = ]====] ..
[====[Data.list('personnel')
        if #people == 0 then note('NO PERSONNEL REGISTERED', colors.gray); return m end
        local options = {}
        for _, p in ipairs(people) do
            options[#options + 1] = (inTeam[tostring(p.name)] and '[X] ' or '[ ] ') .. tostring(p.name)
        end
        options[#options + 1] = 'DONE'
        local n = U]====] ..
[====[I.menu('ASSIGN TEAM / ' .. #team .. ' ASSIGNED', options)
        if not n or n == #options then return m end
        local name = tostring(people[n].name)
        local newTeam = {}
        if inTeam[name] then
            for _, t in ipairs(team) do if t ~= name then newTeam[#newTeam + 1] = t end end
        else
            newTeam = team
      ]====] ..
[====[      newTeam[#newTeam + 1] = name
        end
        m.team = table.concat(newTeam, ', ')
        if Data.update('missions', m.id, m) then m = Data.read('missions', m.id) or m end
    end
end

local function missionView(r)
    local lv = tonumber(r.threat)
    UI.block({
        { text = '[ MSN / OPERATION ]', color = UI.accent() },
        { tex]====] ..
[====[t = tostring(r.name or 'UNNAMED'), color = colors.white },
        { text = 'STATUS: ' .. tostring(r.status or 'PLANNED'), color = colors.yellow },
        { text = 'THREAT: ' .. tostring(r.threat or '-'), color = lv and threatColors[lv] or colors.gray },
        { text = 'OBJECTIVE: ' .. tostring(r.objective or '-') },
        { text = 'LOCATION: ]====] ..
[====[' .. tostring(r.location or '-') },
        { text = 'COMMANDER: ' .. tostring(r.commander or '-') },
        { text = 'TEAM: ' .. ((r.team and r.team ~= '') and r.team or 'NOT ASSIGNED') },
        { text = 'BRIEFING: ' .. tostring(r.briefing or '-') },
        { text = 'AFTER-ACTION: ' .. ((r.aar and r.aar ~= '') and r.aar or 'PENDING'), color = ]====] ..
[====[colors.lightGray },
        { text = 'ID: ' .. tostring(r.id) .. '  UPDATED: ' .. tostring(r.updated or '-'), color = colors.gray }
    }, 'MISSION FILE')
end

local function missionActions(r)
    while r do
        local n = UI.menu('MISSION / ' .. tostring(r.name or 'UNNAMED'),
            { 'VIEW FILE', 'EDIT FILE', 'SET STATUS', 'ASSIGN TEAM', ]====] ..
[====['AFTER-ACTION REPORT', 'DELETE', 'RETURN' })
        if not n or n == 7 then return end
        if n == 1 then missionView(r)
        elseif n == 2 then
            local new = recordForm('MISSION', missionFields, r, 'missions')
            if tostring(new.name or ''):match('^%s*$') then note('NAME IS REQUIRED', colors.red)
            elseif Data.]====] ..
[====[update('missions', r.id, new) then r = Data.read('missions', r.id) or r; note('MISSION UPDATED', colors.lime)
            else note('SAVE FAILED', colors.red) end
        elseif n == 3 then
            local opts = {}
            for _, s in ipairs(missionStatus) do opts[#opts + 1] = s end
            opts[#opts + 1] = 'CANCEL'
            local s ]====] ..
[====[= UI.menu('SET STATUS / CURRENT: ' .. tostring(r.status or 'PLANNED'), opts)
            if s and s <= #missionStatus then
                r.status = missionStatus[s]
                if Data.update('missions', r.id, r) then
                    r = Data.read('missions', r.id) or r
                    Alert.announce('MISSION', 'MISSION ' .. tostring(]====] ..
[====[r.name) .. ': ' .. tostring(r.status))
                end
            end
        elseif n == 4 then r = assignTeam(r)
        elseif n == 5 then
            UI.header('AFTER-ACTION REPORT')
            term.setCursorPos(1, 6)
            local text = ask('REPORT', r.aar)
            r.aar = text
            if Data.update('missions', r.id, r) the]====] ..
[====[n r = Data.read('missions', r.id) or r; note('REPORT SAVED', colors.lime)
            else note('SAVE FAILED', colors.red) end
        elseif n == 6 then
            if confirmDelete(r) and Data.delete('missions', r.id) then note('MISSION DELETED', colors.lime); return end
        end
    end
end

local function missionMenu()
    while true do
    ]====] ..
[====[    local choice = UI.menu('OPERATIONS / MISSIONS', { 'REGISTER NEW MISSION', 'LIST / OPEN MISSIONS', 'RETURN' })
        if not choice or choice == 3 then return end
        if choice == 1 then
            local rec = recordForm('MISSION', missionFields, nil, 'missions')
            if tostring(rec.name or ''):match('^%s*$') then note('NAME IS REQ]====] ..
[====[UIRED', colors.red)
            else
                if rec.status == '' then rec.status = 'PLANNED' end
                rec.team = ''
                local ok, id = Data.create('missions', rec)
                note(ok and ('MISSION CREATED: ' .. tostring(id)) or 'SAVE FAILED', ok and colors.lime or colors.red)
            end
        else
        ]====] ..
[====[    while true do
                local records = Data.list('missions')
                if #records == 0 then note('NO MISSIONS REGISTERED', colors.gray); break end
                local options = {}
                for _, r in ipairs(records) do
                    options[#options + 1] = tostring(r.name or 'UNNAMED') .. ' [' .. tostring(r.status ]====] ..
[====[or 'PLANNED') .. ']'
                end
                local selected = UI.menu('MISSIONS / ' .. #records, options)
                if not selected then break end
                missionActions(records[selected])
            end
        end
    end
end

---------------------------------------------------------------- relations, search, timeline
l]====] ..
[====[ocal allKinds = { 'projects', 'experiments', 'missions', 'personnel', 'replikas', 'threats', 'incidents', 'korps', 'korps_scientists' }
local classifiedKinds = { replikas = true, threats = true, incidents = true, korps = true, korps_scientists = true }

local function unlockClassified()
    if Intelligence.unlock then return Intelligence.unlock() a]====] ..
[====[nd true or false end
    return false
end

local function recordName(r) return tostring(r.name or r.codename or 'UNNAMED') end

-- Prompt a query and let the operator pick one record. Returns kind, record.
local function pickRecord(kinds, title)
    UI.header(title or 'SELECT FILE')
    term.setCursorPos(3, 6)
    term.setTextColor(colors.yellow)
 ]====] ..
[====[   write('SEARCH (blank = all, :back = cancel): ')
    term.setTextColor(colors.white)
    local q = read()
    if q:lower() == ':back' then return nil end
    local results = Data.search(q, kinds)
    if #results == 0 then note('NO MATCHES', colors.gray); return nil end
    local options = {}
    for _, x in ipairs(results) do
        options[#opt]====] ..
[====[ions + 1] = '[' .. Data.code(x.kind) .. '] ' .. recordName(x.record)
    end
    local n = UI.menu((title or 'SELECT FILE') .. ' / ' .. #results, options)
    if not n then return nil end
    return results[n].kind, results[n].record
end

local linkLabels = { 'MEMBER OF', 'LEADS', 'ALLY OF', 'ENEMY OF', 'CREATED BY', 'LOCATED AT', 'INVOLVED IN', 'T]====] ..
[====[ARGET OF', 'ASSIGNED TO', 'RELATED' }

local function recordLinks(kind, rec, kinds)
    while true do
        local links = Links.forRecord(kind, rec.id)
        local options = {}
        for _, l in ipairs(links) do
            local target = Data.read(l.kind, l.id)
            options[#options + 1] = l.dir .. ' ' .. tostring(l.label) .. ': [' ..]====] ..
[====[ Data.code(l.kind) .. '] ' ..
                (target and recordName(target) or 'MISSING FILE')
        end
        options[#options + 1] = '[ ADD LINK ]'
        options[#options + 1] = '[ VIEW THIS FILE ]'
        options[#options + 1] = 'RETURN'
        local n = UI.menu('RELATIONS / [' .. Data.code(kind) .. '] ' .. recordName(rec), options)
   ]====] ..
[====[     if not n or n == #options then return end
        if n == #options - 1 then
            genericView(rec, 'FILE VIEWER')
        elseif n == #options - 2 then
            local tk, tr = pickRecord(kinds, 'LINK TARGET')
            if tk then
                UI.header('LINK LABEL')
                term.setCursorPos(1, 6)
                local la]====] ..
[====[bel = ask('RELATION (TAB COMPLETES)', nil, completer(nil, nil, linkLabels)):upper()
                local ok, err = Links.add(kind, rec.id, tk, tr.id, label)
                if ok then Log.write('AUDIT', 'LINK ' .. kind .. ' ' .. rec.id .. ' -> ' .. tk .. ' ' .. tr.id) end
                note(ok and 'LINK CREATED' or tostring(err or 'SAVE FAILED')]====] ..
[====[, ok and colors.lime or colors.red)
            end
        else
            local l = links[n]
            local sub = UI.menu('LINK / ' .. tostring(l.label), { 'OPEN LINKED FILE', 'REMOVE LINK', 'RETURN' })
            if sub == 1 then
                local target = Data.read(l.kind, l.id)
                if target then genericView(target) else n]====] ..
[====[ote('FILE NO LONGER EXISTS', colors.red) end
            elseif sub == 2 then
                if Links.remove(l.index) then Log.write('AUDIT', 'UNLINK ' .. kind .. ' ' .. rec.id) end
            end
        end
    end
end

local function relationMap()
    if not unlockClassified() then return end
    local kind, rec = pickRecord(allKinds, 'RELATIO]====] ..
[====[N MAP')
    if kind then recordLinks(kind, rec, allKinds) end
end

local function globalSearch()
    local classified = unlockClassified()
    local kinds = { 'projects', 'experiments', 'missions', 'personnel' }
    if classified then
        for _, k in ipairs({ 'replikas', 'threats', 'incidents', 'korps', 'korps_scientists' }) do kinds[#kinds + 1]====] ..
[====[] = k end
    end
    UI.header('GLOBAL SEARCH')
    term.setCursorPos(3, 6)
    term.setTextColor(colors.lightGray)
    write('Searches names, status, location, notes, IDs...')
    term.setCursorPos(3, 8)
    term.setTextColor(colors.yellow)
    write('QUERY (blank = cancel): ')
    term.setTextColor(colors.white)
    local q = read()
    if q == ]====] ..
[====['' then return end
    Log.write('SEARCH', 'Global search' .. (classified and ' (classified)' or ''))
    local results = Data.search(q, kinds)
    if #results == 0 then
        note('NO MATCHES' .. (classified and '' or ' (CLASSIFIED ARCHIVES NOT SEARCHED)'), colors.gray)
        return
    end
    local sortModes = { 'NAME', 'THREAT', 'TYPE' }
  ]====] ..
[====[  local mode = 1
    while true do
        table.sort(results, function(a, b)
            if mode == 2 then
                local x, y = tonumber(a.record.threat) or -1, tonumber(b.record.threat) or -1
                if x ~= y then return x > y end
            elseif mode == 3 then
                if a.kind ~= b.kind then return a.kind < b.kind en]====] ..
[====[d
            end
            return recordName(a.record):lower() < recordName(b.record):lower()
        end)
        local options = {}
        for _, x in ipairs(results) do
            local lv = tonumber(x.record.threat)
            options[#options + 1] = '[' .. Data.code(x.kind) .. '] ' .. recordName(x.record) .. (lv and ('  LV' .. lv) or '')]====] ..
[====[
        end
        options[#options + 1] = '[ SORT: ' .. sortModes[mode] .. ' ]'
        local n = UI.menu('GLOBAL SEARCH / ' .. #results .. ' MATCHES', options)
        if not n then return end
        if n == #options then
            mode = mode % #sortModes + 1
        else
            local x = results[n]
            local sub = UI.menu(reco]====] ..
[====[rdName(x.record), { 'VIEW FILE', 'RELATIONS', 'RETURN' })
            if sub == 1 then genericView(x.record)
            elseif sub == 2 and (classified or not classifiedKinds[x.kind]) then recordLinks(x.kind, x.record, kinds) end
        end
    end
end

local function incidentTimeline()
    if not unlockClassified() then return end
    local filt]====] ..
[====[ers = { { 'ALL INCIDENTS', 0 }, { 'THREAT 3 OR HIGHER', 3 }, { 'THREAT 4 OR HIGHER', 4 }, { 'CRITICAL ONLY (5)', 5 } }
    while true do
        local labels = {}
        for i, f in ipairs(filters) do labels[i] = f[1] end
        labels[#labels + 1] = 'RETURN'
        local n = UI.menu('INCIDENT TIMELINE / FILTER', labels)
        if not n or n ==]====] ..
[====[ #labels then return end
        local minimum = filters[n][2]
        local list = {}
        for _, r in ipairs(Data.list('incidents')) do
            if (tonumber(r.threat) or 0) >= minimum then list[#list + 1] = r end
        end
        table.sort(list, function(a, b)
            return tostring(a.event_time or a.created or '') > tostring(b.ev]====] ..
[====[ent_time or b.created or '')
        end)
        local lines = {}
        for _, r in ipairs(list) do
            local lv = tonumber(r.threat) or 0
            lines[#lines + 1] = { text = tostring(r.event_time or r.created or '?') .. '  LV' .. lv .. '  ' .. recordName(r), color = threatColors[math.max(0, math.min(5, lv))] }
            lines[#li]====] ..
[====[nes + 1] = { text = '   ' .. tostring(r.location or '-') .. ' | ' .. tostring(r.status or '-'), color = colors.gray }
        end
        if #lines == 0 then lines[1] = { text = 'NO INCIDENTS MATCH', color = colors.gray } end
        UI.block(lines, 'INCIDENT TIMELINE (NEWEST FIRST)')
    end
end

---------------------------------------------------]====] ..
[====[------------- briefing
local function briefingMenu()
    while true do
        local n = UI.menu('BRIEFING / REPORTS', { 'VIEW DAILY BRIEFING', 'PRINT BRIEFING', 'SAVE TO ARCHIVES', 'RETURN' })
        if not n or n == 4 then return end
        local lines = Report.build(cfg)
        if n == 1 then UI.block(lines, 'DAILY BRIEFING')
        elseif n]====] ..
[====[ == 2 then
            local ok, msg = Report.print(Report.plain(lines), 'OBLIVIO BRIEFING')
            Log.write('REPORT', 'Briefing print: ' .. tostring(msg))
            note(msg, ok and colors.lime or colors.red)
        elseif n == 3 then
            local path = Report.save(Report.plain(lines))
            Log.write('REPORT', 'Briefing saved]====] ..
[====[')
            note(path and ('SAVED: ' .. path) or 'SAVE FAILED', path and colors.lime or colors.red)
        end
    end
end

---------------------------------------------------------------- log viewer
local logFilters = {
    { 'ALL EVENTS', nil },
    { 'SECURITY / AUTHENTICATION', { AUTH = true, NETWORK_AUTH = true, MOBILE_AUTH = true, VAULT =]====] ..
[====[ true } },
    { 'SENSORS / ALERTS / LOCKDOWN', { SENSOR = true, DEFCON = true, LOCKDOWN = true } },
    { 'INFRASTRUCTURE CONTROL', { CONTROL = true, REMOTE_CONTROL = true, MOBILE_CONTROL = true } },
    { 'AUDIT TRAIL (WHO CHANGED WHAT)', { AUDIT = true, MOBILE_WRITE = true, DATABASE = true, INTEL = true, PERSONNEL = true, ADMIN = true } },
    {]====] ..
[====[ 'CHAIN OF CUSTODY (FILE ACCESS)', { CUSTODY = true, SEARCH = true } }
}

local function logsMenu()
    while true do
        local labels = {}
        for i, f in ipairs(logFilters) do labels[i] = f[1] end
        labels[#labels + 1] = 'RETURN'
        local n = UI.menu('EVENT LOG / AUDIT', labels)
        if not n or n == #labels then return end
]====] ..
[====[        local filter = logFilters[n][2]
        local entries = Log.readLast(500)
        local lines = {}
        for i = #entries, 1, -1 do
            local cat = entries[i]:match('^%S+ %S+ | (%S+) |')
            if not filter or (cat and filter[cat]) then
                local color = colors.lightGray
                if cat == 'SENSOR' or cat ]====] ..
[====[== 'DEFCON' or cat == 'LOCKDOWN' then color = colors.orange
                elseif cat == 'AUTH' or cat == 'MOBILE_AUTH' or cat == 'NETWORK_AUTH' then color = colors.yellow
                elseif cat == 'CUSTODY' or cat == 'AUDIT' then color = colors.cyan end
                lines[#lines + 1] = { text = entries[i]:sub(12), color = color }
         ]====] ..
[====[       if #lines >= 60 then break end
            end
        end
        if #lines == 0 then lines[1] = { text = 'NO EVENTS FOUND', color = colors.gray } end
        UI.block(lines, labels[n] .. ' (NEWEST FIRST)')
    end
end

---------------------------------------------------------------- administration
local function operatorMenu()
    while tr]====] ..
[====[ue do
        local ops = Access.list()
        local options = {}
        for _, o in ipairs(ops) do options[#options + 1] = o.name .. '  [L' .. o.level .. ' ' .. Access.levels[o.level] .. ']' end
        options[#options + 1] = '[ ADD OPERATOR ]'
        options[#options + 1] = 'RETURN'
        local n = UI.menu('OPERATORS / ' .. #ops .. ' REGIST]====] ..
[====[ERED', options)
        if not n or n == #options then return end
        if n == #options - 1 then
            UI.header('NEW OPERATOR')
            term.setCursorPos(1, 6)
            local name = ask('CALLSIGN (A-Z, 0-9)')
            term.setTextColor(colors.lightGray); write('ACCESS CODE (4+): ')
            term.setTextColor(colors.white); lo]====] ..
[====[cal pin = read('*')
            term.setTextColor(colors.lightGray); write('CONFIRM CODE: ')
            term.setTextColor(colors.white); local pin2 = read('*')
            if pin ~= pin2 then
                note('CODES DO NOT MATCH', colors.red)
            else
                local lv = UI.menu('CLEARANCE LEVEL', { 'L1 RECRUIT', 'L2 RESEARCHER']====] ..
[====[, 'L3 SECURITY', 'L4 COMMAND', 'CANCEL' })
                if lv and lv <= 4 then
                    local ok, err = Access.add(name, pin, lv, tostring(cfg.pin))
                    if ok then Log.write('ADMIN', 'Operator registered: ' .. tostring(name):upper() .. ' L' .. lv) end
                    note(ok and 'OPERATOR REGISTERED' or tostring(er]====] ..
[====[r or 'FAILED'), ok and colors.lime or colors.red)
                end
            end
        else
            local op = ops[n]
            local sub = UI.menu('OPERATOR / ' .. op.name, { 'CHANGE CLEARANCE', 'RESET ACCESS CODE', 'REMOVE OPERATOR', 'RETURN' })
            if sub == 1 then
                local lv = UI.menu('NEW CLEARANCE FOR ' .. o]====] ..
[====[p.name, { 'L1 RECRUIT', 'L2 RESEARCHER', 'L3 SECURITY', 'L4 COMMAND', 'CANCEL' })
                if lv and lv <= 4 and Access.setLevel(op.name, lv) then
                    Log.write('ADMIN', 'Clearance of ' .. op.name .. ' set to L' .. lv)
                    note('CLEARANCE UPDATED', colors.lime)
                end
            elseif sub == 2 t]====] ..
[====[hen
                UI.header('RESET ACCESS CODE')
                term.setCursorPos(1, 6)
                term.setTextColor(colors.lightGray); write('NEW CODE (4+): ')
                term.setTextColor(colors.white); local pin = read('*')
                local ok, err = Access.setPin(op.name, pin, tostring(cfg.pin))
                if ok then Log.]====] ..
[====[write('ADMIN', 'Access code reset for ' .. op.name) end
                note(ok and 'CODE UPDATED' or tostring(err or 'FAILED'), ok and colors.lime or colors.red)
            elseif sub == 3 then
                if UI.confirm('REMOVE OPERATOR ' .. op.name .. '?') and Access.remove(op.name) then
                    Log.write('ADMIN', 'Operator remov]====] ..
[====[ed: ' .. op.name)
                    note('OPERATOR REMOVED', colors.lime)
                end
            end
        end
    end
end

local function trashMenu()
    while true do
        local items = Data.trash()
        if #items == 0 then note('TRASH IS EMPTY', colors.gray); return end
        local options = {}
        for _, t in ipairs(ite]====] ..
[====[ms) do options[#options + 1] = '[' .. Data.code(t.kind) .. '] ' .. t.name end
        local n = UI.menu('TRASH RECOVERY / ' .. #items .. ' FILES', options)
        if not n then return end
        local t = items[n]
        local sub = UI.menu(t.name, { 'RESTORE FILE', 'DELETE PERMANENTLY', 'RETURN' })
        if sub == 1 then
            local ok ]====] ..
[====[= Data.restore(t.kind, t.id)
            note(ok and 'FILE RESTORED' or 'RESTORE FAILED (ID IN USE?)', ok and colors.lime or colors.red)
        elseif sub == 2 then
            if UI.confirm('PERMANENTLY DELETE ' .. t.name .. '?') then
                Data.purge(t.kind, t.id)
                note('FILE PURGED', colors.lime)
            end
       ]====] ..
[====[ end
    end
end

local function exportImportMenu()
    while true do
        local n = UI.menu('EXPORT / IMPORT', { 'EXPORT A CATEGORY', 'IMPORT EXPORT FILE', 'RETURN' })
        if not n or n == 3 then return end
        if n == 1 then
            local labels = {}
            for i, k in ipairs(allKinds) do labels[i] = k:upper() .. ' (' .. Data.]====] ..
[====[count(k) .. ')' end
            labels[#labels + 1] = 'CANCEL'
            local k = UI.menu('EXPORT CATEGORY', labels)
            if k and k <= #allKinds then
                local path, count = Data.export(allKinds[k])
                note(path and (count .. ' RECORDS -> ' .. path .. '  (NOT ENCRYPTED)') or 'EXPORT FAILED', path and colors.lime ]====] ..
[====[or colors.red)
            end
        else
            local files = Data.exports()
            if #files == 0 then note('NO EXPORT FILES IN data/archives', colors.gray)
            else
                local labels = {}
                for i, f in ipairs(files) do labels[i] = f:gsub('^data/archives/', '') end
                labels[#labels + 1] =]====] ..
[====[ 'CANCEL'
                local k = UI.menu('IMPORT FILE', labels)
                if k and k <= #files and UI.confirm('IMPORT AS NEW RECORDS?') then
                    local count, kind = Data.import(files[k])
                    note(count and (count .. ' RECORDS IMPORTED INTO ' .. tostring(kind):upper()) or tostring(kind), count and colors.lime]====] ..
[====[ or colors.red)
                end
            end
        end
    end
end

local function backupRun()
    if not fs.exists('oblivio_backup_manager.lua') then
        note('oblivio_backup_manager.lua NOT FOUND', colors.red)
        return
    end
    Log.write('ADMIN', 'Backup manager opened')
    shell.run('oblivio_backup_manager.lua')
end

local]====] ..
[====[ function helpScreen()
    UI.block({
        { text = 'NAVIGATION', color = UI.accent() },
        { text = 'W/S or arrows move. ENTER/SPACE selects.' },
        { text = 'Type a number + ENTER to jump. Q/ESC goes back.' },
        { text = 'In forms: TAB shows options; F2 selects BACK/EXIT.' },
        { text = ' ' },
        { text = 'CLEARANCE ]====] ..
[====[LEVELS', color = UI.accent() },
        { text = 'L1 RECRUIT: status, sensors, help' },
        { text = 'L2 RESEARCHER: projects, missions, search' },
        { text = 'L3 SECURITY: infrastructure, DEFCON, logs, reports' },
        { text = 'L4 COMMAND: classified files, personnel, relations' },
        { text = 'L5 SUPREME (ADMIN PIN): operators,]====] ..
[====[ trash, backup' },
        { text = ' ' },
        { text = 'ALERTS', color = UI.accent() },
        { text = 'DEFCON 5-1 is broadcast by radio to every Pocket.' },
        { text = 'DEFCON 1 engages cfg.lockdown_outputs if set.' },
        { text = 'Sensors auto-raise DEFCON 3 (cfg.auto_defcon=false disables).' },
        { text = ' ' },
        {]====] ..
[====[ text = 'config.lua OPTIONS', color = UI.accent() },
        { text = "theme = 'military' | 'amber' | 'phosphor' | 'ice'" },
        { text = "lockdown_outputs = { 'door_a', 'siren' }" },
        { text = 'lockdown_release = false  (keep lockdown after DEFCON 1)' }
    }, 'HELP / MANUAL')
end

local function adminMenu()
    local items = {
        ]====] ..
[====[{ 'OPERATORS / CLEARANCE', operatorMenu },
        { 'TRASH RECOVERY', trashMenu },
        { 'EXPORT / IMPORT', exportImportMenu },
        { 'BACKUP MANAGER', backupRun },
        { 'VERSION CLEANUP / STORAGE', function() dofile('lib/version_cleanup.lua').menu(UI) end },
        { 'DATA CORE / REMOTE ARCHIVES', function() dofile('lib/datacore_cli]====] ..
[====[ent.lua').menu() end },
        { 'DEVICE REGISTRY', devicesMenu },
        { 'LOGISTICS / STORAGE', inventoryMenu }
    }
    while true do
        local labels = {}
        for i, it in ipairs(items) do labels[i] = it[1] end
        labels[#labels + 1] = 'RETURN'
        local n = UI.menu('ADMINISTRATION', labels)
        if not n or n == #labels]====] ..
[====[ then return end
        items[n][2]()
    end
end

local function tacticalMenu()
    local items = {
        { 'RELATION MAP', relationMap },
        { 'INCIDENT TIMELINE', incidentTimeline },
        { 'DAILY BRIEFING / REPORTS', briefingMenu }
    }
    while true do
        local labels = {}
        for i, it in ipairs(items) do labels[i] = it[]====] ..
[====[1] end
        labels[#labels + 1] = 'RETURN'
        local n = UI.menu('TACTICAL TOOLS', labels)
        if not n or n == #labels then return end
        items[n][2]()
    end
end

---------------------------------------------------------------- background services
-- Watches sensors: logs transitions, beeps, radio-alerts Pockets, escalates DEFCON]====] ..
[====[.
local function sensorWatcher()
    local last = {}
    local speaker = peripheral.find and peripheral.find('speaker') or nil
    local tick = 0
    while running do
        local ok, s = pcall(Control.readSensors, cfg.sensors or {})
        if ok and type(s) == 'table' then
            for name, state in pairs(s) do
                if last[name] ]====] ..
[====[~= nil and last[name] ~= state then
                    Log.write('SENSOR', name .. (state and ' TRIGGERED' or ' CLEARED'))
                    if state then
                        Alert.announce('SENSOR', 'SENSOR TRIGGERED: ' .. name)
                        if speaker then pcall(speaker.playNote, 'bell', 3, 12) end
                        if cfg]====] ..
[====[.auto_defcon ~= false and Alert.get() > 3 then
                            Alert.change(3, 'AUTO/' .. name)
                        end
                    end
                end
                last[name] = state
            end
        end
        tick = tick + 1
        if speaker and tick % 4 == 0 and Alert.get() <= 2 then
            pcall(sp]====] ..
[====[eaker.playNote, 'bit', 3, 18)
        end
        sleep(0.5)
    end
end

local function networkLoop()
    while true do
        local sender, msg = Net.receive(0.1)
        if sender and msg then
            if PocketServer.handle(sender, msg, cfg) then
                -- handled by authenticated mobile service
            elseif msg.action == "HE]====] ..
[====[LLO" then
                Net.send(sender, { action = "WELCOME", computer = os.getComputerID(), name = cfg.system_name })
            elseif msg.action == "AUTH_CHALLENGE" then
                local nonce = Secure.sha256(tostring(os.epoch('utc')) .. ':' .. tostring(math.random()) .. ':' .. tostring(sender) .. ':' .. tostring(os.clock()))
          ]====] ..
[====[      nodeNonces[sender] = { nonce = nonce, expires = os.clock() + 30 }
                Net.send(sender, { action = "AUTH_CHALLENGE_RESULT", nonce = nonce })
            elseif msg.action == "AUTH" then
                local key = 'node:' .. sender
                local locked = Alert.locked(key)
                local c = nodeNonces[sender]
       ]====] ..
[====[         nodeNonces[sender] = nil
                local ok = false
                if not locked and c and os.clock() < c.expires and type(msg.proof) == 'string' and cfg.pin ~= nil then
                    ok = msg.proof == Secure.sha256(tostring(cfg.pin) .. ':' .. c.nonce)
                    if ok then Alert.clear(key) else Alert.fail(key) end
  ]====] ..
[====[              elseif not locked then
                    Alert.fail(key)
                end
                authenticatedNodes[sender] = ok and (os.clock() + 900) or nil
                Net.send(sender, { action = "AUTH_RESULT", ok = ok, locked = locked or nil })
                Log.write("NETWORK_AUTH", "Node " .. sender .. (ok and " authenticate]====] ..
[====[d" or (locked and " is locked out" or " failed authentication")))
            elseif msg.action == "POCKET_STATUS" then
                local function num(kind)
                    local ok, c = pcall(Data.count, kind)
                    return ok and c or 0
                end
                local alarms, totalS, on, totalO = 0, 0, 0, 0
        ]====] ..
[====[        local okS, s = pcall(Control.readSensors, cfg.sensors or {})
                local okO, o = pcall(Control.outputStatus, cfg.outputs or {})
                if okS then for _, v in pairs(s) do totalS = totalS + 1; if v then alarms = alarms + 1 end end end
                if okO then for _, v in pairs(o) do totalO = totalO + 1; if v then on = ]====] ..
[====[on + 1 end end end
                local highest, hostiles = 0, 0
                for _, kind in ipairs({ "replikas", "threats", "incidents" }) do
                    local ok, items = pcall(Data.list, kind)
                    if ok and type(items) == "table" then
                        for _, r in ipairs(items) do
                            loc]====] ..
[====[al n = tonumber(r.threat or r.threat_level)
                            if n then highest = math.max(highest, math.max(0, math.min(5, math.floor(n)))) end
                            if kind == "replikas" and tostring(r.alignment or ""):upper() == "HOSTILE" then hostiles = hostiles + 1 end
                        end
                    end
       ]====] ..
[====[         end
                Net.send(sender, {
                    action = "POCKET_STATUS_RESULT", core = "ONLINE", node = os.getComputerID(),
                    alarms = alarms, sensors = totalS, outputs_on = on, outputs = totalO,
                    replikas = num("replikas"), hostiles = hostiles, threats = num("threats"),
                    ]====] ..
[====[incidents = num("incidents"), projects = num("projects"),
                    experiments = num("experiments"), personnel = num("personnel"),
                    missions = num("missions"), max_threat = highest, defcon = Alert.get()
                })
            elseif msg.action == "STATUS" then
                Net.send(sender, {
                ]====] ..
[====[    action = "STATUS_RESULT", core = "ONLINE", defcon = Alert.label(),
                    projects = Data.count("projects"),
                    experiments = Data.count("experiments"),
                    peripherals = #peripheral.getNames()
                })
            elseif msg.action == "CONTROL" and isAuth(sender) then
                loca]====] ..
[====[l ok, result = Control.toggle(cfg.outputs or {}, msg.name)
                Net.send(sender, { action = "RESULT", ok = ok, message = result })
                Log.write("REMOTE_CONTROL", "Node " .. sender .. ": " .. tostring(result))
            elseif msg.action == "PROJECT_CREATE" and isAuth(sender) then
                local ok, id = Log.withActo]====] ..
[====[r("NODE " .. sender, Data.create, "projects", type(msg.record) == "table" and msg.record or {})
                Net.send(sender, { action = "RESULT", ok = ok, message = "Project record " .. tostring(id) })
            end
        end
    end
end

---------------------------------------------------------------- main menu
local function intelBadge()
]====] ..
[====[    if session.level < 4 then return nil end
    local hostile = 0
    for _, r in ipairs(Data.list('replikas')) do
        if tostring(r.alignment or ''):upper() == 'HOSTILE' then hostile = hostile + 1 end
    end
    return hostile > 0 and ('!' .. hostile .. ' HOSTILE') or tostring(Data.count('replikas'))
end


-- OBLIVIO 6.0: display control and]====] ..
[====[ controlled update discovery.
local Modes=dofile('lib/display_modes.lua')
local Updater=dofile('lib/update_manager.lua')
local function displayControlMenu()
 while true do
  local current=Modes.get()
  local opts={}
  for _,mode in ipairs(Modes.modes) do
   opts[#opts+1]=(mode==current and '[ACTIVE] ' or '[      ] ')..mode
  end
  opts[#opts+1]='RE]====] ..
[====[TURN'
  local n=UI.menu('EXTERNAL DISPLAYS / CURRENT: '..current,opts)
  if not n or n>#Modes.modes then return end
  if Modes.set(Modes.modes[n]) then note('DISPLAY MODE: '..Modes.modes[n],colors.lime) end
 end
end
local function updateCenterMenu()
 while true do
  local last=Updater.last()
  local source=Updater.source() or 'NOT CONFIGURED'
  loc]====] ..
[====[al opts={
   'CHECK FOR UPDATES NOW',
   'SET MANIFEST PASTEBIN ID',
   'DOWNLOAD LAST FOUND INSTALLER',
   'DOWNLOAD INSTALLER BY PASTEBIN ID',
   'RETURN'
  }
  local n=UI.menu('UPDATE CENTER 6.0 / SOURCE '..source,opts)
  if not n or n==5 then return end
  if n==1 then
   UI.header('CHECKING PASTEBIN');UI.center(8,'CONNECTING TO UPDATE SOURCE...]====] ..
[====[',colors.yellow)
   local info,err=Updater.check()
   if info then note('REMOTE '..info.version..' / LOCAL 6.0 / '..(info.new and 'UPDATE AVAILABLE' or 'NO NEW VERSION'),info.new and colors.lime or colors.lightGray)
   else note('CHECK FAILED: '..tostring(err),colors.red) end
  elseif n==2 then
   UI.header('UPDATE SOURCE');UI.center(7,'PASTEBIN MA]====] ..
[====[NIFEST ID (NOT FULL URL)',colors.lightGray)
   term.setCursorPos(3,9);local s=read()
   note(Updater.setSource(s) and 'SOURCE SAVED' or 'INVALID ID',colors.yellow)
  elseif n==3 or n==4 then
   local pasteId=last and last.paste or nil
   if n==4 then
    UI.header('MANUAL UPDATE DOWNLOAD');UI.center(7,'INSTALLER PASTEBIN ID',colors.lightGray)
    t]====] ..
[====[erm.setCursorPos(3,9);pasteId=read()
   end
   if not pasteId then note('NO UPDATE FOUND YET',colors.yellow)
   else
    UI.header('DOWNLOAD UPDATE');UI.center(7,'DOWNLOAD INSTALLER '..pasteId..' ?',colors.yellow)
    if UI.confirm('SAVE UNTRUSTED CODE FOR REVIEW?') then
     local path,err=Updater.download(pasteId)
     if path then
      UI.heade]====] ..
[====[r('UPDATE DOWNLOADED')
      UI.center(7,'SAVED: '..path,colors.lime)
      UI.center(9,'REVIEW THE FILE BEFORE EXECUTING',colors.yellow)
      UI.center(11,'NO CODE HAS BEEN EXECUTED',colors.lightGray)
      sleep(3)
     else note('DOWNLOAD FAILED: '..tostring(err),colors.red) end
    end
   end
  end
 end
end

local function bootSequence60()
 lo]====] ..
[====[cal labels={'SECURITY CORE','PERSONNEL ARCHIVE','INTELLIGENCE GRID','TACTICAL CHANNEL','REDNET COMMAND','OBLIVIO OS 6.0 READY'}
 local w,h=term.getSize()
 term.setBackgroundColor(colors.black);term.clear()
 for i,label in ipairs(labels) do
  term.setTextColor(i==#labels and colors.lime or colors.red)
  term.setCursorPos(2,math.min(h,i+2))
  term.wr]====] ..
[====[ite(('[%02d] %s'):format(i,label):sub(1,w-2))
  sleep(0.13)
 end
 sleep(0.25)
end
local function main()
    bootSequence60()
    if not authenticateLocal() then
        UI.header("CENTRAL AUTHENTICATION")
        term.setCursorPos(2, 7)
        term.setTextColor(colors.red)
        term.write("SESSION LOCKED")
        sleep(2)
        return
    en]====] ..
[====[d
    Log.write("SYSTEM", "Central command started")
    local entries = {
        { label = 'SYSTEM STATUS & DIAGNOSTICS', level = 1, run = status },
        { label = 'EXTERNAL DISPLAY CONTROL', level = 3, run = displayControlMenu, badge = Modes.get },
        { label = 'UPDATE CENTER / PASTEBIN', level = 5, run = updateCenterMenu },
        { la]====] ..
[====[bel = 'INFRASTRUCTURE CONTROL', level = 3, run = outputMenu },
        { label = 'DEFCON / ALERT LEVEL', level = 3, run = defconMenu },
        { label = 'SECURITY & SENSORS', level = 1, run = sensorsMenu },
        { label = 'RESEARCH & PROJECTS', level = 2, run = function() projectMenu('projects', 'RESEARCH & PROJECTS') end, badge = function() re]====] ..
[====[turn Data.count('projects') end },
        { label = 'EXPERIMENTAL DIVISION', level = 2, run = function() projectMenu('experiments', 'EXPERIMENTAL DIVISION') end, badge = function() return Data.count('experiments') end },
        { label = 'OPERATIONS / MISSIONS', level = 2, run = missionMenu, badge = function() return Data.count('missions') end },]====] ..
[====[
        { label = 'PERSONNEL / MEMBER ARCHIVES', level = 4, run = function() Personnel.menu() end, badge = function() return Data.count('personnel') end },
        { label = 'CLASSIFIED INTELLIGENCE', level = 4, run = function() Intelligence.menu() end, badge = intelBadge },
        { label = 'KORPS / HOSTILE INTELLIGENCE', level = 4, run = functi]====] ..
[====[on() Intelligence.korpsMenu() end },
        { label = 'TACTICAL TOOLS', level = 3, run = tacticalMenu },
        { label = 'GLOBAL SEARCH', level = 2, run = globalSearch },
        { label = 'EVENT LOG / AUDIT TRAIL', level = 3, run = logsMenu },
        { label = 'ADMINISTRATION', level = 5, run = adminMenu },
        { label = 'HELP / MANUAL', l]====] ..
[====[evel = 1, run = helpScreen },
        { label = 'SHUTDOWN INTERFACE', level = 1, run = function() running = false end }
    }
    parallel.waitForAny(function()
        while running do
            local labels = {}
            for i, e in ipairs(entries) do
                local text = e.label
                if session.level < e.level then
      ]====] ..
[====[              text = text .. '  [LOCKED L' .. e.level .. ']'
                elseif e.badge then
                    local ok, b = pcall(e.badge)
                    if ok and b ~= nil then text = text .. '  (' .. tostring(b) .. ')' end
                end
                labels[i] = text
            end
            local choice = UI.menu("CENTRAL ]====] ..
[====[| " .. session.name .. " L" .. session.level .. " | " .. Alert.label(), labels)
            if choice == nil then
                running = false
            else
                local e = entries[choice]
                if session.level < e.level then
                    Log.write("AUTH", "Access denied to '" .. e.label .. "' (needs L" .. e.level ]====] ..
[====[.. ")")
                    note('ACCESS DENIED - CLEARANCE L' .. e.level .. ' REQUIRED', colors.red)
                else
                    local ok, err = pcall(e.run)
                    if not ok then
                        Log.write("ERROR", tostring(err))
                        note('MODULE ERROR: ' .. tostring(err), colors.red)
         ]====] ..
[====[           end
                end
            end
        end
        Log.write("SYSTEM", "Central interface closed")
        Log.setActor(nil)
    end, networkLoop, sensorWatcher)
end

local ok, err = pcall(main)
if not ok then
    Log.write("ERROR", err)
    term.setTextColor(colors.red)
    print("OBLIVIO CORE ERROR: " .. tostring(err))
end
]====]
files['dashboard.lua']=[====[-- OBLIVIO OS 5.1 / COMMAND CENTER (read-only, DEFCON reactive)
-- Never shows classified record content: only counts, levels and public events.
local cfg=dofile('config.lua')
local Data=dofile('lib/data.lua')
local Control=dofile('lib/control.lua')
local Alert=dofile('lib/alert.lua')
local Log=dofile('lib/log.lua')
local UI=dofile('lib/ui.lua')
lo]====] ..
[====[cal mon=dofile('lib/displays.lua').get('primary')
if not mon then return end
local C=colors
pcall(function() mon.setTextScale(0.5) end)
local started=os.clock()
local cache={}
local function cached(key,ttl,fn,default)
 local e=cache[key];local now=os.clock()
 if e and now-e.t<ttl then return e.v end
 local ok,v=pcall(fn)
 if not ok or v==nil then v]====] ..
[====[=e and e.v or default end
 cache[key]={t=now,v=v}
 return v
end
local function size() return mon.getSize() end
local function line(x,y,n,bg)
 local w,h=size();if y<1 or y>h or x>w then return end
 x=math.max(1,x);n=math.min(n,w-x+1)
 if n<1 then return end
 mon.setBackgroundColor(bg);mon.setCursorPos(x,y);mon.write((' '):rep(n))
end
local function ]====] ..
[====[put(x,y,s,fg,bg,limit)
 local w,h=size();if y<1 or y>h or x>w then return end
 s=tostring(s or '');x=math.max(1,x)
 local n=math.min(limit or w,w-x+1)
 if n<1 then return end
 mon.setBackgroundColor(bg or C.black);mon.setTextColor(fg or C.white)
 mon.setCursorPos(x,y);mon.write(s:sub(1,n))
end
local function center(y,s,fg,bg)
 local w=size();s=tost]====] ..
[====[ring(s or '')
 put(math.max(1,math.floor((w-#s)/2)+1),y,s,fg,bg)
end
local function sorted(t)
 local k={};for name in pairs(t) do k[#k+1]=name end;table.sort(k);return k
end
local function countTrue(t)
 local n=0;for _,v in pairs(t) do if v then n=n+1 end end;return n
end
local function safeIO()
 local okS,s=pcall(Control.readSensors,cfg.sensors or]====] ..
[====[ {})
 local okO,o=pcall(Control.outputStatus,cfg.outputs or {})
 return okS and s or {},okO and o or {}
end
local function counts()
 return cached('counts',4,function()
  local t={}
  for _,k in ipairs(Data.kinds()) do t[k]=Data.count(k) end
  return t
 end,{})
end
local function stats()
 return cached('stats',8,function()
  local levels={0,0,0,0,0]====] ..
[====[,0};local highest,hostile,open=0,0,0
  for _,kind in ipairs({'replikas','threats','incidents','korps','korps_scientists'}) do
   for _,r in ipairs(Data.list(kind)) do
    local lv=tonumber(r.threat or r.threat_level)
    if lv then lv=math.max(0,math.min(5,math.floor(lv)));levels[lv+1]=levels[lv+1]+1;highest=math.max(highest,lv) end
    if kind=='r]====] ..
[====[eplikas' and tostring(r.alignment or ''):upper()=='HOSTILE' then hostile=hostile+1 end
    if kind=='incidents' then
     local s=tostring(r.status or ''):upper()
     if s~='CLOSED' and s~='RESOLVED' and s~='CONTAINED' then open=open+1 end
    end
   end
  end
  local active=0
  for _,m in ipairs(Data.list('missions')) do if tostring(m.status or ']====] ..
[====['):upper()=='ACTIVE' then active=active+1 end end
  return {levels=levels,highest=highest,hostile=hostile,open=open,missions=active}
 end,{levels={0,0,0,0,0,0},highest=0,hostile=0,open=0,missions=0})
end
-- Only operational events are shown on public monitors (no audit / vault / auth data).
local publicCats={SENSOR=true,DEFCON=true,LOCKDOWN=true,SY]====] ..
[====[STEM=true,CONTROL=true,REMOTE_CONTROL=true,MOBILE_CONTROL=true}
local function events(n)
 return cached('events'..n,3,function()
  local out={}
  local entries=Log.readLast(120)
  for i=#entries,1,-1 do
   local time,cat,msg=entries[i]:match('^%S+ (%S+) | (%S+) | (.*)$')
   if cat and publicCats[cat] then
    out[#out+1]={time=time:sub(1,5),cat=cat]====] ..
[====[,msg=msg}
    if #out>=n then break end
   end
  end
  return out
 end,{})
end
local function panel(x,y,w,h,title,accent)
 if w<8 or h<3 then return end
 line(x,y,w,C.gray);put(x+1,y,' '..title..' ',C.black,C.gray,w-2)
 for yy=y+1,y+h-1 do line(x,yy,w,C.black) end
 line(x,y+h-1,w,accent or C.red)
end
local function field(x,y,w,label,value,fg)
 if w]====] ..
[====[<10 then return end
 local v=tostring(value or '-')
 local maxV=math.min(#v,math.max(3,math.floor(w*0.42)))
 local lx=math.max(1,w-maxV-3)
 put(x+1,y,label,C.lightGray,nil,lx)
 put(x+w-maxV-1,y,v:sub(1,maxV),fg or C.white,nil,maxV)
end
local function elapsed()
 local s=math.floor(os.clock()-started)
 return string.format('%02d:%02d:%02d',math.floor]====] ..
[====[(s/3600),math.floor(s/60)%60,s%60)
end
local levelColors={C.lime,C.green,C.cyan,C.yellow,C.orange,C.red}
local function drawLarge(w,h,dc)
 local sensors,outputs=safeIO()
 local alarms=countTrue(sensors);local on=countTrue(outputs)
 local st=stats();local n=counts()
 local left=math.floor((w-4)/3);local mid=math.floor((w-4)/3);local right=w-4-left-m]====] ..
[====[id
 local x1=1;local x2=x1+left+2;local x3=x2+mid+2
 local top=5;local bottom=h-4;local ph=bottom-top+1
 panel(x1,top,left,ph,'01 / SECURITY',C.red)
 panel(x2,top,mid,ph,'02 / INTELLIGENCE',C.red)
 panel(x3,top,right,ph,'03 / OPERATIONS',C.red)
 field(x1,top+2,left,'ALARM',alarms>0 and ('ACTIVE '..alarms) or 'CLEAR',alarms>0 and C.red or C.lime)
 f]====] ..
[====[ield(x1,top+4,left,'SENSORS',#sorted(sensors),C.white)
 field(x1,top+5,left,'TRIGGERED',alarms,alarms>0 and C.red or C.lime)
 put(x1+1,top+7,'SENSOR GRID',C.yellow)
 local y=top+9
 local keys=sorted(sensors)
 if #keys==0 then put(x1+1,y,'NO SENSORS CONFIGURED',C.gray,nil,left-2) end
 for _,name in ipairs(keys) do
  if y>=bottom-1 then break end
  f]====] ..
[====[ield(x1,y,left,name,sensors[name] and 'ALERT' or 'CLEAR',sensors[name] and C.red or C.lime);y=y+1
 end
 field(x2,top+2,mid,'REPLIKAS',(n.replikas or 0)..'  HOSTILE '..st.hostile,st.hostile>0 and C.orange or C.cyan)
 field(x2,top+3,mid,'THREATS',n.threats or 0,C.orange)
 field(x2,top+4,mid,'INCIDENTS',(n.incidents or 0)..'  OPEN '..st.open,st.open>0]====] ..
[====[ and C.yellow or C.white)
 field(x2,top+5,mid,'KORPS / SCI',(n.korps or 0)..' / '..(n.korps_scientists or 0),C.red)
 field(x2,top+6,mid,'MAX LEVEL',string.format('%02d / 05',st.highest),st.highest>=4 and C.red or C.lime)
 put(x2+1,top+8,'THREAT DISTRIBUTION',C.yellow,nil,mid-2)
 local peak=1
 for i=1,6 do peak=math.max(peak,st.levels[i]) end
 for l]====] ..
[====[v=0,5 do
  local yy=top+10+lv
  if yy>=bottom then break end
  put(x2+1,yy,'L'..lv,levelColors[lv+1],nil,3)
  local bw=math.max(4,mid-11)
  UI.bar(x2+5,yy,bw,st.levels[lv+1],peak,levelColors[lv+1],mon)
  put(x2+5+bw+1,yy,tostring(st.levels[lv+1]),C.white,nil,3)
 end
 field(x3,top+2,right,'PROJECTS',n.projects or 0,C.cyan)
 field(x3,top+3,right,'EXP]====] ..
[====[ERIMENTS',n.experiments or 0,C.cyan)
 field(x3,top+4,right,'MISSIONS',(n.missions or 0)..'  ACTIVE '..st.missions,st.missions>0 and C.lime or C.white)
 field(x3,top+5,right,'PERSONNEL',n.personnel or 0,C.white)
 field(x3,top+7,right,'OUTPUTS ON',on..'/'..#sorted(outputs),C.lime)
 put(x3+1,top+9,'REDSTONE SYSTEMS',C.yellow,nil,right-2)
 local okeys=]====] ..
[====[sorted(outputs);local oy=top+11
 if #okeys==0 then put(x3+1,oy,'NO OUTPUTS CONFIGURED',C.gray,nil,right-2) end
 for _,name in ipairs(okeys) do
  if oy>=bottom-1 then break end
  field(x3,oy,right,name,outputs[name] and 'ON' or 'OFF',outputs[name] and C.lime or C.gray);oy=oy+1
 end
 -- Lower dashboard: use previously empty monitor area for tactical ]====] ..
[====[overview.
 local tacticalTop=top+19
 if bottom-tacticalTop>=11 then
  local tactH=math.min(15,math.max(8,math.floor((bottom-tacticalTop)*0.45)))
  local eventTop=tacticalTop+tactH+2
  line(1,tacticalTop-1,w,C.red)
  put(2,tacticalTop-1,'OBLIVIO / TACTICAL INTELLIGENCE OVERVIEW',C.white,C.red,math.max(1,w-3))
  local cw=math.floor((w-2)/2)
  panel(1]====] ..
[====[,tacticalTop,cw,tactH,'HOSTILE ORGANIZATIONS / KORPS',C.red)
  panel(cw+3,tacticalTop,w-cw-2,tactH,'ACTIVE OPERATIONS / MISSION CONTROL',C.red)
  field(1,tacticalTop+2,cw,'KORPS DIVISIONS',n.korps or 0,C.red)
  field(1,tacticalTop+3,cw,'KORPS SCIENTISTS',n.korps_scientists or 0,C.orange)
  field(1,tacticalTop+4,cw,'KNOWN HOSTILES',st.hostile,C.oran]====] ..
[====[ge)
  field(1,tacticalTop+5,cw,'HIGHEST THREAT',st.highest..' / 5',st.highest>=4 and C.red or C.yellow)
  field(cw+3,tacticalTop+2,w-cw-2,'REGISTERED MISSIONS',n.missions or 0,C.white)
  field(cw+3,tacticalTop+3,w-cw-2,'ACTIVE MISSIONS',st.missions,st.missions>0 and C.orange or C.lime)
  field(cw+3,tacticalTop+4,w-cw-2,'OPEN INCIDENTS',st.open,st.o]====] ..
[====[pen>0 and C.orange or C.lime)
  field(cw+3,tacticalTop+5,w-cw-2,'FACILITY ALARMS',alarms,alarms>0 and C.red or C.lime)
  if tactH>=10 then
   local sy=tacticalTop+7
   put(3,sy,'LIVE HOSTILE SCAN / '..(math.floor(os.clock())%2==0 and 'SCANNING' or 'TRACKING'),C.red)
   local sw=math.max(8,cw-9)
   local phase=math.floor(os.clock()*3)%sw
   put(3,sy]====] ..
[====[+1,'['..string.rep('-',phase)..'|'..string.rep('-',sw-phase-1)..']',C.orange)
   put(cw+5,sy,'OPERATIONS LINK / ACTIVE',C.cyan)
   put(cw+5,sy+1,'NODE 40 / REDNET STATUS',C.gray)
  end
  if eventTop<bottom-3 then
   line(1,eventTop-1,w,C.red)
   put(2,eventTop-1,'SECURITY / OPERATIONS EVENT FEED',C.white,C.red,w-3)
   local feed=events(math.min(16,]====] ..
[====[bottom-eventTop-1))
   if #feed==0 then put(2,eventTop+1,'NO RECENT OPERATIONAL EVENTS',C.gray,nil,w-4) end
   for i,e in ipairs(feed) do
    local y=eventTop+i
    if y>=bottom-1 then break end
    local col=(e.cat=='SENSOR' or e.cat=='LOCKDOWN') and C.red or (e.cat=='DEFCON' and C.orange or C.lightGray)
    put(2,y,string.format('%s  %-16s %s',e.]====] ..
[====[time,e.cat,e.msg),col,nil,w-4)
   end
  end
 end
 line(1,h-3,w,C.red)
 put(2,h-3,'OBLIVIO OS / SYSTEM ONLINE  NODE '..os.getComputerID(),C.white,C.red)
 put(math.max(2,w-22),h-3,'UPTIME '..elapsed(),C.white,C.red)
 local ev=events(2)
 for i=1,2 do
  local e=ev[i]
  if e then
   local col=(e.cat=='SENSOR' or e.cat=='LOCKDOWN') and C.red or (e.cat==']====] ..
[====[DEFCON' and C.orange or C.lightGray)
   put(2,h-3+i,e.time..' '..e.cat..' '..e.msg,col,nil,w-3)
  elseif i==1 then
   put(2,h-2,alarms>0 and ('ALERT: '..alarms..' SENSOR(S) TRIGGERED') or 'ALL CONFIGURED SENSORS NORMAL',alarms>0 and C.red or C.lime,nil,w-3)
  end
 end
end
local function drawCompact(w,h)
 local sensors,outputs=safeIO();local alarms=]====] ..
[====[countTrue(sensors)
 local st=stats();local n=counts()
 local rows={
  {'CORE','ONLINE',C.lime},
  {'SECURITY',alarms>0 and ('ALERT '..alarms) or 'NORMAL',alarms>0 and C.red or C.lime},
  {'REPLIKAS',n.replikas or 0,C.cyan},
  {'HOSTILES',st.hostile,st.hostile>0 and C.orange or C.lime},
  {'THREATS',n.threats or 0,C.orange},
  {'INCIDENTS',(n.incide]====] ..
[====[nts or 0)..' / '..st.open..' OPEN',C.yellow},
  {'KORPS',n.korps or 0,C.red},
  {'KORPS SCI',n.korps_scientists or 0,C.red},
  {'MAX THREAT',st.highest..'/5',st.highest>=4 and C.red or C.lime},
  {'MISSIONS',(n.missions or 0)..' / '..st.missions..' ACT',C.lime},
  {'PROJECTS',n.projects or 0,C.cyan},
  {'EXPERIMENTS',n.experiments or 0,C.cyan},
  {]====] ..
[====['PERSONNEL',n.personnel or 0,C.white},
  {'SENSORS',#sorted(sensors),C.white},
  {'OUTPUTS',countTrue(outputs)..'/'..#sorted(outputs),C.lime},
  {'UPTIME',elapsed(),C.white}
 }
 local y=5
 for _,r in ipairs(rows) do if y>=h-1 then break end;field(1,y,w,r[1],r[2],r[3]);y=y+1 end
 line(1,h,w,C.red);put(2,h,'OBLIVIO OS / MONITOR',C.white,C.red)
end
lo]====] ..
[====[cal function draw()
 local w,h=size()
 local level=Alert.get()
 local info=Alert.levels()[level]
 local dc=info.color
 local alert=level<=2
 local flash=alert and (math.floor(os.clock())%2==0)
 mon.setBackgroundColor(C.black);mon.setTextColor(C.white);mon.clear()
 local barBg=flash and C.white or C.red
 line(1,1,w,barBg);center(1,'O B L I V I O   O]====] ..
[====[ S  //  CENTRAL COMMAND',C.white,barBg)
 center(2,'OBLIVIO OS 5.4  /  DEFCON '..level..' '..info.name,level<=2 and C.red or C.lightGray)
 if alert then
  local bg=flash and C.red or C.black
  line(1,3,w,bg);center(3,'*** ALERT STATUS: '..info.name..' ***',flash and C.white or C.red,bg)
 elseif w>=65 and h>=22 then
  put(2,3,'LIVE FACILITY STATUS',C]====] ..
[====[.lightGray)
  put(math.max(2,w-22),3,'ID '..os.getComputerID()..'  /  READ ONLY',C.gray)
 end
 if w>=65 and h>=22 then drawLarge(w,h,dc) else drawCompact(w,h) end
end

-- OBLIVIO 6.0 / alternate display channels
local Modes=dofile('lib/display_modes.lua')
local bootAt=os.clock()
local function alternateView(mode)
 if mode=='COMMAND' then return fal]====] ..
[====[se end
 local w,h=mon.getSize()
 local C=colors
 local tick=math.floor(os.clock()*2)
 local function line(x,y,t,fg,bg,width)
  if y<1 or y>h or x>w then return end
  x=math.max(1,x);width=math.min(width or (w-x+1),w-x+1)
  if width<1 then return end
  mon.setCursorPos(x,y);mon.setBackgroundColor(bg or C.black);mon.setTextColor(fg or C.lightGray)
  ]====] ..
[====[mon.write(tostring(t or ''):sub(1,width))
 end
 local function fill(x,y,width,fg,ch)
  line(x,y,string.rep(ch or ' ',math.max(0,width)),fg,C.black,width)
 end
 local function rule(y,fg)
  fill(1,y,w,fg or C.red,'-')
 end
 local function box(x,y,bw,bh,title,color)
  if bw<6 or bh<4 then return end
  line(x,y,'+'..string.rep('-',bw-2)..'+',color)
  f]====] ..
[====[or yy=y+1,y+bh-2 do
   line(x,yy,'|',color);line(x+bw-1,yy,'|',color)
  end
  line(x,y+bh-1,'+'..string.rep('-',bw-2)..'+',color)
  line(x+2,y,' '..title..' ',color)
 end
 local function meter(x,y,bw,n,cap,color)
  bw=math.max(1,bw)
  local filled=math.floor(bw*math.min(1,math.max(0,n/math.max(1,cap))))
  line(x,y,string.rep('#',filled)..string.rep]====] ..
[====[('.',bw-filled),color)
 end
 local function count(kind)
  local ok,n=pcall(Data.count,kind)
  return ok and tonumber(n) or 0
 end
 local def=Alert.get()
 mon.setBackgroundColor(C.black);mon.clear()
 line(1,1,string.rep(' ',w),C.white,C.red)
 line(2,1,'OBLIVIO OS 6.0 // '..mode,C.white,C.red)
 line(math.max(1,w-12),1,'DEFCON '..tostring(def),C.white]====] ..
[====[,C.red)
 rule(2,C.red)
 local wide=w>=55
 local cx=math.floor(w/2)
 if mode=='TACTICAL' then
  line(2,4,'TACTICAL OPERATIONS // ACTIVE SECTOR',C.red)
  if wide then
   local rw=math.min(31,math.floor(w*.38));local rh=math.min(27,h-12)
   box(2,6,rw,rh,'RADAR / SWEEP',C.red)
   local rx=2+math.floor(rw/2);local ry=6+math.floor(rh/2)
   for r=1,math.]====] ..
[====[min(math.floor((rw-4)/2),math.floor((rh-4)/2)) do
    local yy=ry-r
    line(rx-r,yy,'+',C.gray);line(rx+r,yy,'+',C.gray)
    line(rx-r,ry+r,'+',C.gray);line(rx+r,ry+r,'+',C.gray)
   end
   line(rx,ry,'X',C.lime)
   local radius=math.max(2,math.min(10,math.floor((rw-5)/2)))
   local a=tick%8
   local dx=({radius,radius,0,-radius,-radius,-radius,0,r]====] ..
[====[adius})[a+1]
   local dy=({0,-3,-5,-3,0,3,5,3})[a+1]
   line(rx+dx,ry+dy,'*',C.orange)
   local xx=rw+4;local right=w-xx-1
   box(xx,6,right,math.min(rh,16),'OPERATIONAL STATUS',C.red)
   line(xx+2,9,'MISSIONS    '..count('missions'),C.white)
   line(xx+2,12,'THREATS     '..count('threats'),C.orange)
   line(xx+2,15,'INCIDENTS   '..count('incidents]====] ..
[====['),C.white)
   if rh>17 then
    box(xx,23,right,math.min(10,h-29),'TACTICAL SIGNAL',C.red)
    for i=1,math.min(5,h-30) do meter(xx+2,24+i,math.max(3,right-5),(tick*3+i*11)%100,100,C.orange) end
   end
  else
   line(2,6,'RADAR SCAN',C.orange)
   for i=1,9 do
    local r=(tick+i)%9
    line(2,7+i,'|'..string.rep('.',r)..'*',i==5 and C.red or C.gra]====] ..
[====[y)
   end
   line(2,19,'MISSIONS '..count('missions'),C.white)
   line(2,21,'THREATS '..count('threats'),C.orange)
   line(2,23,'INCIDENTS '..count('incidents'),C.white)
  end
 elseif mode=='RESEARCH' then
  line(2,4,'RESEARCH DIVISION // ANALYTICAL CORE',C.cyan)
  local vals={{'PROJECTS',count('projects')},{'EXPERIMENTS',count('experiments')},{'PE]====] ..
[====[RSONNEL',count('personnel')},{'SCIENTISTS',count('korps_scientists')}}
  if wide then
   local gap=2;local bw=math.floor((w-8)/2)
   for i,v in ipairs(vals) do
    local x=2+((i-1)%2)*(bw+gap);local y=7+math.floor((i-1)/2)*13
    box(x,y,bw,11,v[1],C.cyan)
    line(x+3,y+3,'REGISTERED: '..v[2],C.white)
    meter(x+3,y+6,bw-7,v[2],math.max(10,v[2]+5]====] ..
[====[),C.cyan)
    line(x+3,y+8,'ANALYSIS '..string.rep('.',tick%6),C.lightBlue)
   end
   local graphY=math.min(h-8,35)
   if graphY>31 then
    line(3,graphY,'LIVE SPECTRAL ANALYSIS',C.cyan)
    for j=1,math.min(w-8,80) do
     local v=math.floor(2+2*math.sin((j+tick)/5))
     line(3+j,graphY+v,'*',C.lightBlue)
    end
   end
  else
   for i,v in ipai]====] ..
[====[rs(vals) do
    local y=6+(i-1)*5
    line(2,y,v[1],C.cyan)
    line(2,y+1,'TOTAL '..v[2],C.white)
    meter(2,y+2,w-4,v[2],math.max(10,v[2]+5),C.lightBlue)
   end
   line(2,28,'LAB LINK ACTIVE',C.cyan)
  end
 elseif mode=='INTELLIGENCE' then
  line(2,4,'INTELLIGENCE // SIGNAL INTERCEPT',C.orange)
  local vals={{'KORPS',count('korps')},{'REPLIKAS',]====] ..
[====[count('replikas')},{'THREATS',count('threats')},{'INCIDENTS',count('incidents')}}
  if wide then
   local left=math.floor(w*.44)
   box(2,6,left,math.min(h-12,29),'THREAT REGISTRY',C.orange)
   for i,v in ipairs(vals) do
    local y=8+(i-1)*5
    line(5,y,string.format('%-13s %03d',v[1],v[2]),i==3 and C.red or C.white)
    meter(5,y+2,left-8,v[2],m]====] ..
[====[ath.max(10,v[2]+7),C.orange)
   end
   local x=left+4;local bw=w-x-1
   box(x,6,bw,math.min(h-12,29),'CIPHER MATRIX',C.orange)
   for j=1,math.min(23,h-15) do
    local t=''
    for k=1,math.max(1,bw-4) do
     local v=(j*31+k*17+tick*7)%16
     t=t..('0123456789ABCDEF'):sub(v+1,v+1)
    end
    line(x+2,7+j,t,j%4==0 and C.red or C.gray)
   end
  e]====] ..
[====[lse
   for i,v in ipairs(vals) do
    line(2,6+i*3,v[1],C.orange)
    line(2,7+i*3,string.format('  %03d DETECTED',v[2]),C.white)
   end
   line(2,22,'SIGNAL MATRIX',C.red)
   for j=1,math.min(6,h-25) do
    local t=''
    for k=1,w-3 do
     local v=(j*13+k*7+tick)%16
     t=t..('0123456789ABCDEF'):sub(v+1,v+1)
    end
    line(2,22+j,t,C.gray)
  ]====] ..
[====[ end
  end
 else
  line(2,4,'SYSTEM DIAGNOSTICS // HARDWARE NODE',C.lime)
  local free=fs.getFreeSpace('/')
  local total=fs.getCapacity and fs.getCapacity('/') or nil
  local up=math.floor(os.clock())
  local vals={{'NODE ID',os.getComputerID()},{'UPTIME',up..' SEC'},{'FREE STORAGE',tostring(free)},{'CAPACITY',tostring(total or 'N/A')},{'DEFCON',d]====] ..
[====[ef},{'DISPLAY MODE','SYSTEM'}}
  if wide then
   box(2,6,w-3,math.min(h-12,23),'SYSTEM HEALTH / READ ONLY',C.lime)
   for i,v in ipairs(vals) do
    line(5,8+i*3,string.format('%-19s %s',v[1],tostring(v[2])),i%2==0 and C.white or C.lime)
   end
   local yy=math.min(h-8,33)
   if yy>30 then
    line(3,yy,'PROCESSOR ACTIVITY // VISUAL',C.lime)
    fo]====] ..
[====[r i=1,math.min(8,h-yy-2) do
     meter(3,yy+i,w-7,(tick*13+i*19)%100,100,C.lime)
    end
   end
  else
   for i,v in ipairs(vals) do
    line(2,6+i*3,v[1],C.lime)
    line(2,7+i*3,tostring(v[2]),C.white)
   end
   line(2,27,'SYSTEM ONLINE',C.lime)
  end
 end
 rule(h-2,mode=='RESEARCH' and C.cyan or mode=='SYSTEM' and C.lime or mode=='INTELLIGENCE' ]====] ..
[====[and C.orange or C.red)
 line(2,h-1,'EXTERNAL / READ ONLY',C.gray)
 line(2,h,'OBLIVIO OS 6.0 // '..string.format('%02d:%02d',math.floor(os.clock()/60)%60,math.floor(os.clock())%60),C.gray)
 return true
end
local function cinematicMonitorBoot()
 local w,h=mon.getSize()
 for i=1,4 do
  mon.setBackgroundColor(colors.black);mon.clear()
  mon.setTextColo]====] ..
[====[r(i%2==0 and colors.white or colors.red)
  local msg=({'OBLIVIO OS','INITIALIZING NODE','MILITARY DATA LINK','SYSTEM ONLINE'})[i]
  mon.setCursorPos(math.max(1,math.floor((w-#msg)/2)+1),math.max(1,math.floor(h/2)))
  mon.write(msg:sub(1,w))
  sleep(0.18)
 end
end
cinematicMonitorBoot()
-- DEFCON 1 / OBLIVIO BLACK SEAL PROTOCOL (DISPLAY ONLY)
-- Fic]====] ..
[====[tional terminal presentation; no filesystem, network or redstone effects.
local sealStart=nil
local function simulatedLockdown()
 if Alert.get()~=1 then sealStart=nil;return false end
 if not sealStart then sealStart=os.epoch('utc') end
 local elapsed=math.max(0,math.floor((os.epoch('utc')-sealStart)/1000))
 local left=math.max(0,300-elapsed)
 loca]====] ..
[====[l w,h=mon.getSize()
 local tick=math.floor(os.clock()*2)
 local function band(y,bg)
  if y<1 or y>h then return end
  mon.setBackgroundColor(bg);mon.setCursorPos(1,y);mon.write((' '):rep(w))
 end
 local function msg(y,s,fg,bg)
  if y<1 or y>h then return end
  s=tostring(s)
  mon.setBackgroundColor(bg or colors.black);mon.setTextColor(fg or colors.]====] ..
[====[white)
  mon.setCursorPos(math.max(1,math.floor((w-#s)/2)+1),y)
  mon.write(s:sub(1,w))
 end
 local function bar(y,pct,width)
  width=math.min(width,w-4);if width<4 then return end
  local count=math.floor(width*math.max(0,math.min(1,pct)))
  msg(y,'['..string.rep('=',count)..string.rep('-',width-count)..']',colors.red)
 end
 mon.setBackgroundColor]====] ..
[====[(colors.black);mon.clear()
 band(1,colors.red)
 msg(1,'OBLIVIO // BLACK SEAL',colors.white,colors.red)
 local flash=tick%2==0
 if w>=45 then
  local center=math.floor(h/2)
  msg(3,'SECURITY DIRECTIVE 001',colors.lightGray)
  msg(5,'DEFCON 1 // TOTAL CONTAINMENT',colors.red)
  band(7,colors.gray)
  msg(7,'RESTRICTED SYSTEM ACCESS',colors.white,color]====] ..
[====[s.gray)
  msg(center-8,flash and 'ACCESS DENIED' or 'AUTHORIZATION REVOKED',colors.red)
  msg(center-5,'CENTRAL COMMAND HAS INITIATED BLACK SEAL',colors.white)
  msg(center-3,'ARCHIVE SANITIZATION SEQUENCE',colors.orange)
  msg(center-1,'T - '..string.format('%02d:%02d',math.floor(left/60),left%60),colors.red)
  bar(center+1,elapsed/300,math.min(46]====] ..
[====[,w-8))
  local phases={'SEALING ACCESS CHANNELS','REVOKING ACTIVE CREDENTIALS','ISOLATING ARCHIVE INDEX','PURGING ENCRYPTION KEYS','FINAL CONTAINMENT STAGE'}
  local idx=math.min(5,math.floor(elapsed/60)+1)
  msg(center+4,elapsed>=300 and 'BLACK SEAL COMPLETE' or phases[idx],colors.white)
  msg(center+6,elapsed>=300 and 'ALL EXTERNAL ACCESS TERMINA]====] ..
[====[TED' or 'PROTOCOL EXECUTION IN PROGRESS',colors.lightGray)
  msg(h-5,'AUTHORITY: CENTRAL COMMAND // LEVEL 5',colors.red)
  msg(h-3,'RESTORATION REQUIRES DEFCON 5',colors.lightGray)
  band(h,colors.red);msg(h,'OBLIVIO // EMERGENCY SECURITY CHANNEL',colors.white,colors.red)
 else
  msg(3,'DEFCON 1',colors.red)
  msg(5,'BLACK SEAL',colors.white)
  msg]====] ..
[====[(7,flash and 'ACCESS DENIED' or 'LOCKDOWN ACTIVE',colors.red)
  msg(10,'ARCHIVE SEAL',colors.orange)
  msg(12,'T-'..string.format('%02d:%02d',math.floor(left/60),left%60),colors.red)
  bar(14,elapsed/300,math.min(12,w-4))
  local labels={'SEAL CHANNEL','REVOKE ACCESS','ISOLATE INDEX','KEY SANITIZE','FINAL STAGE'}
  msg(17,elapsed>=300 and 'SEAL COM]====] ..
[====[PLETE' or labels[math.min(5,math.floor(elapsed/60)+1)],colors.white)
  msg(h-5,'CENTRAL AUTH',colors.lightGray)
  msg(h-4,'LEVEL 5 ONLY',colors.red)
  msg(h-2,'RESET: DEFCON 5',colors.white)
  band(h,colors.red);msg(h,'OBLIVIO OS',colors.white,colors.red)
 end
 return true
end

while true do
 local ok,err=pcall(function() if not simulatedLockdown()]====] ..
[====[ and not alternateView(Modes.get()) then draw() end end)
 if not ok then
  mon.setBackgroundColor(C.black);mon.setTextColor(C.red);mon.clear()
  put(1,1,'OBLIVIO // MONITOR ERROR',C.red)
  put(1,2,tostring(err),C.white,nil)
 end
 sleep(1)
end
]====]
files['lib/access.lua']=[====[-- OBLIVIO 5.1 / operators and clearance levels (admin PIN stays in config.lua)
local Secure=dofile('lib/secure.lua')
local X={}
X.levels={[1]='RECRUIT',[2]='RESEARCHER',[3]='SECURITY',[4]='COMMAND',[5]='SUPREME'}
local PATH='data/system/operators.dat'
local ROUNDS=200
local function load()
  if not fs.exists(PATH) then return {} end
  local f=fs.o]====] ..
[====[pen(PATH,'r');if not f then return {} end
  local raw=f.readAll();f.close()
  local ok,t=pcall(textutils.unserialize,raw)
  if ok and type(t)=='table' then return t end
  return {}
end
local function save(list)
  if not fs.exists('data/system') then fs.makeDir('data/system') end
  local f=fs.open(PATH,'w');if not f then return false end
  f.write(t]====] ..
[====[extutils.serialize(list));f.close()
  return true
end
local function hash(pin,salt)
  local v=Secure.sha256(salt..':'..pin)
  for _=2,ROUNDS do v=Secure.sha256(v..':'..salt) end
  return v
end
local function newSalt(name)
  return Secure.sha256(tostring(os.epoch('utc'))..':'..tostring(math.random())..':'..name..':'..tostring(os.clock()))
end
functi]====] ..
[====[on X.list()
  local out={}
  for i,o in ipairs(load()) do out[i]={name=o.name,level=o.level,created=o.created} end
  return out
end
function X.identify(pin)
  pin=tostring(pin or '')
  if pin=='' then return nil end
  for _,o in ipairs(load()) do
    if hash(pin,o.salt)==o.hash then return {name=o.name,level=o.level} end
  end
  return nil
end
func]====] ..
[====[tion X.add(name,pin,level,adminPin)
  name=tostring(name or ''):upper():gsub('[^%w_%-]','')
  pin=tostring(pin or '')
  level=tonumber(level)
  if #name<2 or #name>16 then return false,'Callsign must be 2-16 characters' end
  if name=='ADMIN' then return false,'Callsign reserved' end
  if #pin<4 then return false,'Code needs 4+ characters' end
  if]====] ..
[====[ not level or level<1 or level>4 then return false,'Invalid clearance level' end
  if pin==tostring(adminPin) then return false,'Code already in use' end
  local list=load()
  if #list>=12 then return false,'Operator limit reached (12)' end
  for _,o in ipairs(list) do
    if o.name==name then return false,'Callsign already exists' end
  end
  if X]====] ..
[====[.identify(pin) then return false,'Code already in use' end
  local salt=newSalt(name)
  list[#list+1]={name=name,level=level,salt=salt,hash=hash(pin,salt),created=os.date('%Y-%m-%d %H:%M:%S')}
  if not save(list) then return false,'Save failed' end
  return true
end
function X.setLevel(name,level)
  level=tonumber(level)
  if not level or level<1 o]====] ..
[====[r level>4 then return false end
  local list=load()
  for _,o in ipairs(list) do
    if o.name==name then o.level=level;return save(list) end
  end
  return false
end
function X.setPin(name,pin,adminPin)
  pin=tostring(pin or '')
  if #pin<4 then return false,'Code needs 4+ characters' end
  if pin==tostring(adminPin) then return false,'Code alread]====] ..
[====[y in use' end
  local other=X.identify(pin)
  if other and other.name~=name then return false,'Code already in use' end
  local list=load()
  for _,o in ipairs(list) do
    if o.name==name then
      o.salt=newSalt(name);o.hash=hash(pin,o.salt)
      if not save(list) then return false,'Save failed' end
      return true
    end
  end
  return fals]====] ..
[====[e,'Operator not found'
end
function X.remove(name)
  local list,keep={},{}
  list=load()
  for _,o in ipairs(list) do if o.name~=name then keep[#keep+1]=o end end
  if #keep==#list then return false end
  return save(keep)
end
return X
]====]
files['lib/alert.lua']=[====[-- OBLIVIO 5.1 / DEFCON state, radio alerts, lockdown, brute-force lockout
local A={}
local PATH='data/system/defcon.dat'
local levels={
  [5]={name='NORMAL',color=colors.lime},
  [4]={name='ELEVATED',color=colors.cyan},
  [3]={name='HIGH',color=colors.yellow},
  [2]={name='SEVERE',color=colors.orange},
  [1]={name='MAXIMUM',color=colors.red}
}
fun]====] ..
[====[ction A.levels() return levels end
local function load()
  if not fs.exists(PATH) then return nil end
  local f=fs.open(PATH,'r');if not f then return nil end
  local raw=f.readAll();f.close()
  local ok,t=pcall(textutils.unserialize,raw)
  if ok and type(t)=='table' and levels[t.level] then return t end
  return nil
end
function A.get()
  local t=]====] ..
[====[load()
  return t and t.level or 5
end
function A.info()
  local t=load() or {level=5}
  return t.level,levels[t.level],t.by,t.at
end
function A.set(level,who)
  level=tonumber(level)
  if not level or not levels[level] then return false end
  if not fs.exists('data/system') then fs.makeDir('data/system') end
  local f=fs.open(PATH,'w');if not f th]====] ..
[====[en return false end
  f.write(textutils.serialize({level=level,by=tostring(who or 'SYSTEM'),at=os.date('%Y-%m-%d %H:%M:%S')}))
  f.close()
  return true
end
function A.label()
  local l=A.get()
  return 'DEFCON '..l..' '..levels[l].name
end
local function mod(path)
  local ok,m=pcall(dofile,path)
  if ok and type(m)=='table' then return m end
  ret]====] ..
[====[urn nil
end
-- Radio alert to every Pocket / terminal on the network.
function A.announce(kind,text,level)
  if rednet and rednet.isOpen and rednet.isOpen() then
    pcall(rednet.broadcast,{action='ALERT',kind=kind,level=level,text=tostring(text)},'oblivio_v2')
  end
end
-- Single entry point for changing the alert level: saves, logs, broadcasts,
-]====] ..
[====[- and engages / releases lockdown outputs (cfg.lockdown_outputs) at DEFCON 1.
function A.change(level,who)
  level=tonumber(level)
  if not level or not levels[level] then return false end
  local previous=A.get()
  if previous==level then return true end
  if not A.set(level,who) then return false end
  local Log=mod('lib/log.lua')
  if Log then L]====] ..
[====[og.write('DEFCON','Level '..previous..' -> '..level..' by '..tostring(who)) end
  A.announce('DEFCON','DEFCON '..level..' '..levels[level].name..' / '..tostring(who),level)
  local cfg=mod('config.lua')
  if cfg and type(cfg.lockdown_outputs)=='table' and type(cfg.outputs)=='table' then
    local engage=level==1
    local release=previous==1 and le]====] ..
[====[vel>1 and cfg.lockdown_release~=false
    if engage or release then
      local Control=mod('lib/control.lua')
      if Control then
        for _,name in ipairs(cfg.lockdown_outputs) do pcall(Control.set,cfg.outputs,name,engage) end
        if Log then Log.write('LOCKDOWN',(engage and 'ENGAGED' or 'RELEASED')..' ('..#cfg.lockdown_outputs..' output]====] ..
[====[s)') end
      end
    end
  end
  return true
end
-- Lockout: 3 failures, then 30s doubling up to 5 minutes (in memory, per key).
local fails={}
function A.locked(key)
  local e=fails[key]
  if e and e.untilT and os.clock()<e.untilT then return true,math.ceil(e.untilT-os.clock()) end
  return false,0
end
function A.fail(key)
  local e=fails[key] o]====] ..
[====[r {n=0}
  e.n=e.n+1
  if e.n>=3 then e.untilT=os.clock()+math.min(300,30*2^(e.n-3)) end
  fails[key]=e
  return e.n
end
function A.clear(key) fails[key]=nil end
return A
]====]
files['lib/control.lua']=[====[local Control = {}

function Control.set(outputs, name, value)
    local item = outputs[name]
    if not item then return false, "Unknown output" end
    local side = item.side
    if not redstone then return false, "Redstone API unavailable" end
    redstone.setOutput(side, value == true)
    return true, name .. " set to " .. (value and "ON" or "]====] ..
[====[OFF")
end

function Control.toggle(outputs, name)
    local item = outputs[name]
    if not item then return false, "Unknown output" end
    local current = redstone.getOutput(item.side)
    if item.mode == "pulse" then
        redstone.setOutput(item.side, true)
        sleep(item.duration or 1)
        redstone.setOutput(item.side, false)
       ]====] ..
[====[ return true, name .. " pulse sent"
    end
    redstone.setOutput(item.side, not current)
    return true, name .. " is now " .. (not current and "ON" or "OFF")
end

function Control.readSensors(sensors)
    local result = {}
    for name, item in pairs(sensors) do
        local state = redstone.getInput(item.side)
        if item.active_high == f]====] ..
[====[alse then state = not state end
        result[name] = state
    end
    return result
end

function Control.outputStatus(outputs)
    local result = {}
    for name, item in pairs(outputs) do
        result[name] = redstone.getOutput(item.side)
    end
    return result
end

return Control
]====]
files['lib/data.lua']=[====[-- OBLIVIO 5.1 / records: audit trail, trash recovery, export / import, missions
local Log = dofile("lib/log.lua")
local Data = {}
local order={"projects","experiments","missions","personnel","replikas","threats","incidents","korps","korps_scientists"}
local allowed={}
for _,k in ipairs(order) do allowed[k]=true end
local codes={projects="PRJ",expe]====] ..
[====[riments="EXP",missions="MSN",personnel="PER",replikas="RPL",threats="THR",incidents="INC",korps="KRP",korps_scientists="KSC"}
-- Longest names first so "korps_scientists" is never mistaken for "korps".
local byLength={}
for _,k in ipairs(order) do byLength[#byLength+1]=k end
table.sort(byLength,function(a,b) return #a>#b end)
local function directo]====] ..
[====[ry(kind)
  assert(allowed[kind],"Invalid record category")
  return "data/"..kind
end
function Data.kinds() return order end
function Data.code(kind) return codes[kind] or "???" end
function Data.init()
  local dirs={"data","data/archives","data/logs","data/system"}
  for _,k in ipairs(order) do dirs[#dirs+1]="data/"..k end
  for _,p in ipairs(dirs]====] ..
[====[) do
    if not fs.exists(p) then fs.makeDir(p) end
  end
end
local function load(path)
  if not fs.exists(path) then return nil end
  local f=fs.open(path,"r")
  if not f then return nil end
  local s=f.readAll(); f.close()
  local ok,v=pcall(textutils.unserialize,s)
  if ok and type(v)=="table" then return v end
  return nil
end
local function sa]====] ..
[====[ve(path,v)
  local f=fs.open(path,"w")
  if not f then return false end
  f.write(textutils.serialize(v)); f.close()
  return true
end
local function short(v)
  if type(v)=="table" then v=textutils.serialize(v) end
  local s=tostring(v==nil and "" or v)
  s=s:gsub("%s+"," ")
  if #s>28 then s=s:sub(1,25).."..." end
  return s
end
local ignored={id=]====] ..
[====[true,created=true,updated=true}
local function diff(old,new)
  local parts,seen={},{}
  for k,v in pairs(new) do
    seen[k]=true
    if not ignored[k] and short(old[k])~=short(v) then
      parts[#parts+1]=tostring(k)..": "..short(old[k]).." > "..short(v)
    end
  end
  for k,v in pairs(old) do
    if not seen[k] and not ignored[k] then parts[#pa]====] ..
[====[rts+1]=tostring(k)..": "..short(v).." > [REMOVED]" end
  end
  table.sort(parts)
  return parts
end
function Data.list(kind)
  Data.init()
  local result={}
  local dir=directory(kind)
  for _,file in ipairs(fs.list(dir)) do
    if file:match("%.dat$") then
      local item=load(dir.."/"..file)
      if item then result[#result+1]=item end
    end
]====] ..
[====[  end
  table.sort(result,function(a,b) return tostring(a.name or ""):lower()<tostring(b.name or ""):lower() end)
  return result
end
function Data.count(kind)
  Data.init()
  local n=0
  for _,file in ipairs(fs.list(directory(kind))) do
    if file:match("%.dat$") then n=n+1 end
  end
  return n
end
function Data.create(kind,item)
  Data.init()
  ]====] ..
[====[local dir=directory(kind)
  local id=tostring(os.epoch("utc")).."-"..tostring(math.random(1000,9999))
  while fs.exists(dir.."/"..id..".dat") do id=id.."x" end
  item.id=id
  item.created=os.date("%Y-%m-%d %H:%M:%S")
  item.updated=item.created
  local ok=save(dir.."/"..id..".dat",item)
  if ok then Log.write("AUDIT","CREATE "..kind.." "..id.." | "]====] ..
[====[..short(item.name or item.codename)) end
  return ok,id
end
function Data.read(kind,id)
  Data.init()
  if not tostring(id):match("^[%w%-]+$") then return nil end
  return load(directory(kind).."/"..id..".dat")
end
function Data.update(kind,id,item)
  Data.init()
  local old=Data.read(kind,id)
  if not old then return false end
  item.id=old.id
  i]====] ..
[====[tem.created=old.created
  item.updated=os.date("%Y-%m-%d %H:%M:%S")
  local ok=save(directory(kind).."/"..id..".dat",item)
  if ok then
    local parts=diff(old,item)
    local text=#parts>0 and table.concat(parts,"; ") or "no field changes"
    if #text>170 then text=text:sub(1,167).."..." end
    Log.write("AUDIT","UPDATE "..kind.." "..id.." | ".]====] ..
[====[.text)
  end
  return ok
end
-- Deleted files go to data/archives/deleted_<kind>_<id>.dat (recoverable).
function Data.delete(kind,id)
  local item=Data.read(kind,id)
  if not item then return false end
  local src=directory(kind).."/"..id..".dat"
  local dst="data/archives/deleted_"..kind.."_"..id..".dat"
  if fs.exists(dst) then fs.delete(dst) en]====] ..
[====[d
  local ok=pcall(fs.move,src,dst)
  if not ok and fs.exists(src) then fs.delete(src) end
  Log.write("AUDIT","DELETE "..kind.." "..id.." | "..short(item.name or item.codename))
  return true
end
function Data.trash()
  local out={}
  if not fs.exists("data/archives") then return out end
  for _,file in ipairs(fs.list("data/archives")) do
    loca]====] ..
[====[l rest=file:match("^deleted_(.+)%.dat$")
    if rest then
      for _,kind in ipairs(byLength) do
        local prefix=kind.."_"
        if rest:sub(1,#prefix)==prefix then
          local item=load("data/archives/"..file)
          out[#out+1]={file=file,kind=kind,id=rest:sub(#prefix+1),
            name=item and tostring(item.name or item.codenam]====] ..
[====[e or "UNNAMED") or "UNREADABLE"}
          break
        end
      end
    end
  end
  table.sort(out,function(a,b) return a.name:lower()<b.name:lower() end)
  return out
end
local function trashPath(kind,id)
  if not allowed[kind] or not tostring(id):match("^[%w%-]+$") then return nil end
  return "data/archives/deleted_"..kind.."_"..id..".dat"
en]====] ..
[====[d
function Data.restore(kind,id)
  local src=trashPath(kind,id)
  if not src or not fs.exists(src) then return false end
  local dst=directory(kind).."/"..id..".dat"
  if fs.exists(dst) then return false end
  fs.move(src,dst)
  Log.write("AUDIT","RESTORE "..kind.." "..id)
  return true
end
function Data.purge(kind,id)
  local src=trashPath(kind,id]====] ..
[====[)
  if not src or not fs.exists(src) then return false end
  fs.delete(src)
  Log.write("AUDIT","PURGE "..kind.." "..id)
  return true
end
function Data.export(kind)
  local list=Data.list(kind)
  local path="data/archives/export_"..kind.."_"..os.date("%Y%m%d_%H%M%S")..".dat"
  if not save(path,{kind=kind,version=1,records=list}) then return nil en]====] ..
[====[d
  Log.write("AUDIT","EXPORT "..kind.." ("..#list.." records)")
  return path,#list
end
function Data.exports()
  local out={}
  if not fs.exists("data/archives") then return out end
  for _,file in ipairs(fs.list("data/archives")) do
    if file:match("^export_[%w_%.%-]+%.dat$") then out[#out+1]="data/archives/"..file end
  end
  table.sort(out)
]====] ..
[====[  return out
end
function Data.import(path)
  if type(path)~="string" or not path:match("^data/archives/export_[%w_%.%-]+%.dat$") then return nil,"Invalid path" end
  local t=load(path)
  if not t or not allowed[t.kind] or type(t.records)~="table" then return nil,"Invalid export file" end
  local n=0
  for _,r in ipairs(t.records) do
    if type(r)]====] ..
[====[=="table" then
      r.id=nil
      if Data.create(t.kind,r) then n=n+1 end
    end
  end
  Log.write("AUDIT","IMPORT "..t.kind.." ("..n.." records)")
  return n,t.kind
end
local searchKeys={"name","codename","model","serial","faction","alignment","status","location","type","division","department","id","notes","description","objective","team","comm]====] ..
[====[ander"}
function Data.search(query,kinds)
  query=tostring(query or ""):lower()
  local out={}
  for _,kind in ipairs(kinds or order) do
    for _,r in ipairs(Data.list(kind)) do
      local parts={}
      for _,key in ipairs(searchKeys) do
        if r[key]~=nil then parts[#parts+1]=tostring(r[key]) end
      end
      if query=="" or table.concat]====] ..
[====[(parts," "):lower():find(query,1,true) then
        out[#out+1]={kind=kind,record=r}
      end
    end
  end
  return out
end
return Data
]====]
files['lib/datacore_client.lua']=[====[-- OBLIVIO DATA CORE CLIENT 1.0 / CENTRAL 40
-- Archive-only integration. No automatic migration or deletion.
local M={}
local SERVER=49
local PROTO='oblivio_archive_v1'
local TOKEN_FILE='datacore_client_auth.cfg'
local MAX=16000
local function readFile(p)
 local h=fs.open(p,'r');if not h then return nil end
 local x=h.readAll();h.close();return x
]====] ..
[====[end
local function checksum(s)
 local n=0
 for i=1,#s do n=(n*31+s:byte(i))%2147483647 end
 return n
end
local function openModems()
 for _,p in ipairs(peripheral.getNames()) do
  if peripheral.hasType(p,'modem') then
   local ok,wireless=pcall(peripheral.call,p,'isWireless')
   if ok and wireless then rednet.open(p) end
  end
 end
end
local functi]====] ..
[====[on token()
 local t=readFile(TOKEN_FILE)
 if t then t=t:gsub('%s+$','') end
 return t
end
local function query(op,args,secured)
 openModems()
 local t=token()
 if secured and (not t or #t<12) then return nil,'PAIRING TOKEN NOT CONFIGURED' end
 local nonce=tostring(os.epoch('utc'))..'-'..tostring(math.random(1000,9999))
 local req={protocol=PROTO,op]====] ..
[====[=op,token=t,request_id=nonce}
 for k,v in pairs(args or {}) do req[k]=v end
 local sent=rednet.send(SERVER,req,PROTO)
 if not sent then return nil,'REDNET NOT AVAILABLE' end
 local deadline=os.startTimer(4)
 while true do
  local e,a,b,c=os.pullEvent()
  if e=='rednet_message' and a==SERVER and c==PROTO and type(b)=='table' and b.request_id==nonce ]====] ..
[====[then
   if b.ok then return b end
   return nil,tostring(b.error or 'SERVER REJECTED REQUEST')
  elseif e=='timer' and a==deadline then return nil,'TIMEOUT: SERVER 49 OFFLINE' end
 end
end
local function show(lines)
 term.setBackgroundColor(colors.black);term.setTextColor(colors.white);term.clear()
 term.setCursorPos(1,1);term.setBackgroundColor(co]====] ..
[====[lors.red);term.clearLine()
 term.setCursorPos(2,1);term.write('OBLIVIO // DATA CORE')
 term.setBackgroundColor(colors.black)
 for i,l in ipairs(lines) do
  local w,h=term.getSize()
  if i+2<h-1 then
   term.setCursorPos(2,i+2)
   term.setTextColor(i==1 and colors.yellow or colors.lightGray)
   term.write(tostring(l):sub(1,w-3))
  end
 end
 local _,]====] ..
[====[h=term.getSize()
 term.setCursorPos(2,h);term.setTextColor(colors.gray);term.write('ENTER TO RETURN')
 read()
end
local function prompt(label)
 term.setBackgroundColor(colors.black);term.setTextColor(colors.white);term.clear()
 term.setCursorPos(2,2);print('OBLIVIO DATA CORE // '..label)
 term.setCursorPos(2,5);write('> ')
 return read()
end
local ]====] ..
[====[function pair()
 local t=prompt('PAIR TOKEN (LOCAL ONLY)')
 if not t or not t:match('^[0-9a-f]+$') or #t~=32 then
  return show({'INVALID TOKEN','Use the 32-character token from ID 49.'})
 end
 local h=fs.open(TOKEN_FILE,'w')
 if not h then return show({'CANNOT SAVE TOKEN'}) end
 h.write(t);h.close()
 local result,err=query('status',nil,true)
 if n]====] ..
[====[ot result then return show({'TOKEN SAVED LOCALLY','Connection check: '..tostring(err)}) end
 show({'PAIRING SUCCESSFUL','SERVER: 49','DRIVES: '..result.drives})
end
local function status()
 local r,err=query('status',nil,true)
 if not r then return show({'STATUS FAILED',err}) end
 show({'SERVER ID 49 / ONLINE','DRIVES: '..r.drives,
 'CAPACITY: '..m]====] ..
[====[ath.floor(r.capacity/1024)..' KiB',
 'FREE: '..math.floor(r.free/1024)..' KiB','ARCHIVES: '..r.files})
end
local function archives()
 local page=1
 while true do
  local r,err=query('list',{page=page},true)
  if not r then return show({'LIST FAILED',err}) end
  local lines={'ARCHIVES / PAGE '..page,'TOTAL: '..r.total}
  for _,item in ipairs(r.files]====] ..
[====[ or {}) do
   lines[#lines+1]=tostring(item.key)..'  ('..item.bytes..' B)'
   if #lines>=15 then break end
  end
  show(lines)
  if (r.total or 0)<=page*250 then return end
  local v=prompt('NEXT PAGE? Y/N')
  if v:lower()~='y' then return end
  page=page+1
 end
end
local function safeKey(k)
 return type(k)=='string' and #k>=1 and #k<=64 and k:matc]====] ..
[====[h('^[%w_%.%-]+$') and not k:find('..',1,true)
end
local function upload()
 local p=prompt('LOCAL FILE PATH')
 if not p or p=='' or not (p=='data' or p:sub(1,5)=='data/') then
  return show({'ONLY FILES INSIDE data/ ARE ALLOWED'})
 end
 if not fs.exists(p) or fs.isDir(p) then return show({'FILE NOT FOUND'}) end
 local size=fs.getSize(p)
 if size>MAX]====] ..
[====[ then return show({'FILE TOO LARGE','MAXIMUM 16000 BYTES PER ARCHIVE'}) end
 local data=readFile(p)
 if not data then return show({'CANNOT READ LOCAL FILE'}) end
 local k=prompt('NEW ARCHIVE KEY (UNIQUE)')
 if not safeKey(k) then return show({'INVALID ARCHIVE KEY'}) end
 local confirm=prompt('TYPE UPLOAD TO SEND')
 if confirm~='UPLOAD' then return ]====] ..
[====[show({'CANCELLED'}) end
 local r,err=query('put',{key=k,data=data},true)
 if not r then return show({'UPLOAD FAILED',err}) end
 if r.checksum~=checksum(data) then return show({'CHECKSUM MISMATCH - VERIFY ARCHIVE'}) end
 show({'UPLOAD VERIFIED','KEY: '..k,'BYTES: '..#data,'DISK: '..tostring(r.drive),
 'LOCAL SOURCE PRESERVED'})
end
local function do]====] ..
[====[wnload()
 local k=prompt('ARCHIVE KEY TO RETRIEVE')
 if not safeKey(k) then return show({'INVALID ARCHIVE KEY'}) end
 local r,err=query('get',{key=k},true)
 if not r then return show({'DOWNLOAD FAILED',err}) end
 if type(r.data)~='string' or r.checksum~=checksum(r.data) then
  return show({'CHECKSUM MISMATCH','NOTHING WRITTEN'})
 end
 if not fs.exi]====] ..
[====[sts('datacore_retrieved') then fs.makeDir('datacore_retrieved') end
 local dest=fs.combine('datacore_retrieved',k..'.dat')
 if fs.exists(dest) then return show({'FILE EXISTS - REFUSING OVERWRITE',dest}) end
 local h=fs.open(dest,'w')
 if not h then return show({'INSUFFICIENT LOCAL SPACE','NOTHING WRITTEN'}) end
 local ok=pcall(function() h.write(r.]====] ..
[====[data) end);h.close()
 if not ok or readFile(dest)~=r.data then
  if fs.exists(dest) then fs.delete(dest) end
  return show({'LOCAL VERIFICATION FAILED'})
 end
 show({'RETRIEVED AND VERIFIED',dest,'BYTES: '..#r.data,
 'ORIGINAL ARCHIVE UNCHANGED'})
end
function M.menu()
 if os.getComputerID()~=40 then return show({'CENTRAL ID 40 ONLY'}) end
 math.ra]====] ..
[====[ndomseed(os.epoch('utc'))
 while true do
  term.setBackgroundColor(colors.black);term.clear()
  term.setCursorPos(1,1);term.setBackgroundColor(colors.red);term.clearLine()
  term.setCursorPos(2,1);term.setTextColor(colors.white);term.write('OBLIVIO // DATA CORE')
  term.setBackgroundColor(colors.black);term.setTextColor(colors.lightGray)
  local en]====] ..
[====[tries={
   '1 - CONNECTION TEST','2 - PAIR TOKEN','3 - STORAGE STATUS',
   '4 - LIST ARCHIVES','5 - UPLOAD FROM data/',
   '6 - RETRIEVE ARCHIVE','0 - RETURN'
  }
  for i,v in ipairs(entries) do term.setCursorPos(2,i+3);print(v) end
  term.setCursorPos(2,13);term.setTextColor(colors.yellow)
  write('SELECT > ')
  local n=read()
  if n=='0' or n=='']====] ..
[====[ then return
  elseif n=='1' then
   local r,err=query('ping',nil,false)
   show(r and {'DATA CORE ONLINE','ID: '..r.id,'DRIVES: '..r.drives} or {'CONNECTION FAILED',err})
  elseif n=='2' then pair()
  elseif n=='3' then status()
  elseif n=='4' then archives()
  elseif n=='5' then upload()
  elseif n=='6' then download()
  end
 end
end
return M
]====]
files['lib/display_modes.lua']=[====[-- OBLIVIO 6.0 display mode controller. Never changes classified data.
local M={}
local path='data/display_mode.txt'
M.modes={'COMMAND','TACTICAL','RESEARCH','INTELLIGENCE','SYSTEM'}
function M.get()
 if not fs.exists(path) then return 'COMMAND' end
 local f=fs.open(path,'r');if not f then return 'COMMAND' end
 local s=f.readLine();f.close()
 for _]====] ..
[====[,v in ipairs(M.modes) do if s==v then return v end end
 return 'COMMAND'
end
function M.set(s)
 for _,v in ipairs(M.modes) do
  if s==v then
   if not fs.exists('data') then fs.makeDir('data') end
   local f=fs.open(path,'w');if not f then return false end
   f.writeLine(s);f.close();return true
  end
 end
 return false
end
return M
]====]
files['lib/displays.lua']=[====[-- OBLIVIO 3.9 / dynamic independent monitor discovery
local M={}
local function monitors()
 local out={}
 for _,name in ipairs(peripheral.getNames()) do
  if peripheral.getType(name)=='monitor' then
   local ok,w,h=pcall(peripheral.call,name,'getSize')
   if ok and type(w)=='number' and type(h)=='number' then
    out[#out+1]={name=name,w=w,h=h,are]====] ..
[====[a=w*h}
   end
  end
 end
 table.sort(out,function(a,b)
  if a.area~=b.area then return a.area>b.area end
  return a.name<b.name
 end)
 return out
end
function M.resolve()
 local list=monitors()
 local primary=nil
 -- Preserve the original main monitor if it still exists.
 for _,m in ipairs(list) do if m.name=='top' then primary=m.name;break end end]====] ..
[====[
 if not primary and list[1] then primary=list[1].name end
 local secondary=nil
 for _,m in ipairs(list) do
  if m.name~=primary then secondary=m.name;break end
 end
 return primary,secondary,list
end
function M.get(which)
 local primary,secondary=M.resolve()
 local name=which=='secondary' and secondary or primary
 if not name then return nil,nil e]====] ..
[====[nd
 local ok,device=pcall(peripheral.wrap,name)
 if not ok then return nil,nil end
 return device,name
end
return M
]====]
files['lib/intelligence.lua']=[====[-- OBLIVIO 3.0: RPG intelligence, Replika dossiers, threat and incident archives.
local UI=dofile('lib/ui.lua')
local Data=dofile('lib/data.lua')
local Log=dofile('lib/log.lua')
local Secure=dofile('lib/secure.lua')
local M={}
-- Each archive has its own schema, sections and visual identity.
-- Old fields are retained so existing records remain rea]====] ..
[====[dable and editable.
local categories={
 {id='replikas',label='REPLIKA DOSSIERS',code='RPL',accent=colors.cyan,sections={
  {'IDENTITY',{{'name','CODENAME / NAME'},{'model','MODEL / TYPE'},{'serial','SERIAL / UNIT ID'},{'faction','FACTION'},{'alignment','RELATION (ALLY / NEUTRAL / HOSTILE)'}}},
  {'TACTICAL PROFILE',{{'threat','THREAT LEVEL (0-5)'},]====] ..
[====[{'abilities','ABILITIES / TRAITS'},{'behavior','BEHAVIOR'},{'weaknesses','WEAKNESSES'},{'equipment','EQUIPMENT / ARMAMENT'}}},
  {'FIELD INTELLIGENCE',{{'location','LAST KNOWN LOCATION'},{'status','STATUS'},{'last_contact','LAST CONTACT'},{'handler','ASSIGNED RESEARCHER'},{'notes','INTELLIGENCE NOTES'}}}
 }},
 {id='threats',label='THREAT REGISTRY',]====] ..
[====[code='THR',accent=colors.orange,sections={
  {'THREAT IDENTIFICATION',{{'name','THREAT NAME'},{'type','TYPE / CATEGORY'},{'faction','FACTION'},{'alignment','RELATION (ALLY / NEUTRAL / HOSTILE)'}}},
  {'RISK ASSESSMENT',{{'threat','THREAT LEVEL (0-5)'},{'impact','POTENTIAL IMPACT'},{'scope','AREA OF EFFECT'},{'capabilities','KNOWN CAPABILITIES'},{'v]====] ..
[====[ulnerabilities','COUNTERMEASURES / WEAKNESSES'}}},
  {'CONTAINMENT PROTOCOL',{{'protocol','RESPONSE PROTOCOL'},{'location','LAST KNOWN LOCATION'},{'status','STATUS'},{'commander','RESPONSIBLE OFFICER'},{'notes','NOTES'}}}
 }},
 {id='incidents',label='CRITICAL INCIDENTS',code='INC',accent=colors.yellow,sections={
  {'EVENT REPORT',{{'name','INCIDENT]====] ..
[====[ TITLE'},{'type','EVENT TYPE'},{'event_time','DATE / TIME'},{'location','LOCATION'},{'reported_by','REPORTED BY'}}},
  {'IMPACT & RESPONSE',{{'threat','THREAT LEVEL (0-5)'},{'impact','IMPACT'},{'casualties','CASUALTIES / LOSSES'},{'protocol','RESPONSE / CONTAINMENT'},{'units','UNITS DEPLOYED'}}},
  {'AFTER-ACTION REVIEW',{{'status','STATUS'},{'caus]====] ..
[====[e','SUSPECTED CAUSE'},{'resolution','RESOLUTION'},{'notes','AFTER-ACTION REPORT'}}}
 }}
}
-- KORPS enemy organization and scientist intelligence archives
local korpsCategories={
 {id='korps',label='KORPS / ENEMY ORGANIZATION',code='KRP',accent=colors.red,sections={
  {'ORGANIZATION PROFILE',{{'name','ORGANIZATION / DIVISION'},{'codename','KNOWN DES]====] ..
[====[IGNATION'},{'leader','LEADERSHIP'},{'objective','KNOWN OBJECTIVES'},{'status','OPERATIONAL STATUS'}}},
  {'HOSTILE CAPABILITIES',{{'threat','THREAT LEVEL (0-5)'},{'resources','RESOURCES / EQUIPMENT'},{'technology','KNOWN TECHNOLOGY'},{'facilities','FACILITIES / BASES'},{'operations','KNOWN OPERATIONS'}}},
  {'INTELLIGENCE REPORT',{{'location','LAST]====] ..
[====[ KNOWN LOCATION'},{'last_contact','LAST SIGHTING'},{'weaknesses','KNOWN VULNERABILITIES'},{'protocol','RESPONSE PROTOCOL'},{'notes','INTELLIGENCE NOTES'}}}
 }},
 {id='korps_scientists',label='KORPS / SCIENTIST THREATS',code='KSC',accent=colors.red,sections={
  {'IDENTITY / AFFILIATION',{{'name','SCIENTIST NAME'},{'codename','ALIAS / CODENAME'},{'ra]====] ..
[====[nk','POSITION / RANK'},{'division','KORPS DIVISION'},{'status','CURRENT STATUS'}}},
  {'RESEARCH / THREAT',{{'threat','THREAT LEVEL (0-5)'},{'specialty','RESEARCH SPECIALTY'},{'projects','KNOWN PROJECTS'},{'experiments','KNOWN EXPERIMENTS'},{'capabilities','THREAT CAPABILITIES'}}},
  {'FIELD DOSSIER',{{'location','LAST KNOWN LOCATION'},{'last_conta]====] ..
[====[ct','LAST SIGHTING'},{'associates','KNOWN ASSOCIATES'},{'protocol','RESPONSE / CONTAINMENT'},{'notes','FIELD INTELLIGENCE NOTES'}}}
 }}
}
for _,cat in ipairs(korpsCategories) do categories[#categories+1]=cat end
for _,cat in ipairs(categories) do
 cat.fields={}
 for _,section in ipairs(cat.sections) do
  for _,field in ipairs(section[2]) do cat.fie]====] ..
[====[lds[#cat.fields+1]=field end
 end
end
local levels={
 [0]={'00 / NONE',colors.lime},[1]={'01 / LOW',colors.green},
 [2]={'02 / GUARDED',colors.cyan},[3]={'03 / HIGH',colors.yellow},
 [4]={'04 / SEVERE',colors.orange},[5]={'05 / CRITICAL',colors.red}}
local unlocked=false
local function pause(msg)
  UI.block({{text=msg,color=colors.lightGray}},'INTE]====] ..
[====[LLIGENCE / MESSAGE')
end
-- Context-aware TAB suggestions for classified dossier fields.
-- CC:Tweaked read() invokes completion with the current input and expects suffixes.
local suggestions={
 korps_branch={'COMBATENTES','MAGIOLOGOS','EXPLORADORES','MAQUINARIOS'},
 role={'COMANDANTE','CO.COMANDANTE','CIENTISTA','COMBATENTE','MAGIOLOGO','EXPLORADO]====] ..
[====[R','MAQUINARIO'},
 department={'SPECIAL OPERATIONS','BLACK OPS','HUNTER DIVISION','EXECUTION DIVISION','SEARCH & TERMINATION','SHADOW OPERATIONS','TACTICAL ENFORCEMENT','COMBAT OPERATIONS','TACTICAL RESPONSE','RECONNAISSANCE','INTELLIGENCE','COUNTERINTELLIGENCE','INFILTRATION','SURVEILLANCE','SECURITY','FACILITY SECURITY','CONTAINMENT','DETENTION',]====] ..
[====['INTERROGATION','CAPTURE & RECOVERY','TARGET ACQUISITION','SEARCH & RESCUE','EXTRACTION','COMMAND','HIGH COMMAND','STRATEGIC OPERATIONS','SCIENCE','RESEARCH','EXPERIMENTAL DIVISION','ADVANCED RESEARCH','MAGIOLOGY','ARCANE RESEARCH','ANOMALOUS STUDIES','BIOENGINEERING','GENETICS','CYBERNETICS','ROBOTICS','ARTIFICIAL INTELLIGENCE','ENGINEERING','MECH]====] ..
[====[ANICAL ENGINEERING','SYSTEMS ENGINEERING','MAINTENANCE','LOGISTICS','SUPPLY','MEDICAL','FIELD MEDICINE','PSYCHOLOGICAL RESEARCH','FORENSICS','CHEMICAL RESEARCH','PHYSICS','ENERGY RESEARCH','ARCHIVES','DATA ANALYSIS','COMMUNICATIONS','DIPLOMACY','EXPLORATION','FIELD RESEARCH','TECHNOLOGY DEVELOPMENT','WEAPONS RESEARCH','RISK ASSESSMENT','INTERNAL AF]====] ..
[====[FAIRS','PERSONNEL','ADMINISTRATION','TRAINING','REPLIKA DEVELOPMENT','REPLIKA OPERATIONS','KORPS INTELLIGENCE'},
 rank={'EXECUTIONER','HUNTER','TRACKER','FIELD OPERATIVE','BLACK OPS AGENT','SPECIAL OPERATIONS OFFICER','TACTICAL COMMANDER','SQUAD LEADER','COMBAT SPECIALIST','RECON SPECIALIST','INFILTRATOR','INTELLIGENCE OFFICER','INTERROGATOR','DETE]====] ..
[====[NTION OFFICER','CAPTURE SPECIALIST','EXTRACTION SPECIALIST','ASSASSIN','COMMANDER','CO-COMMANDER','DIRECTOR','DEPARTMENT CHIEF','SCIENTIST','LEAD SCIENTIST','RESEARCHER','SENIOR RESEARCHER','MAGIOLOGIST','ARCANE ANALYST','BIOENGINEER','CYBERNETICS ENGINEER','MECHANICAL ENGINEER','ROBOTICS ENGINEER','TECHNICIAN','FIELD MEDIC','MEDICAL OFFICER','FORE]====] ..
[====[NSIC ANALYST','DATA ANALYST','SECURITY OFFICER','GUARD','REPLIKA HANDLER','REPLIKA OPERATOR','EXPLORER','NAVIGATOR','LOGISTICS OFFICER','SYSTEM ADMINISTRATOR','ARCHIVIST','RECRUIT'},
 division={'SPECIAL OPERATIONS','BLACK OPS','HUNTER DIVISION','EXECUTION DIVISION','SEARCH & TERMINATION','SHADOW OPERATIONS','TACTICAL ENFORCEMENT','COMBAT OPERATIONS]====] ..
[====[','TACTICAL RESPONSE','RECONNAISSANCE','INTELLIGENCE','COUNTERINTELLIGENCE','INFILTRATION','SURVEILLANCE','SECURITY','FACILITY SECURITY','CONTAINMENT','DETENTION','INTERROGATION','CAPTURE & RECOVERY','TARGET ACQUISITION','SEARCH & RESCUE','EXTRACTION','COMMAND','HIGH COMMAND','STRATEGIC OPERATIONS','SCIENCE','RESEARCH','EXPERIMENTAL DIVISION','ADVA]====] ..
[====[NCED RESEARCH','MAGIOLOGY','ARCANE RESEARCH','ANOMALOUS STUDIES','BIOENGINEERING','GENETICS','CYBERNETICS','ROBOTICS','ARTIFICIAL INTELLIGENCE','ENGINEERING','MECHANICAL ENGINEERING','SYSTEMS ENGINEERING','MAINTENANCE','LOGISTICS','SUPPLY','MEDICAL','FIELD MEDICINE','PSYCHOLOGICAL RESEARCH','FORENSICS','CHEMICAL RESEARCH','PHYSICS','ENERGY RESEARCH]====] ..
[====[','ARCHIVES','DATA ANALYSIS','COMMUNICATIONS','DIPLOMACY','EXPLORATION','FIELD RESEARCH','TECHNOLOGY DEVELOPMENT','WEAPONS RESEARCH','RISK ASSESSMENT','INTERNAL AFFAIRS','PERSONNEL','ADMINISTRATION','TRAINING','REPLIKA DEVELOPMENT','REPLIKA OPERATIONS','KORPS INTELLIGENCE'},
 specialty={'MAGIOLOGY','BIOENGINEERING','CYBERNETICS','ROBOTICS','ARCANE ]====] ..
[====[RESEARCH','GENETICS','WEAPONS RESEARCH','ENERGY RESEARCH','ANOMALOUS STUDIES'},
 alignment={'ALLY','NEUTRAL','HOSTILE','UNKNOWN','FRIENDLY','UNAFFILIATED'},
 threat={'0','1','2','3','4','5'},
 behavior={'AGGRESSIVE','PASSIVE','HOSTILE','FRIENDLY','UNPREDICTABLE','DEFENSIVE','MANIPULATIVE','CAUTIOUS','COOPERATIVE','EVASIVE','PROTECTIVE','CALCULATING]====] ..
[====[','UNKNOWN'},
 status={'ACTIVE','INACTIVE','MISSING','UNKNOWN','UNDER INVESTIGATION','CONTAINED','DECEASED','CAPTURED','MONITORED','RESOLVED','OPEN','CLOSED'},
 type={'ANOMALY','REPLIKA','ORGANIZATION','CREATURE','TECHNOLOGICAL','BIOLOGICAL','PARANORMAL','SECURITY BREACH','CONTAINMENT FAILURE','HOSTILE CONTACT'},
 impact={'MINIMAL','LOCALIZED','MOD]====] ..
[====[ERATE','SEVERE','CATASTROPHIC','UNKNOWN'},
 protocol={'OBSERVE','MONITOR','NEGOTIATE','ISOLATE','EVACUATE','CONTAIN','LOCKDOWN','QUARANTINE','ESCALATE TO COMMAND','UNKNOWN'},
 model={'UNKNOWN','STANDARD','COMBAT','RESEARCH','SECURITY','PROTOTYPE'},
 location={'UNKNOWN','CENTRAL FACILITY','RESEARCH WING','SECURITY SECTOR','CONTAINMENT ZONE','EXTERNA]====] ..
[====[L TERRITORY'},
 faction={'OBLIVIO','INDEPENDENT','UNKNOWN','UNAFFILIATED'},
 abilities={'UNKNOWN','ENHANCED STRENGTH','HIGH MOBILITY','TACTICAL INTELLIGENCE','REGENERATION','STEALTH','REMOTE CONTROL'}
}
local function completionFor(cat,key)
  local values={}
  local seen={}
  local function add(v)
    if type(v)~='string' or v=='' then return end
 ]====] ..
[====[   local norm=v:lower()
    if not seen[norm] then seen[norm]=true;values[#values+1]=v end
  end
  for _,v in ipairs(suggestions[key] or {}) do add(v) end
  -- Existing records supply vocabulary as well as the built-in options.
  for _,r in ipairs(Data.list(cat.id)) do add(r[key]) end
  table.sort(values,function(a,b)return a:lower()<b:lower() end)]====] ..
[====[
  return function(input)
    local results={}
    local lower=input:lower()
    for _,v in ipairs(values) do
      if v:lower():sub(1,#lower)==lower and #v>#input then
        results[#results+1]=v:sub(#input+1)
      end
    end
    return results
  end
end
local function prompt(label,old,complete)
  term.setBackgroundColor(colors.black);term.set]====] ..
[====[TextColor(colors.lightGray)
  print('');write(label..(old~=nil and (' ['..tostring(old)..']') or '')..': ')
  term.setTextColor(colors.white)
  local value=read(nil,nil,complete)
  if value=='' and old~=nil then return old end
  return value
end
local function login()
  if unlocked then return true end
  if not Secure.configured() then
    UI.heade]====] ..
[====[r('CLASSIFIED VAULT / FIRST SETUP')
    print('Create a password (8+ characters).')
    print('WARNING: Files are NOT encrypted at rest.')
    write('NEW PASSWORD: ');local a=read('*')
    write('CONFIRM PASSWORD: ');local b=read('*')
    if a~=b then pause('Passwords do not match');return false end
    local ok,err=Secure.setup(a)
    if not ok th]====] ..
[====[en pause(err);return false end
    Log.write('VAULT','Classified vault initialized')
  end
  for i=1,3 do
    UI.header('CLASSIFIED VAULT / AUTHENTICATION')
    print('ATTEMPT '..i..' / 3')
    write('PASSWORD: ')
    local entered=read('*')
    if Secure.verify(entered) then
      unlocked=true;Log.write('VAULT','Local vault unlocked');return true]====] ..
[====[
    end
    Log.write('VAULT','Failed local vault authentication')
    if i<3 then sleep(i*2) end
  end
  pause('ACCESS DENIED / SESSION LOCKED')
  return false
end
local function levelInfo(v)
  local n=tonumber(v)
  return levels[n] or {'UNCLASSIFIED',colors.gray}
end
-- OBLIVIO 3.3: clean one-field-at-a-time dossier editor.
-- All changes are st]====] ..
[====[aged in memory until SAVE DOSSIER is confirmed.
local function editForm(cat,old)
  local record={}
  if old then for k,v in pairs(old) do record[k]=v end end
  local index=1
  local total=#cat.fields
  local function cut(text,limit)
    text=tostring(text or '')
    if #text>limit then return text:sub(1,math.max(1,limit-3))..'...' end
    return te]====] ..
[====[xt
  end
  local function fieldPrompt(i)
    local field=cat.fields[i]
    local w,h=term.getSize()
    UI.header((old and 'EDIT' or 'NEW')..' / '..cat.code..' FILE')
    local usable=math.max(12,w-4)
    local function at(y,text,color)
      if y>h-2 then return end
      term.setBackgroundColor(colors.black)
      term.setTextColor(color or color]====] ..
[====[s.lightGray)
      term.setCursorPos(3,y)
      term.write(cut(text,usable))
    end
    at(5,'FIELD '..string.format('%02d',i)..' / '..string.format('%02d',total),colors.yellow)
    at(7,cut(field[2],usable),colors.white)
    if record[field[1]]~=nil and tostring(record[field[1]])~='' then
      at(9,'CURRENT: '..cut(record[field[1]],math.max(4,us]====] ..
[====[able-9)),colors.gray)
    else
      at(9,'CURRENT: [EMPTY]',colors.gray)
    end
    at(11,'NEW VALUE:',colors.yellow)
    at(h-5,'TAB COMPLETE | ENTER NEXT | F2 ACTIONS',colors.lightGray)
    at(h-4,'F2: A/D SELECT BACK / EXIT',colors.yellow)
    UI.footer('DOSSIER EDITOR  //  UNSAVED')
    term.setBackgroundColor(colors.black)
    term.setTextCo]====] ..
[====[lor(colors.white)
    term.setCursorPos(3,12)
    -- CC:Tweaked's read() owns TAB completion. F2 opens an independent
    -- action chooser, so typing A or D in names never triggers navigation.
    local complete=completionFor(cat,field[1])
    -- Standard read() with completion preserves native TAB behavior.
    -- F2 is intercepted through a temp]====] ..
[====[orary event pull wrapper, and the
    -- regular read editor handles all other keyboard/paste events.
    local nativePull=os.pullEvent
    local action=nil
    os.pullEvent=function(filter)
      while true do
        local ev={nativePull(filter)}
        if ev[1]=='key' and ev[2]==keys.f2 then
          term.setCursorBlink(false)
          local ]====] ..
[====[selected=1
          while true do
            term.setCursorPos(3,h-3)
            term.setBackgroundColor(colors.black)
            term.write((' '):rep(math.max(1,w-4)))
            term.setCursorPos(3,h-3)
            term.setTextColor(selected==1 and colors.yellow or colors.gray)
            term.write(selected==1 and '[ BACK ]' or '  BACK  ')]====] ..
[====[
            term.setTextColor(selected==2 and colors.red or colors.gray)
            term.write(selected==2 and '  [ EXIT ]' or '    EXIT  ')
            local e,k=nativePull()
            if e=='char' then
              if k:lower()=='a' then selected=1 elseif k:lower()=='d' then selected=2 end
            elseif e=='key' then
              if k=]====] ..
[====[=keys.left then selected=1
              elseif k==keys.right then selected=2
              elseif k==keys.enter or k==keys.numPadEnter then
                action=selected==1 and ':back' or ':cancel'
                -- Signal read() to finish with the current buffer, then
                -- override the returned result below.
                term.]====] ..
[====[setCursorPos(3,h-3)
                term.setTextColor(colors.black)
                term.write((' '):rep(math.max(1,w-4)))
                return 'key',keys.enter
              elseif k==keys.escape or k==keys.f2 then break end
            end
          end
          at(h-4,'F2: A/D SELECT BACK / EXIT',colors.yellow)
          -- Native read() resu]====] ..
[====[mes with its existing input buffer.
        else
          return table.unpack(ev)
        end
      end
    end
    local ok,value=pcall(read,nil,nil,complete)
    os.pullEvent=nativePull
    term.setCursorBlink(false)
    if not ok then error(value,0) end
    if action then return action end
    if value=='' and record[field[1]]~=nil then return ]====] ..
[====[record[field[1]] end
    return value
  end
  while true do
    if index<=total then
      local field=cat.fields[index]
      local value=fieldPrompt(index)
      local command=tostring(value):lower()
      if command==':cancel' then return nil end
      if command==':back' then
        index=math.max(1,index-1)
      elseif field[1]=='threat' and]====] ..
[====[ (not tonumber(value) or tonumber(value)<0 or tonumber(value)>5 or tonumber(value)%1~=0) then
        pause('THREAT LEVEL MUST BE 0 TO 5')
      else
        record[field[1]]=value
        index=index+1
      end
    else
      local w=term.getSize()
      local options={}
      local preview=math.max(6,math.min(18,w-28))
      for _,field in ipair]====] ..
[====[s(cat.fields) do
        local value=tostring(record[field[1]] or '')
        local label=cut(field[2],math.max(12,w-preview-11))
        options[#options+1]=label..' : '..cut(value=='' and '[EMPTY]' or value,preview)
      end
      options[#options+1]='SAVE DOSSIER / CONFIRM'
      options[#options+1]='CANCEL / DISCARD'
      local choice=UI.menu]====] ..
[====[('REVIEW '..cat.code..' / EDIT FIELDS',options)
      if not choice or choice==#options then return nil end
      if choice==#options-1 then
        if tostring(record.name or ''):match('^%s*$') then
          pause('NAME REQUIRED / EDIT FIRST FIELD')
          index=1
        else
          return record
        end
      else
        index=choice]====] ..
[====[
      end
    end
  end
end
-- OBLIVIO 3.5: category-specific, left-aligned, paged intelligence files.
-- Empty fields are grouped into a short pending-data list, not wasted rows.
local function details(cat,r)
  local w,h=term.getSize()
  local lv=levelInfo(r.threat)
  local pages={}
  local maxW=math.max(12,w-6)
  local function wrap(text)
    te]====] ..
[====[xt=tostring(text or '')
    local out={}
    repeat
      if #text<=maxW then out[#out+1]=text;break end
      local part=text:sub(1,maxW)
      local cut=part:match('^.*() ') or maxW
      if cut<math.floor(maxW/2) then cut=maxW end
      out[#out+1]=text:sub(1,cut):gsub('%s+$','')
      text=text:sub(cut+1):gsub('^%s+','')
    until text==''
    ]====] ..
[====[return out
  end
  local function addLine(page,value,color)
    for _,part in ipairs(wrap(value)) do
      page[#page+1]={text=part,color=color or colors.lightGray}
    end
  end
  local cover={}
  addLine(cover,'[ '..cat.code..' / CLASSIFIED FILE ]',cat.accent)
  addLine(cover,tostring(r.name or 'UNNAMED'),colors.white)
  addLine(cover,'THREAT: '.]====] ..
[====[.lv[1],lv[2])
  addLine(cover,'STATUS: '..tostring(r.status or 'NOT REPORTED'),colors.yellow)
  addLine(cover,'RELATION: '..tostring(r.alignment or 'UNCLASSIFIED'),colors.lightGray)
  addLine(cover,'FILE ID: '..tostring(r.id or '-'),colors.gray)
  addLine(cover,'UPDATED: '..tostring(r.updated or '-'),colors.gray)
  pages[#pages+1]={title='FILE OVER]====] ..
[====[VIEW',lines=cover}
  for _,section in ipairs(cat.sections) do
    local lines={}
    local missing={}
    for _,field in ipairs(section[2]) do
      local value=tostring(r[field[1]] or '')
      if value:match('%S') then
        addLine(lines,field[2],cat.accent)
        addLine(lines,'  '..value,colors.white)
        lines[#lines+1]={text=' ',colo]====] ..
[====[r=colors.gray}
      else
        missing[#missing+1]=field[2]
      end
    end
    if #missing>0 then
      addLine(lines,'NOT DOCUMENTED ('..#missing..')',colors.yellow)
      for _,name in ipairs(missing) do addLine(lines,'- '..name,colors.gray) end
    end
    if #lines==0 then addLine(lines,'NO INTELLIGENCE RECORDED',colors.gray) end
    page]====] ..
[====[s[#pages+1]={title=section[1],lines=lines}
  end
  local page=1
  local scroll=1
  while true do
    local current=pages[page]
    UI.header(cat.code..' / '..current.title)
    local firstY=5
    local capacity=math.max(3,h-firstY-3)
    local maxScroll=math.max(1,#current.lines-capacity+1)
    scroll=math.min(scroll,maxScroll)
    for i=scroll,mat]====] ..
[====[h.min(#current.lines,scroll+capacity-1) do
      local item=current.lines[i]
      term.setBackgroundColor(colors.black)
      term.setTextColor(item.color)
      term.setCursorPos(4,firstY+i-scroll)
      term.write(item.text:sub(1,maxW))
    end
    local hint='PAGE '..page..'/'..#pages..' | A/D PAGE | W/S SCROLL | Q EXIT'
    UI.footer(hint)
   ]====] ..
[====[ local event,key=os.pullEvent()
    if event=='key' then
      if key==keys.escape then return
      elseif key==keys.right or key==keys.enter or key==keys.space then
        if page<#pages then page=page+1;scroll=1 else return end
      elseif key==keys.left then page=math.max(1,page-1);scroll=1
      elseif key==keys.up then scroll=math.max(1,scr]====] ..
[====[oll-1)
      elseif key==keys.down then scroll=math.min(maxScroll,scroll+1) end
    elseif event=='char' then
      key=key:lower()
      if key=='q' then return
      elseif key=='d' then page=math.min(#pages,page+1);scroll=1
      elseif key=='a' then page=math.max(1,page-1);scroll=1
      elseif key=='w' then scroll=math.max(1,scroll-1)
      el]====] ..
[====[seif key=='s' then scroll=math.min(maxScroll,scroll+1) end
    end
  end
end
-- OBLIVIO 3.4: searchable intelligence registry, clean fixed layout.
local function searchPrompt(cat)
  local w,h=term.getSize()
  UI.header('INTELLIGENCE / SEARCH')
  local function line(y,text,color)
    if y<5 or y>=h-2 then return end
    term.setBackgroundColor(color]====] ..
[====[s.black)
    term.setTextColor(color or colors.lightGray)
    term.setCursorPos(3,y)
    term.write(tostring(text):sub(1,math.max(1,w-4)))
  end
  line(5,cat.label,colors.red)
  line(7,'SEARCH DATABASE',colors.yellow)
  line(8,'Name, model, faction, ID or status',colors.lightGray)
  line(10,'QUERY:',colors.white)
  line(13,'Leave blank to display e]====] ..
[====[very record.',colors.gray)
  line(14,'Type :back to return to the menu.',colors.gray)
  UI.footer('ENTER SEARCH  |  :back RETURN')
  term.setCursorPos(3,11)
  term.setTextColor(colors.white)
  local q=read()
  if q:lower()==':back' or q:lower()==':cancel' then return nil end
  return q:lower()
end
local function choose(cat)
  local query=searchProm]====] ..
[====[pt(cat)
  if query==nil then return nil end
  local filter='ALL'
  while true do
    local matches={}
    for _,r in ipairs(Data.list(cat.id)) do
      local pieces={r.name,r.model,r.type,r.faction,r.alignment,r.status,r.location,r.id}
      local hay={}
      for _,v in ipairs(pieces) do hay[#hay+1]=tostring(v or '') end
      local relationship=t]====] ..
[====[ostring(r.alignment or ''):upper()
      local accepted=(filter=='ALL' or relationship==filter)
      if accepted and (query=='' or table.concat(hay,' '):lower():find(query,1,true)) then
        matches[#matches+1]=r
      end
    end
    table.sort(matches,function(a,b)
      return tostring(a.name or ''):lower()<tostring(b.name or ''):lower()
   ]====] ..
[====[ end)
    local w=term.getSize()
    local options={}
    for _,r in ipairs(matches) do
      local level=levelInfo(r.threat)[1]
      local short=level:match('^%d%d') or '--'
      local label=tostring(r.name or 'UNKNOWN')
      local available=math.max(7,w-18)
      if #label>available then label=label:sub(1,available-3)..'...' end
      options[]====] ..
[====[#options+1]=label..'  [LV '..short..']'
    end
    local filterIndex=#options+1
    options[#options+1]='FILTER: '..filter
    local searchIndex=#options+1
    options[#options+1]='CHANGE SEARCH QUERY'
    local backIndex=#options+1
    options[#options+1]='RETURN'
    local title=cat.label..' / '..#matches..' FOUND'
    local selected=UI.menu(tit]====] ..
[====[le,options)
    if not selected or selected==backIndex then return nil end
    if selected==filterIndex then
      local n=UI.menu('RELATIONSHIP FILTER',{'ALL','ALLY','NEUTRAL','HOSTILE','UNKNOWN','RETURN'})
      if n and n<=5 then filter=({'ALL','ALLY','NEUTRAL','HOSTILE','UNKNOWN'})[n] end
    elseif selected==searchIndex then
      query=search]====] ..
[====[Prompt(cat)
      if query==nil then return nil end
    elseif matches[selected] then
      return matches[selected]
    end
  end
end
local function actions(cat,r)
  while r do
    local n=UI.menu(cat.code..' / '..tostring(r.name),{'VIEW DOSSIER','EDIT DOSSIER','DELETE DOSSIER','RETURN'})
    if not n or n==4 then return end
    if n==1 then Log.w]====] ..
[====[rite('CUSTODY','Opened '..tostring(cat.id)..' '..tostring(r.id)..' '..tostring(r.name));details(cat,r)
    elseif n==2 then
      local new=editForm(cat,r)
      if not new then pause('EDIT CANCELLED - NO CHANGES')
      elseif new.name=='' then pause('NAME IS REQUIRED')
      elseif Data.update(cat.id,r.id,new) then
        Log.write('INTEL','Upda]====] ..
[====[ted '..cat.id..' '..r.id)
        r=Data.read(cat.id,r.id);pause('DOSSIER UPDATED')
      else pause('SAVE FAILED') end
    elseif n==3 then
      UI.header('DELETE / CONFIRMATION')
      print('Delete '..tostring(r.name)..'?')
      write('Type DELETE: ')
      if read()=='DELETE' then
        if Data.delete(cat.id,r.id) then
          Log.write(']====] ..
[====[INTEL','Deleted '..cat.id..' '..r.id)
          pause('DOSSIER DELETED');return
        end
        pause('DELETE FAILED')
      end
    end
  end
end
local function categoryMenu(cat)
  while true do
    local n=UI.menu(cat.label,{'REGISTER DOSSIER','SEARCH / VIEW / EDIT','LIST ALL','RETURN'})
    if not n or n==4 then return end
    if n==1 then
 ]====] ..
[====[     local r=editForm(cat)
      if not r then pause('REGISTRATION CANCELLED')
      elseif r.name=='' then pause('NAME IS REQUIRED')
      else
        local ok,id=Data.create(cat.id,r)
        if ok then Log.write('INTEL','Created '..cat.id..' '..id) end
        pause(ok and ('FILE SAVED: '..id) or 'SAVE FAILED')
      end
    elseif n==2 then lo]====] ..
[====[cal r=choose(cat);if r then actions(cat,r) end
    elseif n==3 then
      local all=Data.list(cat.id)
      local lines={{text='FILES: '..#all,color=colors.red}}
      for _,r in ipairs(all) do
        local lv=levelInfo(r.threat)
        lines[#lines+1]={text=tostring(r.name or 'UNKNOWN')..' | '..lv[1],color=lv[2]}
      end
      if #all==0 then ]====] ..
[====[lines[#lines+1]={text='NO RECORDS'} end
      UI.block(lines,cat.label..' / INDEX')
    end
  end
end
local function threatSummary()
  local counts={0,0,0,0,0,0}
  for _,cat in ipairs(categories) do
    for _,r in ipairs(Data.list(cat.id)) do
      local n=tonumber(r.threat)
      if n and n>=0 and n<=5 and n%1==0 then counts[n+1]=counts[n+1]+1 end]====] ..
[====[
    end
  end
  local lines={{text='CLASSIFIED INTELLIGENCE SUMMARY',color=colors.red}}
  for n=0,5 do lines[#lines+1]={text=levels[n][1]..' : '..counts[n+1],color=levels[n][2]} end
  UI.block(lines,'THREAT ASSESSMENT')
end
local function passwordMenu()
  UI.header('CHANGE VAULT PASSWORD')
  write('CURRENT PASSWORD: ');local old=read('*')
  write(]====] ..
[====['NEW PASSWORD (8+): ');local new=read('*')
  write('CONFIRM NEW: ');local confirm=read('*')
  if new~=confirm then pause('PASSWORDS DO NOT MATCH');return end
  local ok,err=Secure.change(old,new)
  if ok then Log.write('VAULT','Vault password changed') end
  pause(ok and 'PASSWORD UPDATED' or tostring(err))
end
function M.unlock() return login() en]====] ..
[====[d
-- KORPS hierarchy is stored in the existing archive kinds, preserving
-- old dossiers and Pocket/central compatibility (no database migration).
local replikaCategory=categories[1]
local function branchCategory(base,extra,label,code)
  local c={id=base.id,label=label,code=code,accent=colors.red,sections={}}
  for _,section in ipairs(base.sections]====] ..
[====[) do
    local fields={}
    for _,f in ipairs(section[2]) do fields[#fields+1]=f end
    c.sections[#c.sections+1]={section[1],fields}
  end
  c.sections[#c.sections+1]={'KORPS ASSIGNMENT',extra}
  c.fields={}
  for _,section in ipairs(c.sections) do
    for _,f in ipairs(section[2]) do c.fields[#c.fields+1]=f end
  end
  return c
end
local comman]====] ..
[====[dCat=branchCategory(korpsCategories[1],{{'role','POSITION / RANK'}},'KORPS / HIGH COMMAND','KCM')
local replikaCat=branchCategory(replikaCategory,{{'korps_branch','KORPS UNIT CATEGORY'}},'KORPS / REPLIKA FORCES','KRL')
local branches={'COMBATENTES','MAGIOLOGOS','EXPLORADORES','MAQUINARIOS'}
local function classifiedList(cat,predicate)
  local out={]====] ..
[====[}
  for _,r in ipairs(Data.list(cat.id)) do
    if predicate(r) then out[#out+1]=r end
  end
  table.sort(out,function(a,b)return tostring(a.name or ''):lower()<tostring(b.name or ''):lower() end)
  return out
end
local function filteredMenu(cat,title,predicate,defaults)
  while true do
    local items=classifiedList(cat,predicate)
    local n=UI.m]====] ..
[====[enu(title..' / '..#items..' FILES',{
      'REGISTER NEW DOSSIER','OPEN / EDIT DOSSIER','LIST FILES','RETURN'})
    if not n or n==4 then return end
    if n==1 then
      local r=editForm(cat)
      if not r then pause('REGISTRATION CANCELLED')
      elseif tostring(r.name or ''):match('^%s*$') then pause('NAME IS REQUIRED')
      else
        for]====] ..
[====[ k,v in pairs(defaults or {}) do r[k]=v end
        local ok,id=Data.create(cat.id,r)
        if ok then Log.write('INTEL','Created '..cat.id..' '..tostring(id)) end
        pause(ok and ('FILE SAVED: '..tostring(id)) or 'SAVE FAILED')
      end
    elseif n==2 then
      if #items==0 then pause('NO FILES REGISTERED')
      else
        local label]====] ..
[====[s={}
        for _,r in ipairs(items) do
          labels[#labels+1]=tostring(r.name or 'UNKNOWN')..' [LV '..tostring(r.threat or '-')..']'
        end
        labels[#labels+1]='RETURN'
        local selected=UI.menu(title..' / TARGET INDEX',labels)
        if selected and selected<=#items then actions(cat,items[selected]) end
      end
    elseif]====] ..
[====[ n==3 then
      local lines={{text='REGISTERED FILES: '..#items,color=colors.red}}
      for _,r in ipairs(items) do
        lines[#lines+1]={text=tostring(r.name or 'UNKNOWN')..' | LV '..tostring(r.threat or '-'),color=colors.lightGray}
      end
      UI.block(lines,title)
    end
  end
end
local function commandMenu(role)
  filteredMenu(command]====] ..
[====[Cat,'KORPS / '..role,function(r)
    return tostring(r.role or ''):upper()==role
  end,{role=role})
end
local function replikaMenu(branch)
  filteredMenu(replikaCat,'KORPS / '..branch,function(r)
    local affiliation=tostring(r.faction or ''):upper()
    local group=tostring(r.korps_branch or ''):upper()
    return affiliation=='KORPS' and group==]====] ..
[====[branch
  end,{faction='KORPS',alignment='HOSTILE',korps_branch=branch})
end
local function replikaBranches()
  while true do
    local labels={}
    for _,b in ipairs(branches) do
      local n=#classifiedList(replikaCat,function(r)
        return tostring(r.faction or ''):upper()=='KORPS'
          and tostring(r.korps_branch or ''):upper()==b
   ]====] ..
[====[   end)
      labels[#labels+1]=b..'  ('..n..')'
    end
    labels[#labels+1]='RETURN'
    local n=UI.menu('KORPS / REPLIKA DIVISIONS',labels)
    if not n or n==#labels then return end
    replikaMenu(branches[n])
  end
end
local function korpsAssessment()
  local lines={{text='KORPS / COMMAND INTELLIGENCE',color=colors.red}}
  local groups={
   ]====] ..
[====[ {'COMANDANTE',commandCat.id,function(r)return tostring(r.role or ''):upper()=='COMANDANTE' end},
    {'CO.COMANDANTE',commandCat.id,function(r)return tostring(r.role or ''):upper()=='CO.COMANDANTE' end},
    {'CIENTISTAS','korps_scientists',function()return true end}
  }
  for _,b in ipairs(branches) do
    groups[#groups+1]={b,'replikas',function]====] ..
[====[(r)
      return tostring(r.faction or ''):upper()=='KORPS' and tostring(r.korps_branch or ''):upper()==b
    end}
  end
  for _,g in ipairs(groups) do
    local count,high=0,0
    for _,r in ipairs(Data.list(g[2])) do
      if g[3](r) then count=count+1;high=math.max(high,tonumber(r.threat) or 0) end
    end
    lines[#lines+1]={text=g[1]..': '..c]====] ..
[====[ount..'  |  MAX LV '..math.min(5,math.floor(high)),color=colors.lightGray}
  end
  UI.block(lines,'KORPS / THREAT ASSESSMENT')
end
function M.korpsMenu()
  if not login() then return end
  while true do
    local n=UI.menu('KORPS / HOSTILE INTELLIGENCE',{
      'HIGH COMMAND / COMANDANTE',
      'HIGH COMMAND / CO.COMANDANTE',
      'SCIENTISTS / R]====] ..
[====[ESEARCH DIVISION',
      'REPLIKA FORCES / 4 DIVISIONS',
      'ORGANIZATION / INSTALLATIONS',
      'THREAT ASSESSMENT',
      'RETURN TO CENTRAL COMMAND'
    })
    if not n or n==7 then return end
    if n==1 then commandMenu('COMANDANTE')
    elseif n==2 then commandMenu('CO.COMANDANTE')
    elseif n==3 then categoryMenu(korpsCategories[2])
   ]====] ..
[====[ elseif n==4 then replikaBranches()
    elseif n==5 then categoryMenu(korpsCategories[1])
    elseif n==6 then korpsAssessment() end
  end
end
function M.menu()
  if not login() then return end
  while true do
    local n=UI.menu('CLASSIFIED INTELLIGENCE',{
      'REPLIKA DOSSIERS','THREAT REGISTRY','CRITICAL INCIDENTS',
      'THREAT ASSESSMENT',']====] ..
[====[CHANGE VAULT PASSWORD','LOCK VAULT / RETURN'
    })
    if not n or n==6 then unlocked=false;Log.write('VAULT','Vault locked');return end
    if n<=3 then categoryMenu(categories[n])
    elseif n==4 then threatSummary()
    elseif n==5 then passwordMenu() end
  end
end
return M
]====]
files['lib/links.lua']=[====[-- OBLIVIO 5.1 / relations between files (Replika <-> faction <-> incident ...)
local L={}
local PATH='data/system/links.dat'
local function load()
  if not fs.exists(PATH) then return {} end
  local f=fs.open(PATH,'r');if not f then return {} end
  local raw=f.readAll();f.close()
  local ok,t=pcall(textutils.unserialize,raw)
  if ok and type(t)==']====] ..
[====[table' then return t end
  return {}
end
local function save(list)
  if not fs.exists('data/system') then fs.makeDir('data/system') end
  local f=fs.open(PATH,'w');if not f then return false end
  f.write(textutils.serialize(list));f.close()
  return true
end
function L.forRecord(kind,id)
  local out={}
  for i,l in ipairs(load()) do
    if l.a_kin]====] ..
[====[d==kind and l.a_id==id then
      out[#out+1]={index=i,kind=l.b_kind,id=l.b_id,label=l.label,dir='>'}
    elseif l.b_kind==kind and l.b_id==id then
      out[#out+1]={index=i,kind=l.a_kind,id=l.a_id,label=l.label,dir='<'}
    end
  end
  return out
end
function L.add(ak,aid,bk,bid,label)
  if ak==bk and aid==bid then return false,'Cannot link a fil]====] ..
[====[e to itself' end
  local list=load()
  for _,l in ipairs(list) do
    if (l.a_kind==ak and l.a_id==aid and l.b_kind==bk and l.b_id==bid) or
       (l.a_kind==bk and l.a_id==bid and l.b_kind==ak and l.b_id==aid) then
      return false,'Files are already linked'
    end
  end
  if #list>=500 then return false,'Link limit reached (500)' end
  list[#l]====] ..
[====[ist+1]={a_kind=ak,a_id=aid,b_kind=bk,b_id=bid,
    label=tostring(label~=nil and label~='' and label or 'RELATED'):sub(1,30),
    created=os.date('%Y-%m-%d %H:%M:%S')}
  return save(list),nil
end
function L.remove(index)
  local list=load()
  if not list[index] then return false end
  table.remove(list,index)
  return save(list)
end
function L.purg]====] ..
[====[e(kind,id)
  local list,keep={},{}
  list=load()
  for _,l in ipairs(list) do
    if not ((l.a_kind==kind and l.a_id==id) or (l.b_kind==kind and l.b_id==id)) then keep[#keep+1]=l end
  end
  return save(keep)
end
return L
]====]
files['lib/log.lua']=[====[-- OBLIVIO 5.1 / event log with operator attribution and rotation
local Log = {}
local PATH = "data/logs/events.log"
local ACTOR = "data/system/actor.dat"
local MAX_SIZE = 64000

local function ensure()
    for _, p in ipairs({ "data", "data/logs", "data/archives", "data/system" }) do
        if not fs.exists(p) then fs.makeDir(p) end
    end
end

]====] ..
[====[local function rotate()
    if fs.exists(PATH) and fs.getSize(PATH) > MAX_SIZE then
        local old = "data/archives/events_prev.log"
        if fs.exists(old) then fs.delete(old) end
        pcall(fs.move, PATH, old)
    end
end

-- The "actor" is whoever is operating right now (shown as @NAME on each line).
function Log.setActor(name)
    ensur]====] ..
[====[e()
    if name == nil then
        if fs.exists(ACTOR) then fs.delete(ACTOR) end
        return
    end
    local f = fs.open(ACTOR, "w")
    if f then f.write(tostring(name)); f.close() end
end

function Log.getActor()
    if not fs.exists(ACTOR) then return nil end
    local f = fs.open(ACTOR, "r")
    if not f then return nil end
    local s = ]====] ..
[====[f.readAll()
    f.close()
    if s == "" then return nil end
    return s
end

-- Runs fn with a temporary actor (used for Pocket / remote operations).
function Log.withActor(name, fn, ...)
    local old = Log.getActor()
    Log.setActor(name)
    local res = table.pack(pcall(fn, ...))
    Log.setActor(old)
    if not res[1] then error(res[2], 0) e]====] ..
[====[nd
    return table.unpack(res, 2, res.n)
end

function Log.write(category, message)
    ensure()
    rotate()
    local actor = Log.getActor()
    local f = fs.open(PATH, "a")
    if f then
        f.writeLine(os.date("%Y-%m-%d %H:%M:%S") .. " | " ..
            tostring(category) .. " | " .. tostring(message) ..
            (actor and (" @" .. ac]====] ..
[====[tor) or ""))
        f.close()
    end
end

function Log.readLast(maxLines)
    ensure()
    maxLines = maxLines or 12
    if not fs.exists(PATH) then return {} end
    local f = fs.open(PATH, "r")
    if not f then return {} end
    local lines = {}
    while true do
        local line = f.readLine()
        if not line then break end
        line]====] ..
[====[s[#lines + 1] = line
    end
    f.close()
    local out = {}
    for i = math.max(1, #lines - maxLines + 1), #lines do
        out[#out + 1] = lines[i]
    end
    return out
end

return Log
]====]
files['lib/net.lua']=[====[local Net = {}
local PROTOCOL = "oblivio_v2"

function Net.openAll()
    local opened = {}
    for _, name in ipairs(peripheral.getNames()) do
        if peripheral.getType(name) == "modem" then
            local ok = pcall(rednet.open, name)
            if ok then table.insert(opened, name) end
        end
    end
    return opened
end

function N]====] ..
[====[et.send(target, message)
    message.protocol = PROTOCOL
    rednet.send(target, message, PROTOCOL)
end

function Net.broadcast(message)
    message.protocol = PROTOCOL
    rednet.broadcast(message, PROTOCOL)
end

function Net.receive(timeout)
    local sender, message = rednet.receive(PROTOCOL, timeout)
    if type(message) == "table" then return ]====] ..
[====[sender, message end
    return sender, nil
end

function Net.protocol()
    return PROTOCOL
end

return Net
]====]
files['lib/peripherals.lua']=[====[local P = {}

function P.list()
    local result = {}
    for _, name in ipairs(peripheral.getNames()) do
        local types = peripheral.getType(name)
        result[#result + 1] = {
            name = name,
            type = type(types) == "table" and table.concat(types, ",") or tostring(types)
        }
    end
    return result
end

function ]====] ..
[====[P.inventories()
    local result = {}
    for _, name in ipairs(peripheral.getNames()) do
        local wrapped = peripheral.wrap(name)
        if wrapped and type(wrapped.list) == "function" then
            local ok, items = pcall(wrapped.list)
            if ok and type(items) == "table" then
                local count = 0
                for _]====] ..
[====[, item in pairs(items) do count = count + (item.count or 0) end
                result[#result + 1] = { name = name, slots = #items, itemCount = count }
            end
        end
    end
    return result
end

return P
]====]
files['lib/personnel.lua']=[====[-- OBLIVIO 2.2 personnel records: add/view/search/edit/remove without editing Lua
local UI=dofile("lib/ui.lua")
local Data=dofile("lib/data.lua")
local Log=dofile("lib/log.lua")
local P={}
-- Visual hierarchy: CC:Tweaked supports fixed-width font only.
local ranks = {
  {id="DIRECTOR", name="DIRETORIA", color=colors.orange, mark="[DIR]"},
  {id="CO]====] ..
[====[MMAND", name="ALTO COMANDO", color=colors.purple, mark="[CMD]"},
  {id="CHIEF", name="CHEFIA DE DEPARTAMENTO", color=colors.cyan, mark="[CHF]"},
  {id="RESEARCH", name="PESQUISADOR", color=colors.lightBlue, mark="[R&D]"},
  {id="SECURITY", name="SEGURANCA", color=colors.yellow, mark="[SEC]"},
  {id="OPERATIVE", name="OPERADOR", color=colors.lime, m]====] ..
[====[ark="[OPR]"},
  {id="RECRUIT", name="RECRUTA", color=colors.lightGray, mark="[REC]"},
  {id="OTHER", name="OUTRO", color=colors.white, mark="[---]"}
}
local fields={
  {"name","NAME"},{"rank","POSITION / TITLE"},
  {"department","DEPARTMENT"},{"clearance","ACCESS LEVEL"},
  {"status","STATUS"},{"notes","NOTES"}
}
local function ask(label,default)
 ]====] ..
[====[ local presets={
   ['POSITION / TITLE']={'EXECUTIONER','HUNTER','TRACKER','FIELD OPERATIVE','BLACK OPS AGENT','SPECIAL OPERATIONS OFFICER','TACTICAL COMMANDER','SQUAD LEADER','COMBAT SPECIALIST','RECON SPECIALIST','INFILTRATOR','INTELLIGENCE OFFICER','INTERROGATOR','DETENTION OFFICER','CAPTURE SPECIALIST','EXTRACTION SPECIALIST','ASSASSIN','COMMAN]====] ..
[====[DER','CO-COMMANDER','DIRECTOR','DEPARTMENT CHIEF','SCIENTIST','LEAD SCIENTIST','RESEARCHER','SENIOR RESEARCHER','MAGIOLOGIST','ARCANE ANALYST','BIOENGINEER','CYBERNETICS ENGINEER','MECHANICAL ENGINEER','ROBOTICS ENGINEER','TECHNICIAN','FIELD MEDIC','MEDICAL OFFICER','FORENSIC ANALYST','DATA ANALYST','SECURITY OFFICER','GUARD','REPLIKA HANDLER','REP]====] ..
[====[LIKA OPERATOR','EXPLORER','NAVIGATOR','LOGISTICS OFFICER','SYSTEM ADMINISTRATOR','ARCHIVIST','RECRUIT'},
   ['DEPARTMENT']={'SPECIAL OPERATIONS','BLACK OPS','HUNTER DIVISION','EXECUTION DIVISION','SEARCH & TERMINATION','SHADOW OPERATIONS','TACTICAL ENFORCEMENT','COMBAT OPERATIONS','TACTICAL RESPONSE','RECONNAISSANCE','INTELLIGENCE','COUNTERINTELLIG]====] ..
[====[ENCE','INFILTRATION','SURVEILLANCE','SECURITY','FACILITY SECURITY','CONTAINMENT','DETENTION','INTERROGATION','CAPTURE & RECOVERY','TARGET ACQUISITION','SEARCH & RESCUE','EXTRACTION','COMMAND','HIGH COMMAND','STRATEGIC OPERATIONS','SCIENCE','RESEARCH','EXPERIMENTAL DIVISION','ADVANCED RESEARCH','MAGIOLOGY','ARCANE RESEARCH','ANOMALOUS STUDIES','BIOE]====] ..
[====[NGINEERING','GENETICS','CYBERNETICS','ROBOTICS','ARTIFICIAL INTELLIGENCE','ENGINEERING','MECHANICAL ENGINEERING','SYSTEMS ENGINEERING','MAINTENANCE','LOGISTICS','SUPPLY','MEDICAL','FIELD MEDICINE','PSYCHOLOGICAL RESEARCH','FORENSICS','CHEMICAL RESEARCH','PHYSICS','ENERGY RESEARCH','ARCHIVES','DATA ANALYSIS','COMMUNICATIONS','DIPLOMACY','EXPLORATION]====] ..
[====[','FIELD RESEARCH','TECHNOLOGY DEVELOPMENT','WEAPONS RESEARCH','RISK ASSESSMENT','INTERNAL AFFAIRS','PERSONNEL','ADMINISTRATION','TRAINING','REPLIKA DEVELOPMENT','REPLIKA OPERATIONS','KORPS INTELLIGENCE'},
   ['ACCESS LEVEL']={'1','2','3','4','5'},
   ['STATUS']={'ACTIVE','INACTIVE','MISSING','SUSPENDED','DECEASED','UNKNOWN','ON MISSION','ON LEAVE']====] ..
[====[,'UNDER INVESTIGATION','CLASSIFIED','DETACHED','REASSIGNED','IN TRAINING','INJURED','CAPTURED','RETIRED','AWAITING ORDERS'}
  }
  local field=({NAME='name',['POSITION / TITLE']='rank',DEPARTMENT='department',['ACCESS LEVEL']='clearance',STATUS='status',NOTES='notes'})[label]
  local options={};local seen={}
  local function add(v)
   if v==nil then]====] ..
[====[ return end
   v=tostring(v);if v=='' or seen[v:lower()] then return end
   seen[v:lower()]=true;options[#options+1]=v
  end
  for _,v in ipairs(presets[label] or {}) do add(v) end
  if field then for _,r in ipairs(Data.list('personnel')) do add(r[field]) end end
  local function complete(input)
   local out={}
   for _,v in ipairs(options) do
    ]====] ..
[====[if v:lower():sub(1,#input)==input:lower() and #v>#input then out[#out+1]=v:sub(#input+1) end
   end
   return out
  end
  local w=term.getSize()
  term.setTextColor(colors.yellow)
  print(tostring(label):sub(1,w-4))
  term.setTextColor(colors.white);term.setCursorPos(3,9)
  local v,action=UI.fieldInput(default,complete)
  if action then return defa]====] ..
[====[ult or '' end
  if v=='' and default~=nil then return default end
  return v
end

local function rankInfo(r)
  if r and (r.special=="ZERO" or tostring(r.name or ""):upper()=="ZERO") then
    return {id="ZERO",name="AUTORIDADE SUPREMA",color=colors.red,mark="[ZERO]"}
  end
  for _,v in ipairs(ranks) do
    if v.id==tostring(r and r.rank_class or "")]====] ..
[====[ then return v end
  end
  -- Existing profiles get a visual category without changing their data.
  local txt=tostring(r and r.rank or ""):upper()
  if txt:find("DIRECTOR",1,true) or txt:find("DIRETOR",1,true) then return ranks[1] end
  if txt:find("COMMAND",1,true) or txt:find("COMANDO",1,true) then return ranks[2] end
  if txt:find("CHIEF",1,tru]====] ..
[====[e) or txt:find("CHEFE",1,true) then return ranks[3] end
  if txt:find("RESEARCH",1,true) or txt:find("PESQUIS",1,true) then return ranks[4] end
  if txt:find("SECURITY",1,true) or txt:find("SEGUR",1,true) then return ranks[5] end
  if txt:find("OPER",1,true) then return ranks[6] end
  if txt:find("RECR",1,true) then return ranks[7] end
  return ran]====] ..
[====[ks[8]
end
local function chooseRank(default)
  local current=default or 'OTHER'
  local options={'KEEP CURRENT CLASS ['..current..']'}
  for _,v in ipairs(ranks) do options[#options+1]=v.mark..' '..v.name end
  local choice=UI.menu('HIERARCHY / CLASSIFICATION',options)
  if not choice or choice==1 then return current end
  return ranks[choice-1].id]====] ..
[====[
end
local function form(old)
  local rec={}
  for i,f in ipairs(fields) do
    UI.header(old and 'EDIT MEMBER' or 'REGISTER MEMBER',string.format('FIELD %02d / %02d',i,#fields))
    term.setCursorPos(3,7)
    rec[f[1]]=ask(f[2],old and old[f[1]] or nil)
  end
  rec.rank_class=chooseRank(old and rankInfo(old).id or "OTHER")
  return rec
end
local f]====] ..
[====[unction isZero(r)
  return r and (r.special == "ZERO" or tostring(r.name or ""):upper() == "ZERO")
end
local function zeroRecord()
  for _,r in ipairs(Data.list("personnel")) do
    if isZero(r) then return r end
  end
  return nil
end
local function zeroForm(old)
  UI.header("ZERO / SUPREME AUTHORITY")
  print("IDENTITY: ZERO (LOCKED)")
  print("E]====] ..
[====[NTER keeps the current value.")
  local rec={
    name="ZERO", special="ZERO", rank_class="ZERO", rank="SUPREME DIRECTOR",
    department="OBLIVIO HIGH COMMAND", clearance="00 / ABSOLUTE",
    status="ACTIVE", notes="", title="FOUNDER / LEADER"
  }
  if old then
    for k,v in pairs(old) do rec[k]=v end
  end
  rec.name="ZERO"
  rec.special="ZERO"
]====] ..
[====[  rec.rank_class="ZERO"
  rec.rank=ask("POSITION",rec.rank)
  rec.department=ask("DEPARTMENT",rec.department)
  rec.clearance=ask("ACCESS CLASS",rec.clearance)
  rec.status=ask("STATUS",rec.status)
  rec.title=ask("DESIGNATION",rec.title)
  rec.notes=ask("NOTES",rec.notes)
  return rec
end
local function zeroDetails(r)
  UI.block({
    {text='[ ZER]====] ..
[====[O ]',color=colors.red},
    {text='SUPREME AUTHORITY',color=colors.red},
    {text='FOUNDER / LEADER',color=colors.red},
    {text='IDENTITY: ZERO'},
    {text='DESIGNATION: '..tostring(r.title or 'FOUNDER / LEADER')},
    {text='POSITION: '..tostring(r.rank or 'SUPREME DIRECTOR')},
    {text='DEPARTMENT: '..tostring(r.department or 'HIGH COMMAND')]====] ..
[====[},
    {text='ACCESS: '..tostring(r.clearance or '00 / ABSOLUTE'),color=colors.red},
    {text='STATUS: '..tostring(r.status or 'ACTIVE')},
    {text='NOTES: '..tostring(r.notes or '')},
    {text='RECORD ID: '..tostring(r.id)},
    {text='UPDATED: '..tostring(r.updated or '?')}
  },'ZERO / SUPREME AUTHORITY')
end
local function zeroMenu()
  while ]====] ..
[====[true do
    local r=zeroRecord()
    if not r then
      UI.header('ZERO / SUPREME AUTHORITY')
      print('ZERO profile not found in saved records.')
      print('Existing data was not changed.')
      print('Restore your data/personnel backup if needed.')
      UI.pause()
      return
    end
    local choice=UI.menu('ZERO / SUPREME AUTHORITY',{
]====] ..
[====[      'VIEW LEADER PROFILE','UPDATE LEADER PROFILE','RETURN'
    })
    if not choice or choice==3 then return end
    if choice==1 then zeroDetails(r)
    elseif choice==2 then
      local changed=zeroForm(r)
      local ok=Data.update('personnel',r.id,changed)
      if ok then Log.write('PERSONNEL','Updated ZERO leader profile') end
      print(o]====] ..
[====[k and 'ZERO profile updated.' or 'Save failed.')
      UI.pause()
    end
  end
end
local function details(r)
  if isZero(r) then zeroDetails(r);return end
  local v=rankInfo(r)
  local lines={
    {text=v.mark..' '..v.name,color=v.color},
    {text=tostring(r.name or 'UNNAMED'),color=v.color},
    {text='RECORD ID: '..tostring(r.id),color=colors.g]====] ..
[====[ray}
  }
  for _,f in ipairs(fields) do
    lines[#lines+1]={text=f[2]..': '..tostring(r[f[1]] or '')}
  end
  lines[#lines+1]={text='CREATED: '..tostring(r.created or '?'),color=colors.gray}
  lines[#lines+1]={text='UPDATED: '..tostring(r.updated or '?'),color=colors.gray}
  UI.block(lines,'PERSONNEL / MEMBER PROFILE')
end
local function selectRec]====] ..
[====[ord()
  UI.header("PERSONNEL / SEARCH")
  write("Name / department (blank = all): ")
  local q=read():lower()
  local matches={}
  for _,r in ipairs(Data.list("personnel")) do
    local s=(tostring(r.name or "").." "..tostring(r.department or "").." "..tostring(r.id or "")):lower()
    if q=="" or s:find(q,1,true) then matches[#matches+1]=r end
  e]====] ..
[====[nd
  if #matches==0 then print("No matching records.");UI.pause();return nil end
  local options={}
  for _,r in ipairs(matches) do
    local v=rankInfo(r)
    options[#options+1]=v.mark..' '..tostring(r.name or 'UNNAMED')..' / '..tostring(r.department or '-')
  end
  local selected=UI.menu('PERSONNEL / SELECT RECORD',options)
  return selected and]====] ..
[====[ matches[selected] or nil
end
local function editOrView(r)
  while true do
    local action=UI.menu('PERSONNEL / RECORD ACTIONS',{'VIEW PROFILE','EDIT PROFILE','DELETE PROFILE','RETURN'})
    if not action or action==4 then return end
    if action==1 then details(r)
    elseif action==2 then
      if isZero(r) then zeroMenu(); return end
      loc]====] ..
[====[al changed=form(r)
      if changed.name=="" then print("Name cannot be empty.");UI.pause()
      elseif Data.update("personnel",r.id,changed) then
        Log.write("PERSONNEL","Updated member "..r.id)
        r=Data.read("personnel",r.id)
        print("Record updated.");UI.pause()
      else print("Save failed.");UI.pause() end
    elseif action]====] ..
[====[==3 then
      if isZero(r) then
        print("ZERO profile is protected from deletion.")
        UI.pause(); return
      end
      UI.header("CONFIRM RECORD DELETION")
      print("Delete "..tostring(r.name).."? This cannot be undone.")
      write("Type DELETE to confirm: ")
      if read()=="DELETE" then
        if Data.delete("personnel",r.id]====] ..
[====[) then
          Log.write("PERSONNEL","Deleted member "..r.id)
          print("Record deleted.")
        else print("Delete failed.") end
        UI.pause();return
      end
    end
  end
end
function P.menu()
  while true do
    local choice=UI.menu("PERSONNEL / MEMBER ARCHIVES",{
      "ZERO / SUPREME AUTHORITY","REGISTER NEW MEMBER","SEARCH / ]====] ..
[====[VIEW / EDIT MEMBER","LIST ALL MEMBERS","RETURN"
    })
    if not choice or choice==5 then return end
    if choice==1 then zeroMenu()
    elseif choice==2 then
      local rec=form(nil)
      if rec.name=="" then print("Name cannot be empty.");UI.pause()
      elseif rec.name:upper()=="ZERO" then print("Use ZERO / SUPREME AUTHORITY for this name."]====] ..
[====[);UI.pause()
      else
        local ok,id=Data.create("personnel",rec)
        if ok then Log.write("PERSONNEL","Created member "..id) end
        print(ok and ("Member saved. ID: "..id) or "Save failed.")
        UI.pause()
      end
    elseif choice==3 then
      local r=selectRecord()
      if r then editOrView(r) end
    elseif choice==4 the]====] ..
[====[n
      local all=Data.list("personnel")
      local lines={{text='TOTAL MEMBERS: '..#all,color=colors.red}}
      for i,r in ipairs(all) do
        local v=rankInfo(r)
        lines[#lines+1]={text=v.mark..' '..tostring(r.name or 'UNNAMED')..' | '..tostring(r.status or ''),color=v.color}
      end
      lines[#lines+1]={text='USE SEARCH TO OPEN OR]====] ..
[====[ EDIT PROFILES',color=colors.gray}
      UI.block(lines,'PERSONNEL / SUMMARY')
    end
  end
end
return P
]====]
files['lib/pocket_server.lua']=[====[-- OBLIVIO 5.1 / authenticated Pocket data service (lockout, DEFCON, search, audit)
local M={}
local Secure=dofile('lib/secure.lua')
local Data=dofile('lib/data.lua')
local Log=dofile('lib/log.lua')
local Control=dofile('lib/control.lua')
local Alert=dofile('lib/alert.lua')
local categories={projects=true,experiments=true,missions=true,personnel=tr]====] ..
[====[ue,replikas=true,threats=true,incidents=true,korps=true,korps_scientists=true}
local pending,sessions={},{}
local function send(id,msg) msg.action=msg.action or 'MOBILE_RESULT';rednet.send(id,msg,'oblivio_v2') end
local function clean(v,depth)
  if depth>5 then return nil end
  if type(v)=='string' then return v:sub(1,4000) end
  if type(v)=='numbe]====] ..
[====[r' or type(v)=='boolean' then return v end
  if type(v)~='table' then return nil end
  local t={};local n=0
  for k,x in pairs(v) do
    if (type(k)=='string' and #k<=64 or type(k)=='number') and n<120 then
      local z=clean(x,depth+1)
      if z~=nil then t[k]=z;n=n+1 end
    end
  end
  return t
end
local function authorized(id,m)
  local sess=]====] ..
[====[sessions[id]
  return sess and sess.token==m.token and os.clock()<sess.expires
end
local function protected(kind,r)
  if kind~='personnel' then return false end
  return tostring(r.name or ''):upper()=='ZERO' or tostring(r.codename or ''):upper()=='ZERO'
end
local function archiveList()
  local out={}
  for _,kind in ipairs({'archives','logs'}) do
]====] ..
[====[    local path='data/'..kind
    if fs.exists(path) and fs.isDir(path) then
      for _,name in ipairs(fs.list(path)) do
        if not fs.isDir(path..'/'..name) then out[#out+1]={kind=kind,name=name} end
      end
    end
  end
  return out
end
local function matches(r,q)
  if not q or q=='' then return true end
  q=tostring(q):lower():sub(1,60)
 ]====] ..
[====[ local hay={}
  for _,k in ipairs({'name','codename','status','faction','location','type','alignment','id','model','commander'}) do
    if r[k]~=nil then hay[#hay+1]=tostring(r[k]) end
  end
  return table.concat(hay,' '):lower():find(q,1,true)~=nil
end
local function statusRows(cfg)
  local okS,s=pcall(Control.readSensors,cfg.sensors or {})
  loca]====] ..
[====[l okO,o=pcall(Control.outputStatus,cfg.outputs or {})
  local alarms,sc,on,oc=0,0,0,0
  if okS and type(s)=='table' then for _,v in pairs(s) do sc=sc+1;if v then alarms=alarms+1 end end end
  if okO and type(o)=='table' then for _,v in pairs(o) do oc=oc+1;if v then on=on+1 end end end
  local function n(kind) local ok,c=pcall(Data.count,kind);retur]====] ..
[====[n ok and c or 0 end
  return {
    Alert.label(),
    'CORE: ONLINE  NODE '..os.getComputerID(),
    'SENSORS: '..sc..'  TRIGGERED: '..alarms,
    'OUTPUTS ON: '..on..'/'..oc,
    'REPLIKAS: '..n('replikas'),
    'THREATS: '..n('threats'),
    'INCIDENTS: '..n('incidents'),
    'KORPS: '..n('korps')..'  SCIENTISTS: '..n('korps_scientists'),
    'PE]====] ..
[====[RSONNEL: '..n('personnel'),
    'PROJECTS: '..n('projects')..'  EXPERIMENTS: '..n('experiments'),
    'MISSIONS: '..n('missions')
  }
end
function M.handle(id,m,cfg)
  if m.action=='MOBILE_CHALLENGE' then
    local info=Secure.challengeInfo()
    if not info then send(id,{action='MOBILE_CHALLENGE_RESULT',ok=false,error='Vault not configured'});retu]====] ..
[====[rn true end
    local locked,wait=Alert.locked('mobile:'..id)
    if locked then send(id,{action='MOBILE_CHALLENGE_RESULT',ok=false,error='Locked for '..wait..'s'});return true end
    local nonce=Secure.sha256(tostring(os.epoch('utc'))..':'..tostring(math.random())..':'..tostring(id)..':'..tostring(os.clock()))
    pending[id]={nonce=nonce,expires]====] ..
[====[=os.clock()+45}
    send(id,{action='MOBILE_CHALLENGE_RESULT',ok=true,nonce=nonce,salt=info.salt,rounds=info.rounds})
    return true
  elseif m.action=='MOBILE_LOGIN' then
    local key='mobile:'..id
    local locked,wait=Alert.locked(key)
    local p=pending[id];pending[id]=nil
    if locked then
      send(id,{action='MOBILE_LOGIN_RESULT',ok=fal]====] ..
[====[se,error='Locked for '..wait..'s'})
      return true
    end
    local ok=p and os.clock()<p.expires and Secure.verifyChallenge(m.proof,p.nonce)
    if ok then
      Alert.clear(key)
      local token=Secure.sha256(tostring(os.epoch('utc'))..':'..tostring(math.random())..':'..tostring(id)..':'..tostring(os.clock()))
      sessions[id]={token=token]====] ..
[====[,expires=os.clock()+1800}
      Log.write('MOBILE_AUTH','Pocket '..id..' authenticated')
      send(id,{action='MOBILE_LOGIN_RESULT',ok=true,token=token})
    else
      local n=Alert.fail(key)
      Log.write('MOBILE_AUTH','Pocket '..id..' rejected (failure '..n..')')
      send(id,{action='MOBILE_LOGIN_RESULT',ok=false,error='Access denied'})
   ]====] ..
[====[ end
    return true
  elseif m.action=='MOBILE_DATA' then
    if not authorized(id,m) then send(id,{ok=false,error='Session expired; log in again'});return true end
    sessions[id].expires=os.clock()+1800
    local kind=m.kind
    if m.op=='categories' then
      send(id,{ok=true,data={'status','replikas','threats','incidents','korps','korps_scie]====] ..
[====[ntists','personnel','projects','experiments','missions','archives','logs','infrastructure','defcon'}})
    elseif kind=='status' then
      local out={}
      for i,row in ipairs(statusRows(cfg)) do out[#out+1]={id=tostring(i),name=row} end
      send(id,{ok=true,data=out})
    elseif kind=='defcon' then
      if m.op=='list' then
        local cur]====] ..
[====[rent=Alert.get()
        local out={}
        for lv=5,1,-1 do
          out[#out+1]={id=tostring(lv),name='DEFCON '..lv..' '..Alert.levels()[lv].name,status=lv==current and 'ACTIVE' or nil}
        end
        send(id,{ok=true,data=out})
      elseif m.op=='toggle' then
        local lv=tonumber(m.id)
        if not lv or not Alert.levels()[lv] th]====] ..
[====[en send(id,{ok=false,error='Invalid level'});return true end
        local ok=Alert.change(lv,'POCKET '..id)
        send(id,{ok=ok,error=ok and nil or 'Save failed'})
      else send(id,{ok=false,error='Unknown operation'}) end
    elseif categories[kind] then
      if m.op=='list' then
        local items=Data.list(kind);local out={}
        for ]====] ..
[====[_,r in ipairs(items) do if #out<300 and matches(r,m.query) then out[#out+1]={id=r.id,name=r.name or r.codename or r.title or 'UNNAMED',status=r.status,threat=r.threat or r.threat_level} end end
        send(id,{ok=true,data=out})
      elseif m.op=='read' then
        local r=Data.read(kind,m.id or '')
        send(id,{ok=r~=nil,data=r,error=r and ]====] ..
[====[nil or 'Record not found'})
      elseif m.op=='create' then
        if type(m.record)~='table' then send(id,{ok=false,error='Invalid record'});return true end
        local ok,rid=Log.withActor('POCKET '..id,Data.create,kind,clean(m.record,0))
        Log.write('MOBILE_WRITE','Pocket '..id..' created '..kind)
        send(id,{ok=ok,id=rid})
      ]====] ..
[====[elseif m.op=='update' then
        local old=Data.read(kind,m.id or '')
        if not old or type(m.record)~='table' then send(id,{ok=false,error='Record missing'});return true end
        local record=clean(m.record,0)
        if protected(kind,old) and not protected(kind,record) then send(id,{ok=false,error='ZERO identity protected'});return tru]====] ..
[====[e end
        local ok=Log.withActor('POCKET '..id,Data.update,kind,m.id,record)
        Log.write('MOBILE_WRITE','Pocket '..id..' updated '..kind)
        send(id,{ok=ok})
      elseif m.op=='delete' then
        local old=Data.read(kind,m.id or '')
        if not old then send(id,{ok=false,error='Not found'});return true end
        if protected(]====] ..
[====[kind,old) then send(id,{ok=false,error='ZERO cannot be deleted'});return true end
        local ok=Log.withActor('POCKET '..id,Data.delete,kind,m.id)
        Log.write('MOBILE_WRITE','Pocket '..id..' deleted '..kind..' (moved to archives)')
        send(id,{ok=ok})
      else send(id,{ok=false,error='Unknown operation'}) end
    elseif kind=='archi]====] ..
[====[ves' or kind=='logs' then
      if m.op=='list' then
        local out={}
        for _,v in ipairs(archiveList()) do if v.kind==kind then out[#out+1]={id=v.name,name=v.name} end end
        send(id,{ok=true,data=out})
      elseif m.op=='read' then
        local name=tostring(m.id or '')
        if not name:match('^[%w%._%-]+$') or name:find('..',]====] ..
[====[1,true) then send(id,{ok=false,error='Invalid name'});return true end
        local path='data/'..kind..'/'..name
        local f=fs.open(path,'r')
        if not f then send(id,{ok=false,error='File not found'});return true end
        local body=f.read(12000) or '';f.close()
        send(id,{ok=true,data={name=name,content=body}})
      else send]====] ..
[====[(id,{ok=false,error='Archive is read only'}) end
    elseif kind=='infrastructure' then
      local outs=cfg.outputs or {}
      if m.op=='list' then
        local states=Control.outputStatus(outs)
        local out={}
        for name,state in pairs(states) do out[#out+1]={id=name,name=name,status=state and 'ON' or 'OFF'} end
        table.sort(ou]====] ..
[====[t,function(a,b)return a.name<b.name end)
        send(id,{ok=true,data=out})
      elseif m.op=='toggle' then
        if not outs[m.id or ''] then send(id,{ok=false,error='Unknown output'});return true end
        local ok,detail=Control.toggle(outs,m.id)
        Log.write('MOBILE_CONTROL','Pocket '..id..' '..tostring(m.id)..' '..tostring(detail))
]====] ..
[====[        send(id,{ok=ok,error=ok and nil or detail})
      else send(id,{ok=false,error='Unknown operation'}) end
    else send(id,{ok=false,error='Invalid category'}) end
    return true
  end
  return false
end
return M
]====]
files['lib/report.lua']=[====[-- OBLIVIO 5.1 / daily briefing builder, archive and printer output
local Data=dofile('lib/data.lua')
local Control=dofile('lib/control.lua')
local Alert=dofile('lib/alert.lua')
local Log=dofile('lib/log.lua')
local R={}
local publicCats={SENSOR=true,DEFCON=true,LOCKDOWN=true,SYSTEM=true,CONTROL=true,REMOTE_CONTROL=true,MOBILE_CONTROL=true}
local f]====] ..
[====[unction safe(fn,default)
  local ok,v=pcall(fn)
  if ok and v~=nil then return v end
  return default
end
function R.build(cfg)
  local lines={}
  local function add(text,color) lines[#lines+1]={text=tostring(text),color=color} end
  local level,info=Alert.info()
  add('OBLIVIO DAILY BRIEFING',colors.red)
  add(os.date('%Y-%m-%d %H:%M'),colors.gray]====] ..
[====[)
  add('')
  add(Alert.label(),info.color)
  local sensors=safe(function() return Control.readSensors(cfg.sensors or {}) end,{})
  local outputs=safe(function() return Control.outputStatus(cfg.outputs or {}) end,{})
  local triggered,total,on,totalO={},0,0,0
  for name,state in pairs(sensors) do total=total+1;if state then triggered[#triggered+1]=]====] ..
[====[name end end
  for _,state in pairs(outputs) do totalO=totalO+1;if state then on=on+1 end end
  table.sort(triggered)
  add('SENSORS: '..total..'  TRIGGERED: '..#triggered,#triggered>0 and colors.red or colors.lime)
  for _,name in ipairs(triggered) do add('  ! '..name,colors.red) end
  add('OUTPUTS ON: '..on..'/'..totalO)
  add('')
  local highest]====] ..
[====[,hostile,open=0,0,0
  for _,kind in ipairs({'replikas','threats','incidents','korps','korps_scientists'}) do
    for _,r in ipairs(safe(function() return Data.list(kind) end,{})) do
      local n=tonumber(r.threat or r.threat_level)
      if n then highest=math.max(highest,math.max(0,math.min(5,math.floor(n)))) end
      if kind=='replikas' and tos]====] ..
[====[tring(r.alignment or ''):upper()=='HOSTILE' then hostile=hostile+1 end
      if kind=='incidents' then
        local s=tostring(r.status or ''):upper()
        if s~='CLOSED' and s~='RESOLVED' and s~='CONTAINED' then open=open+1 end
      end
    end
  end
  add('INTELLIGENCE',colors.orange)
  add('  REPLIKAS: '..Data.count('replikas')..'  HOSTILE:]====] ..
[====[ '..hostile)
  add('  THREATS: '..Data.count('threats'))
  add('  INCIDENTS: '..Data.count('incidents')..'  OPEN: '..open,open>0 and colors.yellow or nil)
  add('  KORPS: '..Data.count('korps')..'  SCIENTISTS: '..Data.count('korps_scientists'))
  add('  HIGHEST THREAT: '..highest..'/5',highest>=4 and colors.red or colors.lime)
  add('')
  add('OPER]====] ..
[====[ATIONS',colors.cyan)
  add('  PROJECTS: '..Data.count('projects')..'  EXPERIMENTS: '..Data.count('experiments'))
  add('  PERSONNEL: '..Data.count('personnel'))
  local active={}
  for _,m in ipairs(safe(function() return Data.list('missions') end,{})) do
    if tostring(m.status or ''):upper()=='ACTIVE' then active[#active+1]=tostring(m.name or 'U]====] ..
[====[NNAMED') end
  end
  add('  MISSIONS: '..Data.count('missions')..'  ACTIVE: '..#active)
  for _,name in ipairs(active) do add('   > '..name,colors.lime) end
  add('')
  add('RECENT ALERTS',colors.yellow)
  local shown=0
  local entries=Log.readLast(150)
  for i=#entries,1,-1 do
    local time,cat,msg=entries[i]:match('^%S+ (%S+) | (%S+) | (.*)$')
 ]====] ..
[====[   if cat and publicCats[cat] and cat~='SYSTEM' and cat~='CONTROL' then
      add('  '..time:sub(1,5)..' '..cat..' '..msg,colors.lightGray)
      shown=shown+1
      if shown>=6 then break end
    end
  end
  if shown==0 then add('  NO RECENT ALERTS',colors.gray) end
  return lines
end
function R.plain(lines)
  local out={}
  for _,l in ipairs(line]====] ..
[====[s) do out[#out+1]=l.text end
  return out
end
function R.save(strings)
  if not fs.exists('data/archives') then fs.makeDir('data/archives') end
  local path='data/archives/briefing_'..os.date('%Y%m%d_%H%M%S')..'.txt'
  local f=fs.open(path,'w')
  if not f then return nil end
  for _,s in ipairs(strings) do f.writeLine(s) end
  f.close()
  return pa]====] ..
[====[th
end
function R.print(strings,title)
  local p=peripheral.find and peripheral.find('printer') or nil
  if not p then return false,'No printer attached' end
  local wrapped={}
  for _,s in ipairs(strings) do
    s=tostring(s)
    if s=='' then wrapped[#wrapped+1]='' end
    while #s>0 do wrapped[#wrapped+1]=s:sub(1,25);s=s:sub(26) end
  end
  loca]====] ..
[====[l page,i=0,1
  while i<=#wrapped do
    if not p.newPage() then return false,'Printer needs paper and ink' end
    page=page+1
    p.setPageTitle((title or 'OBLIVIO')..' '..page)
    local w,h=p.getPageSize()
    for y=1,h do
      if i>#wrapped then break end
      p.setCursorPos(1,y)
      p.write(wrapped[i]:sub(1,w))
      i=i+1
    end
    if n]====] ..
[====[ot p.endPage() then return false,'Could not finish the page' end
  end
  return true,page..' page(s) printed'
end
return R
]====]
files['lib/secure.lua']=[====[-- OBLIVIO 3.0: SHA-256 salted, iterated password verifier.
-- Passwords are not stored; records themselves are NOT encrypted at rest.
local S={}
local b=bit32
local band,bor,bxor,bnot,rshift,lshift,rrotate=b.band,b.bor,b.bxor,b.bnot,b.rshift,b.lshift,b.rrotate
local K={
0x428a2f98,0x71374491,0xb5c0fbcf,0xe9b5dba5,0x3956c25b,0x59f111f1,0x923f82a4,0]====] ..
[====[xab1c5ed5,
0xd807aa98,0x12835b01,0x243185be,0x550c7dc3,0x72be5d74,0x80deb1fe,0x9bdc06a7,0xc19bf174,
0xe49b69c1,0xefbe4786,0x0fc19dc6,0x240ca1cc,0x2de92c6f,0x4a7484aa,0x5cb0a9dc,0x76f988da,
0x983e5152,0xa831c66d,0xb00327c8,0xbf597fc7,0xc6e00bf3,0xd5a79147,0x06ca6351,0x14292967,
0x27b70a85,0x2e1b2138,0x4d2c6dfc,0x53380d13,0x650a7354,0x766a0abb,0x81c2]====] ..
[====[c92e,0x92722c85,
0xa2bfe8a1,0xa81a664b,0xc24b8b70,0xc76c51a3,0xd192e819,0xd6990624,0xf40e3585,0x106aa070,
0x19a4c116,0x1e376c08,0x2748774c,0x34b0bcb5,0x391c0cb3,0x4ed8aa4a,0x5b9cca4f,0x682e6ff3,
0x748f82ee,0x78a5636f,0x84c87814,0x8cc70208,0x90befffa,0xa4506ceb,0xbef9a3f7,0xc67178f2}
local function add(...) local n=0 for i=1,select('#',...) do n=(n+]====] ..
[====[select(i,...))%4294967296 end return n end
function S.sha256(msg)
  msg=tostring(msg or '')
  local bytes={msg:byte(1,#msg)};local bitlen=#bytes*8
  bytes[#bytes+1]=128
  while (#bytes%64)~=56 do bytes[#bytes+1]=0 end
  local high=math.floor(bitlen/4294967296);local low=bitlen%4294967296
  for _,v in ipairs({high,low}) do for j=3,0,-1 do bytes[#byt]====] ..
[====[es+1]=band(rshift(v,j*8),255) end end
  local H={0x6a09e667,0xbb67ae85,0x3c6ef372,0xa54ff53a,0x510e527f,0x9b05688c,0x1f83d9ab,0x5be0cd19}
  for pos=1,#bytes,64 do
    local w={}
    for i=0,15 do local j=pos+i*4;w[i]=add(lshift(bytes[j],24),lshift(bytes[j+1],16),lshift(bytes[j+2],8),bytes[j+3]) end
    for i=16,63 do
      local x=w[i-15];local y=w]====] ..
[====[[i-2]
      local s0=bxor(rrotate(x,7),rrotate(x,18),rshift(x,3))
      local s1=bxor(rrotate(y,17),rrotate(y,19),rshift(y,10))
      w[i]=add(w[i-16],s0,w[i-7],s1)
    end
    local a,c,d,e,f,g,h,j=H[1],H[2],H[3],H[4],H[5],H[6],H[7],H[8]
    for i=0,63 do
      local s1=bxor(rrotate(f,6),rrotate(f,11),rrotate(f,25))
      local ch=bxor(band(f,g),b]====] ..
[====[and(bnot(f),h))
      local t1=add(j,s1,ch,K[i+1],w[i])
      local s0=bxor(rrotate(a,2),rrotate(a,13),rrotate(a,22))
      local maj=bxor(band(a,c),band(a,d),band(c,d))
      local t2=add(s0,maj)
      a,c,d,e,f,g,h,j=add(t1,t2),a,c,d,add(e,t1),f,g,h
    end
    for i,v in ipairs({a,c,d,e,f,g,h,j}) do H[i]=add(H[i],v) end
  end
  local res={} for ]====] ..
[====[i=1,8 do res[i]=string.format('%08x',H[i]) end
  return table.concat(res)
end
local path='data/security/vault.dat'
local function readConfig()
  if not fs.exists(path) then return nil end
  local f=fs.open(path,'r');if not f then return nil end
  local raw=f.readAll();f.close()
  local ok,t=pcall(textutils.unserialize,raw)
  if ok and type(t)=='tab]====] ..
[====[le' and t.salt and t.hash and t.rounds then return t end
  return nil
end
local function digest(password,salt,rounds)
  local value=S.sha256(salt..':'..password)
  for i=2,rounds do value=S.sha256(value..':'..salt) end
  return value
end
local function equal(a,c)
  if type(a)~='string' or type(c)~='string' then return false end
  local x=bxor(#a,#c]====] ..
[====[)
  for i=1,math.max(#a,#c) do x=bor(x,bxor(a:byte(i) or 0,c:byte(i) or 0)) end
  return x==0
end
function S.configured() return readConfig()~=nil end
function S.challengeInfo()
  local v=readConfig()
  if not v then return nil end
  return {salt=v.salt,rounds=v.rounds}
end
function S.verifyChallenge(proof,nonce)
  local v=readConfig()
  if not v o]====] ..
[====[r type(proof)~='string' or type(nonce)~='string' then return false end
  return equal(proof,S.sha256(v.hash..':'..nonce))
end
function S.proof(password,salt,rounds,nonce)
  rounds=tonumber(rounds)
  if type(salt)~='string' or type(nonce)~='string' or not rounds or rounds<1 or rounds>100000 then return nil end
  return S.sha256(digest(password,salt,]====] ..
[====[rounds)..':'..nonce)
end
function S.setup(password)
  if S.configured() then return false,'Already configured' end
  if type(password)~='string' or #password<8 then return false,'Use at least 8 characters' end
  fs.makeDir('data/security')
  local salt=S.sha256(tostring(os.epoch('utc'))..':'..tostring(os.getComputerID())..':'..tostring(math.random(]====] ..
[====[))..':'..tostring(os.clock()))
  local rounds=1200
  local f=fs.open(path,'w');if not f then return false,'Cannot write vault' end
  f.write(textutils.serialize({version=1,algo='SHA256-ITERATED',salt=salt,rounds=rounds,hash=digest(password,salt,rounds)}));f.close()
  return true
end
function S.verify(password)
  local v=readConfig();if not v then r]====] ..
[====[eturn false end
  return equal(v.hash,digest(password,v.salt,v.rounds))
end
function S.change(old,new)
  if not S.verify(old) then return false,'Invalid old password' end
  if #new<8 then return false,'Use at least 8 characters' end
  local v=readConfig();v.hash=digest(new,v.salt,v.rounds)
  local f=fs.open(path,'w');if not f then return false,'Can]====] ..
[====[not write vault' end
  f.write(textutils.serialize(v));f.close();return true
end
return S
]====]
files['lib/theme.lua']=[====[-- OBLIVIO 5.1 / color themes (set cfg.theme = 'military' | 'amber' | 'phosphor' | 'ice')
local T={}
local themes={
  military={accent=colors.red,sub=colors.orange},
  amber={accent=colors.orange,sub=colors.yellow},
  phosphor={accent=colors.lime,sub=colors.green},
  ice={accent=colors.cyan,sub=colors.lightBlue}
}
local current
local alertMod
local]====] ..
[====[ function theme()
  if current then return current end
  local name='military'
  local ok,cfg=pcall(dofile,'config.lua')
  if ok and type(cfg)=='table' and themes[cfg.theme or ''] then name=cfg.theme end
  current=themes[name]
  return current
end
local function alert()
  if alertMod==nil then
    local ok,m=pcall(dofile,'lib/alert.lua')
    alertM]====] ..
[====[od=(ok and type(m)=='table') and m or false
  end
  return alertMod or nil
end
function T.get() return theme() end
-- DEFCON level and its color, or nil when the alert module is missing (Pocket).
function T.defcon()
  local A=alert()
  if not A then return nil end
  local lv=A.get()
  return lv,A.levels()[lv].color
end
-- Accent follows the theme, ]====] ..
[====[but turns DEFCON-colored at levels 2 and 1.
function T.accent()
  local lv,col=T.defcon()
  if lv and lv<=2 then return col end
  return theme().accent
end
function T.sub() return theme().sub end
return T
]====]
files['lib/ui.lua']=[====[-- OBLIVIO 5.1 / UI toolkit (themed, DEFCON-aware)
local UI = {}
local okT,Theme=pcall(dofile,'lib/theme.lua')
if not okT or type(Theme)~='table' then Theme=nil end
local function accent() return Theme and Theme.accent() or colors.red end
UI.accent=accent
function UI.size() return term.getSize() end
function UI.clear()
  term.setBackgroundColor(col]====] ..
[====[ors.black);term.setTextColor(colors.white)
  term.clear();term.setCursorPos(1,1)
end
function UI.center(y,text,color)
  local w=term.getSize();text=tostring(text or '')
  term.setTextColor(color or colors.white)
  term.setCursorPos(math.max(1,math.floor((w-math.min(#text,w))/2)+1),y)
  term.write(text:sub(1,w))
end
function UI.line(y)
  local w=ter]====] ..
[====[m.getSize();term.setTextColor(accent())
  term.setCursorPos(1,y);term.write(string.rep('-',w))
end
-- Colored progress bar made of background-filled cells (works on term or a monitor).
function UI.bar(x,y,width,value,max,color,target)
  target=target or term
  value=tonumber(value) or 0
  max=math.max(1,tonumber(max) or 1)
  local filled=math.floor]====] ..
[====[(math.min(1,math.max(0,value/max))*width+0.5)
  if value>0 and filled==0 then filled=1 end
  target.setCursorPos(x,y)
  if filled>0 then target.setBackgroundColor(color or colors.lime);target.write((' '):rep(filled)) end
  if width-filled>0 then target.setBackgroundColor(colors.gray);target.write((' '):rep(width-filled)) end
  target.setBackgroundC]====] ..
[====[olor(colors.black)
end
function UI.header(title,subtitle)
  UI.clear()
  local w=term.getSize()
  UI.center(1,'O B L I V I O   O S   //   CENTRAL COMMAND',accent())
  if Theme then
    local lv,col=Theme.defcon()
    if lv then
      local tag=' D'..lv..' '
      term.setCursorPos(math.max(1,w-#tag+1),1)
      term.setBackgroundColor(col);term.setT]====] ..
[====[extColor(colors.black);term.write(tag)
      term.setBackgroundColor(colors.black)
    end
  end
  UI.line(2)
  UI.center(3,'[ '..tostring(title or 'COMMAND INTERFACE')..' ]',colors.lightGray)
  if subtitle then UI.center(4,tostring(subtitle),colors.gray) end
end
function UI.footer(text)
  local _,h=term.getSize();UI.line(h-1)
  UI.center(h,text or]====] ..
[====[ 'W/S SELECT | ENTER/SPACE OPEN | NUMBER + ENTER',colors.gray)
end
function UI.message(text,color)
  term.setTextColor(color or colors.white);print(tostring(text))
end
function UI.confirm(text,title)
  UI.header(title or 'CONFIRMATION')
  UI.center(7,text,colors.yellow)
  UI.center(9,'[Y] YES        [N] NO',colors.lightGray)
  UI.footer('Y CONFIRM ]====] ..
[====[| N / Q / ESC CANCEL')
  while true do
    local e,k=os.pullEvent()
    if e=='char' then
      k=k:lower()
      if k=='y' then return true elseif k=='n' or k=='q' then return false end
    elseif e=='key' and k==keys.escape then return false end
  end
end
-- Navigation: W/S, up/down, ENTER/SPACE; number + ENTER; Q/ESC to return.
function UI.menu(]====] ..
[====[title,items)
  if #items==0 then return nil end
  local selected=1;local digits='';local offset=1
  while true do
    local w,h=term.getSize()
    local firstY=6;local count=math.max(1,h-firstY-4)
    if selected<offset then offset=selected end
    if selected>=offset+count then offset=selected-count+1 end
    UI.header(title)
    local ac=accent()]====] ..
[====[
    for j=1,count do
      local i=offset+j-1
      if i>#items then break end
      local y=firstY+j-1
      local active=i==selected
      term.setBackgroundColor(active and ac or colors.black)
      term.setTextColor(active and colors.black or colors.lightGray)
      local label=string.format('%02d  %s',i,tostring(items[i]))
      local marker=]====] ..
[====[active and '> ' or '  '
      local display=(marker..label):sub(1,math.max(1,w-2))
      term.setCursorPos(3,y)
      term.write(display)
      term.setBackgroundColor(colors.black)
    end
    if #items>count then
      term.setTextColor(colors.gray)
      if offset>1 then term.setCursorPos(w,firstY);term.write('^') end
      if offset+count-1<#it]====] ..
[====[ems then term.setCursorPos(w,firstY+count-1);term.write('v') end
    end
    term.setTextColor(colors.yellow)
    local hint=digits~='' and ('NUMBER: '..digits..'  [ENTER]') or ('SELECTED '..selected..' / '..#items)
    UI.center(h-3,hint,colors.yellow)
    UI.footer('OBLIVIO OS | W/S MOVE | ENTER SELECT | Q BACK')
    local event,a=os.pullEvent()
]====] ..
[====[    if event=='key' then
      if a==keys.up then selected=math.max(1,selected-1);digits=''
      elseif a==keys.down then selected=math.min(#items,selected+1);digits=''
      elseif a==keys.enter or a==keys.numPadEnter or a==keys.space then
        if digits~='' then
          local n=tonumber(digits)
          if n and n>=1 and n<=#items then ret]====] ..
[====[urn n end
          digits=''
        else return selected end
      elseif a==keys.backspace then digits=digits:sub(1,-2)
      elseif a==keys.escape then return nil end
    elseif event=='char' then
      local c=a:lower()
      if c=='w' then selected=math.max(1,selected-1);digits=''
      elseif c=='s' then selected=math.min(#items,selected+1);]====] ..
[====[digits=''
      elseif c=='q' then return nil
      elseif c:match('%d') then digits=(digits..c):sub(1,4) end
    elseif event=='paste' then
      local pasted=tostring(a):match('^%s*(%d+)%s*$')
      if pasted then digits=pasted:sub(1,4) end
    elseif event=='term_resize' then offset=1 end
  end
end
-- Centered text with safe word wrapping and op]====] ..
[====[tional page breaks.
function UI.block(lines, title)
  local w,h=term.getSize()
  local maxWidth=math.max(8,w-4)
  local expanded={}
  for _,item in ipairs(lines) do
    local value=tostring(item.text or '')
    if value=='' then value=' ' end
    while #value>maxWidth do
      local split=maxWidth
      local prefix=value:sub(1,maxWidth)
      loca]====] ..
[====[l space=prefix:match('^.*() ')
      if space and space>math.floor(maxWidth/2) then split=space end
      expanded[#expanded+1]={text=value:sub(1,split):gsub('%s+$',''),color=item.color}
      value=value:sub(split+1):gsub('^%s+','')
    end
    expanded[#expanded+1]={text=value,color=item.color}
  end
  local perPage=math.max(1,h-8)
  local page=1]====] ..
[====[
  repeat
    UI.header(title or 'ARCHIVE RECORD')
    local first=(page-1)*perPage+1
    for i=first,math.min(#expanded,first+perPage-1) do
      UI.center(5+i-first,expanded[i].text,expanded[i].color or colors.white)
    end
    local pages=math.max(1,math.ceil(#expanded/perPage))
    UI.footer('ENTER/SPACE NEXT | Q/ESC BACK | '..page..'/'..pages]====] ..
[====[)
    while true do
      local event,key=os.pullEvent()
      if event=='key' then
        if key==keys.enter or key==keys.numPadEnter or key==keys.space then
          page=page+1;break
        elseif key==keys.escape then return end
      elseif event=='char' and key:lower()=='q' then return end
    end
  until page>math.max(1,math.ceil(#expande]====] ..
[====[d/perPage))
end

-- OBLIVIO 5.3: unified dossier editor, real suggestion list on TAB.
-- completion(input) returns suffixes, as in CC:Tweaked read().
function UI.fieldInput(default,completion,opts)
 opts=opts or {}
 local w,h=term.getSize()
 local startX,startY=term.getCursorPos()
 -- Ensure input is never written over another field or the fixed fo]====] ..
[====[oter.
 if startX>math.max(4,w-12) then startX=3;startY=startY+1 end
 if startY>=h-5 then
  UI.header('DOSSIER / INPUT')
  startX,startY=3,7
 end
 term.setCursorPos(startX,startY)
 local value,cursor='',1
 local candidates,chosen={},0
 local nav=false;local action=1
 local mask=opts.mask
 local function refresh()
  w,h=term.getSize()
  local availab]====] ..
[====[le=math.max(1,w-startX+1)
  local shown=mask and string.rep('*',#value) or value
  local scroll=math.max(0,cursor-available)
  term.setBackgroundColor(colors.black)
  term.setCursorPos(startX,startY)
  term.write(string.rep(' ',available))
  term.setCursorPos(startX,startY)
  term.setTextColor(colors.white)
  term.write(shown:sub(scroll+1,scroll+av]====] ..
[====[ailable))
  if h>=7 then
   local y=h-3
   term.setCursorPos(1,y);term.setBackgroundColor(colors.black)
   term.write(string.rep(' ',w))
   term.setCursorPos(1,y)
   if nav then
    term.setTextColor(action==1 and colors.yellow or colors.gray)
    term.write(action==1 and '[ BACK ]' or '  BACK  ')
    term.setTextColor(action==2 and colors.red or c]====] ..
[====[olors.gray)
    term.write(action==2 and '  [ EXIT ]' or '    EXIT  ')
   elseif #candidates>0 then
    term.setTextColor(colors.yellow)
    local bits={}
    for i=1,math.min(3,#candidates) do
     local text=tostring(candidates[i]):gsub('[\r\n]',' ')
     bits[#bits+1]=(i==chosen and '['..text..']' or text)
    end
    term.write(('TAB: '..table.]====] ..
[====[concat(bits,'  ')):sub(1,w))
   else
    term.setTextColor(colors.gray)
    term.write('TAB SUGGESTIONS  |  F2 BACK / EXIT')
   end
  end
  term.setCursorPos(math.min(w,startX+cursor-1-scroll),startY)
  term.setCursorBlink(not nav)
 end
 local function reset() candidates={};chosen=0 end
 while true do
  refresh()
  local e,k=os.pullEvent()
  if e==]====] ..
[====['char' then
   if nav then
    if k:lower()=='a' then action=1 elseif k:lower()=='d' then action=2 end
   else
    value=value:sub(1,cursor-1)..k..value:sub(cursor)
    cursor=cursor+#k;reset()
   end
  elseif e=='paste' and not nav then
   value=value:sub(1,cursor-1)..k..value:sub(cursor)
   cursor=cursor+#k;reset()
  elseif e=='key' then
   if k=]====] ..
[====[=keys.f2 then nav=not nav;reset()
   elseif nav then
    if k==keys.left or k==keys.a then action=1
    elseif k==keys.right or k==keys.d then action=2
    elseif k==keys.escape then nav=false
    elseif k==keys.enter or k==keys.numPadEnter then
     term.setCursorBlink(false)
     return nil,action==1 and 'back' or 'exit'
    end
   elseif k==keys]====] ..
[====[.tab then
    if type(completion)=='function' and not mask then
     if #candidates==0 then
      local ok,result=pcall(completion,value)
      if ok and type(result)=='table' then
       local seen={}
       for _,suffix in ipairs(result) do
        if type(suffix)=='string' and suffix~='' then
         local full=value..suffix
         if not see]====] ..
[====[n[full] then candidates[#candidates+1]=full;seen[full]=true end
        end
       end
      end
      chosen=#candidates>0 and 1 or 0
     else chosen=chosen%#candidates+1 end
     if chosen>0 then
      value=candidates[chosen];cursor=#value+1
      -- Keep candidates visible for cycling; next edit resets them.
     end
    end
   elseif k==keys.]====] ..
[====[enter or k==keys.numPadEnter then
    term.setCursorBlink(false)
    term.setCursorPos(1,math.min(h-4,startY+1))
    print()
    return (value=='' and default~=nil) and default or value
   elseif k==keys.backspace and cursor>1 then
    value=value:sub(1,cursor-2)..value:sub(cursor);cursor=cursor-1;reset()
   elseif k==keys.delete then
    value=val]====] ..
[====[ue:sub(1,cursor-1)..value:sub(cursor+1);reset()
   elseif k==keys.left then cursor=math.max(1,cursor-1);reset()
   elseif k==keys.right then cursor=math.min(#value+1,cursor+1);reset()
   elseif k==keys.home then cursor=1;reset()
   elseif k==keys['end'] then cursor=#value+1;reset()
   end
  end
 end
end

function UI.pause()
  term.setTextColor(colo]====] ..
[====[rs.gray);print('');print('Press ENTER to continue...');read()
end
return UI
]====]
files['lib/update_manager.lua']=[====[-- OBLIVIO 6.0 updater: check only, never execute downloads automatically.
local M={}
local settings='data/update_source.txt'
local status='data/update_status.txt'
local function save(path,s)
 if not fs.exists('data') then fs.makeDir('data') end
 local f=fs.open(path,'w');if not f then return false end
 f.write(s);f.close();return true
end
local fu]====] ..
[====[nction load(path)
 if not fs.exists(path) then return nil end
 local f=fs.open(path,'r');if not f then return nil end
 local s=f.readAll();f.close();return s
end
local function id(s)
 s=tostring(s or ''):match('^%s*(.-)%s*$')
 return s:match('^[%w]+$') and s or nil
end
function M.source()return id(load(settings))end
function M.setSource(s)
 s=id(s)]====] ..
[====[;if not s then return false end
 return save(settings,s)
end
local function fetch(pasteId)
 if not http or not http.get then return nil,'HTTP disabled in ComputerCraft config' end
 local ok,res=pcall(http.get,'https://pastebin.com/raw/'..pasteId,nil,true)
 if not ok or not res then return nil,'Pastebin unreachable / HTTP blocked' end
 local code=re]====] ..
[====[s.getResponseCode and res.getResponseCode() or 200
 if code~=200 then res.close();return nil,'HTTP '..tostring(code) end
 local body=res.readAll();res.close()
 if not body or #body>240000 then return nil,'Empty or oversized response' end
 return body
end
function M.check()
 local src=M.source();if not src then return nil,'Set the manifest Pastebin ]====] ..
[====[ID first' end
 local body,err=fetch(src);if not body then return nil,err end
 local version,patch=body:match('^%s*OBLIVIO_VERSION%s*=%s*([%d%.]+)%s*INSTALLER_ID%s*=%s*([%w]+)')
 if not version or not patch then return nil,'Invalid manifest format' end
 local result={version=version,paste=patch,current='6.0',new=tonumber(version)>6.0}
 save(status,v]====] ..
[====[ersion..'|'..patch..'|'..tostring(os.epoch('utc')))
 return result
end
function M.last()
 local v,p,t=tostring(load(status) or ''):match('^([^|]+)|([^|]+)|([^|]+)')
 if v then return {version=v,paste=p,checked=t,new=(tonumber(v) or 0)>6.0} end
end
function M.download(pasteId)
 pasteId=id(pasteId);if not pasteId then return nil,'Invalid Pastebin ID']====] ..
[====[ end
 local body,err=fetch(pasteId);if not body then return nil,err end
 if #body<100 or not body:find('OBLIVIO',1,true) then return nil,'Installer signature not found' end
 local path='oblivio_update_candidate.lua'
 local f=fs.open(path,'w');if not f then return nil,'Cannot save update candidate' end
 f.write(body);f.close()
 return path
end
retur]====] ..
[====[n M
]====]
files['lib/version_cleanup.lua']=[====[-- OBLIVIO OS 6.1 / Storage and Version Manager
-- Strictly manual cleanup. No background deletion.
local M={}
local function protected(path)
 local p=path:lower():gsub('^/','')
 if p:find('/',1,true) then return true end
 if p=='startup' or p=='startup.lua' or p=='config.lua' or p=='central.lua' or p=='dashboard.lua' or p=='secondary.lua' or p=='p]====] ..
[====[ocket.lua' then return true end
 if p=='oblivio_backup.lua' or p=='oblivio_backup_manager.lua' or p=='oblivio_backup.cfg' or p=='oblivio_backup_enable_auto.lua' then return true end
 if p:match('^oblivio_backup') or p:match('^oblivio_snapshots') then return true end
 if p=='lockdown_outputs' or p=='rom' or p=='disk' then return true end
 return fal]====] ..
[====[se
end
local function classify(p)
 if protected(p) or fs.isDir(p) then return nil end
 local low=p:lower()
 if low:match('%.pre[%w_%-]*$') or low:match('%.pre%-[%w_%-]+$') then return 'ROLLBACK COPY' end
 if low:match('%.%d%d?stage$') or low:match('%.lockstage$') then return 'STAGING FILE' end
 if low:match('^oblivio%d[%w_%-]*%.lua$') or low:match(]====] ..
[====['^oblivio_os_[%w_%-]+%.lua$') then return 'OLD INSTALLER' end
 if low=='unique.lua' or low=='blackseal.lua' or low=='lockdown.lua' or low=='atualizar.lua' or low=='atualizar_logo.lua' then return 'UPDATE SCRIPT' end
 if low=='oblivio_update_candidate.lua' then return 'DOWNLOADED UPDATE' end
 return nil
end
local function fmt(n)
 n=tonumber(n) or 0
]====] ..
[====[ if n>=1024 then return string.format('%.1f KiB',n/1024) end
 return tostring(n)..' B'
end
local function scan()
 local result={}
 for _,p in ipairs(fs.list('/')) do
  local kind=classify(p)
  if kind then result[#result+1]={path=p,kind=kind,size=fs.getSize(p)} end
 end
 table.sort(result,function(a,b) return a.size>b.size end)
 return result
end
l]====] ..
[====[ocal function info(ui,entry)
 ui.block({
  {text='FILE: '..entry.path,color=colors.yellow},
  {text='CLASS: '..entry.kind},
  {text='SIZE: '..fmt(entry.size)},
  {text='This file is NOT used by the running program only if it is an old installer or recovery copy.'},
  {text='Recovery copies may be needed to undo a broken update.'},
  {text='Deletion]====] ..
[====[ is permanent. No automatic cleanup.'}
 },'STORAGE / FILE REVIEW')
end
local function deleteOne(ui,entry)
 if not fs.exists(entry.path) or fs.isDir(entry.path) or protected(entry.path) or not classify(entry.path) then
  ui.block({{text='FILE CHANGED OR PROTECTED: CANCELLED',color=colors.red}},'STORAGE GUARD');return
 end
 info(ui,entry)
 local acti]====] ..
[====[on=ui.menu('DELETE '..entry.path..'?',{'NO / KEEP FILE','YES / DELETE PERMANENTLY'})
 if action~=2 then return end
 ui.header('CONFIRM PERMANENT DELETION')
 ui.center(7,entry.path,colors.yellow)
 ui.center(9,'TYPE DELETE TO CONFIRM',colors.red)
 term.setCursorPos(3,11)
 local word=read()
 if word~='DELETE' then return end
 if protected(entry.path) ]====] ..
[====[or not classify(entry.path) or fs.isDir(entry.path) then return end
 local ok,err=pcall(fs.delete,entry.path)
 if ok and not fs.exists(entry.path) then
  ui.block({{text='DELETED: '..entry.path,color=colors.lime},{text='RECLAIMED: '..fmt(entry.size)}},'STORAGE / COMPLETE')
 else
  ui.block({{text='DELETE FAILED: '..tostring(err),color=colors.red}},]====] ..
[====['STORAGE / ERROR')
 end
end
function M.menu(ui)
 while true do
  local entries=scan()
  local total=0
  for _,e in ipairs(entries) do total=total+e.size end
  local opts={'SCAN / REFRESH  |  '..#entries..' CANDIDATES  |  '..fmt(total),'STORAGE SUMMARY'}
  for _,e in ipairs(entries) do
   opts[#opts+1]=e.path..' ['..fmt(e.size)..']'
  end
  opts[#op]====] ..
[====[ts+1]='RETURN'
  local n=ui.menu('ADMIN / VERSION CLEANUP',opts)
  if not n or n==#opts then return end
  if n==2 then
   local free=fs.getFreeSpace('/')
   local cap=fs.getCapacity and fs.getCapacity('/') or nil
   ui.block({
    {text='AVAILABLE SPACE: '..(type(free)=='number' and fmt(free) or tostring(free))},
    {text='CAPACITY: '..(type(cap)=]====] ..
[====[='number' and fmt(cap) or 'UNKNOWN')},
    {text='CANDIDATES: '..#entries},
    {text='POTENTIALLY RECLAIMABLE: '..fmt(total)},
    {text='Protected: active OS, data/, lib/, configs, backup nodes.'},
    {text='All cleanup requires manual confirmation.'}
   },'STORAGE / SUMMARY')
  elseif n>=3 and n<=#entries+2 then
   deleteOne(ui,entries[n-2])
  ]====] ..
[====[end
 end
end
return M
]====]
files['oblivio_backup_manager.lua']=[====[-- OBLIVIO 4.1 / BACKUP MANAGER (CENTRAL ID 40)
-- Uses existing OBLIVIO BACKUP SYSTEM 1.0; does not alter data or startup.
local C=colors
local function cfg()
 if not fs.exists('oblivio_backup.cfg') then return nil end
 local f=fs.open('oblivio_backup.cfg','r');if not f then return nil end
 local ok,t=pcall(textutils.unserialize,f.readAll());f.clo]====] ..
[====[se()
 return ok and type(t)=='table' and t or nil
end
local function screen(title)
 term.setBackgroundColor(C.black);term.setTextColor(C.white);term.clear()
 local w=term.getSize()
 term.setBackgroundColor(C.red);term.setTextColor(C.white);term.setCursorPos(1,1)
 term.write((' OBLIVIO // BACKUP CONTROL '):sub(1,w)..(' '):rep(math.max(0,w-27)))
 ter]====] ..
[====[m.setBackgroundColor(C.black);term.setTextColor(C.yellow);term.setCursorPos(2,3);print(title)
 term.setTextColor(C.lightGray)
end
local function pause() print('');print('Pressione ENTER para continuar');read() end
local function runBackup(action)
 if not fs.exists('oblivio_backup.lua') then print('Cliente de backup nao encontrado.');return end
 if ]====] ..
[====[action=='restore' then
  print('AVISO: a restauracao substitui arquivos da central.')
  print('Recomendado: backup do mundo pelo administrador.')
  write('Digite ABRIR RESTAURACAO: ')
  if read()~='ABRIR RESTAURACAO' then return end
 end
 shell.run('oblivio_backup.lua',action)
end
while true do
 screen('CENTRAL 40 / STORAGE OPERATIONS')
 local c=cf]====] ..
[====[g()
 print('BACKUP NODE: '..(c and tostring(c.id) or 'NOT CONFIGURED'))
 print('AUTO START: '..(c and 'CONFIGURED' or 'DISABLED'))
 print('FREE SPACE: '..tostring(fs.getFreeSpace('/'))..' bytes')
 print('')
 print('1  EXECUTAR BACKUP AGORA')
 print('2  VERIFICAR CONFIGURACAO')
 print('3  RESTAURAR ULTIMO BACKUP')
 print('4  SAIR')
 write('> ')
 loc]====] ..
[====[al k=read()
 if k=='1' then screen('MANUAL BACKUP');runBackup('now');pause()
 elseif k=='2' then screen('BACKUP STATUS');print('NODE: '..(c and tostring(c.id) or 'NAO CONFIGURADO'));print('AUTO SERVICE: '..(c and 'STARTUP CONFIGURED' or 'CHECK CONFIG'));print('A lista de snapshots fica no computador 47.');pause()
 elseif k=='3' then screen('RESTORE]====] ..
[====[ / DANGER');runBackup('restore');pause()
 elseif k=='4' or k==':back' then break end
end
]====]
files['pocket.lua']=[====[-- OBLIVIO OS 5.4 / MILITARY MOBILE TERMINAL
-- Authenticated CRUD + status + DEFCON + archives + remote infrastructure.
local C=colors
local P='oblivio_v2'
local node=nil
local token=nil
local menu={
  {'status','SYSTEM STATUS'},{'replikas','REPLIKA DOSSIERS'},{'threats','THREAT FILES'},
  {'incidents','INCIDENT REPORTS'},{'korps','KORPS / ENEMY O]====] ..
[====[RG'},{'korps_scientists','KORPS SCIENTISTS'},
  {'personnel','PERSONNEL'},{'projects','PROJECTS'},{'experiments','EXPERIMENTS'},{'missions','MISSIONS'},
  {'archives','ARCHIVES / TRASH'},{'logs','EVENT LOGS'},{'infrastructure','INFRASTRUCTURE'},
  {'defcon','DEFCON / ALERT'}
}
local alertText,alertAt=nil,0
local function noteAlert(m)
  if type(m)==]====] ..
[====['table' and m.action=='ALERT' then
    alertText=tostring(m.text or 'ALERT'):sub(1,40);alertAt=os.clock()
    return true
  end
  return false
end
local locked={archives=true,logs=true,infrastructure=true,status=true,defcon=true}
local function modem()
  for _,n in ipairs(peripheral.getNames()) do
    if peripheral.hasType(n,'modem') and peripheral]====] ..
[====[.call(n,'isWireless') then
      rednet.open(n);return true
    end
  end
  return false
end
local function draw(title,lines,footer)
  local w,h=term.getSize()
  term.setBackgroundColor(C.black);term.setTextColor(C.white);term.clear()
  local function bar(y,text,bg,fg)
    term.setBackgroundColor(bg);term.setTextColor(fg)
    term.setCursorPos(1,y)]====] ..
[====[;term.write((' '):rep(w))
    term.setCursorPos(2,y);term.write(tostring(text):sub(1,math.max(0,w-2)))
  end
  bar(1,'OBLIVIO OS / FIELD UNIT',C.red,C.white)
  if alertText and os.clock()-alertAt<90 then bar(2,'! '..alertText,C.red,C.white)
  else bar(2,'NODE '..tostring(node or '--')..'  |  SECURE LINK',C.gray,C.white) end
  term.setBackgroundColo]====] ..
[====[r(C.black)
  term.setTextColor(C.orange);term.setCursorPos(1,4)
  term.write(('> '..tostring(title)):sub(1,w))
  term.setTextColor(C.gray);term.setCursorPos(1,5);term.write(('-'):rep(w))
  local y=6
  for _,entry in ipairs(lines or {}) do
    if y>=h-2 then break end
    local s=type(entry)=='table' and tostring(entry.text or '') or tostring(entry)]====] ..
[====[
    local fg=type(entry)=='table' and entry.color or C.lightGray
    term.setCursorPos(1,y);term.setTextColor(fg or C.lightGray)
    term.write(s:sub(1,w));y=y+1
  end
  term.setTextColor(C.gray);term.setCursorPos(1,h-1);term.write(('-'):rep(w))
  term.setTextColor(C.yellow);term.setCursorPos(1,h)
  term.write(tostring(footer or 'Q BACK'):sub(1,w)]====] ..
[====[)
  term.setTextColor(C.white)
end
local function message(title,body)
  draw(title,{tostring(body or '')},'PRESS ANY KEY')
  os.pullEvent('key')
end
local function prompt(title,caption,default,masked)
  draw(title,{caption or '',default and ('CURRENT: '..tostring(default):sub(1,25)) or '', '', 'NEW VALUE:'},'ENTER SAVE | :BACK')
  local _,h=term.ge]====] ..
[====[tSize()
  term.setCursorPos(1,math.min(9,h-3))
  local s=read(masked and '*' or nil)
  if s==':back' or s==':cancel' then return nil end
  if s=='' and default~=nil then return tostring(default) end
  return s
end
local function oneLine(v)
  local s=tostring(v):gsub('[\r\n]',' ')
  return s
end
local function choose(title,options)
  if #options==0 ]====] ..
[====[then message(title,'NO ENTRIES');return nil end
  local selected,offset=1,0
  while true do
    local w,h=term.getSize();local capacity=math.max(2,h-9)
    if selected<=offset then offset=selected-1 end
    if selected>offset+capacity then offset=selected-capacity end
    local lines={{text=string.format('INDEX %02d/%02d',selected,#options),color=C]====] ..
[====[.gray}}
    for i=offset+1,math.min(#options,offset+capacity) do
      local s=oneLine(options[i])
      lines[#lines+1]={text=(i==selected and '> ' or '  ')..s:sub(1,w-2),
        color=i==selected and C.yellow or C.lightGray}
    end
    draw(title,lines,'W/S MOVE ENTER | Q BACK')
    local e,k,m2,proto=os.pullEvent()
    if e=='rednet_message' t]====] ..
[====[hen
      if proto==P then noteAlert(m2) end
    elseif e=='key' then
      if k==keys.up then selected=math.max(1,selected-1)
      elseif k==keys.down then selected=math.min(#options,selected+1)
      elseif k==keys.enter or k==keys.space then return selected
      elseif k==keys.escape then return nil end
    elseif e=='char' then
      k=k:lowe]====] ..
[====[r()
      if k=='w' then selected=math.max(1,selected-1)
      elseif k=='s' then selected=math.min(#options,selected+1)
      elseif k=='q' then return nil end
    end
  end
end
local function request(payload,timeout)
  if not node then return nil,'Not connected' end
  payload=payload or {};payload.token=token
  rednet.send(node,payload,P)
  local]====] ..
[====[ untilTime=os.clock()+(timeout or 7)
  while os.clock()<untilTime do
    local id,m=rednet.receive(P,math.max(0,untilTime-os.clock()))
    noteAlert(m)
    if id==node and type(m)=='table' and (m.action=='MOBILE_RESULT' or m.action=='MOBILE_CHALLENGE_RESULT' or m.action=='MOBILE_LOGIN_RESULT') then
      if m.ok==false then return nil,m.error or 'R]====] ..
[====[equest rejected' end
      return m
    end
  end
  return nil,'Central timed out'
end
local function connect()
  draw('CONNECTING',{'SEARCHING CENTRAL...'},'PLEASE WAIT')
  rednet.broadcast({action='HELLO'},P)
  local untilTime=os.clock()+5
  while os.clock()<untilTime do
    local id,m=rednet.receive(P,math.max(0,untilTime-os.clock()))
    if id ]====] ..
[====[and type(m)=='table' and m.action=='WELCOME' then node=id;return true end
  end
  return false
end
local function login()
  local challenge,err=request({action='MOBILE_CHALLENGE'})
  if not challenge then message('LOGIN ERROR',err);return false end
  local pass=prompt('CLASSIFIED ACCESS','ENTER VAULT PASSWORD',nil,true)
  if not pass then return fa]====] ..
[====[lse end
  local Secure=dofile('lib/secure.lua')
  local proof=Secure.proof(pass,challenge.salt,challenge.rounds,challenge.nonce)
  pass=nil
  local result,why=request({action='MOBILE_LOGIN',proof=proof},12)
  if not result then message('ACCESS DENIED',why);return false end
  token=result.token
  return true
end
local function saveRecord(kind,id,rec]====] ..
[====[ord)
  local ok,why=request({action='MOBILE_DATA',op='update',kind=kind,id=id,record=record})
  message('SAVE RESULT',ok and 'SAVED' or why)
end
local function details(kind,id)
  while true do
    local response,err=request({action='MOBILE_DATA',op='read',kind=kind,id=id})
    if not response then message('READ FAILED',err);return end
    local rec]====] ..
[====[ord=response.data or {}
    local keysList={}
    for k in pairs(record) do keysList[#keysList+1]=k end
    local order={'name','codename','model','serial','faction','alignment','status','threat',
      'threat_level','abilities','behavior','weaknesses','equipment','location','last_contact',
      'handler','classification','department','rank','cle]====] ..
[====[arance','description','owner',
      'impact','protocol','notes','id','created','updated','content'}
    local priority={}
    for i,k in ipairs(order) do priority[k]=i end
    table.sort(keysList,function(a,b)
      local x,y=priority[a] or 999,priority[b] or 999
      if x~=y then return x<y end
      return tostring(a)<tostring(b)
    end)
    l]====] ..
[====[ocal opts={}
    for _,k in ipairs(keysList) do
      local v=record[k]
      if type(v)=='table' then v=textutils.serialize(v):gsub('%s+',' ') end
      local label=tostring(k):upper():gsub('_',' ')
      opts[#opts+1]=label..'  /  '..oneLine(v):sub(1,60)
    end
    local editable=kind~='archives' and kind~='logs'
    if editable then
      opts[]====] ..
[====[#opts+1]='[ EDIT FIELD ]'
      opts[#opts+1]='[ ADD NEW FIELD ]'
      opts[#opts+1]='[ DELETE DOSSIER ]'
    end
    local i=choose('FILE: '..tostring(record.name or record.codename or id),opts)
    if not i then return end
    if i<=#keysList then
      local k=keysList[i]
      local val=record[k]
      local textValue=type(val)=='table' and te]====] ..
[====[xtutils.serialize(val) or tostring(val)
      local w,h=term.getSize();local per=math.max(5,h-7)
      local lines={}
      for line in (textValue..'\n'):gmatch('(.-)\n') do
        if line=='' then lines[#lines+1]=' ' else
          for j=1,#line,w do lines[#lines+1]=line:sub(j,j+w-1) end
        end
      end
      local start=1
      while true ]====] ..
[====[do
        local visible={}
        for j=start,math.min(#lines,start+per-1) do visible[#visible+1]=lines[j] end
        draw(tostring(k):upper(),visible,'W/S SCROLL Q BACK')
        local e,key=os.pullEvent()
        if e=='key' and key==keys.up then start=math.max(1,start-1)
        elseif e=='key' and key==keys.down then start=math.min(math.max(]====] ..
[====[1,#lines-per+1),start+1)
        elseif e=='char' and key:lower()=='w' then start=math.max(1,start-1)
        elseif e=='char' and key:lower()=='s' then start=math.min(math.max(1,#lines-per+1),start+1)
        elseif (e=='key' and key==keys.escape) or (e=='char' and key:lower()=='q') then break end
      end
    elseif editable and i==#keysList+1 t]====] ..
[====[hen
      local choices={}
      for _,k in ipairs(keysList) do if k~='id' and k~='created' and k~='updated' then choices[#choices+1]=k end end
      local j=choose('EDIT FIELD',choices)
      if j then
        local k=choices[j]
        local old=record[k]
        if type(old)=='table' then
          message('NOT EDITABLE','COMPLEX FIELD - USE CEN]====] ..
[====[TRAL')
        else
          local v=prompt('EDIT '..k:upper(),'NEW VALUE',old)
          if v~=nil then
            if k=='threat' and (not tonumber(v) or tonumber(v)<0 or tonumber(v)>5) then
              message('INVALID','THREAT MUST BE 0-5')
            else
              record[k]=v
              saveRecord(kind,id,record)
            end
  ]====] ..
[====[        end
        end
      end
    elseif editable and i==#keysList+2 then
      local k=prompt('NEW FIELD','FIELD NAME')
      if k and k:match('^[%w_]+$') and #k<=40 and k~='id' and k~='created' and k~='updated' then
        local v=prompt('FIELD VALUE',k)
        if v~=nil then
          record[k]=v
          saveRecord(kind,id,record)
      ]====] ..
[====[  end
      end
    elseif editable and i==#keysList+3 then
      local confirmation=prompt('DELETE FILE','TYPE DELETE TO CONFIRM')
      if confirmation=='DELETE' then
        local ok,why=request({action='MOBILE_DATA',op='delete',kind=kind,id=id})
        message('DELETE RESULT',ok and 'MOVED TO ARCHIVES' or why)
        if ok then return 'delete]====] ..
[====[d' end
      end
    end
  end
end
local function browse(kind)
  local query=''
  local searchable=not locked[kind]
  while true do
    local response,err=request({action='MOBILE_DATA',op='list',kind=kind,query=query})
    if not response then message('NETWORK ERROR',err);return end
    local records=response.data or {}
    local options={}
    for]====] ..
[====[ _,r in ipairs(records) do options[#options+1]=tostring(r.name or r.id)..(r.status and (' ['..r.status..']') or '') end
    local searchIndex,createIndex=nil,nil
    if searchable then options[#options+1]='[ SEARCH / FILTER ]';searchIndex=#options end
    if not locked[kind] then options[#options+1]='[ CREATE NEW FILE ]';createIndex=#options end
  ]====] ..
[====[  if #options==0 then options[1]='[ NO RECORDS ]' end
    local title=kind:upper()..' / '..#records..(query~='' and (' / '..query) or '')
    local index=choose(title,options)
    if not index then return end
    if index<=#records then
      local r=records[index]
      if kind=='infrastructure' or kind=='defcon' then
        local confirm=prompt(]====] ..
[====[kind=='defcon' and 'SET ALERT LEVEL' or 'REMOTE CONTROL','TYPE YES: '..tostring(r.name))
        if confirm=='YES' then
          local ok,why=request({action='MOBILE_DATA',op='toggle',kind=kind,id=r.id})
          message('CONTROL',ok and 'COMMAND EXECUTED' or why)
        end
      elseif kind~='status' then
        details(kind,r.id)
      end
 ]====] ..
[====[   elseif index==searchIndex then
      local q=prompt('SEARCH','NAME / STATUS / LOCATION (BLANK = ALL)')
      if q~=nil then query=q end
    elseif index==createIndex then
      local name=prompt('NEW DOSSIER','NAME / CODENAME')
      if name and name~='' then
        local record={name=name,status='NEW'}
        local ok,why=request({action='MOB]====] ..
[====[ILE_DATA',op='create',kind=kind,record=record})
        if ok then details(kind,ok.id) else message('CREATE FAILED',why) end
      end
    end
  end
end
local function main()
  if not modem() then message('NO WIRELESS MODEM','ATTACH MODEM');return end
  if not connect() then message('OFFLINE','CENTRAL NOT FOUND');return end
  if not login() then re]====] ..
[====[turn end
  local labels={}
  for i,m in ipairs(menu) do labels[i]=m[2] end
  while true do
    local i=choose('COMMAND / '..node,labels)
    if not i then return end
    browse(menu[i][1])
  end
end
local ok,err=pcall(main)
if not ok then message('POCKET ERROR',tostring(err)) end
term.setBackgroundColor(C.black);term.setTextColor(C.white);term.clea]====] ..
[====[r();term.setCursorPos(1,1)
]====]
files['secondary.lua']=[====[-- OBLIVIO OS 5.1 / SECONDARY INTELLIGENCE NODE
-- Read-only portrait monitor: alert state, threat bar and live operational ticker.
local C=colors
local Data=dofile('lib/data.lua')
local Control=dofile('lib/control.lua')
local Alert=dofile('lib/alert.lua')
local Log=dofile('lib/log.lua')
local UI=dofile('lib/ui.lua')
local cfg=dofile('config.lua')
]====] ..
[====[local mon=dofile('lib/displays.lua').get('secondary')
if not mon then return end
pcall(function() mon.setTextScale(0.5) end)
local start=os.clock()
local publicCats={SENSOR=true,DEFCON=true,LOCKDOWN=true,SYSTEM=true,CONTROL=true,REMOTE_CONTROL=true,MOBILE_CONTROL=true}
local cache={}
local function cached(key,ttl,fn,default)
 local e=cache[key];loc]====] ..
[====[al now=os.clock()
 if e and now-e.t<ttl then return e.v end
 local ok,v=pcall(fn)
 if not ok or v==nil then v=e and e.v or default end
 cache[key]={t=now,v=v}
 return v
end
local function intel()
 return cached('intel',8,function()
  local highest,hostile,open,count=0,0,0,{}
  for _,kind in ipairs({'replikas','threats','incidents'}) do
   local lis]====] ..
[====[t=Data.list(kind)
   count[kind]=#list
   for _,r in ipairs(list) do
    local lv=tonumber(r.threat or r.threat_level)
    if lv then highest=math.max(highest,math.min(5,math.max(0,math.floor(lv)))) end
    if kind=='replikas' and tostring(r.alignment or ''):upper()=='HOSTILE' then hostile=hostile+1 end
    if kind=='incidents' then
     local s=to]====] ..
[====[string(r.status or ''):upper()
     if s~='CLOSED' and s~='RESOLVED' and s~='CONTAINED' then open=open+1 end
    end
   end
  end
  return {highest=highest,hostile=hostile,open=open,count=count}
 end,{highest=0,hostile=0,open=0,count={}})
end
local function events()
 return cached('events',3,function()
  local out={}
  local entries=Log.readLast(15]====] ..
[====[0)
  for i=#entries,1,-1 do
   local time,cat,msg=entries[i]:match('^%S+ (%S+) | (%S+) | (.*)$')
   if cat and publicCats[cat] then out[#out+1]={time=time:sub(1,5),cat=cat,msg=msg} end
   if #out>=12 then break end
  end
  return out
 end,{})
end
local function draw()
 local w,h=mon.getSize()
 local level=Alert.get();local info=Alert.levels()[level]====] ..
[====[];local dc=info.color
 local flash=level<=2 and (math.floor(os.clock())%2==0)
 local function put(y,s,fg,bg,center)
  if y<1 or y>h then return end
  s=tostring(s or '')
  local x=center and math.max(1,math.floor((w-#s)/2)+1) or 1
  mon.setBackgroundColor(bg or C.black);mon.setTextColor(fg or C.white)
  mon.setCursorPos(x,y);mon.write(s:sub(1,math.]====] ..
[====[max(0,w-x+1)))
 end
 local function bar(y,s,bg,fg)
  if y>h then return end
  mon.setBackgroundColor(bg);mon.setCursorPos(1,y);mon.write((' '):rep(w))
  put(y,s,fg or C.white,bg,true)
 end
 local st=intel()
 local okS,sensors=pcall(Control.readSensors,cfg.sensors or {})
 sensors=okS and type(sensors)=='table' and sensors or {}
 local sensorCount,al]====] ..
[====[erts=0,0
 for _,v in pairs(sensors) do sensorCount=sensorCount+1;if v then alerts=alerts+1 end end
 mon.setBackgroundColor(C.black);mon.clear()
 bar(1,'OBLIVIO OS',flash and C.white or C.red,C.white)
 put(2,'INTEL / NODE 02',C.lightGray,nil,true)
 bar(4,'DEFCON '..level..' '..info.name,C.red,C.white)
 bar(6,alerts>0 and 'SENSOR ALERT' or 'SYSTEM SE]====] ..
[====[CURE',alerts>0 and C.red or C.gray,C.white)
 put(8,'MAX FILE THREAT',C.lightGray,nil,true)
 put(9,string.format('LEVEL %02d / 05',st.highest),st.highest>=5 and C.red or st.highest>=4 and C.orange or st.highest>=3 and C.yellow or C.lime,nil,true)
 if w>=6 then UI.bar(2,10,w-2,st.highest,5,st.highest>=4 and C.red or C.orange,mon) end
 put(12,'REPLIKA]====] ..
[====[S: '..(st.count.replikas or 0),C.white)
 put(13,'HOSTILES: '..st.hostile,st.hostile>0 and C.orange or C.lime)
 put(14,'THREATS: '..(st.count.threats or 0),C.white)
 put(15,'INCIDENTS: '..(st.count.incidents or 0),C.white)
 put(16,'OPEN: '..st.open,st.open>0 and C.yellow or C.lime)
 put(17,'SENSORS: '..sensorCount..' / '..alerts..' !',alerts>0 and C]====] ..
[====[.red or C.white)
 local y=19
 put(y,'-- OBLIVIO EVENTS --',C.red,nil,true)
 y=y+1
 for _,e in ipairs(events()) do
  if y>=h-11 then break end
  local col=(e.cat=='SENSOR' or e.cat=='LOCKDOWN') and C.red or (e.cat=='DEFCON' and C.orange or C.lightGray)
  put(y,e.time..' '..e.cat:sub(1,6),col);y=y+1
  local msg=e.msg
  while #msg>0 and y<h-11 do
   p]====] ..
[====[ut(y,' '..msg:sub(1,w-1),C.gray);msg=msg:sub(w);y=y+1
   if y>=h-11 then break end
   break
  end
 end
 -- Dedicated animated telemetry panel in previously unused bottom area.
 local sec=math.floor(os.clock()-start)
 local base=math.max(19,h-10)
 bar(base,'-- NODE TELEMETRY --',C.red,C.white)
 put(base+1,'KORPS: '..Data.count('korps'),C.lightGray)
]====] ..
[====[ put(base+2,'SCIENTISTS: '..Data.count('korps_scientists'),C.lightGray)
 put(base+3,'CENTRAL: '..tostring(cfg.central_id or 40),C.lightGray)
 put(base+4,'LINK: MONITORING',C.lime)
 put(base+5,'UPTIME '..string.format('%02d:%02d',math.floor(sec/3600),math.floor(sec/60)%60),C.white)
 local cells=math.max(1,w-2)
 local step=math.floor(os.clock()*2)%ce]====] ..
[====[lls
 put(base+7,'['..string.rep('-',step)..'>'..string.rep('-',cells-step-1)..']',C.red)
 put(base+8,'SECURE DATA NODE',C.gray,nil,true)
 bar(h,string.format('OS 5.4  UP %02d:%02d',math.floor(sec/3600),math.floor(sec/60)%60),C.red,C.white)
end

-- OBLIVIO 6.0 / alternate display channels
local Modes=dofile('lib/display_modes.lua')
local bootAt=os.c]====] ..
[====[lock()
local function alternateView(mode)
 if mode=='COMMAND' then return false end
 local w,h=mon.getSize()
 local C=colors
 local tick=math.floor(os.clock()*2)
 local function line(x,y,t,fg,bg,width)
  if y<1 or y>h or x>w then return end
  x=math.max(1,x);width=math.min(width or (w-x+1),w-x+1)
  if width<1 then return end
  mon.setCursorPos(x,y)]====] ..
[====[;mon.setBackgroundColor(bg or C.black);mon.setTextColor(fg or C.lightGray)
  mon.write(tostring(t or ''):sub(1,width))
 end
 local function fill(x,y,width,fg,ch)
  line(x,y,string.rep(ch or ' ',math.max(0,width)),fg,C.black,width)
 end
 local function rule(y,fg)
  fill(1,y,w,fg or C.red,'-')
 end
 local function box(x,y,bw,bh,title,color)
  if bw<6]====] ..
[====[ or bh<4 then return end
  line(x,y,'+'..string.rep('-',bw-2)..'+',color)
  for yy=y+1,y+bh-2 do
   line(x,yy,'|',color);line(x+bw-1,yy,'|',color)
  end
  line(x,y+bh-1,'+'..string.rep('-',bw-2)..'+',color)
  line(x+2,y,' '..title..' ',color)
 end
 local function meter(x,y,bw,n,cap,color)
  bw=math.max(1,bw)
  local filled=math.floor(bw*math.min(1,]====] ..
[====[math.max(0,n/math.max(1,cap))))
  line(x,y,string.rep('#',filled)..string.rep('.',bw-filled),color)
 end
 local function count(kind)
  local ok,n=pcall(Data.count,kind)
  return ok and tonumber(n) or 0
 end
 local def=Alert.get()
 mon.setBackgroundColor(C.black);mon.clear()
 line(1,1,string.rep(' ',w),C.white,C.red)
 line(2,1,'OBLIVIO OS 6.0 // '..]====] ..
[====[mode,C.white,C.red)
 line(math.max(1,w-12),1,'DEFCON '..tostring(def),C.white,C.red)
 rule(2,C.red)
 local wide=w>=55
 local cx=math.floor(w/2)
 if mode=='TACTICAL' then
  line(2,4,'TACTICAL OPERATIONS // ACTIVE SECTOR',C.red)
  if wide then
   local rw=math.min(31,math.floor(w*.38));local rh=math.min(27,h-12)
   box(2,6,rw,rh,'RADAR / SWEEP',C.red]====] ..
[====[)
   local rx=2+math.floor(rw/2);local ry=6+math.floor(rh/2)
   for r=1,math.min(math.floor((rw-4)/2),math.floor((rh-4)/2)) do
    local yy=ry-r
    line(rx-r,yy,'+',C.gray);line(rx+r,yy,'+',C.gray)
    line(rx-r,ry+r,'+',C.gray);line(rx+r,ry+r,'+',C.gray)
   end
   line(rx,ry,'X',C.lime)
   local radius=math.max(2,math.min(10,math.floor((rw-5)/2))]====] ..
[====[)
   local a=tick%8
   local dx=({radius,radius,0,-radius,-radius,-radius,0,radius})[a+1]
   local dy=({0,-3,-5,-3,0,3,5,3})[a+1]
   line(rx+dx,ry+dy,'*',C.orange)
   local xx=rw+4;local right=w-xx-1
   box(xx,6,right,math.min(rh,16),'OPERATIONAL STATUS',C.red)
   line(xx+2,9,'MISSIONS    '..count('missions'),C.white)
   line(xx+2,12,'THREATS     ']====] ..
[====[..count('threats'),C.orange)
   line(xx+2,15,'INCIDENTS   '..count('incidents'),C.white)
   if rh>17 then
    box(xx,23,right,math.min(10,h-29),'TACTICAL SIGNAL',C.red)
    for i=1,math.min(5,h-30) do meter(xx+2,24+i,math.max(3,right-5),(tick*3+i*11)%100,100,C.orange) end
   end
  else
   line(2,6,'RADAR SCAN',C.orange)
   for i=1,9 do
    local r=]====] ..
[====[(tick+i)%9
    line(2,7+i,'|'..string.rep('.',r)..'*',i==5 and C.red or C.gray)
   end
   line(2,19,'MISSIONS '..count('missions'),C.white)
   line(2,21,'THREATS '..count('threats'),C.orange)
   line(2,23,'INCIDENTS '..count('incidents'),C.white)
  end
 elseif mode=='RESEARCH' then
  line(2,4,'RESEARCH DIVISION // ANALYTICAL CORE',C.cyan)
  local v]====] ..
[====[als={{'PROJECTS',count('projects')},{'EXPERIMENTS',count('experiments')},{'PERSONNEL',count('personnel')},{'SCIENTISTS',count('korps_scientists')}}
  if wide then
   local gap=2;local bw=math.floor((w-8)/2)
   for i,v in ipairs(vals) do
    local x=2+((i-1)%2)*(bw+gap);local y=7+math.floor((i-1)/2)*13
    box(x,y,bw,11,v[1],C.cyan)
    line(x+3,y+3]====] ..
[====[,'REGISTERED: '..v[2],C.white)
    meter(x+3,y+6,bw-7,v[2],math.max(10,v[2]+5),C.cyan)
    line(x+3,y+8,'ANALYSIS '..string.rep('.',tick%6),C.lightBlue)
   end
   local graphY=math.min(h-8,35)
   if graphY>31 then
    line(3,graphY,'LIVE SPECTRAL ANALYSIS',C.cyan)
    for j=1,math.min(w-8,80) do
     local v=math.floor(2+2*math.sin((j+tick)/5))
   ]====] ..
[====[  line(3+j,graphY+v,'*',C.lightBlue)
    end
   end
  else
   for i,v in ipairs(vals) do
    local y=6+(i-1)*5
    line(2,y,v[1],C.cyan)
    line(2,y+1,'TOTAL '..v[2],C.white)
    meter(2,y+2,w-4,v[2],math.max(10,v[2]+5),C.lightBlue)
   end
   line(2,28,'LAB LINK ACTIVE',C.cyan)
  end
 elseif mode=='INTELLIGENCE' then
  line(2,4,'INTELLIGENCE // SI]====] ..
[====[GNAL INTERCEPT',C.orange)
  local vals={{'KORPS',count('korps')},{'REPLIKAS',count('replikas')},{'THREATS',count('threats')},{'INCIDENTS',count('incidents')}}
  if wide then
   local left=math.floor(w*.44)
   box(2,6,left,math.min(h-12,29),'THREAT REGISTRY',C.orange)
   for i,v in ipairs(vals) do
    local y=8+(i-1)*5
    line(5,y,string.format('%-]====] ..
[====[13s %03d',v[1],v[2]),i==3 and C.red or C.white)
    meter(5,y+2,left-8,v[2],math.max(10,v[2]+7),C.orange)
   end
   local x=left+4;local bw=w-x-1
   box(x,6,bw,math.min(h-12,29),'CIPHER MATRIX',C.orange)
   for j=1,math.min(23,h-15) do
    local t=''
    for k=1,math.max(1,bw-4) do
     local v=(j*31+k*17+tick*7)%16
     t=t..('0123456789ABCDEF'):s]====] ..
[====[ub(v+1,v+1)
    end
    line(x+2,7+j,t,j%4==0 and C.red or C.gray)
   end
  else
   for i,v in ipairs(vals) do
    line(2,6+i*3,v[1],C.orange)
    line(2,7+i*3,string.format('  %03d DETECTED',v[2]),C.white)
   end
   line(2,22,'SIGNAL MATRIX',C.red)
   for j=1,math.min(6,h-25) do
    local t=''
    for k=1,w-3 do
     local v=(j*13+k*7+tick)%16
   ]====] ..
[====[  t=t..('0123456789ABCDEF'):sub(v+1,v+1)
    end
    line(2,22+j,t,C.gray)
   end
  end
 else
  line(2,4,'SYSTEM DIAGNOSTICS // HARDWARE NODE',C.lime)
  local free=fs.getFreeSpace('/')
  local total=fs.getCapacity and fs.getCapacity('/') or nil
  local up=math.floor(os.clock())
  local vals={{'NODE ID',os.getComputerID()},{'UPTIME',up..' SEC'},{'FR]====] ..
[====[EE STORAGE',tostring(free)},{'CAPACITY',tostring(total or 'N/A')},{'DEFCON',def},{'DISPLAY MODE','SYSTEM'}}
  if wide then
   box(2,6,w-3,math.min(h-12,23),'SYSTEM HEALTH / READ ONLY',C.lime)
   for i,v in ipairs(vals) do
    line(5,8+i*3,string.format('%-19s %s',v[1],tostring(v[2])),i%2==0 and C.white or C.lime)
   end
   local yy=math.min(h-8,33)]====] ..
[====[
   if yy>30 then
    line(3,yy,'PROCESSOR ACTIVITY // VISUAL',C.lime)
    for i=1,math.min(8,h-yy-2) do
     meter(3,yy+i,w-7,(tick*13+i*19)%100,100,C.lime)
    end
   end
  else
   for i,v in ipairs(vals) do
    line(2,6+i*3,v[1],C.lime)
    line(2,7+i*3,tostring(v[2]),C.white)
   end
   line(2,27,'SYSTEM ONLINE',C.lime)
  end
 end
 rule(h-2,mode]====] ..
[====[=='RESEARCH' and C.cyan or mode=='SYSTEM' and C.lime or mode=='INTELLIGENCE' and C.orange or C.red)
 line(2,h-1,'EXTERNAL / READ ONLY',C.gray)
 line(2,h,'OBLIVIO OS 6.0 // '..string.format('%02d:%02d',math.floor(os.clock()/60)%60,math.floor(os.clock())%60),C.gray)
 return true
end
local function cinematicMonitorBoot()
 local w,h=mon.getSize()
 for ]====] ..
[====[i=1,4 do
  mon.setBackgroundColor(colors.black);mon.clear()
  mon.setTextColor(i%2==0 and colors.white or colors.red)
  local msg=({'OBLIVIO OS','INITIALIZING NODE','MILITARY DATA LINK','SYSTEM ONLINE'})[i]
  mon.setCursorPos(math.max(1,math.floor((w-#msg)/2)+1),math.max(1,math.floor(h/2)))
  mon.write(msg:sub(1,w))
  sleep(0.18)
 end
end
cinematic]====] ..
[====[MonitorBoot()
-- DEFCON 1 / OBLIVIO BLACK SEAL PROTOCOL (DISPLAY ONLY)
-- Fictional terminal presentation; no filesystem, network or redstone effects.
local sealStart=nil
local function simulatedLockdown()
 if Alert.get()~=1 then sealStart=nil;return false end
 if not sealStart then sealStart=os.epoch('utc') end
 local elapsed=math.max(0,math.floor]====] ..
[====[((os.epoch('utc')-sealStart)/1000))
 local left=math.max(0,300-elapsed)
 local w,h=mon.getSize()
 local tick=math.floor(os.clock()*2)
 local function band(y,bg)
  if y<1 or y>h then return end
  mon.setBackgroundColor(bg);mon.setCursorPos(1,y);mon.write((' '):rep(w))
 end
 local function msg(y,s,fg,bg)
  if y<1 or y>h then return end
  s=tostring(s]====] ..
[====[)
  mon.setBackgroundColor(bg or colors.black);mon.setTextColor(fg or colors.white)
  mon.setCursorPos(math.max(1,math.floor((w-#s)/2)+1),y)
  mon.write(s:sub(1,w))
 end
 local function bar(y,pct,width)
  width=math.min(width,w-4);if width<4 then return end
  local count=math.floor(width*math.max(0,math.min(1,pct)))
  msg(y,'['..string.rep('=',coun]====] ..
[====[t)..string.rep('-',width-count)..']',colors.red)
 end
 mon.setBackgroundColor(colors.black);mon.clear()
 band(1,colors.red)
 msg(1,'OBLIVIO // BLACK SEAL',colors.white,colors.red)
 local flash=tick%2==0
 if w>=45 then
  local center=math.floor(h/2)
  msg(3,'SECURITY DIRECTIVE 001',colors.lightGray)
  msg(5,'DEFCON 1 // TOTAL CONTAINMENT',colors.red]====] ..
[====[)
  band(7,colors.gray)
  msg(7,'RESTRICTED SYSTEM ACCESS',colors.white,colors.gray)
  msg(center-8,flash and 'ACCESS DENIED' or 'AUTHORIZATION REVOKED',colors.red)
  msg(center-5,'CENTRAL COMMAND HAS INITIATED BLACK SEAL',colors.white)
  msg(center-3,'ARCHIVE SANITIZATION SEQUENCE',colors.orange)
  msg(center-1,'T - '..string.format('%02d:%02d',ma]====] ..
[====[th.floor(left/60),left%60),colors.red)
  bar(center+1,elapsed/300,math.min(46,w-8))
  local phases={'SEALING ACCESS CHANNELS','REVOKING ACTIVE CREDENTIALS','ISOLATING ARCHIVE INDEX','PURGING ENCRYPTION KEYS','FINAL CONTAINMENT STAGE'}
  local idx=math.min(5,math.floor(elapsed/60)+1)
  msg(center+4,elapsed>=300 and 'BLACK SEAL COMPLETE' or phases[id]====] ..
[====[x],colors.white)
  msg(center+6,elapsed>=300 and 'ALL EXTERNAL ACCESS TERMINATED' or 'PROTOCOL EXECUTION IN PROGRESS',colors.lightGray)
  msg(h-5,'AUTHORITY: CENTRAL COMMAND // LEVEL 5',colors.red)
  msg(h-3,'RESTORATION REQUIRES DEFCON 5',colors.lightGray)
  band(h,colors.red);msg(h,'OBLIVIO // EMERGENCY SECURITY CHANNEL',colors.white,colors.red)
]====] ..
[====[ else
  msg(3,'DEFCON 1',colors.red)
  msg(5,'BLACK SEAL',colors.white)
  msg(7,flash and 'ACCESS DENIED' or 'LOCKDOWN ACTIVE',colors.red)
  msg(10,'ARCHIVE SEAL',colors.orange)
  msg(12,'T-'..string.format('%02d:%02d',math.floor(left/60),left%60),colors.red)
  bar(14,elapsed/300,math.min(12,w-4))
  local labels={'SEAL CHANNEL','REVOKE ACCESS','ISO]====] ..
[====[LATE INDEX','KEY SANITIZE','FINAL STAGE'}
  msg(17,elapsed>=300 and 'SEAL COMPLETE' or labels[math.min(5,math.floor(elapsed/60)+1)],colors.white)
  msg(h-5,'CENTRAL AUTH',colors.lightGray)
  msg(h-4,'LEVEL 5 ONLY',colors.red)
  msg(h-2,'RESET: DEFCON 5',colors.white)
  band(h,colors.red);msg(h,'OBLIVIO OS',colors.white,colors.red)
 end
 return true]====] ..
[====[
end

while true do
 local ok,err=pcall(function() if not simulatedLockdown() and not alternateView(Modes.get()) then draw() end end)
 if not ok then
  mon.setBackgroundColor(C.black);mon.setTextColor(C.red);mon.clear()
  mon.setCursorPos(1,1);mon.write('SECONDARY ERROR')
  mon.setCursorPos(1,2);mon.write(tostring(err):sub(1,18))
 end
 sleep(1)
end]====] ..
[====[
]====]
files['startup.lua']=[====[-- OBLIVIO OS 5.1 / animated boot + auto-discovered displays + Pocket client
if pocket then shell.run('pocket.lua');return end
local cfg=dofile('config.lua')
local Displays=dofile('lib/displays.lua')
local native=term.native()
term.redirect(native)
local primary=Displays.get('primary')
local secondary=Displays.get('secondary')
local function splash]====] ..
[====[(m)
 if not m then return end
 pcall(function()
  m.setTextScale(0.5)
  local w,h=m.getSize()
  m.setBackgroundColor(colors.black);m.setTextColor(colors.red);m.clear()
  local word='OBLIVIO'
  m.setCursorPos(math.max(1,math.floor((w-#word)/2)+1),math.max(1,math.floor(h/2)))
  m.write(word)
 end)
end
splash(primary);splash(secondary)
term.setBackgro]====] ..
[====[undColor(colors.black);term.setTextColor(colors.red);term.clear()
term.setCursorPos(1,1);print('OBLIVIO 5.1 // COMMAND TERMINAL')
term.setTextColor(colors.gray);print(string.rep('-',(term.getSize())))
local steps={
 {'CONFIG',function() return fs.exists('config.lua') end},
 {'DATA STORE',function() dofile('lib/data.lua').init();return true end},
 {]====] ..
[====['CLASSIFIED VAULT',function() return dofile('lib/secure.lua').configured() end},
 {'NETWORK MODEM',function()
   for _,n in ipairs(peripheral.getNames()) do if peripheral.getType(n)=='modem' then return true end end
   return false
  end},
 {'DISPLAYS',function() return primary~=nil end},
 {'ALERT SYSTEM',function() return type(dofile('lib/alert.lu]====] ..
[====[a').get())=='number' end}
}
for _,s in ipairs(steps) do
 term.setTextColor(colors.lightGray);write(s[1]..' ')
 local w=term.getSize()
 local x=select(1,term.getCursorPos())
 write(string.rep('.',math.max(1,w-8-x)))
 local ok,res=pcall(s[2])
 sleep(0.2)
 if ok and res then term.setTextColor(colors.lime);print(' [OK]')
 else term.setTextColor(colors.]====] ..
[====[yellow);print(' [WARN]') end
end
term.setTextColor(colors.red);print('');print('SYSTEM ONLINE')
sleep(1)
term.setBackgroundColor(colors.black);term.setTextColor(colors.red);term.clear()
term.setCursorPos(1,1);print('OBLIVIO 5.1 // COMMAND TERMINAL')
if cfg.role=='central' then
 local jobs={function() term.redirect(native);shell.run('central.lua') e]====] ..
[====[nd}
 if primary then jobs[#jobs+1]=function() shell.run('dashboard.lua') end end
 if secondary then jobs[#jobs+1]=function() shell.run('secondary.lua') end end
 parallel.waitForAll(table.unpack(jobs))
elseif cfg.role=='terminal' then shell.run('terminal.lua')
else print('Invalid role: '..tostring(cfg.role)) end
term.redirect(native)
]====]
files['terminal.lua']=[====[-- OBLIVIO OS 6.2 / COMMAND TERMINAL REWORK
-- Compatible with central protocol oblivio_v2. No remote filesystem modifications.
local Net=dofile('lib/net.lua')
local Secure=dofile('lib/secure.lua')
local cfg=dofile('config.lua')
local Log=dofile('lib/log.lua')
local centralID=nil
local authorized=false
local lastAlert='NONE'
local connectedAt=os.cl]====] ..
[====[ock()
local history={}
local selected=1
local bootAt=os.clock()
local function line(y,text,color,bg)
 local w,h=term.getSize()
 if y<1 or y>h then return end
 term.setCursorPos(1,y)
 term.setBackgroundColor(bg or colors.black)
 term.setTextColor(color or colors.white)
 term.write(tostring(text):sub(1,w)..string.rep(' ',math.max(0,w-#tostring(text))]====] ..
[====[))
end
local function frame(title,subtitle)
 local w,h=term.getSize()
 term.setBackgroundColor(colors.black);term.clear()
 line(1,' O B L I V I O  O S  //  COMMAND TERMINAL 6.2',colors.white,colors.red)
 line(2,' '..(title or 'CENTRAL UPLINK')..'  |  NODE '..os.getComputerID(),colors.red)
 line(3,' '..(subtitle or 'SECURE NETWORK INTERFACE'),colors]====] ..
[====[.lightGray)
 line(h,' [UP/DOWN] SELECT  [ENTER] OPEN  [Q] BACK',colors.lightGray)
end
local function center(y,text,color)
 local w=term.getSize()
 term.setCursorPos(math.max(1,math.floor((w-#text)/2)+1),y)
 term.setTextColor(color or colors.white)
 term.write(text:sub(1,w))
end
local function pause()
 local _,h=term.getSize()
 line(h,' PRESS ENTER ]====] ..
[====[/ SPACE TO RETURN',colors.gray)
 while true do
  local e,k=os.pullEvent()
  if e=='key' and (k==keys.enter or k==keys.numPadEnter or k==keys.space or k==keys.escape) then return end
 end
end
local function logEvent(s)
 history[#history+1]=os.date('%H:%M:%S')..' '..tostring(s)
 if #history>50 then table.remove(history,1) end
end
local function reque]====] ..
[====[st(msg,timeout)
 if not centralID then return nil end
 Net.send(centralID,msg)
 local deadline=os.clock()+(timeout or 5)
 while os.clock()<deadline do
  local id,response=Net.receive(math.max(.1,deadline-os.clock()))
  if id==centralID and type(response)=='table' then
   if response.action=='ALERT' then
    lastAlert=tostring(response.text or 'ALER]====] ..
[====[T')
    logEvent('ALERT '..lastAlert)
   else return response end
  end
 end
 return nil
end
local function discover()
 frame('NETWORK DISCOVERY','SEARCHING CENTRAL COMMAND')
 Net.broadcast({action='HELLO'})
 local deadline=os.clock()+6
 local spin={'|','/','-','\\'}
 local step=1
 while os.clock()<deadline do
  local w,h=term.getSize()
  line(math]====] ..
[====[.max(5,math.floor(h/2)),' SCANNING REDNET '..spin[step]..'  CENTRAL NODE 40',colors.yellow)
  step=step%4+1
  local id,msg=Net.receive(.25)
  if id and type(msg)=='table' and msg.action=='WELCOME' and id==40 then
   centralID=id;logEvent('UPLINK ESTABLISHED / 40');return true
  end
 end
 frame('NETWORK OFFLINE','CENTRAL ID 40 NOT FOUND')
 line(6,' ]====] ..
[====[Verify wireless modems and central server.',colors.red)
 pause();return false
end
local function login()
 frame('IDENTITY VERIFICATION','CHALLENGE-RESPONSE AUTHENTICATION')
 local r=request({action='AUTH_CHALLENGE'},5)
 if not r or r.action~='AUTH_CHALLENGE_RESULT' or not r.nonce then
  line(7,' AUTH CHALLENGE UNAVAILABLE',colors.red);pause();retur]====] ..
[====[n false
 end
 line(6,' CENTRAL AUTHORITY: 40',colors.lightGray)
 line(8,' ADMIN PIN:',colors.yellow)
 term.setCursorPos(3,10);term.setTextColor(colors.white)
 local pin=read('*')
 local proof=Secure.sha256(tostring(pin)..':'..r.nonce)
 pin=nil
 local answer=request({action='AUTH',proof=proof},5)
 if answer and answer.action=='AUTH_RESULT' and answe]====] ..
[====[r.ok then
  authorized=true;logEvent('AUTHENTICATED')
  pcall(Log.write,'AUTH','Terminal 6.2 authenticated')
  return true
 end
 frame('ACCESS DENIED','INVALID AUTHORIZATION')
 line(7,answer and answer.locked and ' TERMINAL LOCKED / RETRY LATER' or ' INVALID CREDENTIALS',colors.red)
 pause();return false
end
local function dashboard()
 local r=requ]====] ..
[====[est({action='STATUS'})
 frame('COMMAND OVERVIEW','LIVE CENTRAL STATUS')
 if not r then line(7,' CENTRAL NOT RESPONDING',colors.red);pause();return end
 local values={
  {'CENTRAL CORE',r.core},{'DEFCON LEVEL',r.defcon},
  {'ACTIVE PROJECTS',r.projects},{'EXPERIMENTS',r.experiments},
  {'PERIPHERALS',r.peripherals},{'RADIO ALERT',lastAlert}
 }
 for ]====] ..
[====[i,v in ipairs(values) do
  line(5+i*2,string.format(' %-18s : %s',v[1],tostring(v[2] or 'UNKNOWN')),i==2 and colors.red or colors.white)
 end
 pause()
end
local function controls()
 local names={}
 for n in pairs(cfg.outputs or {}) do names[#names+1]=n end
 table.sort(names)
 if #names==0 then
  frame('INFRASTRUCTURE','NO CONFIGURED OUTPUTS')
  lin]====] ..
[====[e(7,' Configure outputs in config.lua on the central.',colors.yellow)
  pause();return
 end
 local idx=1
 while true do
  frame('INFRASTRUCTURE CONTROL','REMOTE REDSTONE / CONFIRM EACH ACTION')
  local _,h=term.getSize()
  local visible=math.max(1,h-8)
  local offset=math.max(0,math.min(idx-math.floor(visible/2),#names-visible))
  for j=1,math.min(]====] ..
[====[visible,#names-offset) do
   local k=j+offset
   line(4+j,(k==idx and ' > ' or '   ')..names[k],k==idx and colors.yellow or colors.lightGray)
  end
  local e,k=os.pullEvent()
  if e=='key' then
   if k==keys.up then idx=math.max(1,idx-1)
   elseif k==keys.down then idx=math.min(#names,idx+1)
   elseif k==keys.escape then return
   elseif k==keys.en]====] ..
[====[ter or k==keys.numPadEnter then
    frame('ACTION CONFIRMATION','REMOTE INFRASTRUCTURE')
    line(7,' TARGET: '..names[idx],colors.yellow)
    line(9,' Press Y to send command, N to cancel.',colors.red)
    local _,choice=os.pullEvent('char')
    if choice:lower()=='y' then
     local r=request({action='CONTROL',name=names[idx]})
     frame('COMMAN]====] ..
[====[D RESULT','CENTRAL RESPONSE')
     line(7,r and tostring(r.message or r.action) or 'NO RESPONSE',r and colors.lime or colors.red)
     logEvent('CONTROL '..names[idx])
     pause()
    end
   end
  elseif e=='char' and k:lower()=='q' then return end
 end
end
local function radio()
 frame('RADIO TRAFFIC','LAST CENTRAL SECURITY ALERT')
 line(6,' '..l]====] ..
[====[astAlert,colors.red)
 line(9,' Messages are received during central requests.',colors.gray)
 pause()
end
local function diagnostic()
 frame('TERMINAL DIAGNOSTICS','LOCAL SYSTEM TELEMETRY')
 local modems=0
 for _,n in ipairs(peripheral.getNames()) do if peripheral.hasType(n,'modem') then modems=modems+1 end end
 local entries={
  'NODE ID: '..os.get]====] ..
[====[ComputerID(),
  'CENTRAL ID: '..tostring(centralID or 'OFFLINE'),
  'MODEMS: '..modems,
  'FREE STORAGE: '..tostring(fs.getFreeSpace('/'))..' B',
  'UPTIME: '..math.floor(os.clock())..' SEC',
  'AUTHENTICATED: '..tostring(authorized),
  'LINK PROTOCOL: '..Net.protocol()
 }
 for i,v in ipairs(entries) do line(4+i*2,' '..v,colors.lightGray) end
 paus]====] ..
[====[e()
end
local function activity()
 frame('SESSION ACTIVITY','LOCAL TERMINAL AUDIT')
 local _,h=term.getSize()
 local first=math.max(1,#history-(h-7))
 for i=first,#history do line(4+i-first+1,' '..history[i],colors.lightGray) end
 pause()
end
local function boot()
 term.setBackgroundColor(colors.black);term.clear()
 local w,h=term.getSize()
 local ]====] ..
[====[stages={'INITIALIZING COMMAND TERMINAL','LOADING SECURE CHANNEL',
  'ESTABLISHING REDNET UPLINK','VERIFYING CENTRAL AUTHORITY','READY'}
 for i,s in ipairs(stages) do
  frame('SYSTEM INITIALIZATION','COMMAND TERMINAL / VERSION 6.2')
  center(math.floor(h/2)-1,s,i==#stages and colors.lime or colors.red)
  center(math.floor(h/2)+1,'['..string.rep('#',]====] ..
[====[i*6)..string.rep('-',30-i*6)..']',colors.red)
  sleep(.22)
 end
end
local function main()
 local opened=Net.openAll()
 boot()
 if #opened==0 then frame('NO MODEM','NETWORK UNAVAILABLE');pause();return end
 if not discover() or not login() then return end
 local options={
  {'CENTRAL OVERVIEW',dashboard},
  {'INFRASTRUCTURE CONTROL',controls},
  {'S]====] ..
[====[ECURITY RADIO',radio},
  {'TERMINAL DIAGNOSTICS',diagnostic},
  {'SESSION ACTIVITY',activity},
  {'RECONNECT CENTRAL',function() discover() end},
  {'DISCONNECT',function() return 'exit' end}
 }
 while true do
  frame('COMMAND MENU','SECURE UPLINK '..tostring(centralID or 'OFFLINE'))
  local _,h=term.getSize()
  local visible=math.max(1,h-8)
  loca]====] ..
[====[l offset=math.max(0,math.min(selected-math.floor(visible/2),#options-visible))
  for i=1,math.min(visible,#options-offset) do
   local j=i+offset
   line(4+i,(j==selected and ' > ' or '   ')..options[j][1],
    j==selected and colors.yellow or colors.lightGray)
  end
  local e,k=os.pullEvent()
  if e=='key' then
   if k==keys.up then selected=math.]====] ..
[====[max(1,selected-1)
   elseif k==keys.down then selected=math.min(#options,selected+1)
   elseif k==keys.escape then break
   elseif k==keys.enter or k==keys.numPadEnter then
    local result=options[selected][2]()
    if result=='exit' then break end
   end
  elseif e=='char' then
   if k:lower()=='q' then break end
   local n=tonumber(k)
   if n an]====] ..
[====[d n>=1 and n<=#options then selected=n end
  end
 end
 logEvent('SESSION CLOSED')
 pcall(Log.write,'NETWORK','Terminal 6.2 disconnected')
 frame('SESSION TERMINATED','SECURE LINK CLOSED')
end
local ok,err=pcall(main)
if not ok then
 term.setBackgroundColor(colors.black);term.clear()
 print('OBLIVIO TERMINAL 6.2 / ERROR')
 print(tostring(err))
end
]====]
local cfgPath='config.lua'
if not fs.exists(cfgPath) then
 print('CONFIG MISSING: config.lua is required.')
 print('This FULL package includes all OS code, but does not invent your PIN, IDs or peripherals.')
 print('Install/configure the original OBLIVIO config.lua first. No files changed.')
 return
end
local ok,cfg=pcall(dofile,cfgPath)
if not ok or type(cfg)~='table' then
 print('Invalid config.lua. No files changed.');return
end
local role=tostring(cfg.role or ''):lower()
local pocket=role=='pocket' or (pocket and pocket.isPocket and pocket.isPocket())
local selected={}
if pocket then
 for _,p in ipairs({'pocket.lua','lib/ui.lua','lib/net.lua','lib/log.lua','lib/data.lua','lib/access.lua','lib/alert.lua','lib/links.lua','lib/report.lua','lib/theme.lua','lib/secure.lua'}) do
  if files[p] then selected[#selected+1]=p end
 end
else
 for p in pairs(files) do selected[#selected+1]=p end
end
table.sort(selected)
local changed={}
local growth=0
local staging=0
for _,p in ipairs(selected) do
 if not (p=='startup.lua' and fs.exists(p)) then
  local f=fs.exists(p) and fs.open(p,'r') or nil
  local old=f and f.readAll() or nil
  if f then f.close() end
  if old~=files[p] then
   changed[#changed+1]=p
   growth=growth+math.max(0,#files[p]-(old and #old or 0))
   staging=staging+#files[p]
  end
 end
end
local free=fs.getFreeSpace('/')
print('OBLIVIO OS 6.2 FULL // '..(pocket and 'POCKET' or 'CENTRAL / TERMINAL'))
print('Files in package: '..#selected..' | Changes: '..#changed)
print('Space available: '..tostring(free))
print('Space for staging: '..staging..' bytes')
if type(free)=='number' and free<staging+8192 then
 print('INSUFFICIENT SPACE. No changes made.')
 print('Free space or use the 6.1 incremental updater instead.')
 return
end
if #changed==0 then print('Already up to date.');return end
print('Preserved: config.lua, data/, backups, vault and existing startup.lua.')
print('This package installs code only; no automatic backup is created.')
write('Type INSTALL to continue: ')
if read()~='INSTALL' then print('Cancelled.');return end
local staged={}
local function cleanup()
 for _,t in ipairs(staged) do if fs.exists(t.tmp) then fs.delete(t.tmp) end end
end
for _,p in ipairs(changed) do
 local dir=fs.getDir(p)
 if dir~='' and not fs.exists(dir) then fs.makeDir(dir) end
 local tmp=p..'.full62repairedstage'
 if fs.exists(tmp) then print('Staging collision: '..tmp);cleanup();return end
 local f=fs.open(tmp,'w')
 if not f then print('Could not stage '..p);cleanup();return end
 local wok,werr=pcall(function() f.write(files[p]) end)
 f.close()
 if not wok then print('Write failed: '..tostring(werr));cleanup();return end
 local v=fs.open(tmp,'r')
 local same=v and v.readAll()==files[p]
 if v then v.close() end
 if not same then print('Verification failed: '..p);cleanup();return end
 staged[#staged+1]={path=p,tmp=tmp}
end
for _,t in ipairs(staged) do
 if fs.exists(t.path) then fs.delete(t.path) end
 fs.move(t.tmp,t.path)
 print('Installed: '..t.path)
end
print('OBLIVIO OS 6.2 FULL installed. Reboot to activate.')
print('Existing startup.lua was intentionally preserved.')
