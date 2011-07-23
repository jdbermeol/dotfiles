import Control.Concurrent
import Control.OldException(catchDyn,try)
import DBus
import DBus.Connection
import DBus.Message
import Data.Ratio ((%))
import System.Cmd
import System.Exit
import System.IO
import XMonad
import XMonad.Actions.GridSelect
import XMonad.Config.Gnome
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.SetWMName
import XMonad.Layout.Accordion
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.ManageHook
import XMonad.Prompt
import XMonad.Util.EZConfig
import XMonad.Util.Run

import qualified XMonad.StackSet as W
import qualified Data.Map        as M


myPrettyPrinter :: Connection -> PP
myPrettyPrinter dbus = defaultPP {
    ppOutput  = outputThroughDBus dbus
  , ppTitle   = pangoColor "#003366" . shorten 50 . pangoSanitize
  , ppCurrent = pangoColor "#006666" . wrap "[" "]" . pangoSanitize
  , ppVisible = wrap " " " "
  , ppHidden  = wrap " " " "
  , ppUrgent  = pangoColor "red"
  , ppLayout  = pangoColor "green"
  }


-- -----------------------------------------------------------------------------

getWellKnownName :: Connection -> IO ()
getWellKnownName dbus = tryGetName `catchDyn` (\ (DBus.Error _ _) ->
                                                getWellKnownName dbus)
 where
  tryGetName = do
    namereq <- newMethodCall serviceDBus pathDBus interfaceDBus "RequestName"
    addArgs namereq [String "org.xmonad.Log", Word32 5]
    sendWithReplyAndBlock dbus namereq 0
    return ()

