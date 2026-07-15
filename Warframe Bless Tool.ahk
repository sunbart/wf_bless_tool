#Requires AutoHotkey v2.0
#SingleInstance Force
#UseHook
keyhistory 0
Persistent
SetWinDelay -1
SetKeyDelay -1
SetMouseDelay -1
SetControlDelay -1
PatchGUIPrototype()

; ============== ;
; Customizations ;
; ============== ;
; Auto-Advance mode
; In Auto-Advance mode, the next step is automatically activated after pasting (Ctrl+V).
; This option sets whether the Auto-Advance mode is enabled when the script starts.
; It can also be toggled live with F5.
auto_advance := false ; true/false

; Clipboard tooltip
; The tooltip shows the text that is placed in the clipboard when a step is selected.
; This variable sets how long the tooltip is displayed for.
tooltip_timeout := 3 ; number of seconds

; Celebration emojis
; A list of emojis used in the "Relay done" discord message. Picked randomly every time.
celebration_emojis := [
    "🎉", "✅", ":CuteNova:", ":Cutevara:"
]

; Organizer mode
; In Organizer mode, steps for organizing the whole session are also included.
; Otherwise, only steps that are needed for the relay itself are included.
organizer_mode := true ; true/false

; Bless session timing
; This option sets at what time of the hour the bless session is planned to start.
; Next occurrence of this time is used for setting the blessing time.
; Set `bless_time_minute` to 0 for the top of the hour, 30 for half past the hour, etc.
; Use `bless_time_buffer` to give yourself time to organize the session.
; If the next bless time would be sooner than the buffer, the hour after that is used.
bless_time_minute := 0 ; 0-59
bless_time_buffer := 10 ; number of minutes

; Default region
; This sets the region selected by default in the Config section's Region dropdown.
; Must match one of the options in the dropdown (see gui_region_dropdown below).
default_region := "Europe"

; Default relay
; This sets the relay selected by default in the Config section's Relay dropdown.
; Must match one of the options in the dropdown (see gui_relay_dropdown below).
default_relay := "Strata"

; Role list separator
; This is the text used to separate each "blesser -> role" pair in the Roles message.
role_list_divider := " | "

; Blesser/Role separator
; This is the text  between a blesser's name and their bless type in the Roles message.
blesser_role_separator := " -> "

