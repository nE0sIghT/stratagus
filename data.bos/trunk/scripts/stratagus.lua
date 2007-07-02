--            ____            
--           / __ )____  _____
--          / __  / __ \/ ___/
--         / /_/ / /_/ (__  ) 
--        /_____/\____/____/  
--
--  Invasion - Battle of Survival                  
--   A GPL'd futuristic RTS game
--
--	stratagus.lua	-	The craft configuration language.
--
--	(c) Copyright 1998-2006 by Crestez Leonard and Francois Beerten
--
--      This program is free software; you can redistribute it and/or modify
--      it under the terms of the GNU General Public License as published by
--      the Free Software Foundation; either version 2 of the License, or
--      (at your option) any later version.
--  
--      This program is distributed in the hope that it will be useful,
--      but WITHOUT ANY WARRANTY; without even the implied warranty of
--      MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
--      GNU General Public License for more details.
--  
--      You should have received a copy of the GNU General Public License
--      along with this program; if not, write to the Free Software
--      Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
--
--	$Id$


print("Battle of Survival default config file loading ...\n")

-------------------------------------------------------------------------------
--	Config-Part
-------------------------------------------------------------------------------

--	Enter your default title screen.

SetTitleScreens(
      {Image="video/stratagus_intro.ogg"},
      {Image="video/bos_intro.ogg"}
)

--	Set the game name
SetGameName("bos")

-------------------------------------------------------------------------------
--	Music play list -	Insert your titles here
-------------------------------------------------------------------------------
playlist = {}
local musiclist = ListFilesInDirectory("music/")
for i,f in ipairs(musiclist) do
  if(string.find(f, ".ogg$") or string.find(f, ".wav$") or string.find(f, ".mp3$")) then 
    print("Added music file:" .. f) 
    playlist[i] = f
  end
end

SetSelectionStyle("corners")
Preference.ShowSightRange = false
Preference.ShowAttackRange = false
Preference.ShowReactionRange = false
Preference.ShowOrders = 2

ManaSprite("general/mana2.png", 0, -1, 31, 4)
HealthSprite("general/health2.png", 0, -4, 31, 4)

ShowHealthDot()
ShowManaDot()
ShowNoFull()

-------------------------------------------------------------------------------
--	Game modification
-------------------------------------------------------------------------------

--	Enable XP to add more damage to attacks?
SetXPDamage(true)

--	Edit this to enable/disable the training queues.
SetTrainingQueue(true)

--	Always reveal the attacker.
SetRevealAttacker(true)

-------------------------------------------------------------------------------

--  Fighters move by default.
RightButtonMoves();

--	Set the name of the missile to use when clicking (move order)
SetClickMissile("missile-green-cross")

--	Set the name of the missile to use when displaying damage
SetDamageMissile("missile-hit")

--	Enable stopping scrolling on mouse leave.
SetLeaveStops(true)

--	Enable mouse and keyboard scrolling.
SetMouseScroll(true)
SetKeyScroll(true)
SetMouseScrollSpeedDefault(4)
SetMouseScrollSpeedControl(15)

SetDoubleClickDelay(300)
SetHoldClickDelay(1000)

--	Enable minimap terrain by default.
SetMinimapTerrain(true)

--  Set Fog of War opacity
SetFogOfWarOpacity(128)

-------------------------------------------------------------------------------
--	Define default resources
-------------------------------------------------------------------------------

DefineDefaultIncomes(0, 100, 100, 100, 100, 100, 100)
DefineDefaultActions("stop", "mine", "harvest", "drill", "mine", "mine", "mine")

DefineDefaultResourceNames("time", "titanium", "crystal", "gas", "ore", "stone", "coal")

DefineDefaultResourceAmounts("titanium", 150, "crystal", 150, "gas", 150)

DefinePlayerColorIndex(208, 4)

