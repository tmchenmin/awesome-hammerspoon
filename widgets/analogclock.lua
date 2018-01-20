seccolor = {red=158/255,blue=158/255,green=158/255,alpha=0.5}
tofilledcolor = {red=1,blue=1,green=1,alpha=0.1}
secfillcolor = {red=158/255,blue=158/255,green=158/255,alpha=0.1}
mincolor = {red=24/255,blue=195/255,green=145/255,alpha=0.75}
hourcolor = {red=236/255,blue=39/255,green=109/255,alpha=0.75}

if not aclockcenter then
    local mainScreen = hs.screen.primaryScreen()
    local mainRes = mainScreen:fullFrame()
    aclockcenter = {x=160,y=200}
end

clocks = {}

function showAnalogClock(screen)
    if not clocks[screen:id()] then
        clocks[screen:id()] = {} 
    end
    local clock = clocks[screen:id()]
    clock.screen = screen
    clock.mainRes = screen:fullFrame()
    clock.localMainRes = screen:absoluteToLocal(clock.mainRes)
    if not aclockcenter then
        clock.center = {x=160,y=200}
    else
        clock.center = aclockcenter
    end
    local aclockcenter = clock.center

    if not clock.bgcirle then
        imagerect = hs.geometry.rect(screen:localToAbsolute(aclockcenter.x-100,aclockcenter.y-100,200,200))
        clock.imagedisp = hs.drawing.image(imagerect,hs.fs.pathToAbsolute(hs.configdir..'/resources/watchbg.png'))
        clock.imagedisp:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.imagedisp:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.imagedisp:show()

        clock.bgcirle = hs.drawing.arc(aclockcenter,80,0,360)
        clock.bgcirle:setFill(false)
        clock.bgcirle:setStrokeWidth(1)
        clock.bgcirle:setStrokeColor(seccolor)
        clock.bgcirle:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.bgcirle:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.bgcirle:show()

        clock.mincirle = hs.drawing.arc(aclockcenter,55,0,360)
        clock.mincirle:setFill(false)
        clock.mincirle:setStrokeWidth(3)
        clock.mincirle:setStrokeColor(tofilledcolor)
        clock.mincirle:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.mincirle:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.mincirle:show()

        clock.hourcirle = hs.drawing.arc(aclockcenter,40,0,360)
        clock.hourcirle:setFill(false)
        clock.hourcirle:setStrokeWidth(3)
        clock.hourcirle:setStrokeColor(tofilledcolor)
        clock.hourcirle:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.hourcirle:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.hourcirle:show()

        clock.sechand = hs.drawing.arc(aclockcenter,80,0,0)
        clock.sechand:setFillColor(secfillcolor)
        clock.sechand:setStrokeWidth(1)
        clock.sechand:setStrokeColor(seccolor)
        clock.sechand:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.sechand:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.sechand:show()

        clock.minhand1 = hs.drawing.arc(aclockcenter,55,0,0)
        clock.minhand1:setFill(false)
        -- minhand:setStrokeWidth(3)
        clock.minhand1:setStrokeColor(mincolor)
        clock.minhand1:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.minhand1:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.minhand1:show()
        clock.minhand2 = hs.drawing.arc(aclockcenter,54,0,0)
        clock.minhand2:setFill(false)
        clock.minhand2:setStrokeColor(mincolor)
        clock.minhand2:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.minhand2:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.minhand2:show()
        clock.minhand3 = hs.drawing.arc(aclockcenter,53,0,0)
        clock.minhand3:setFill(false)
        clock.minhand3:setStrokeColor(mincolor)
        clock.minhand3:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.minhand3:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.minhand3:show()

        clock.hourhand1 = hs.drawing.arc(aclockcenter,40,0,0)
        clock.hourhand1:setFill(false)
        clock.hourhand1:setStrokeColor(hourcolor)
        clock.hourhand1:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.hourhand1:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.hourhand1:show()
        clock.hourhand2 = hs.drawing.arc(aclockcenter,39,0,0)
        clock.hourhand2:setFill(false)
        clock.hourhand2:setStrokeColor(hourcolor)
        clock.hourhand2:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.hourhand2:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.hourhand2:show()
        clock.hourhand3 = hs.drawing.arc(aclockcenter,38,0,0)
        clock.hourhand3:setFill(false)
        clock.hourhand3:setStrokeColor(hourcolor)
        clock.hourhand3:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        clock.hourhand3:setLevel(hs.drawing.windowLevels.desktopIcon)
        clock.hourhand3:show()

        if clock.clocktimer == nil then
            clock.clocktimer = hs.timer.doEvery(1,function() updateClock(clock) end)
        else
            clock.clocktimer:start()
        end
    else
        clock.clocktimer:stop()
        clock.clocktimer=nil
        clock.imagedisp:delete()
        clock.imagedisp=nil
        clock.bgcirle:delete()
        clock.bgcirle=nil
        clock.mincirle:delete()
        clock.mincirle=nil
        clock.hourcirle:delete()
        clock.hourcirle=nil
        clock.sechand:delete()
        clock.sechand=nil
        clock.minhand1:delete()
        clock.minhand1=nil
        clock.minhand2:delete()
        clock.minhand2=nil
        clock.minhand3:delete()
        clock.minhand3=nil
        clock.hourhand1:delete()
        clock.hourhand1=nil
        clock.hourhand2:delete()
        clock.hourhand2=nil
        clock.hourhand3:delete()
        clock.hourhand3=nil
    end
end

function updateClock(clock)
    local secnum = math.tointeger(os.date("%S"))
    local minnum = math.tointeger(os.date("%M"))
    local hournum = math.tointeger(os.date("%I"))
    local seceangle = 6*secnum
    local mineangle = 6*minnum+6/60*secnum
    local houreangle = 30*hournum+30/60*minnum+30/60/60*secnum

    clock.sechand:setArcAngles(0,seceangle)
    clock.minhand1:setArcAngles(0,mineangle)
    clock.minhand2:setArcAngles(0,mineangle)
    clock.minhand3:setArcAngles(0,mineangle)
    if houreangle >= 360 then
        houreangle = houreangle - 360
    end
    clock.hourhand1:setArcAngles(0,houreangle)
    clock.hourhand2:setArcAngles(0,houreangle)
    clock.hourhand3:setArcAngles(0,houreangle)
end

function showAnalogClocks()
    for i=1,#hs.screen.allScreens() do
        showAnalogClock(hs.screen.allScreens()[i])
    end
end

if not launch_analogclock then launch_analogclock = true end
if launch_analogclock == true then showAnalogClocks() end
