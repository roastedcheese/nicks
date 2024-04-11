import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { lookUpIcon, timeout } from 'resource:///com/github/Aylur/ags/utils.js';


function lineBreak(str, x) {
    if (str.length <= x)
      return str;
    let brk;
    for (let i = x; i < str.length; i += x) {
      brk = `${str.slice(0, i)}\n${str.slice(i, str.length)}`;
    }
    return brk;
};

const NotificationIcon = ({ appEntry, appIcon, image }) => {
  if (image) {
    return Widget.Box({
      valign: 'start',
      hexpand: false,
      className: 'icon img',
      css: `
          background-image: url("${image}");
          background-size: contain;
          background-repeat: no-repeat;
          background-position: center;
          min-width: 78px;
          min-height: 78px;
      `,
    });
  }

  let icon = '';
  if (!lookUpIcon(appIcon) && !lookUpIcon(appIcon))
  return;
  if (lookUpIcon(appIcon))
      icon = appIcon;
  if (lookUpIcon(appEntry))
      icon = appEntry;
  return Widget.Box({
    valign: 'start',
    hexpand: false,
    visible: icon == '' ? false : true,
    className: 'icon',
    css: `
        min-width: 78px;
        min-height: 78px;
    `,
    children: [Widget.Icon({
        icon, size: 58,
        visible: icon == '' ? false : true,
        halign: 'center', hexpand: true,
        valign: 'center', vexpand: true,
    })],
  });
};

export const Notification = n => Widget.EventBox({
  classNames: [`notification ${n.urgency}`, 'n'],
  onPrimaryClick: () => n.dismiss(),
  properties: [['hovered', false]],
  onHover: self => {
    if (self._hovered)
        return;
    timeout(300, () => self._hovered =true);
  },
  onHoverLost: self => {
    if (!self._hovered)
        return;

    self._hovered = false;
    n.dismiss();
  },
  vexpand: false,
  child: Widget.Box({
    vertical: true,
    children: [
        Widget.Box({
            children: [
                NotificationIcon(n),
                Widget.Box({
                    className: 'text',
                    hexpand: true,
                    vertical: true,
                    children: [
                        Widget.Box({
                          children: [
                              Widget.Label({
                                  className: 'title',
                                  xalign: 0,
                                  justification: 'left',
                                  hexpand: true,
                                  maxWidthChars: 24,
                                  truncate: 'end',
                                  wrap: true,
                                  label: lineBreak(n.summary, 38),
                                  useMarkup: true,
                              }),
                              Widget.Button({
                                  className: 'close-button',
                                  valign: 'start',
                                  child: Widget.Icon('window-close-symbolic'),
                                  onClicked: n.close.bind(n),
                              }),
                          ],
                      }),
                      Widget.Label({
                          className: 'description',
                          hexpand: true,
                          useMarkup: true,
                          xalign: 0,
                          justification: 'left',
                          label: lineBreak(n.body, 48),
                          wrap: true,
                      }),
                  ],
              }),
          ],
      }),
      Widget.Box({
          className: 'actions',
          children: n.actions.map(({ id, label }) => Button({
              className: 'action-button',
              onClicked: () => n.invoke(id),
              hexpand: true,
              child: Widget.label(label),
          })),
      }),
    ],
  }),
});
