#NoEnv
#UseHook
#NoTrayIcon

; setting 
SendMode,Input
SetTitleMatchMode,3
CoordMode,Mouse,Screen
CoordMode,Menu,Screen
MouseGetPos,mx,my
; create menu
Menu, ctMenu, Add ,600x600
Menu, ctMenu, Add ,800x600
Menu, ctMenu, Add ,1024x700
Menu, ctMenu, Add ,Vim
Menu, ctMenu, Add ,FULL
Menu, ctMenu, Add ,Manual
Menu, ctMenu, Add ,AFXW
; show
Menu, ctMenu, Show, %mx%, %my%
ExitApp

; function
600x600:
  Resize(600,600)
  return
800x600:
  Resize(800,600)
  return
1024x700:
  Resize(1024,700)
  return
FULL:
  WinMaximize, A
  return
Manual:
  Resize(0,0)
  return
AFXW:
  Resize(1000,500)
  WinGetPos, , , , H, A
  WinMove, A, , 0, A_ScreenHeight - H + 5
  return
Vim:
  Resize(1000,704)
  return

;resize window {{{
Resize(Width, Height) {
  WinGetPos, X, Y, W, H, A
  If %Width% = 0
    InputBox, Width, input, â°ïù, , 170, 130

  If %Height% = 0
    InputBox, Height, input, ècïù, , 170, 130

  WinMove, A, , 0, 0, Width, Height
} ;}}}


