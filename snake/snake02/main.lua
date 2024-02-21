-- title:   snake
-- author:  danilo
-- desc:    a simple snake game
-- site:    website link
-- license: MIT License (change this to your license of choice)
-- version: 0.1
-- script:  lua
package.path = package.path..";/home/danilo/.local/share/com.nesbox.tic/TIC-80/my-games-tic-80/snake/snake02/?.lua"

require "scenemanager"
require "scenes/gamescene"
require "scenes/titlescene"
require "scenes/pausescene"
require "scenes/countdownscene"
require "scenes/gameoverscene"
require "snake"
require "food"
require "utils"

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

GlobalSceneManager:change("title")

function TIC()
	GlobalSceneManager:update(1/60)
	GlobalSceneManager:draw()
end

-- <TILES>
-- 001:eccccccccc888888caaaaaaaca888888cacccccccacc0ccccacc0ccccacc0ccc
-- 002:ccccceee8888cceeaaaa0cee888a0ceeccca0ccc0cca0c0c0cca0c0c0cca0c0c
-- 003:eccccccccc888888caaaaaaaca888888cacccccccacccccccacc0ccccacc0ccc
-- 004:ccccceee8888cceeaaaa0cee888a0ceeccca0cccccca0c0c0cca0c0c0cca0c0c
-- 017:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 018:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- 019:cacccccccaaaaaaacaaacaaacaaaaccccaaaaaaac8888888cc000cccecccccec
-- 020:ccca00ccaaaa0ccecaaa0ceeaaaa0ceeaaaa0cee8888ccee000cceeecccceeee
-- </TILES>

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

