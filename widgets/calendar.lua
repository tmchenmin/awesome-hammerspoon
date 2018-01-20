caltodaycolor = hs.drawing.color.white
calcolor = {red=235/255,blue=235/255,green=235/255}
calbgcolor = {red=0,blue=0,green=0,alpha=0.3}

calendars = {}

function drawToday(calendar)
    local currentmonth = tonumber(os.date("%m"))
    -- local todayyearweek = os.date("%W")
    local todayyearweek = hs.execute("date -v+1d +'%W'")
    -- Year week of last day of last month
    local ldlmyearweek = hs.execute("date -v"..currentmonth.."m -v1d -v+1d +'%W'")
    local rowofcurrentmonth = todayyearweek - ldlmyearweek
    local columnofcurrentmonth = os.date("*t").wday
    local splitw = 205
    local splith = 141
    local todaycoverrect = hs.geometry.rect(calendar.screen:localToAbsolute(calendar.caltopleft[1]+10+splitw/7*(columnofcurrentmonth-1),calendar.caltopleft[2]+10+splith/7*(rowofcurrentmonth+2),splitw/7,splith/7))
    if not calendar.todaycover then
        calendar.todaycover = hs.drawing.rectangle(todaycoverrect)
        calendar.todaycover:setStroke(false)
        calendar.todaycover:setRoundedRectRadii(3,3)
        calendar.todaycover:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        calendar.todaycover:setLevel(hs.drawing.windowLevels.desktopIcon)
        calendar.todaycover:setFillColor(caltodaycolor)
        calendar.todaycover:setAlpha(0.3)
        calendar.todaycover:show()
    else
        calendar.todaycover:setFrame(todaycoverrect)
    end
end

function updateCal(calendar)
    local caltext = hs.styledtext.ansi(hs.execute("cal"),{font={name="Courier",size=16},color=calcolor})
    calendar.caldraw:setStyledText(caltext)
    drawToday(calendar.caltopleft)
end

function showCalendar(screen)
    if not calendars[screen:id()] then
        calendar = {}
        calendars[screen:id()] = calendar
        calendar.screen = screen
        local mainRes = screen:fullFrame()
        local localMainRes = screen:absoluteToLocal(mainRes)
        if not caltopleft then
            calendar.caltopleft = {localMainRes.w-330-20,localMainRes.h-161-84}
        else
            calendar.caltopleft = caltopleft
        end
        calendar.bgrect = hs.geometry.rect(screen:localToAbsolute(calendar.caltopleft[1],calendar.caltopleft[2],230,161))
        local calbg = hs.drawing.rectangle(calendar.bgrect)
        calendar.calbg = calbg
        calbg:setFillColor(calbgcolor)
        calbg:setStroke(false)
        calbg:setRoundedRectRadii(10,10)
        calbg:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        calbg:setLevel(hs.drawing.windowLevels.desktopIcon)
        calbg:show()

        local caltext = hs.styledtext.ansi(hs.execute("cal"),{font={name="Courier",size=16},color=calcolor})
        local calrect = hs.geometry.rect(screen:localToAbsolute(calendar.caltopleft[1]+15,calendar.caltopleft[2]+10,230,161))
        local caldraw = hs.drawing.text(calrect,caltext)
        calendar.caldraw = caldraw
        caldraw:setBehavior(hs.drawing.windowBehaviors.canJoinAllSpaces)
        caldraw:setLevel(hs.drawing.windowLevels.desktopIcon)
        caldraw:show()

        drawToday(calendar)
        if calendar.caltimer == nil then
            calendar.caltimer = hs.timer.doEvery(1800,function() updateCal(calendar) end)
        else
            calendar.caltimer:start()
        end
    else
        calendar = calendars[screen:id()]
        calendar.caltimer:stop()
        calendar.caltimer=nil
        calendar.todaycover:delete()
        calendar.todaycover=nil
        calendar.calbg:delete()
        calendar.calbg=nil
        calendar.caldraw:delete()
        calendar.caldraw=nil
        calendars[screen:id()] = nil 
    end
end

function showCalendars()
    for i=1,#hs.screen.allScreens() do
        showCalendar(hs.screen.allScreens()[i])
    end
end

if not launch_calendar then launch_calendar=true end
if launch_calendar == true then showCalendars() end
