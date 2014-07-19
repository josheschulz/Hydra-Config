local config = {}

config.modules = {
    "monitors",
    "repl",
    "updates",
    "reload",
    "arrows",
    "lock",
    "slide",
    "hop"
}

-- Maps monitor id -> screen index.
config.monitors = {
    autodiscover = true,
}

config.autolaunch = true

config.lock = {
   mash = {"cmd"},
   key = "ESCAPE"
}

config.arrows = {
   mash = {"cmd"},
   keys = {   UP = "top",
        DOWN = "bottom",
        LEFT = "left",
        RIGHT = "right",
        SPACE = "full",
    }
}

config.slide = {
   mash = {"cmd", "ctrl"},
   step = 50 
}

config.hop = {
   mash = {"cmd"},
   keys = { k = "up",
    j = "down",
    h = "left",
    l = "right",
   }
}

return config
