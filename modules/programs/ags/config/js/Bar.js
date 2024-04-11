// importing 
import Hyprland from 'resource:///com/github/Aylur/ags/service/hyprland.js';
import Mpris from 'resource:///com/github/Aylur/ags/service/mpris.js';
import Audio from 'resource:///com/github/Aylur/ags/service/audio.js';
import Network from 'resource:///com/github/Aylur/ags/service/network.js';
import Battery from 'resource:///com/github/Aylur/ags/service/battery.js';
import SystemTray from 'resource:///com/github/Aylur/ags/service/systemtray.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
const { Box, Button, Stack, Label, Icon, CenterBox, Window, Slider, ProgressBar } = Widget;
import { Weather } from './weather.js';
import { NotificationCenter } from './notifcenter.js';
import Gdk from 'gi://Gdk';
import { cut } from './utils.js';

// Keyboard name for the layout widget, you can get this by running 'hyprctl devices'
const DEFAULT_KB = "keychron-keychron-q3-keyboard";

const Distro = () => Box({
  className: 'distro',
  child: Icon({icon: App.configDir + "/assets/distroicon.svg", size: 20,}),
})


const Workspaces = () => Box({
    className: 'workspaces',
    connections: [[Hyprland, box => {
        const arr = Hyprland.workspaces.sort((a, b) => {return a.id - b.id});
        // Labels for each workspace id
        let wsNames = [, 1, 2, 3, 4, 5, 6, 7, 8, 9, 0];
        box.children = arr.map( i => Button({
          onClicked: () => execAsync(`hyprctl dispatch workspace ${i.id}`),
          child: Label({ label: `${wsNames[i.id]}`}),
          classNames: [Hyprland.active.workspace.id == i.id ? 'focused' : '', 'workspace']
        }))
      }
    ]]
});

const ClientTitle = () => Box({
  className: 'client-title',
  child: Label({
    // an initial label value can be given but its pointless
    // because callbacks from connections are run on construction
    // so in this case this is redundant
    label: cut(Hyprland.active.client.title, 30) || '',
    connections: [[Hyprland, label => {
        label.label = cut(Hyprland.active.client.title, 30) || '';
        if (!Hyprland.active.client.title) {
          label.get_parent().classNames = ['client-title', 'no-client'];
        } 
    }]],
}),
});
const Clock = () => Box({
  className: 'clock',
  children: [
    Icon({
      icon: 'preferences-system-time-symbolic',
      css: 'margin-right: 4px;',
    }),
    Label({
        connections: [[1000, label => execAsync(['date', '+%H:%M:%S %d/%m/%y'])
            .then(date => label.label = date).catch(console.error)],
        ],
    })
]})

const Media = () => Button({
  className: 'media-box',
  onPrimaryClick: () => Mpris.getPlayer('')?.playPause(),
  onScrollUp: () => Mpris.getPlayer('')?.next(),
  onScrollDown: () => Mpris.getPlayer('')?.previous(),
  child: Box({
    className: 'media',
    children: [
      Stack({
        items: [
          ['Playing', Icon('media-playback-start-symbolic')],
          ['Paused', Icon('media-playback-pause-symbolic')],
          ['Stopped', Icon('media-playback-stop-symbolic')]
        ],
        css: 'margin-right: 4px;',
      }),
      Label('')
    ],
    connections: [[Mpris, self => {
        const mpris = Mpris.getPlayer('');
        self.get_parent().visible = !!mpris;

        if (mpris)
            self.children[1].label= `${cut(mpris.trackArtists.join(', '))} - ${cut(mpris.trackTitle, 20)}`;
        if (self.children[1].label== 'Unknown artist - Unknown title') {
            self.get_parent().hide();
        }
        self.children[0].shown = mpris.playBackStatus;
  }]],
}),
})

const Volume = () => Button({
  className: 'volume',
  onScrollUp: () => execAsync('pactl set-sink-volume @DEFAULT_SINK@ +1000'),
  onScrollDown: () => execAsync('pactl set-sink-volume @DEFAULT_SINK@ -1000'),
  onClicked: () => execAsync('pactl set-sink-mute @DEFAULT_SINK@ toggle'),
  child: Box({
    //css: 'min-width: 180px',
    children: [
        Stack({
            items: [
                // tuples of [string, Widget]
                ['101', Icon('audio-volume-overamplified-symbolic')],
                ['67', Icon('audio-volume-high-symbolic')],
                ['34', Icon('audio-volume-medium-symbolic')],
                ['1', Icon('audio-volume-low-symbolic')],
                ['0', Icon('audio-volume-muted-symbolic')],
            ],
            connections: [[Audio, stack => {
                if (!Audio.speaker)
                    return;

                if (Audio.speaker.stream.isMuted) {
                    stack.shown = '0';
                    return;
                }

                const show = [101, 67, 34, 1, 0].find(
                    threshold => threshold <= Audio.speaker.volume * 100);

                stack.shown = `${show}`;
            }, 'speaker-changed']],
        }),
        Label({
          connections: [[Audio, label => {
        label.label = `${Math.floor(Audio.speaker.volume * 100)}%`;
          }, 'speaker-changed']],
        }),
    ],
  }),
});