DefinePlayerColors({
  "red", {{164, 0, 0}, {124, 0, 0}, {92, 4, 0}, {68, 4, 0}},
  "blue", {{12, 72, 204}, {4, 40, 160}, {0, 20, 116}, {0, 4, 76}},
  "violet", {{152, 72, 176}, {116, 44, 132}, {80, 24, 88}, {44, 8, 44}},
  "orange", {{248, 140, 20}, {200, 96, 16}, {152, 60, 16}, {108, 32, 12}},
  "black", {{40, 40, 60}, {28, 28, 44}, {20, 20, 32}, {12, 12, 20}},
  "white", {{224, 224, 224}, {152, 152, 180}, {84, 84, 128}, {36, 40, 76}},
  "yellow", {{252, 252, 72}, {228, 204, 40}, {204, 160, 16}, {180, 116, 0}},
  "green", {{44, 180, 148}, {20, 132, 92}, {4, 84, 44}, {0, 40, 12}},
})

function InitGameVariables()
   SetSpeeds(1)
   InitAiScripts()
end

AStar("fixed-unit-cost", 1000, "moving-unit-cost", 4, "dont-know-unseen-terrain", "unseen-terrain-cost", 2)

--	Maximum number of selectable units
SetMaxSelectable(24)

--	All player unit limit
SetAllPlayersUnitLimit(200)
--	All player building limit
SetAllPlayersBuildingLimit(200)
--	All player total unit limit
SetAllPlayersTotalUnitLimit(400)

-------------------------------------------------------------------------------
--  Default triggers for single player

function SinglePlayerTriggers()
  AddTrigger(
    function() return GetPlayerData(GetThisPlayer(),"TotalNumUnits") == 0 end,
    function() return StopGame(GameDefeat) end)

  AddTrigger(
    function() return GetNumOpponents(GetThisPlayer()) == 0 end,
    function() return StopGame(GameVictory) end)   
end

-------------------------------------------------------------------------------
--	Tables-Part
-------------------------------------------------------------------------------
SetFogOfWarGraphics("general/fog.png")

Load("preferences.lua")

if (preferences == nil) then
  preferences = {
    VideoWidth = 800,
    VideoHeight = 600,
    VideoFullScreen = false,
    PlayerName = "Player",
    FogOfWar = true,
    ShowCommandKey = true,
    GroupKeys = "0123456789`",
    GameSpeed = 30,
    EffectsEnabled = true,
    EffectsVolume = 128,
    MusicEnabled = true,
    MusicVolume = 128,
    StratagusTranslation = "",
    GameTranslation = "",
    TipNumber = 0,
    ShowTips = true,
    GrabMouse = false,
  }
end

SetVideoResolution(preferences.VideoWidth, preferences.VideoHeight)
SetVideoFullScreen(preferences.VideoFullScreen)
SetLocalPlayerName(preferences.PlayerName)
SetFogOfWar(preferences.FogOfWar)
UI.ButtonPanel.ShowCommandKey = preferences.ShowCommandKey
SetGroupKeys(preferences.GroupKeys)
SetGameSpeed(preferences.GameSpeed)
SetEffectsEnabled(preferences.EffectsEnabled)
SetEffectsVolume(preferences.EffectsVolume)
SetMusicEnabled(preferences.MusicEnabled)
SetMusicVolume(preferences.MusicVolume)
SetTranslationsFiles(preferences.StratagusTranslation, preferences.GameTranslation)
SetGrabMouse(preferences.GrabMouse)


--; Uses Stratagus Library path!
Load("scripts/bos.lua")
Load("scripts/icons.lua")
Load("scripts/sound.lua")
Load("scripts/missiles.lua")
Load("scripts/spells.lua")
Load("scripts/units.lua")
Load("scripts/fonts.lua")
Load("scripts/ui.lua")
Load("scripts/upgrade.lua")
Load("scripts/dependency.lua")
Load("scripts/buttons.lua")
Load("scripts/ai.lua")
Load("scripts/commands.lua")
Load("scripts/cheats.lua")
Load("scripts/maps.lua")


default_objective = _("Eliminate your enemies.")

print("... ready!")