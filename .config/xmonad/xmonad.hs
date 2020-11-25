{- 
Notes/thoughts:
I really like xmonad so far. I think this can be a very good replacement for dwm. 
I should learn more Haskell

I want to keep the config simple as possible and override defaults where I can.
I think the defaults are pretty good. Might want to play with some layouts though.

Todos:
- might add some spacing. 
- try out prompts + gridselect thing.
  - can be a dmenu/rofi replacement
- how does it work with multiple montitors?
  - what about the ultra wide monitor at work?
- hide xmobar using dbus interface?
-}

import XMonad
import XMonad.Actions.CycleWS (toggleWS) -- Toggle to prev workspace
import XMonad.Config.Desktop (desktopConfig) -- sane defaults
import XMonad.Hooks.DynamicLog (statusBar, xmobarPP, xmobarColor, wrap, PP(..)) -- statusbar
import XMonad.Util.EZConfig (additionalKeysP) -- emacs style keybindings
import XMonad.Layout.NoBorders (smartBorders) -- no borders when only 1 window
import XMonad.Util.SpawnOnce (spawnOnce) -- spawn program once, useful for startup

myManageHook = composeAll [ resource  =? "irc"   --> doShift "irc" ]

volDec    = spawn "pamixer -d 10"
volInc    = spawn "pamixer -i 10"
volMute   = spawn "pamixer -t"

myKeys = [ ("M-v j",                   volDec)
         , ("M-v k",                   volInc)
         , ("M-v m",                   volMute)
         , ("<XF86AudioLowerVolume>",  volDec)
         , ("<XF86AudioRaiseVolume>",  volInc)
         , ("<XF86AudioMute>",         volMute)
         , ("<XF86MonBrightnessDown>", spawn "~/bin/backlight s 10%-")
         , ("<XF86MonBrightnessUp>",   spawn "~/bin/backlight s +10%")
         , ("<XF86Tools>",             spawn "~/bin/cycle-kbd-brightness")
         , ("M-s s",     spawn "maim ~/Pictures/screenshots/screenshot-$(date +%Y-%m-%d-%H%M%S).png")
         , ("M-s S-s",   spawn "maim -s -c 255,0,0 ~/Pictures/screenshots/screenshot-$(date +%Y-%m-%d-%H%M%S).png")
         , ("M-s M-s",   spawn "maim | xclip -selection clipboard -t image/png")
         , ("M-s M-S-s", spawn "maim -s -c 255,0,0 | xclip -selection clipboard -t image/png")
         , ("M-<Tab>",   toggleWS)
         ]

toggleStrutsKey XConfig {XMonad.modMask = modMask} = (modMask, xK_b)

myStartupHook = do
    spawnOnce "setxkbmap no &"
    spawnOnce "feh --no-fehbg --bg-fill /home/tor/.config/lucie-capkova-ENovbLgx6M0-unsplash.png"
    spawnOnce "alacritty --class irc -t irc -e /home/tor/bin/irc"

myConfig = desktopConfig 
    { terminal           = "alacritty"
    , modMask            = mod4Mask
    , focusFollowsMouse  = False
    , workspaces         = ["web", "dev", "irc"] ++ map show [4..9]
    , normalBorderColor  = "#504945"
    , focusedBorderColor = "#b8bb26"
    , startupHook        = myStartupHook <+> startupHook desktopConfig
    , manageHook         = myManageHook <+> manageHook desktopConfig
    , layoutHook         = smartBorders $ layoutHook desktopConfig
    } `additionalKeysP` myKeys

myPP = xmobarPP { ppCurrent          = xmobarColor "#b8bb26" "" . wrap "[" "]"
                , ppTitle            = xmobarColor "#ebdbb2" ""
                , ppHidden           = xmobarColor "#ebdbb2" "" . wrap "+" ""
                , ppHiddenNoWindows  = xmobarColor "#ebdbb2" ""
                , ppSep              = xmobarColor "#ebdbb2" "" " | "
                }

main = xmonad =<< statusBar "xmobar" myPP toggleStrutsKey myConfig
