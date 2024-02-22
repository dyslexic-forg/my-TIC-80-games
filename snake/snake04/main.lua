-- title:   snake
-- author:  danilo
-- desc:    a simple snake game
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua
package.path = package.path..";/home/danilo/.local/share/com.nesbox.tic/TIC-80/my-games-tic-80/snake/snake02/?.lua"

require "scenes/gamescene"
require "scenes/titlescene"
require "scenes/pausescene"
require "scenes/countdownscene"
require "scenes/gameoverscene"
require "scenemanager"
require "snake"
require "food"
require "utils"
require "question"

SCREEN_WIDTH = 240
SCREEN_HEIGHT = 136
SQUARE_SIZE = 8
GRID_WIDTH = SCREEN_WIDTH // SQUARE_SIZE
GRID_HEIGHT = SCREEN_HEIGHT // SQUARE_SIZE
DEFAULT_FONT_WIDTH = 6

GlobalSceneManager = SceneManager:new({
		["play"] = function() return GameScene:new() end,
		["title"] = function() return TitleScene:new() end,
		["pause"] = function() return PauseScene:new() end,
		["count"] = function() return CountDownScene:new() end,
		["gameover"] = function() return GameOverScene:new() end,
})

GlobalSceneManager:push("title")

function TIC()
	GlobalSceneManager:update(1/60)
	GlobalSceneManager:draw()
end

-- <TILES>
-- 001:0666666666666666666666666666666666666666666666667666666607777777
-- 002:6666666666666666666666666666666666666666666666666666666677777777
-- 003:666660006fff660066666600666666226fff6600666666006666670077777000
-- 004:666660006fff660066666600666666206fff6600666666006666670077777000
-- 005:666660006fff660066666600666666006fff6600666666006666670077777000
-- 006:6666666666666666666666666666666666666666666666666666666666666666
-- 007:0000060000226660022112200222222002222220012222100011110000000000
-- 049:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 050:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 051:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddd
-- 052:dddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 065:dddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddddf
-- 066:ddddddddddddddddddddddddddddddddddddddddddddddddddddddddffffffff
-- 067:ddddddddddddddddddddddddddddddddddddddddddddddddddddddddffffffff
-- 068:dddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 081:dddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 082:9999999999999999999999999999999999999999999999999999999999999999
-- 083:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 084:dddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 097:dddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 098:aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa
-- 099:9999999999999999999999999999999999999999999999999999999999999999
-- 100:dddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddf
-- 113:ddddddddddddddddddddddddddddddddddddddddddddddddddddddddffffffff
-- 114:ddddddddddddddddddddddddddddddddddddddddddddddddddddddddffffffff
-- 115:ddddddddddddddddddddddddddddddddddddddddddddddddddddddddffffffff
-- 116:dddddddfdddddddfdddddddfdddddddfdddddddfdddddddfdddddddfffffffff
-- </TILES>

-- <MAP>
-- 000:131313131313131313131313131313131313131313131313131313131344000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 001:142424242424242424242424242424242424242424242424242424242444000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 002:163525352535253525352535253525352535253525352535253525352544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 003:162535253525352535253525352535253525352535253525352535253544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 004:163525352535253525352535253525352535253525352535253525352544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 005:162535253525352535253525352535253525352535253525352535253544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 006:163525352535253525352535253525352535253525352535253525352544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 007:162535253525352535253525352535253525352535253525352535253544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 008:163525352535253525352535253525352535253525352535253525352544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 009:162535253525352535253525352535253525352535253525352535253544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 010:163525352535253525352535253525352535253525352535253525352544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 011:162535253525352535253525352535253525352535253525352535253544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 012:163525352535253525352535253525352535253525352535253525352544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 013:162535253525352535253525352535253525352535253525352535253544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 014:163525352535253525352535253525352535253525352535253525352544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 015:162535253525352535253525352535253525352535253525352535253544000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- 016:173737373737373737373737373737373737373737373737373737373747000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </MAP>

-- <WAVES>
-- 000:00000000ffffffff00000000ffffffff
-- 001:0123456789abcdeffedcba9876543210
-- 002:0123456789abcdef0123456789abcdef
-- </WAVES>

-- <SFX>
-- 000:000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000304000000000
-- </SFX>

-- <TRACKS>
-- 000:100000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000
-- </TRACKS>

-- <PALETTE>
-- 000:1a1c2c5d275db13e53ef7d57ffcd75a7f07038b76425717929366f3b5dc941a6f673eff7f4f4f494b0c2566c86333c57
-- </PALETTE>
