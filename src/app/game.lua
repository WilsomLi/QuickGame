
game = game or {}

game.startup = function ()
    require("app.MyApp").new():run()
end