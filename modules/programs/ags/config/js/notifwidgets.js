import { Notification } from './notification.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';
import Gtk from 'gi://Gtk';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';

Notifications.clear();
const List = () => Widget.Box({
    vertical: true,
    vexpand: true,
    connections: [[Notifications, self => {
        self.children = Notifications.notifications
            .reverse()
            .map(Notification);
        self.visible = Notifications.notifications.length > 0;
    }]],
});

const Placeholder = () => Widget.Box({
    className: 'placeholder',
    vertical: true,
    vexpand: true,
    valign: 'center',
    children: [
        Widget.Icon('notifications-disabled-symbolic'),
        Widget.Label('Your inbox is empty'),
    ],
    binds: [
        ['visible', Notifications, 'notifications', n => n.length === 0],
    ],
});

export const NotificationList = () => Widget.Scrollable({
    hscroll: 'never',
    vscroll: 'automatic',
    child: Widget.Box({
        className: 'list',
        vertical: true,
        children: [
            List(),
            Placeholder(),
        ],
    }),
});

export const ClearButton = () => Widget.Button({
    className: 'clear',
    onClicked: () => Notifications.clear(),
    binds: [
        ['sensitive', Notifications, 'notifications', n => n.length > 0],
    ],
    child: Widget.Box({
        children: [
            Widget.Label({
              label: 'Clear',
              css: 'margin-right: 4px;',
            }),
            Widget.Icon({
                binds: [
                    ['icon', Notifications, 'notifications', n =>
                        `user-trash-${n.length > 0 ? 'full-' : ''}symbolic`],
                ],
            }),
        ],
    }),
});


export const DNDSwitch = () => Widget.Button({
  classNames: ['dndswitch', 'off'],
    valign: 'center',
    onClicked: () => {
        Notifications.dnd = !Notifications.dnd;
    },
    child: Widget.Icon('weather-clear-night-symbolic'),
    connections: [[Notifications, self => {
            self.classNames = ['dndswitch', Notifications.dnd ? 'on' : 'off'];
    }]],
});

export const PopupList = () => Widget.Box({
    className: 'list',
    css: 'padding: 1px;', // so it shows up
    vertical: true,
    binds: [['children', Notifications, 'popups',
        popups => popups.map(Notification)]],
});
