#NoEnv ; Recommended for performance and compatibility with future AutoHotKey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
; SetWorkingDir %A_ScriptDir% ; Ensures a consistent starting directory

; #include IME.ahk
; #include lib\IME-utf8.ahk

EnvGet, USERHOME, USERPROFILE

; Windows10環境では、「管理者で実行」しないとホットキーが有効にならない場合あり。
; http://stackoverflow.com/questions/31839062/autohotkey-in-windows-10-hotkeys-not-working-in-some-applications

;settings{{{
; AutoHotKey再読み込み{{{
#z::
Reload
WinWait,ahk_class #32770,Error at line ,2
If (ErrorLevel=0) {
  ControlGetText,v,Static1
  StringGetPos,p,v,.
  p-=14
  StringMid,line,v,15,%p%
  Run,%USERHOME%\program\vim\gvim.exe "%A_ScriptFullPath%" +%line%
  WinWaitNotActive
  WinActivate
}
return ;}}}
; vim{{{
#v::
if WinExist("ahk_class Vim") {
  WinActivate
} else if WinExist("ahk_exe nvim-qt.exe") {
  WinActivate
} else {
  ; Run, %USERHOME%\program\vim\gvim.exe
  ; WinWait, ahk_class Vim
  Run, %USERHOME%\program\Neovim\bin\nvim-qt.exe --no-ext-tabline --no-ext-popupmenu --qwindowgeometry 800x600
  WinWait, ahk_exe nvim-qt.exe, , 5
  WinActivate
}
return ; }}}
; WSL{{{
#c::
if WinExist("ahk_exe wsl.exe") {
  WinActivate
} else {
  Run, wsl.exe
}
return ; }}}
;}}}

;Special Mappings {{{
!^h::Send, {Left}
!^j::Send, {Down}
!^k::Send, {Up}
!^l::Send, {Right}
!^g::Send, {Home}
!^;::Send, {End}
!^8::Send, {Volume_Down}
!^9::Send, {Volume_Up}
!^e::Send, {Esc}
!+h::Send, {BS}
!+l::Send, {Del}
!+u::Send, +{Home}{Del}
!+k::Send, +{End}{Del}

!^.::Send, {PgDn}
!^/::Send, {PgUp}
;}}}

;Mouse Mappings {{{
;Mouse Move
; !^y::MouseMove, -10, 0, 0, R
; !^u::MouseMove, 0, 10, 0, R
; !^i::MouseMove, 0, -10, 0, R
; !^o::MouseMove, 10, 0, 0, R
;Click
; !^n::MouseClick, Left
; !^p::MouseClick, Right
;Right click on current window
;Mouse wheel
!^m::MouseClick, WheelUp,,,  5
!^,::MouseClick, WheelDown,,,  5
;}}}

