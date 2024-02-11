import {
    NotificationList, DNDSwitch, ClearButton, PopupList,
} from './notifwidgets.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { execAsync, timeout } from 'resource:///com/github/Aylur/ags/utils.js';

const Header = () => Widget.Box({
    className: 'header',
    children: [
        DNDSwitch(),
        Widget.Box({ hexpand: true }),
        ClearButton(),
    ],
});

export const NotificationCenter = () => Widget.Window({
    name: 'notification-center',
    anchor: ['top'],
    popup: true,
    focusable: false,
    child: Widget.Box({
        children: [
            Widget.EventBox({
                hexpand: true,
                connections: [['button-press-event', () =>
                    App.closeWindow('notification-center')]]
            }),
            Widget.Box({
                vertical: true,
                children: [
                    Header(),
                    NotificationList(),
                ],
            }),
        ],
    }),
});

export const NotificationsPopupWindow = () => Widget.Window({
    name: 'popup-window',
    anchor: ['top', 'right'],
    child: PopupList(),
});

// timeout(500, () => execAsync([
//     'notify-send',
//     'Notification Center example',
//     'To have the panel popup run "ags toggle-window notification-center"' +
//     '\nPress ESC to close it.',
// ]).catch(console.error));

// export default {
//     style: App.configDir + '/style.css',
//     windows: [
//         NotificationsPopupWindow(),
//         NotificationCenter(),
//     ]
// }
