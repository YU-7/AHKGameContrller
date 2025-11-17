#Requires AutoHotkey v2.0
#SingleInstance Force

#Include %A_ScriptDir%\Util.ahk
#include %A_ScriptDir%\Hearthstone.ahk
#include %A_ScriptDir%\Chrome.ahk
#include %A_ScriptDir%\DefaultMapping.ahk
#include %A_ScriptDir%\QuarkMapping.ahk

; 先全局声明并赋值然后再具体的地方在声明一遍
global count := 0
global beforeWindowTitle := ""
; HSHELL_WINDOWACTIVATED是窗口激活的事件代码
HSHELL_WINDOWACTIVATED := 4

; 窗口脚本映射对象 - 使用Map代替Object以兼容v2语法N
WindowScripts := Map()
WindowScripts["msedge.exe"] := ChromeScript
WindowScripts["chrome.exe"] := ChromeScript
WindowScripts["Hearthstone.exe"] := HearthStroeMapping
WindowScripts["quark.exe"] := QuarkMapping

; 飞智键位映射
ControllerButtonMapping := Map()
ControllerButtonMapping["ButtonA"] := "Joy1"
ControllerButtonMapping["ButtonB"] := "Joy2"
ControllerButtonMapping["ButtonX"] := "Joy3"
ControllerButtonMapping["ButtonY"] := "Joy4"
ControllerButtonMapping["LeftShoulderButton"] := "Joy5"
ControllerButtonMapping["RightShoulderButton"] := "Joy6"
ControllerButtonMapping["ButtonSelect"] := "Joy7"
ControllerButtonMapping["ButtonStart"] := "Joy8"
ControllerButtonMapping["leftbackButton"] := "Joy9"
ControllerButtonMapping["rightbackButton"] := "Joy10"