; Step definitions
; This defines which steps the script will go through, and the corresponding text(s).
; If you provide multiple text options, a random one will be picked.
; The texts can use some placeholders for dynamic values. See `GetStepText()` for details.
; A step can be marked as an "organizer_step" to disable it when Organizer mode is off.
; Steps can be auto-skipped or have conditional text based on some conditions.
;     See the "Relay: Help Request" step for examples.
steps := [
    {
        name: "Discord: Bless announcement",
        organizer_step: true,
        text: ["@{bless_team} Hello!`nWho can bless today?`n`nPlease let us know here if you want to lead a relay! :Cutevara:`nNewcomers and questions are welcome!`nEnjoy your time here! :heart: `n`n    Setting relays with teams at <t:{bless_time-8m}:t> `n    Relay leaders, do not forget ping at <t:{bless_time-5m}:t>`n    We aim to do the planned bless at <t:{bless_time}:t> "]
    },
    {
        name: "Relay Robber URL",
        organizer_step: true,
        text: ["https://yareli.net/relay"]
    },
    {
        name: "Discord: Teams template",
        organizer_step: true,
        text: ["Relay Soon:tm:`n@`n@`n@`n@`n@`n@`n`nRelay Soon:tm:`n@`n@`n@`n@`n@`n@"]
    },
    {
        name: "Discord: 'Teams updated'",
        organizer_step: true,
        text: ["Team updated, please check ☝️"]
    },
    {
        name: "Discord: Chat debug",
        organizer_step: true,
        text: ["Please enter the relay before it gets full, and put a word/smiley inside the relay channel so you check and debug  👍`nThere are still slots to fill! You can join us, there is still time 🏃‍♂️"]
    },
    {
        name: "Discord: Command for #bless",
        organizer_step: true,
        text: ["!bless {region_code} {relay} {relay_instance} {minutes_till_bless_command} {bless_types}"]
    },
    {
        name: "Relay: Greeting",
        text: [
            "Hello fellow Tenno :highfive:! Are you ready for a blessing session?",
            "Good evening, Tenno! Rise and shine :cool:, it's soon time for blessings!",
            "Greetings, fellow Tenno! Let's start the evening with some powerful blessings :fist:!",
            "Hello, everyone! Hope you're ready for a day filled with blessings and good vibes :stareyes:!",
            "Good evening, Tenno :highfive:! May the Lotus guide your blessed path today!",
            "Greetings, fellow Tenno! Wishing you a radiant bless session :cool:!",
            "Hello, warriors of Warframe! Bless party :alliance: happening soon!"
        ]
    },
    {
        name: "Relay: Help Request",
        skip_conditions: ["full_bless"],
        conditional_text: [
            {
                condition: "no_blessers",
                text: [
                    "Who can help giving bless today? :alliance: Raise your hand in chat and let us know! :recruiting: Needed more blessers: ",
                    ":peace: Seeking help from any kind-hearted Tenno out there! Who's up for blessing our relay? :recruiting: Needed more blessers: ",
                    "Calling all Tenno :eyes:! We need your assistance for our daily blessings. Anyone available to help us? :recruiting: Needed more blessers: ",
                    "Attention, fellow warriors! We're in need of your help to bestow blessings upon our team. Tell us if you can :wink:! :recruiting: Needed more blessers: ",
                    "Calling all skilled Tenno! We need your assistance in blessing fellow players! :recruiting: Needed more blessers: ",
                    "Looking for capable Tenno to join us in spreading blessings! Any volunteers :heart:? :recruiting: Needed more blessers: ",
                    "Attention :recruiting:, talented Tenno! We could use your help in bringing joy and positivity to the community using your bless! :recruiting: Needed more blessers: "
                ]
            },
            {
                condition: "default",
                text: [
                    "Who can help giving bless today? :alliance: We still need {blessers_needed} more blesser{blessers_needed_plural}, so raise your hand in chat and let us know! :recruiting:",
                    ":peace: Seeking help from any kind-hearted Tenno out there! We're short {blessers_needed} blesser{blessers_needed_plural} for our relay, who's up for it? :recruiting:",
                    "Calling all Tenno :eyes:! We still need {blessers_needed} more blesser{blessers_needed_plural} for our daily blessings. Anyone available to help us? :recruiting:",
                    "Attention, fellow warriors! We're still {blessers_needed} blesser{blessers_needed_plural} short of a full team. Tell us if you can help :wink:! :recruiting:",
                    "Calling all skilled Tenno! We need {blessers_needed} more blesser{blessers_needed_plural} to join us in blessing fellow players! :recruiting:",
                    "Looking for capable Tenno to join us in spreading blessings! We still need {blessers_needed} more blesser{blessers_needed_plural}, any volunteers :heart:? :recruiting:",
                    "Attention :recruiting:, talented Tenno! We're looking for {blessers_needed} more blesser{blessers_needed_plural} to bring joy and positivity to the community with your bless!"
                ]
            }
        ],
    },
    {
        name: "Relay: Roles incoming",
        text: ["Roles incoming!"]
    },
    {
        name: "Relay: Roles assignment",
        text: ["Roles: {bless_roles}"],
        skip_conditions: ["no_blessers"]
    },
    {
        name: "Relay: Bless timing",
        text: ["Blessing time in {minutes_till_bless} minute{minutes_till_bless_plural}!"]
    },
    {
        name: "Relay: Discord advertising",
        text: [
            "Curious when and where a bless will happen? Join our Discord tiny.cc/warframeblessing",
            "Don't forget to join our Blessings Discord at tiny.cc/warframeblessing for more community fun and support!",
            "Have you joined our Blessings Discord yet? Head over to tiny.cc/warframeblessing and be part of our amazing community!",
            "Looking for more ways to connect with fellow Tenno? Join our Blessings Discord at tiny.cc/warframeblessing and experience the power of unity!",
            "Join our Warframe Blessings Discord community at tiny.cc/warframeblessing for more positive vibes and group blessings!",
            "Discover the power of unity in our Warframe Blessings Discord! Visit tiny.cc/warframeblessing to become a part of something greater!",
            "Calling all Tenno! Join our Discord community at tiny.cc/warframeblessing and let's spread blessings together!"
        ]
    },
    {
        name: "Relay: Sermon incoming",
        text: ["Sermon inbound!"]
    },
    {
        name: "Relay: Sermon",
        text: [
            "Tenno, may the Lotus watch over you and guide your blades true. May you find strength in your warframes and courage in the heat of battle. May RNGesus bless you with rare drops and may your mods always be maxed. We are all one in the fight. So always bring your best warframe game :stareyes:!",
            "Fellow Tenno, may the Lotus illuminate your path and grant you unwavering resolve. May your warframes be mighty, and your enemies fall before you. May your loot be plentiful, and your mods shine with power. Together, we stand united in the battle. :lotus:",
            "Dear Tenno, may the Lotus guide you to victory. May your warframes embody indomitable strength, and your skills be honed to perfection. May the void bless you with rare treasures, and your mods grant unmatched power. Remember, we fight as one, united against darkness! :lotus:",
            "Brave Tenno, may the Lotus empower your unwavering determination. May your warframes embody resilience, and your blades strike true. May RNGesus bestow rare rewards, and may your mods hold limitless potential. Together, we forge a path of triumph! :lotus:",
            "Courageous Tenno, may the Lotus guide and empower your actions. May your warframes embody unwavering resolve, bringing glorious triumph. May RNGesus bless you with incredible loot, and may your mods reach their fullest potential. Fight with unity and unwavering determination! :lotus:"
        ]
    },
    {
        name: "Relay: Bless now",
        text: ["Blessing time NOW, Tenno! :angel: Go forth and conquer!"]
    },
    {
        name: "Relay: Encouragements",
        text: [
            "You're all amazing, resilient warriors! Keep pushing forward and let the power of blessings guide your path!",
            "Remember, Tenno, your strength knows no bounds! Embrace the blessings and conquer any challenges that come your way!",
            "Each and every one of you is a shining star! May the blessings ignite your spirit and bring you victory!",
            "Stay strong, Tenno! Remember, together we can overcome any challenge that comes our way! ",
            "Keep fighting the good fight, warriors! Your determination and skill inspire us all!",
            "You are all amazing, Tenno! Don't give up, and keep spreading those positive vibes!"
        ]
    },
    {
        name: "Discord: Bless complete",
        text: [
            "{relay_code} done {celebration_emoji}`nThanks for joining in today's blessing session, Tenno! :lotus: May the Lotus continue to watch over us all. Until next time, keep grinding and having fun in Warframe :heart:!",
            "{relay_code} done {celebration_emoji}`nA heartfelt thank you to all the Tenno who joined us in spreading blessings today! Your kindness is truly appreciated! ",
            "{relay_code} done {celebration_emoji}`nGratitude fills our hearts for every Tenno who participated in the blessings! You've made a positive impact on the community!",
            "{relay_code} done {celebration_emoji}`nBig thanks to all the wonderful Tenno who participated!",
            "{relay_code} done {celebration_emoji}`nGood work Team! A ❤️ goes out to all our lovely blessers today and remember to stay hydrated and stretch while you farm!"
        ]
    }
]

