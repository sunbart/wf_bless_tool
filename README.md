# Warframe Bless Tool

A small utility to assist in organizing Blessing sessions, made by and for the blessing
community over at the
[Warframe Blessing Discord server](https://tiny.cc/warframeblessing).

## Quick Start Guide

Make sure you have AutoHotkey v2 installed on your system, download the `.ahk` file and
double click it to start it.

#### The most basic usage of the script consists of the following steps:

- Press F2 to advance to the next step (The script places the relevant text into your
  clipboard automatically, and a tooltip briefly shows what text was copied.)
- Paste the text into the right place (either Discord or the in-game Relay chat)
- Adjust the text if needed (e.g. when sending the ping bot command in the `#bless`
  channel)
- Send the text
- Repeat these instructions until you run out of steps.

### Warning

The script can conflict with other scripts or programs that use the same hotkeys.\
It will also overwrite your clipboard contents, so be careful when using it, make sure
you don't have anything important copied.

## Usage Guide

After opening the script, the **Script Controls** section lists the basic controls of
the script.

| Key | Action                                                                   |
| --- | ------------------------------------------------------------------------ |
| F1  | Go back one step in the step list                                        |
| F2  | Advance one step forward in the step list                                |
| F4  | Show/hide the optional config section                                    |
| F5  | Move Bless time 1 minute earlier                                         |
| F6  | Move Bless time 1 minute later                                           |
| F8  | Reset Bless time to the next available slot based on your customizations |
| F11 | Reset the script by jumping back to step 0                               |
| F12 | Close the script                                                         |

## Script Features

### Customization Options

The script has several customization options you can tweak to your liking. The list
follows but they are also described in the script itself.

| Option name              | Description                                                                                             |
| ------------------------ | ------------------------------------------------------------------------------------------------------- |
| `tooltip_timeout`        | Sets how long [the tooltip with the newly copied value](#copied-text-tooltip) will be visible for       |
| `config_section_visible` | Sets whether the [Config section](#config-section) will be visible when the script is launched          |
| `celebration_emojis`     | The list of text or Discord emojis to be used in a celebration message                                  |
| `organizer_mode`         | Sets whether the script will run in [Organizer Mode](#organizer-mode)                                   |
| `bless_time_minute`      | Sets the basic timing of the Bless session. [More details here.](#bless-time-calculation)               |
| `bless_time_buffer`      | Sets the minimum buffer for organizing the Bless session. [More details here.](#bless-time-calculation) |
| `default_region`         | Sets which Region will be selected when the script is launched                                          |
| `default_relay`          | Sets which Relay will be selected when the script is launched                                           |
| `role_list_divider`      | Character used to separate the list of Blessers in the Role Assignment step                             |
| `blesser_role_separator` | Character used between the name and the role of a Blesser in the Role Assignment step                   |
| `steps`                  | Definitions of the steps the script will go through. [More details here.](#step-definitions)            |

### Copied Text Tooltip

When text is copied to the clipboard, a tooltip will briefly show what text was copied.
The tooltip will automatically disappear after a few seconds, set by the
`tooltip_timeout` [Customization option](#customization-options).

### Config Section

The Config section is an optional feature of the script that allows you to set the
Region, Relay, Relay Instance and Blessers.

The script will use this information to prepare the correct `#bless` ping command, the
"Looking for additional Blessers" message and the Bless role assignment message.

The Config section can be toggled on and off with the F4 key at any time, and its
visibility when the script is launched can also be set with the `config_section_visible`
[Customization option](#customization-options).

### Organizer Mode

When the script is launched in with `organizer_mode` set to `true`, extra steps are
added to the script to help organize the Bless session.

### Bless Time Calculation

The script calculates the next available Bless time based on the current time, the
`bless_time_minute` and `bless_time_buffer`
[Customization options](#customization-options).

The bless time is decided based on the `bless_time_minute` option, which sets the minute
of the hour of the bless time. So 0 means that the time will be at the beginning of the
next hour, 15 would set the bless time to the closest XX:15 and so on.

If the script is in [Organizer Mode](#organizer-mode) and the calculated bless time
would be earlier than `bless_time_buffer` minutes in the future, it is automatically
moved to the next hour (still keeping the minute value in mind). This is so that there
is always enough time to organize the bless session.

The current bless time is displayed at the bottom of the window and is used to prepare
the text of some of the script steps.

### Role Assignment Message

The script prepares a message to assign the Blessers their roles in the Bless session,
if the list of Blessers is provided in the Config section.

The `role_list_divider` and `blesser_role_separator`
[Customization options](#customization-options) are used to format the message
correctly, like this example:

When `role_list_divider` is set to `|` and `blesser_role_separator` is set to `->` and
there are 3 blessers set in the [Config Section](#config-section), the message will look
like this:

`@blesser1 -> affinity | @blesser2 -> credits | @blesser3 -> resources`

### Step Definitions

_Step definition help coming soon™. The script itself has a brief explanation already._

## Disclaimer

This tool is in no way affiliated with or sanctioned by Digital Extremes. Use at your
own risk, ideally after reading and understanding the code. 🙃
