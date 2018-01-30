timelapses = {}

function showTimelapse(screen)
    if not timelapses[screen:id()] then 
        timelapses[screen:id()] = {}
    end
    local timelapse = timelapses[screen:id()]
    timelapse.screen = screen
    timelapse.mainRes = screen:fullFrame()
    timelapse.localMainRes = screen:absoluteToLocal(timelapse.mainRes)

    if not timelapsetopleft then
        timelapse.topleft = {timelapse.localMainRes.w-280-120, timelapse.localMainRes.h-125-400}
    else
        timelapse.topleft = timelapsetopleft
    end
    local timelapsetopleft = timelapse.topleft

    local canvasrect = hs.geometry.rect(screen:localToAbsolute({x=timelapsetopleft[1],y=timelapsetopleft[2],w=280,h=125}))
    if not timelapse.canvas then
        timelapse.canvas = hs.canvas.new(canvasrect)
        timelapse.canvas:behavior(hs.canvas.windowBehaviors.canJoinAllSpaces)
        timelapse.canvas:level(hs.canvas.windowLevels.desktopIcon)
        timelapse.canvas:show()
    else
        timelapse.canvas:frame(canvasrect)
    end

    -- canvas background
    timelapse.canvas[1] = {
        action = "fill",
        type = "rectangle",
        fillColor = black,
        roundedRectRadii = {xRadius=5, yRadius=5},
    }
    timelapse.canvas[1].fillColor.alpha = .2
    -- title
    timelapse.canvas[2] = {
        type = "text",
        text = "Time Elapsed",
        textSize = 14,
        textColor = white,
        frame = {
            x = tostring(10/280),
            y = tostring(10/125),
            w = tostring(260/280),
            h = tostring(25/125),
        }
    }
    timelapse.canvas[2].textColor.alpha = .3
    -- time
    timelapse.canvas[3] = {
        type = "text",
        text = "",
        textColor = {hex="#A6AAC3"},
        textSize = 17,
        textAlignment = "center",
        frame = {
            x = tostring(0/280),
            y = tostring(35/125),
            w = tostring(280/280),
            h = tostring(25/125),
        }
    }
    -- indicator background
    timelapse.canvas[4] = {
        type = "image",
        image = hs.image.imageFromPath(hs.fs.pathToAbsolute(hs.configdir..'/resources/timebg.png')),
        frame = {
            x = tostring(10/280),
            y = tostring(65/125),
            w = tostring(260/280),
            h = tostring(50/125),
        }
    }
    -- light indicator
    timelapse.canvas[5] = {
        action = "fill",
        type = "rectangle",
        fillColor = white,
        frame = {
            x = tostring(20/280),
            y = tostring(75/125),
            w = tostring(240/280),
            h = tostring(20/125),
        }
    }
    timelapse.canvas[5].fillColor.alpha = .2
    -- indicator mask
    timelapse.canvas[6] = {
        action = "fill",
        type = "rectangle",
        frame = {
            x = tostring(20/280),
            y = tostring(75/125),
            w = tostring(240/280),
            h = tostring(20/125),
        }
    }
    -- color indicator
    timelapse.canvas[7] = {
        action = "fill",
        type = "rectangle",
        frame = {
            x = tostring(20/280),
            y = tostring(75/125),
            w = tostring(240/280),
            h = tostring(20/125),
        },
        fillGradient="linear",
        fillGradientColors = {
            {hex = "#00A0F7"},
            {hex = "#92D2E5"},
            {hex = "#4BE581"},
            {hex = "#EAF25E"},
            {hex = "#F4CA55"},
            {hex = "#E04E4E"},
        },
    }
    timelapse.canvas[7].compositeRule = "sourceAtop"

    if timelapse.elapsedTimer == nil then
        timelapse.elapsedTimer = hs.timer.doEvery(1, function() updateElapsedCanvas(timelapse) end)
    else
        timelapse.elapsedTimer:start()
    end
end

function destroyTimelapse(idx)
   if timelapses[idx] then
       local timelapse = timelapses[idx]
       if hs.screen.find(timelapse.screen:id()) then
           return
       end
       if timelapse.elapsedTimer then
           timelapse.elapsedTimer:stop()
           timelapse.elapsedTimer=nil
       end
       if timelapse.canvas then
           timelapse.canvas:delete()
           timelapse.canvas=nil
       end
       timelapses[idx]=nil
   end
end

function updateElapsedCanvas(timelapse)
   local nowtable = os.date("*t")
   local nowyday = nowtable.yday
   local nowhour = string.format("%2s", nowtable.hour)
   local nowmin = string.format("%2s", nowtable.min)
   local nowsec = string.format("%2s", nowtable.sec)
   local timestr = nowyday.." days "..nowhour.." hours "..nowmin.." min "..nowsec.." sec"
   local secs_since_epoch = os.time()
   local nowyear = nowtable.year
   local yearstartsecs_since_epoch = os.time({year=nowyear, month=1, day=1, hour=0})
   local nowyear_elapsed_secs = secs_since_epoch - yearstartsecs_since_epoch
   local yearendsecs_since_epoch = os.time({year=nowyear+1, month=1, day=1, hour=0})
   local nowyear_total_secs = yearendsecs_since_epoch - yearstartsecs_since_epoch
   local elapsed_percent = nowyear_elapsed_secs/nowyear_total_secs
   if timelapse.canvas:isShowing() then
       timelapse.canvas[3].text = timestr
       timelapse.canvas[6].frame.w = tostring(240/280*elapsed_percent)
   end
end

function showTimelapses()
    showTimelapse(hs.screen.primaryScreen())
end

function destroyTimelapses()
    for i in pairs(timelapses) do
        destroyTimelapse(i)
    end
end

if not launch_timelapse then launch_timelapse = true end
if launch_timelapse == true then
    showTimelapses()
    hs.screen.watcher.newWithActiveScreen(function(activeChanged)
        if activeChanged then
            destroyTimelapses()
            hs.timer.doAfter(3, function()
                print('Refresh Timelapse')
                showTimelapses()
            end)
        end
    end):start()
end