;application operability {{{
;neeview {{{
#IfWinActive ahk_exe NeeView.exe
  global break_loop = 0
  !a::
    ; ControlGet, xID, Hwnd
    break_loop = 0
    InputBox, stime, slide, slide, , 130, 110, , , , 3, 3
    stime *= 1000
    if (stime = 0) 
      return
    while (break_loop != 1)
    {
      IfWinActive, ahk_exe NeeView.exe
      {
        ControlSend, , n, ahk_exe NeeView.exe
      }
      Sleep, %stime%
    }
    return
  !z::
    break_loop = 1
    MsgBox, 0, , stop slide, 1
    return
#IfWinActive
;clipboard history {{{
#IfWinActive ahk_class AutoHotkeyGUI ahk_exe ClipboardHistory_x64.exe
  !j::Send, {Down}
  !k::Send, {Up}
#IfWinActive ; }}}
;fenrir move cursor like vim; {{{
#IfWinActive ahk_class fenrirMainWindow
  !j::Send, {Down}
  !k::Send, {Up}
  !l::Send, {Right}
  !h::Send, {Left}
#IfWinActive; }}}
;eClip move cursor like vim; {{{
#IfWinActive ahk_class eClipMainClass
  !j::Send, {Down}
  !k::Send, {Up}
#IfWinActive; }}}
;excel; {{{
#IfWinActive ahk_class XLMAIN
  F3 up:: DoubleKey("!{F4}", 200) 
#IfWinActive; }}}
;word; {{{
#IfWinActive ahk_class OpusApp
  F3 up:: DoubleKey("!{F4}", 200)
#IfWinActive; }}}
;powerpoint; {{{
#IfWinActive ahk_class PP11FrameClass
  F3 up:: DoubleKey("!{F4}", 200)
#IfWinActive; }}}
;rapture; Not currently in use. {{{
#IfWinActive ahk_class RaptureWindow
  ESC up:: DoubleKey("!{F4}", 200) 
#IfWinActive; }}}
;afxw; {{{
#IfWinActive ahk_class TLogForm
  @::Send, {ESC}
  [::Send, {ESC}
  !j::Send, {Down}
  !k::Send, {Up}
  +l::Send, {Right}
  +h::Send, {Left}
#IfWinActive ahk_class TAfxWForm
  ^@::Send, {ESC}
  ^[::Send, {ESC}
  !j::Send, {Down}
  !k::Send, {Up}
#IfWinActive ahk_class TFinfoForm 
  ^h::Send, {BS}
  ^f::Send, {Right}
  ^b::Send, {Left}
  ^a::Send, {Home}
  ^e::Send, {End}
  ^u::Send, +{Home}{Del}
  ^k::Send, +{End}{Del}
  ^d::Send, {Delete}
  !z::
    tmp := IME_GET()
    IME_SET(0)
    Send, .zip
    IME_SET(%tmp%)
    return
#IfWinActive ahk_class TSortForm
  @::Send, {ESC}
  [::Send, {ESC}
#IfWinActive ahk_class TFinf2Form
  !j::Send, {Down}
  !k::Send, {Up}
#If WinActive("ahk_class TExRenForm")
  || WinActive("ahk_class TOverForm")
  || WinActive("ahk_class TInputForm")
  ^h::Send, {BS}
  ^f::Send, {Right}
  ^b::Send, {Left}
  ^a::Send, {Home}
  ^e::Send, {End}
  ^u::Send, +{Home}{Del}
  ^k::Send, +{End}{Del}
  ^d::Send, {Delete}
#IfWinActive; }}}
;afxfazzy {{{
#IfWinActive ahk_exe afxfazzy.exe
  !j::Send, {Down}
  !k::Send, {Up}
#IfWinActive ;}}}
;FenrirFS; {{{
#IfWinActive ahk_class TFenrirFSMainForm.UnicodeClass
  ^l::
    tmp := IME_GET()
    IME_SET(0)
    Send, {Down}{Enter}{End}[
    if (%tmp% = 0) {
      IME_SET(0)
    } else {
      IME_SET(1)
    }
    return
  ^k::
    ; tmp := IME_GET()
    IME_SET(0)
    Send, {Down}{Enter}{Enter}
    return
  ^e::Send, ^{F2}
  ^v::Send, !{TAB}
  +j::Send, +{Down}
  +k::Send, +{Up}
#IfWinActive; }}}
;firefox; {{{
#IfWinActive ahk_class MozillaWindowClass
  !c:: ; 生放送でコメントを入力する
    SetKeyDelay, 100
    WinGetPos x, y, width, height
    xx := width / 2
    ; yy := height - 50 ; Vimperator
    yy := height - 20 ; その他
    InputBox, comment, comment, Input comment and press enter.
    if (comment <>) {
      clipboard = %comment%
      MouseClick, left, %xx%, %yy%, 1, 0, ,
      ; Send, %comment%
      Sleep, 500
      Send, ^v ; In Vimperator environment, change mode to IGNORE.
      Send, {Enter}
      MouseClick, left, 500, 500, 1, 0, ,
    }
    return
  ^[::Send, {Esc}
#IfWinActive; }}}
;chrome {{{
#IfWinActive ahk_class Chrome_WidgetWin_1
  !c:: ; 生放送でコメントを入力する
    SetKeyDelay, 20
    MouseGetPos, mx, my, mid
    WinGetPos, x, y, width, height
    xx := width / 2
    yy := height - 20
    ; MsgBox, 0, Enter comment, Wait seconds, 1
    InputBox, comment, Enter comment, Enter comment, then press ENTER.
    if (comment <> "") {
      MouseClick, left, %xx%, %yy%, 1, 0, ,
      Sleep, 500
      clipboard = %comment%
      Send, ^v{Enter}{Enter}
      ; MouseClick, left, 500, 500, 1, 0, ,
    } else {
      MsgBox, no comment.
    }
    ; MouseMove, mx, my
    MouseClick, left, %mx%, %my%, 1, 0, ,
    return
  ^[::Send, {Esc}
#IfWinActive; }}}
;everything; {{{
#IfWinActive ahk_class EVERYTHING
  ^l::Send, {End}
#IfWinActive; }}}
;Neovim {{{
; When pressing the ESC or C-[, turn off the IME.
; ref: https://blog.pepo-le.com/vim-normalmode-imeoff/
#IfWinActive ahk_exe nvim-qt.exe
  Esc::
  ^[::
    GoSub, sub_ResetIME
    Send {Esc}
    return

  sub_ResetIME:
    getImeMode := IME_GET()
    if (getImeMode == 1) {
      IME_SET(0)
    }
    return
#IfWinActive ;}}}
; Wox.exe {{{
#IfWinActive ahk_exe Wox.exe
  ^[::Send, {Esc}
  ^y::Send, +{Home}{Del}
#IfWinActive
; }}}
; KeyPirinha {{{
#IfWinActive ahk_class keypirinha_wndcls_run
  !j::Send, {Down}
  !k::Send, {Up}
#IfWinActive
; }}}
;}}}

;games {{{
#IfWinActive ahk_class Recover the Restarts!
  s::Left
  d::Down
  f::Right
  e::Up
#IfWinActive
; RPG2000
#IfWinActive ahk_class TFormLcfGameMain
  s::Left
  d::Down
  f::Right
  e::Up
  j::z
  k::Esc
  l::LShift
  w::z
  r::Esc
#IfWinActive
; RPGXP, VX
#IfWinActive ahk_class RGSS Player
  s::Left
  d::Down
  f::Right
  e::Up
  j::Enter
  r::Enter
  w::Enter
  k::Esc
  t::Esc
  q::Esc
  l::LShift
  u::c
  i::v
  o::b
  ,::d
#IfWinActive
;}}}

;other {{{
; control window {{{
^+]::VerticalSplit()
^+[::HorizontalSplit()
; resize window
^#r::
  if WinExist("ahk_class #32768") {
    return
  }
  CoordMode, Mouse, Screen
  Run, %A_ScriptDir%\winresize.ahk
  ;メニューにフォーカスを移す処理をして終わる
  WinWait,ahk_class #32768,,2
  WinGetPos,wx,wy,,,ahk_class #32768
  MouseClick,Left,%wx%,%wy%
  return
;shade
#MButton::
#w::
  WinGet,whd,ID,A
  GoSub,sub_WindowShade
  return

  sub_WindowShade:
  WinGetPos,x,y,w,h,ahk_id %whd%
  if (wshade%whd% > 0) {
    StringTrimLeft,h,wshade%whd%,0
    wshade%whd% = 0
  } else {
    wshade%whd% = %h%
    h = 27
  }
  WinMove,ahk_id %whd%,,%x%,%y%,%w%,%h%
  return
;AlwaysOnTop
#t::winset, alwaysontop, toggle, A
;}}}
;Turn off the monitor. {{{
#^m::  ; Win+Ctrl+m
  InputBox, seconds, Timer, Turn off the monitor after the seconds., , 100, 100, , , , 0, 0
  if (ErrorLevel!=0)
    return
  Sleep seconds * 1000
  ; Turn Monitor Off:
  SendMessage, 0x112, 0xF170, 2,, Program Manager  ; 0x112 is WM_SYSCOMMAND, 0xF170 is SC_MONITORPOWER.
  ; Note for the above: Use -1 in place of 2 to turn the monitor on.
  ; Use 1 in place of 2 to activate the monitor's low-power mode.
; }}}
;}}}

;function {{{
;detect double tap {{{
DoubleKey(RunCommand, timeout){
 if(A_PriorHotKey = A_ThisHotKey and A_TimeSincePriorHotkey < timeout)
   Send, %RunCommand%
} ;}}}
;set out the identical window class {{{
VerticalSplit(){
  ;get activeWindowID
  WinGet, activeWindowID, ID, A
  ;get window position
  WinGetPos, x, y, w, h, ahk_id %activeWindowID%
  ;get monitor number
  SysGet, monitorCount, MonitorCount
  ;repeat monitor number times
  Loop, %monitorCount% {
    ;get MonitorWorkArea
    SysGet, m, MonitorWorkArea, %a_index%
    if (mLeft <= x && x <= mRight && mTop <= y && y <= mBottom) {
      WinGetClass, activeWindowClass, ahk_id %activeWindowID%
      ;get window class id to involved
      WinGet, id, list, ahk_class %activeWindowClass%
      Loop, %id% {
        w := (mRight - mLeft) / 2
        h := (id > 2) ? (mBottom - mTop) / 2 : mBottom - mTop
        x := (Mod(a_index, 2) == 1) ? mLeft : mLeft + w
        y := (a_index <= 2) ? mTop : mTop + h
        StringTrimRight, this_id, id%a_index%, 0
        ;active window
        WinActivate, ahk_id %this_id%
        WinWaitActive, ahk_id %this_id%
        ;move window
        WinMove, ahk_id %this_id%,,%x%, %y%, %w%, %h%
      }
      break
    }
  }
} ;}}}
;resize window to fullwidth and halfheight {{{
HorizontalSplit() {
  ;get activeWindowID
  WinGet, activeWindowID, ID, A
  ;set parameter
  x := 0
  y := 0
  w := A_ScreenWidth
  h := A_ScreenHeight / 2
  ;activeWindow move and resize
  WinMove, ahk_id %activeWindowID%, , %x%, %y%, %w%, %h%
} ;}}}
;IME check (required IME.ahk) {{{
IMESave() {
  IME_SET(0)
  return
} ;}}}
;}}}

;autohotkey.ahk end
; vim:fenc=utf-8