; =================== ;
; Setup & Definitions ;
; =================== ;
current_step := 0
bless_time := CalculateBlessTime()

; When Organizer mode is off, discard Organizer steps
if not organizer_mode {
    filtered_steps := []
    for step in steps {
        if !(step.HasOwnProp("organizer_step") && step.organizer_step)
            filtered_steps.Push(step)
    }
    steps := filtered_steps
}

; Set up the GUI
BlessGui := Gui("+AlwaysOnTop", "WFBT")

; Prepare controls hints
controls_hints := Map(
    1, "Go back one Step",
    2, "Advance one Step",
    3, "Toggle Config section",
    5, "Nudge Bless time -1m",
    6, "Nudge Bless time +1m",
    8, "Reset Bless time",
    11, "Reset current Step to 0",
    12, "Close the Script",
)

; Add simple GUI texts
BlessGui.AddBoldText(, "Script Controls:")
gui_controls_hint := []
for section_num, text in GetControlHints() {
    control := BlessGui.AddText(section_num = 1 ? "x15" : "xp y+5" " w150 -Wrap", text)
    gui_controls_hint.Push(control)
}

; Prepare the step list from steps array
BlessGui.AddBoldText("x10", "Step List:")
step_controls := []
for step_num, step in steps {
    text := Format("{:2}", step_num) " " step.name
    control := BlessGui.AddBoldText(step_num = 1 ? "xp y+5" : "xp y+2", text)
    step_controls.Push(control)
}