outputThroughDBus :: Connection -> String -> IO ()
outputThroughDBus dbus str = do
  let str' = "<span font=\"Monaco 9 Bold\">" ++ str ++ "</span>"
  msg <- newSignal "/org/xmonad/Log" "org.xmonad.Log" "Update"
  addArgs msg [String str']
  send dbus msg 0 `catchDyn` (\ (DBus.Error _ _ ) -> return 0)
  return ()

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
 where
  left  = "<span foreground=\"" ++ fg ++ "\">"
  right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
 where
  sanitize '>'  acc = "&gt;" ++ acc
  sanitize '<'  acc = "&lt;" ++ acc
  sanitize '\"' acc = "&quot;" ++ acc
  sanitize '&'  acc = "&amp;" ++ acc
  sanitize x    acc = x:acc

myTerminal      = "gnome-terminal"
myBorderWidth   = 1
myModMask       = mod4Mask
myNumlockMask   = mod2Mask
myWorkspaces    = ["1:code","2:web","3:mail","4:db","5:md","6:test","7:im","8:web2","9:min","0","-:tmp","=:music"]
myNormalBorderColor  = "#ff00cc"
myFocusedBorderColor = "#ccff00"
myKeys conf@(XConfig {XMonad.modMask = modMask}) = M.fromList $
    [ ((modMask .|. shiftMask, xK_Return), spawn $ XMonad.terminal conf)
     , ((modMask                 , xK_comma ) , sendMessage (IncMasterN 1))
     , ((modMask                 , xK_period) , sendMessage (IncMasterN (-1)))
     , ((modMask                 , xK_q     ) , restart "xmonad" True)
     , ((modMask .|. controlMask , xK_l     ) , spawn "xscreensaver-command -lock")
     , ((modMask .|. shiftMask   , xK_j     ) , windows W.swapDown  )
     , ((modMask .|. shiftMask   , xK_k     ) , windows W.swapUp    )
     , ((modMask .|. shiftMask   , xK_p     ) , spawn "gmrun")
     , ((modMask .|. shiftMask   , xK_q     ) , io (exitWith ExitSuccess))
     , ((modMask .|. shiftMask   , xK_space ) , setLayout $ XMonad.layoutHook conf)
     , ((modMask                 , xK_Return) , windows W.swapMaster)
     , ((modMask                 , xK_Tab   ) , windows W.focusDown)
     , ((modMask                 , xK_h     ) , sendMessage Shrink)
     , ((modMask                 , xK_j     ) , windows W.focusDown)
     , ((modMask                 , xK_k     ) , windows W.focusUp  )
     , ((modMask                 , xK_l     ) , sendMessage Expand)
     , ((modMask                 , xK_m     ) , windows W.focusMaster  )
     , ((modMask                 , xK_n     ) , refresh)
     , ((modMask                 , xK_space ) , sendMessage NextLayout)
     , ((modMask                 , xK_t     ) , withFocused $ windows . W.sink)
     , ((modMask                 , xK_d     ) , kill)
     , ((modMask                 , xK_g)      , goToSelected defaultGSConfig)
     , ((modMask                 , xK_v)      , spawnSelected defaultGSConfig ["gnome-terminal" , "firefox" , "banshee" , "gvim"])
    ]
    ++
     [((m .|. modMask, k), windows $ f i)
        | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_equal]
        , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]]
    ++
    [((m .|. modMask, key), screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip [xK_w, xK_e, xK_r] [0..]
        , (f, m) <- [(W.view, 0), (W.shift, shiftMask)]]
------------------------------------------------------------------------
-- Mouse bindings: default actions bound to mouse events
--
myMouseBindings (XConfig {XMonad.modMask = modMask}) = M.fromList $

    -- mod-button1, Set the window to floating mode and move by dragging
    [ ((modMask, button1), (\w -> focus w >> mouseMoveWindow w))

    -- mod-button2, Raise the window to the top of the stack
    , ((modMask, button2), (\w -> focus w >> windows W.swapMaster))

    -- mod-button3, Set the window to floating mode and resize by dragging
    , ((modMask, button3), (\w -> focus w >> mouseResizeWindow w))

    -- you may also bind events to the mouse scroll wheel (button4 and button5)
    ]

------------------------------------------------------------------------
-- Layouts:

-- You can specify and transform your layouts by modifying these values.
-- If you change layout bindings be sure to use 'mod-shift-space' after
-- restarting (with 'mod-q') to reset your layout state to the new
-- defaults, as xmonad preserves your old layout settings by default.
--
-- The available layouts.  Note that each layout is separated by |||,
-- which denotes layout choice.
--
myLayout = smartBorders $ avoidStruts (grid ||| Full ||| tiled ||| Mirror tiled ||| Full ||| spiral (6/7))
  where
     grid    = withIM size roster Grid
     tiled   = Tall nmaster delta ratio
     size    = 1%5
     roster  = Title "Contact List"
     nmaster = 3
     ratio   = 1/2
     delta   = 1/100

------------------------------------------------------------------------
-- Window rules:
myManageHook = composeAll
    [ isFullscreen --> doFullFloat
    , className =? "Banshee"        --> doFloat
    , className =? "Galculator"     --> doFloat
    , className =? "Gvim"           --> doShift "1:code"
    , className =? "Komodo Edit"    --> doShift "1:code"
    , className =? "Ktorrent"       --> doShift "5:media"
    , className =? "Pidgin"         --> doShift "3:msg"
    , className =? "Terminal"       --> doShift "1:code"
    , className =? "VirtualBox"     --> doShift "4:vm"
    , className =? "Xchat"          --> doShift "5:media"
    , className =? "banshee"        --> doShift "5:media"
    , className =? "evolution"      --> doShift "3:msg"
    , className =? "firefox"        --> doShift "2:web"
    , className =? "gimp"           --> doFloat
    , resource  =? "Komodo_find2"   --> doFloat
    , resource  =? "compose"        --> doFloat
    , resource  =? "desktop_window" --> doIgnore
    , resource  =? "synapse"        --> doIgnore ]

myFocusFollowsMouse :: Bool
myFocusFollowsMouse = False
myStartupHook = setWMName "LG3D"
main = withConnection Session $ \ dbus -> do
  getWellKnownName dbus
  xmonad $ defaults {
            workspaces         = myWorkspaces
          , manageHook         = manageDocks <+> myManageHook
          , logHook            = logHook gnomeConfig >> dynamicLogWithPP (myPrettyPrinter dbus)
          , layoutHook         = myLayout
}

defaults = gnomeConfig {
      -- simple stuff
        terminal           = myTerminal,
        focusFollowsMouse  = myFocusFollowsMouse,
        borderWidth        = myBorderWidth,
        modMask            = myModMask,
        numlockMask        = myNumlockMask,
        normalBorderColor  = myNormalBorderColor,
        focusedBorderColor = myFocusedBorderColor,
        keys               = myKeys,
        mouseBindings      = myMouseBindings,
        layoutHook         = smartBorders $ myLayout,
        manageHook         = myManageHook,
        startupHook        = myStartupHook
    }
