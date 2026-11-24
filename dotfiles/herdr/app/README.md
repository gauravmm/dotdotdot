# Herdr Desktop layout

From WSL, run `~/.dotdotdot/dotfiles/herdr/herdr-app.dotsh` to sync with the
Windows Herdr Desktop installation. The hook runs as part of dotdotdot and
copies newer files in either direction. On a fresh installation, open Herdr
Desktop once, run the hook, then choose `main-with-mods` in the layout picker.

The layout uses Better Sidebar, Better Changes, and Session Bar. Edit
`mods/better-sidebar/mod.json` to change `machine_order` or
`hide_this_computer`. The order uses the connection names shown in the sidebar.
Register connections on each computer in Herdr Settings → Machines or with
`hc machine add`. Core stores the connection targets and paired identities
in its local machine registry.

Better Sidebar's Windows PR lookup uses `/usr/bin/gh` in the `Ubuntu` WSL
distribution with its existing GitHub login. Session Bar opens Better Changes
from its changed-files chip. Its optional Claude usage integration uses
state directories under the Windows user's `.local/state`.

## Upstream sources

- [Better Sidebar and Better Changes](https://github.com/munza/herdr-mods/tree/bad7512b6148b7092068cd3a6478c45706731c18)
  are licensed under Apache-2.0. See [license](licenses/munza-APACHE-2.0.txt)
  and [local changes and notices](licenses/munza-NOTICE.txt).
- [Session Bar](https://github.com/cybertron288/herdr-mods/tree/34e7c3348e954fd0a1147b846898db8c3e37e526/session-bar)
  is licensed under the [MIT license](licenses/cybertron288-MIT.txt).