; Add the status bar showing the current step
gui_status_bar := BlessGui.AddStatusBar(, "Current Step: 0")

; Add a collapsible Config section
config_section_visible := false
gui_config_group := BlessGui.AddGroupBox("x10 y+5 w185 h215 Hidden", "Config")
gui_config_controls := [gui_config_group]

; Define and process Region options
region_list := [
    {name: "North America", code: "NA", bless_group: "Bless Team NA"},
    {name: "South America", code: "SA", bless_group: "Bless Team NA"},
    {name: "Europe", code: "EU", bless_group: "Bless Team EU"},
    {name: "Eastern Europe", code: "RU", bless_group: "Bless Team EU"},
    {name: "Asia", code: "AS", bless_group: "Bless Team AU"},
    {name: "Oceania", code: "OCE", bless_group: "Bless Team AU"}
]
regions := Map()
region_name_list := []
default_region_index := 1
for index, region in region_list {
    region.index := index
    regions[region.name] := region
    region_name_list.Push(region.name)
    if (region.name = default_region)
        default_region_index := region.index
}

; Add a Region dropdown
gui_config_controls.Push(BlessGui.AddText("xp+10 yp+20 w37 Section Hidden", "Region:"))
gui_region_dropdown := BlessGui.AddDropDownList("x+10 yp-3 Hidden", region_name_list)
gui_region_dropdown.Choose(default_region_index)
gui_region_dropdown.OnEvent("Change", OnRegionChange)
gui_config_controls.Push(gui_region_dropdown)
selected_region := regions[default_region]

; Define and process Relay options
relay_list := ["Strata", "Larunda", "Maroo", "Kronia", "Orcus"]
default_relay_index := 1
for index, relay_name in relay_list {
    if (relay_name = default_relay)
        default_relay_index := index
}

; Add a Relay dropdown
gui_config_controls.Push(BlessGui.AddText("xs y+10 w37 Hidden", "Relay:"))
gui_relay_dropdown := BlessGui.AddDropDownList("x+10 yp-3 Hidden", relay_list)
gui_relay_dropdown.Choose(default_relay_index)
gui_relay_dropdown.OnEvent("Change", OnRelayChange)
gui_config_controls.Push(gui_relay_dropdown)
selected_relay := relay_list[default_relay_index]

; Add a Relay Instance up-down field, initialized to 1
gui_config_controls.Push(BlessGui.AddText("xs y+10 w116 Hidden", "Relay Instance:"))
gui_relay_instance_edit := BlessGui.AddEdit("x+10 yp-3 w40 Number Limit2 Hidden", "1")
gui_relay_instance_updown := BlessGui.AddUpDown("Range1-99 Hidden")
gui_relay_instance_edit.OnEvent("Change", OnRelayInstanceChange)
gui_config_controls.Push(gui_relay_instance_edit)
gui_config_controls.Push(gui_relay_instance_updown)
selected_relay_instance := "1"

