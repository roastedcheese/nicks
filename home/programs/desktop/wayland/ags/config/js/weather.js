import App from 'resource:///com/github/Aylur/ags/app.js';
import Widget from 'resource:///com/github/Aylur/ags/widget.js';
import { exec, execAsync } from 'resource:///com/github/Aylur/ags/utils.js';
const { Box, Button, Stack, Label, Icon, CenterBox, Window, Slider, ProgressBar } = Widget;

let fetch;
execAsync('curl http://ip-api.com/json/').then(out => {
  let o = JSON.parse(out);
  const POS = [o.lat, o.lon];
  fetch = `https://api.open-meteo.com/v1/forecast?latitude=${POS[0]}&longitude=${POS[1]}&current=temperature_2m,is_day,rain,showers,snowfall,weathercode,cloudcover&timezone=Europe%2FBerlin&forecast_days=1`;
}).catch(console.error);
// "ummmm but this allows for a race condition" I don't care, this  module is useless anyways


export const Weather = () => Button({
  className: 'weather',
  child: Box({
    children: [
      Stack({
        items: [
          ['', Label('')],
          ['clear', Icon('weather-clear-symbolic')],
          ['clear-night', Icon('weather-clear-night-symbolic')],
          ['cloudy', Icon('weather-few-clouds-symbolic')],
          ['cloudy-night', Icon('weather-few-clouds-night-symbolic')],
          ['overcast', Icon('weather-overcast-symbolic')],
          ['rainy', Icon('weather-showers-symbolic')],
          ['snowy', Icon('weather-snow-symbolic')],
          ['thunder', Icon('weather-storm-symbolic')],
        ],
        css: 'margin-right: 4;',
      }),
      Label('')
    ],
    connections: [[60000, self => {
      execAsync(`curl ${fetch}`).then(out => {
        let fc = JSON.parse(out);
        let day = fc.current.is_day;
        let rain = fc.current.rain;
        let showers = fc.current.showers;
        let snow = fc.current.snowfall;
        let clouds = fc.current.cloudcover;
        let wc = fc.current.weathercode;
        let output;

        self.children[1].label = `${fc.current.temperature_2m} °C`;
        if (clouds > 25)
            output = 'cloudy';
        else
          output = 'clear';
        if (day === 0)
          output += '-night';
        if (clouds > 88)
          output = 'overcast';
        if (rain !== 0)
          output = 'rainy';
        if (snow !== 0)
          output = 'snowy';
        if (wc > 94)
          output = 'thunder';

        self.children[0].shown = output;
      }).catch(console.error);
    }]],
  }),
});