const MicVolume = () => Button({
  className: 'micvolume',
  onScrollUp: () => execAsync('pactl set-source-volume @DEFAULT_SOURCE@ +1000'),
  onScrollDown: () => execAsync('pactl set-source-volume @DEFAULT_SOURCE@ -1000'),
  onClicked: () => execAsync('pactl set-source-mute @DEFAULT_SOURCE@ toggle'),
  child: Box({
    //css: 'min-width: 180px',
    children: [
        Stack({
            items: [
                // tuples of [string, Widget]
                ['67', Icon('microphone-sensitivity-high-symbolic')],
                ['34', Icon('microphone-sensitivity-medium-symbolic')],
                ['1', Icon('microphone-sensitivity-low-symbolic')],
                ['0', Icon('microphone-sensitivity-muted-symbolic')],
            ],
            connections: [[Audio, stack => {
                if (!Audio.microphone)
                    return;

                if (Audio.microphone.stream.isMuted) {
                    stack.shown = '0';
                    return;
                }

                const show = [67, 34, 1, 0].find(
                    threshold => threshold <= Audio.microphone.volume * 100);

                stack.shown = `${show}`;
            }, 'microphone-changed']],
        }),
        Label({
          connections: [[Audio, label => {
        label.label = `${Math.floor(Audio.microphone.volume * 100)}%`;
            }, 'microphone-changed']],
        }),
    ],
  }),
});

const NetworkIndicator = () => Box ({
  className: 'networkindicator',
  child: Stack({
    items: [
        ['wifi', Widget.Icon({
            connections: [[Network, self => {
                self.icon = Network.wifi?.iconName || '';
            }]],
        })],
        ['wired', Widget.Icon({
            connections: [[Network, self => {
                self.icon = Network.wired?.iconName || '';
            }]],
        })],
    ],
    binds: [['shown', Network, 'primary' || 'wifi']],
}),
})



const BatteryLabel = () => Box({
    className: 'battery',
    children: [
        Icon({
            connections: [[Battery, icon => {
                icon.icon = `battery-level-${Math.floor(Battery.percent / 10) * 10}-symbolic`;
            }]],
        }),
        ProgressBar({
            valign: 'center',
            connections: [[Battery, progress => {
                if (Battery.percent < 0)
                    return;

                progress.fraction = Battery.percent / 100;
            }]],
        }),
    ],
});

const SysTray = () => Box({
    className: 'systray',
    connections: [[SystemTray, box => {
        if (!SystemTray.items.length) {
          box.classNames = ['systray', 'empty'];
        };
        box.children = SystemTray.items.map(item => Button({
            child: Icon(''),
            onPrimaryClick: (_, event) => item.activate(event),
            onSecondaryClick: (_, event) => item.openMenu(event),
            connections: [[item, button => {
                button.child.icon = item.icon;
                button.tooltipMarkup = item.tooltipMarkup; 
                item.menu.className = 'traymenu';
            }]],
        }));
    }]],
});

const NCenterToggle = () => Button({
    className: 'ncentertoggle',
    child: Icon('preferences-system-notifications-symbolic'),
    onClicked: () => execAsync('ags toggle-window notification-center'),
    // onClicked: self => NotificationCenter.popup_at_widget(self, Gdk.Gravity.SOUTH, Gdk.Gravity.NORTH, null)
});

const KbLayout = () => Button({
  className: 'kblayout',
  onClicked: () => execAsync(`hyprctl switchxkblayout ${DEFAULT_KB} next`),
  child: Box({
  children: [
    Icon({
      icon: 'input-keyboard-symbolic',
      css: 'margin-right: 4px;',
    }),
    Label({
      connections: [[Hyprland, (self, _n, layout) => {
        if (!layout) {
          let obj = exec('hyprctl devices -j');
          let keyboards = JSON.parse(obj)['keyboards'];
          let kb = keyboards.find(val => val.name === DEFAULT_KB);

          layout = kb['active_keymap'];

          self.label = layout;
        }
        else {
          self.label = layout;
        }
      }, 'keyboard-layout']],
    }),
  ],
}),
})


// layout of the bar
const Left = () => Box({
    children: [
        Distro(),
        Workspaces(),
        Weather(),
    ],
});

const Center = () => Box({
    children: [
        ClientTitle(),
    ],
});

const Right = () => Box({
    hpack: 'end',
    children: [
        Media(),
        KbLayout(),
        Volume(),
        MicVolume(),
        NetworkIndicator(),
        //BatteryLabel(),
        SysTray(),
        // NCenterToggle(),
        Clock(),
    ],
});

const Bar = ({ monitor } = {}) => Window({
    name: `bar-${monitor}`, // name has to be unique
    className: 'bar',
    monitor,
    anchor: ['top', 'left', 'right'],
    exclusivity: 'exclusive',
    child: CenterBox({
        className: 'barbox',
        start_widget: Left(),
        center_widget: Center(),
        end_widget: Right(),
    }),
})

// exporting the config so ags can manage the windows
export default {
    style: App.configDir + '/style.css',
    windows: [
        Bar(),
    ],
};