; Add a Blessers multi-line textbox
gui_config_controls.Push(BlessGui.AddText("xs y+10 w165 Hidden", "Blessers:"))
gui_blessers_edit := BlessGui.AddEdit("xs y+2 w165 r6 -VScroll Hidden", "")
gui_blessers_edit.OnEvent("Change", OnBlessersChange)
gui_config_controls.Push(gui_blessers_edit)

; List of bless types, in the order they are requested/announced
bless_types_list := ["Affinity", "Credits", "Resource", "Damage", "Health", "Shield"]
blessers_count := 0
blessers_names := []

; Exit the script when the GUI is closed
BlessGui.OnEvent("Close", (*) => ExitApp())

; Show the GUI
BlessGui.Show("X10 Y10")

; ============ ;
; Hotkey Setup ;
; ============ ;
F1:: RewindStep()

F2:: AdvanceStep()

; Toggle the visibility of the Config section
F3:: {
    global config_section_visible, gui_config_controls

    config_section_visible := !config_section_visible

    for control in gui_config_controls
        control.Visible := config_section_visible

    BlessGui.Show("AutoSize NoActivate")
}

; Toggle auto-advance mode
F4:: {
    global auto_advance
    auto_advance := !auto_advance
    UpdateGUI()
}

; Nudge the bless time backward
F5:: {
    global bless_time
    bless_time -= 60
    UpdateGUI()
}

; Nudge the bless time forward
F6:: {
    global bless_time
    bless_time += 60
    UpdateGUI()
}

; Re-calculate the bless time
F8:: {
    global bless_time
    bless_time := CalculateBlessTime()
    UpdateGUI()
}

F11:: ActivateStep(0)

F12:: ExitApp

; Auto-advance after a paste when enabled
^v:: {
    global auto_advance
    Send "^v"
    Sleep 100
    if auto_advance
        AdvanceStep()
}

^r:: Reload

; ==================== ;
; Initialization Steps ;
; ==================== ;
UpdateGUI()

; ==================== ;
; Function Definitions ;
; ==================== ;
RewindStep() {
    global current_step

    if current_step > 1
        ActivateStep(current_step - 1)
}

AdvanceStep() {
    global current_step, steps

    ; Find the next step that is not skipped
    next_step := current_step + 1
    while (next_step <= steps.Length && ShouldSkipStep(next_step))
        next_step += 1

    ; If we have a valid next step, activate it. Otherwise, all steps are complete.
    if next_step <= steps.Length
        ActivateStep(next_step)
    else {
        result := MsgBox("All steps are complete. The script will now close.", "Bless", "OKCancel")
        if (result = "OK")
            ExitApp
    }
}

ShouldSkipStep(step_num) {
    global steps

    step_data := steps[step_num]
    if !step_data.HasOwnProp("skip_conditions")
        return false

    for flag_name in step_data.skip_conditions {
        if EvaluateCondition(flag_name)
            return true
    }
    return false
}

; Evaluates a named condition used by both `skip_conditions` and `conditional_text`.
EvaluateCondition(condition_name) {
    global blessers_count

    switch condition_name {
        case "full_bless":
            return blessers_count >= 6
        case "no_blessers":
            return blessers_count < 1
        default:
            return false
    }
}

ActivateStep(step_num) {
    global current_step, tooltip_timeout

    current_step := step_num

    if (current_step > 0) {
        A_Clipboard := GetStepText()
        ToolTip ("Step " current_step "`n" A_Clipboard)
        SetTimer () => ToolTip(), tooltip_timeout * 1000
    }

    UpdateGUI()
    BlessGui.restore
}

