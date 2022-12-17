{-# OPTIONS_GHC -Wno-missing-signatures #-}

import           Control.Monad               (liftM2)
import qualified Data.Map                    as Map
import           Data.Time
import           Data.Word
import           System.Environment
import           System.Exit
import           System.IO.Unsafe            (unsafePerformIO)
import           XMonad
import           XMonad.Actions.CycleWS
import           XMonad.Actions.EasyMotion
import           XMonad.Actions.Submap
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.StatusBar
import           XMonad.Layout.Maximize
import           XMonad.Layout.Renamed
import           XMonad.Prompt
import           XMonad.Prompt.AppendFile
import           XMonad.Prompt.ConfirmPrompt
import           XMonad.Prompt.FuzzyMatch
import           XMonad.Prompt.Pass
import           XMonad.Prompt.Window
import           XMonad.Prompt.Workspace
import           XMonad.Prompt.Zsh
import qualified XMonad.StackSet             as W
import           XMonad.Util.EZConfig
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.Run             (runProcessWithInput)
import           XMonad.Util.SpawnOnce
import           XMonad.Util.Ungrab
import           XMonad.Util.XUtils

main :: IO ()
main = do
  setEnv "EDITOR" "alacritty -e nvim"
  xmonad
    . ewmhFullscreen
    . ewmh
    . withEasySB
        (statusBarProp "xmobar ~/.config/xmobar/xmobar.hs" (pure myXmobarPP))
        myToggleStrutsKey
    $ myConfig

getFromXres :: String -> IO String
getFromXres key = do
  installSignalHandlers
  runProcessWithInput "xrdb" ["-get", key] ""

xProp :: String -> String
xProp = unsafePerformIO . getFromXres

getDpi :: Int
getDpi = read $ xProp "Xft.dpi"

scaleWithDpi :: Int -> Int
scaleWithDpi x = (getDpi `div` 96) * x

scaleWithDpi' :: Word32 -> Word32
scaleWithDpi' x = fromIntegral $ scaleWithDpi $ fromIntegral x

-- Font and colors
myXftFontName = "xft:Iosevka"
myBgColor = "#282828"
myFgColor = "#ebdbb2"
myNormalBorderColor = "#7c6f64"
myFocusedBorderColor = "#b8bb26"

addToNotes dateFmt = do
  date <- io $ fmap (formatTime defaultTimeLocale dateFmt) getZonedTime
  appendFilePrompt' myXPConfig ("- " ++) $ "~/notes/journal/" ++ date ++ ".md"

-- Keybindings
myToggleStrutsKey :: XConfig t -> (KeyMask, KeySym)
myToggleStrutsKey XConfig { modMask = modm } = (modm .|. shiftMask, xK_b)
myKeys =
  [ ("M-S-z"  , spawn "i3lock -c 000000")
  , ("M-S-q", confirmPrompt myXPConfig "exit" $ io (exitWith ExitSuccess))
  , ("<Print>", unGrab *> spawn "flameshot gui")
  , ( "M-s"
    , visualSubmap myDefaultWindowConf
      $ Map.fromList
      $ [ ((0, xK_b), subName "Qutebrowser" $ spawn "qutebrowser")
        , ( (0, xK_o)
          , subName "Outlook" $ spawn "qutebrowser https://outlook.office.com"
          )
        , ( (0, xK_s)
          , subName "Spotify"
            $ spawn "qutebrowser --target window https://open.spotify.com"
          )
        ]
    )
  , ("M-<Tab>", toggleWS)
  , ("M-S-m", withFocused (sendMessage . maximizeRestore))
  , ( "M-f"
    , selectWindow easyMotionConfig >>= (`whenJust` windows . W.focusWindow)
    )
  , ("M-C-c", selectWindow easyMotionConfig >>= (`whenJust` killWindow))
  , ( "M-n"
    , visualSubmap myDefaultWindowConf
      $ Map.fromList
      $ [ ((0, xK_d), subName "Add to daily note" $ addToNotes "%Y-%m-%d")
        , ((0, xK_w), subName "Add to weekly note" $ addToNotes "%Y-%W")
        , ((0, xK_m), subName "Add to monthly note" $ addToNotes "%Y-%m")
        ]
    )
  , ("M-p", zshPrompt myXPConfig "/home/tor/.config/xmonad/capture.zsh")
  , ( "M-S-p"
    , visualSubmap myDefaultWindowConf
      $ Map.fromList
      $ [ ((0, xK_c), subName "Copy password" $ passPrompt myXPConfig)
        , ((0, xK_e), subName "Edit password" $ passEditPrompt myXPConfig)
        , ( (0, xK_g)
          , subName "Generate password" $ passGenerateAndCopyPrompt myXPConfig
          )
        , ((0, xK_i), subName "Insert password" $ passTypePrompt myXPConfig)
        ]
    )
  , ("M-g", windowPrompt myXPConfigWithAutoComplete Goto allWindows)
  , ( "M-b"
    , windowMultiPrompt myXPConfigWithAutoComplete
                        [(Bring, allWindows), (BringCopy, allWindows)]
    )
  , ("M-o"  , namedScratchpadAction scratchpads "obsidian")
  , ("M-ø", workspacePrompt myXPConfigWithAutoComplete (windows . W.greedyView))
  , ("M-S-ø", workspacePrompt myXPConfigWithAutoComplete (windows . W.shift))
  , ( "M-S-l"
    , visualSubmap myDefaultWindowConf
      $ Map.fromList
      $ [ ((0, xK_t), subName "Tall" $ (sendMessage . JumpToLayout) "Tall")
        , ( (0, xK_l)
          , subName "Mirror Tall" $ (sendMessage . JumpToLayout) "Mirror Tall"
          )
        , ((0, xK_f), subName "Full" $ (sendMessage . JumpToLayout) "Full")
        ]
    )
  ]

myConfig =
  def { modMask            = mod4Mask
      , focusFollowsMouse  = False
      , layoutHook         = myLayout
      , manageHook         = myManageHook
      , startupHook        = myStartupHook
      , terminal           = "alacritty"
      , normalBorderColor  = myNormalBorderColor
      , focusedBorderColor = myFocusedBorderColor
      , borderWidth        = 2
      , workspaces         = myWorkspaces
      }
    `additionalKeysP` myKeys
    `removeKeysP`     []

scratchpads =
  [ NS "obsidian"
       "obsidian"
       (className =? "obsidian")
       (doRectFloat (W.RationalRect (0) (0.02) (1) (0.98)))
  ]

myWorkspaces :: [String]
myWorkspaces =
  ["1:web", "2:dev"]
    ++ map (show :: Int -> String) [3 .. 7]
    ++ ["8:media", "9:chat"]
    ++ otherWorkspaces

otherWorkspaces =
  [  -- Work VPN sucks on linux. Seperate workspace for that
   "vpn"]

myManageHook :: ManageHook
myManageHook =
  composeAll
      [ className =? "float" --> doFloat
      , className =? "qutebrowser" --> viewShift "1:web"
      , className =? "Slack" --> viewShift "9:chat"
      , className =? "irc" --> doShift "9:chat"
      , appName =? "vpnbrowser" --> doShift "vpn"
      , isDialog --> doFloat
      , isFullscreen --> doFullFloat
      ]
    <+> namedScratchpadManageHook scratchpads
  where viewShift = doF . liftM2 (.) W.greedyView W.shift

myLayout = renamed [CutWordsLeft 1]
  $ maximize (tiled ||| Mirror tiled ||| Full)
 where
  tiled   = Tall nmaster delta ratio
  nmaster = 1 -- Default number of windows in the master pane
  ratio   = 1 / 2 -- Default proportion of screen occupied by master pane
  delta   = 3 / 100 -- Percent of screen to increment by when resizing panes

myXPConfig :: XPConfig
myXPConfig = def { font              = myXftFontName ++ "-11"
                 , maxComplRows      = Just 20
                 , bgColor           = myBgColor
                 , fgColor           = myFgColor
                 , bgHLight          = myFgColor
                 , fgHLight          = myBgColor
                 , borderColor       = "#b8bb26"
                 , promptBorderWidth = 2
                 , position          = Top
                 , height            = scaleWithDpi' 25
                 , changeModeKey     = xK_Alt_L
                 , searchPredicate   = fuzzyMatch
                 , sorter            = fuzzySort
                 }

myXPConfigWithAutoComplete :: XPConfig
myXPConfigWithAutoComplete = myXPConfig { autoComplete = Just 500000 }

easyMotionConfig :: EasyMotionConfig
easyMotionConfig = def { bgCol     = myBgColor
                       , borderCol = myFocusedBorderColor
                       , borderPx  = 2
                       , cancelKey = xK_Escape
                       , emFont    = myXftFontName ++ "-30"
                       , overlayF  = proportional (0.1 :: Double)
                       , txtCol    = myFgColor
                       }

myDefaultWindowConf :: WindowConfig
myDefaultWindowConf =
  def { winFont = myXftFontName ++ "-20", winBg = "#3c3836", winFg = myFgColor }

myXmobarPP :: PP
myXmobarPP =
  filterOutWsPP [scratchpadWorkspaceTag] def { ppTitle = shorten 30 }

myStartupHook :: X ()
myStartupHook = do
  spawnOnce "xrandr --output DP-4 --scale 1.5"
  spawnOnce "feh --no-fehbg --bg-fill .config/wallpaper"
  spawnOnce "xsetroot -cursor_name arrow"
  spawnOnce "~/bin/tray"
  spawnOnce "~/bin/vpnbrowser"
