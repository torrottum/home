import System.Process
import System.IO.Unsafe (unsafePerformIO)
import Data.List
import Xmobar

import System.Process

getFromXres :: IO String
getFromXres = readProcess "xrdb" ["-get", "Xft.dpi"] ""

getDpi :: Int
getDpi = read (unsafePerformIO getFromXres)

scaleWithDpi :: Int -> Int
scaleWithDpi x = (getDpi `div` 96) * x

green = "#98971a"

config :: Config
config =
  defaultConfig
    { overrideRedirect = False,
      font = "Iosevka Term SS14 14",
      bgColor = "#282828",
      fgColor = "#ebdbb2",
      position = TopSize L 100 (scaleWithDpi 20),
      commands =
        [ Run XMonadLog,
          Run $ Wireless "wlan0" ["-t", "<ssid>"] 10,
          Run $
            Battery
              [ "-t",
                "<fn=1>Bat:</fn> <acstatus>",
                "--Low",
                "20",
                "--High",
                "75",
                "--low",
                "red",
                "--normal",
                "#ebdbb2",
                "--high",
                green,
                "--",
                "-o",
                "<left>% (<timeleft>)",
                "-O",
                "<left>% Charging"
              ]
              50,
          Run $ Date "%a %d %b <fn=1>%H:%M:%S</fn>" "date" 10,
          Run $ Com "/home/tor/.config/xmobar/icon-padding.sh" ["panel"] "tpad" 10,
          Run $ Memory ["-t", "<used>/<total>G", "--", "--scale", "1000"] 20,
          Run $ DiskU [("/", "<used>/<size>")] [] 300,
          Run $ MultiCpu [] 50,
          Run $
            MultiCoreTemp
              [ "-t",
                "Temp: <avg>°C | <avgpc>%",
                "-L",
                "60",
                "-H",
                "80",
                "-l",
                green,
                "-n",
                "yellow",
                "-h",
                "red",
                "--",
                "--mintemp",
                "20",
                "--maxtemp",
                "100"
              ]
              50,
          Run $ Alsa "default" "Master" []
        ],
      alignSep = "}{",
      template = "%XMonadLog% }{ %multicpu% "
    ++ "%multicoretemp% | <fn=1>Mem:</fn> %memory% | <fn=1>Disk:</fn> %disku% | <fn=1>Wifi:</fn> %wlan0wi% | %battery% | %alsa:default:Master% | %date% %tpad%",
      dpi = fromIntegral getDpi
    }

main :: IO ()
main = xmobar config