OnRegionChange(dropdown, *) {
    global selected_region, regions, region_name_list

    region_name := region_name_list[dropdown.Value]
    selected_region := regions[region_name]
}

OnRelayChange(dropdown, *) {
    global selected_relay, relay_list

    selected_relay := relay_list[dropdown.Value]
}

OnRelayInstanceChange(edit, *) {
    global selected_relay_instance

    selected_relay_instance := edit.Value
}

OnBlessersChange(edit, *) {
    ; Debounce processing until the user stops editing for 1 second.
    ; Passing the same function reference resets the pending one-shot timer.
    SetTimer ProcessBlessersText, -1000
}

ProcessBlessersText() {
    global gui_blessers_edit, blessers_count, blessers_names

    lines := StrSplit(gui_blessers_edit.Value, "`n", "`r")
    changed := false

    ; Trim to at most 6 lines
    if (lines.Length > 6) {
        lines.Length := 6
        changed := true
    }

    for index, line in lines {
        if (line != "" && SubStr(line, 1, 1) != "@") {
            lines[index] := "@" line
            changed := true
        }
    }

    if changed {
        new_text := ""
        for index, line in lines
            new_text .= (index > 1 ? "`n" : "") line
        gui_blessers_edit.Value := new_text
    }

    ; Update the global list of blesser names, stripping lines that are empty,
    ; whitespace-only, or just "@"
    names := []
    for line in lines {
        trimmed := Trim(line)
        if (trimmed != "" && trimmed != "@")
            names.Push(trimmed)
    }
    blessers_names := names

    ; Update the blessers count based on the parsed names
    blessers_count := blessers_names.Length
}

UpdateGUI() {
    global step_controls, gui_status_bar, gui_controls_hint

    ; Update the status bar with the current step and bless time
    gui_status_bar.SetText(GetBlessTimeText() " | Current Step: " current_step)

    ; Highlight the current step in the step list
    for step_num, control in step_controls {
        if (step_num = current_step)
            control.SetFont("Bold")
        else
            control.SetFont("Norm")
    }

    ; Refresh the controls hints text
    for section_num, section_text in GetControlHints()
        gui_controls_hint[section_num].Value := section_text

    BlessGui.Show("AutoSize NoActivate")
}

GetControlHints() {
    global controls_hints, auto_advance

    ; Add the Auto-Advance hint in the correct state
    hints := controls_hints.Clone()
    hints[4] := auto_advance ? "Disable Auto-Advance" : "Enable Auto-Advance "

    ; Group hints into sections of F1-F4, F5-F8, F9-F12
    sections := []
    section_text := ""
    prev_section := 0
    Loop 12 {
        f_key := A_Index
        if !hints.Has(f_key)
            continue
        section := Ceil(f_key / 4)
        if (prev_section && section != prev_section) {
            sections.Push(Trim(section_text, "`n"))
            section_text := ""
        }
        prev_section := section
        section_text .= Format("F{:-2} - {}`n", f_key, hints[f_key])
    }
    sections.Push(Trim(section_text, "`n"))

    return sections
}

CalculateBlessTime() {
    global bless_time_minute, bless_time_buffer

    ; Get current timestamp
    nowtime := DateDiff(A_NowUTC, "1970", "s")

    ; Find next occurrence of bless_time_minute
    new_bless_time := nowtime - mod(nowtime, 3600) + (bless_time_minute * 60)
    if (new_bless_time - (bless_time_buffer * 60) <= nowtime)
        new_bless_time += 3600

    return new_bless_time
}

GetBlessTimeText() {
    global bless_time

    ; Convert the UTC epoch timestamp to a local, human-readable time
    utc_bias := DateDiff(A_Now, A_NowUTC, "s")
    local_datetime := DateAdd("19700101000000", bless_time + utc_bias, "s")
    return "Bless time: " FormatTime(local_datetime, "HH:mm")
}

