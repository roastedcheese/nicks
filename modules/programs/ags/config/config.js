import Bar from './js/Bar.js';
import { NotificationCenter, NotificationsPopupWindow } from './js/notifcenter.js';
import App from 'resource:///com/github/Aylur/ags/app.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
import { IconBrowser } from './js/iconbrowser.js';
import Notifications from 'resource:///com/github/Aylur/ags/service/notifications.js';


export default {
    style: App.configDir + '/style.css',
    windows: [
      Bar,
      // NotificationCenter(),
      NotificationsPopupWindow(),
      // IconBrowser(),
    ],
};
execAsync('ags toggle-window notification-center');
Notifications.clear();
