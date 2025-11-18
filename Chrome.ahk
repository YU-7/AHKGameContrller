#Requires AutoHotkey v2.0
#SingleInstance Force
ChromeMapping() {
    ; 翻页、全屏、暂停、切换标签页、关闭当前标签页、关闭所有标签页
    Hotkey ControllerButtonMapping["LeftShoulderButton"], (*) => Send("+{Left}")
    Hotkey ControllerButtonMapping["RightShoulderButton"], (*) => Send("+{Right}")
    Hotkey ControllerButtonMapping["ButtonB"], (*) => Send("{Space}")
    Hotkey ControllerButtonMapping["ButtonX"], (*) => Send("!{F4}")
    Hotkey ControllerButtonMapping["ButtonY"], (*) => Send("f")
    Hotkey ControllerButtonMapping["ButtonA"], (*) => Send("{space}")

}