GetStepText() {
    global steps, bless_time, selected_region, selected_relay, selected_relay_instance, blessers_count, blessers_names, bless_types_list, role_list_divider, blesser_role_separator, celebration_emojis

    step_data := steps[current_step]

    ; Resolve the text options, either directly from `text` or from the first
    ; matching entry in `conditional_text`
    text_options := false
    if step_data.HasOwnProp("conditional_text") {
        ; See if any of the `conditional_text` entries match the current conditions
        for entry in step_data.conditional_text {
            if EvaluateCondition(entry.condition) {
                text_options := entry.text
                break
            }
        }

        ; If no `conditional_text` matched, check for a "default" entry
        if !text_options {
            for entry in step_data.conditional_text {
                if (entry.condition = "default") {
                    text_options := entry.text
                    break
                }
            }
        }
    }
    ; If no conditional text was used, fall back to the main `text` property
    if !text_options {
        text_options := step_data.text
    }

    ; Pick random text variant if multiple options exist
    text := text_options[Random(1, text_options.Length)]

    ; Replace time placeholders
    text := StrReplace(text, "{bless_time}", bless_time)
    text := StrReplace(text, "{bless_time-8m}", bless_time - 480)
    text := StrReplace(text, "{bless_time-5m}", bless_time - 300)

    ; Replace minutes-till-bless placeholders
    nowtime := DateDiff(A_NowUTC, "1970", "s")
    minutes_till_bless := Max(0, Ceil((bless_time - nowtime) / 60))
    text := StrReplace(text, "{minutes_till_bless}", minutes_till_bless)
    text := StrReplace(text, "{minutes_till_bless_plural}", minutes_till_bless != 1 ? "s" : "")
    text := StrReplace(text, "{minutes_till_bless_command}", Max(minutes_till_bless, 5) "m")

    ; Replace region placeholders
    text := StrReplace(text, "{bless_team}", selected_region.bless_group)
    text := StrReplace(text, "{region_name}", selected_region.name)
    text := StrReplace(text, "{region_code}", selected_region.code)

    ; Replace relay placeholder
    text := StrReplace(text, "{relay}", selected_relay)
    text := StrReplace(text, "{relay_instance}", selected_relay_instance)
    text := StrReplace(text, "{relay_code}", StrUpper(SubStr(selected_relay, 1, 1)) selected_relay_instance)

    ; Replace blessers placeholders
    text := StrReplace(text, "{blessers_count}", blessers_count)
    blessers_needed := 6 - blessers_count
    text := StrReplace(text, "{blessers_needed}", blessers_needed)
    text := StrReplace(text, "{blessers_needed_plural}", blessers_needed != 1 ? "s" : "")

    ; Prepare active bless types list for the !bless command
    bless_types := ""
    if (blessers_count >= 6) {
        bless_types := "all"
    }
    else {
        bless_type_count := Min(blessers_count, bless_types_list.Length)

        ; If no blessers were set up, provide all roles for manual adjustment
        if (bless_type_count < 1)
            bless_type_count := 6

        loop (bless_type_count) {
            bless_types .= (A_Index > 1 ? " " : "") StrLower(bless_types_list[A_Index])
        }
    }
    text := StrReplace(text, "{bless_types}", bless_types)

    ; Prepare blessing roles assignments
    bless_roles := ""
    for index, name in blessers_names
        bless_roles .= (index > 1 ? role_list_divider : "") name blesser_role_separator bless_types_list[index]
    text := StrReplace(text, "{bless_roles}", bless_roles)

    ; Replace celebration emoji placeholder
    text := StrReplace(text, "{celebration_emoji}", celebration_emojis[Random(1, celebration_emojis.Length)])

    return text
}

PatchGUIPrototype() {
    ; Adds a Text control rendered in bold, restoring the normal font afterwards.
    GuiAddBoldText(this, Options := "", Text := "") {
        this.SetFont("Bold")
        gui_control := this.AddText(Options, Text)
        this.SetFont("Norm")
        return gui_control
    }
    Gui.Prototype.AddBoldText := GuiAddBoldText
}
