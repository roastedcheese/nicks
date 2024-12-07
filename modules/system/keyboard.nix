{pkgs, ...}: {
  services.xserver.xkb.extraLayouts.graphite = {
    description = "Graphite us keyboard layout";
    languages = ["eng"];

    symbolsFile = pkgs.writeText "graphite-symbols" ''
      default partial alphanumeric_keys modifier_keys
      xkb_symbols "graphite" {
        include "us(basic)"
        name[Group1]= "graphite";

        key <RALT> {
          type= "ONE_LEVEL",
          symbols= [ ISO_Level3_Shift ]
        };
        key <TLDE> {[ grave, asciitilde ]};
        key <AE01> {[ 1, exclam ]};
        key <AE02> {[ 2, at ]};
        key <AE03> {type= "THREE_LEVEL", symbols= [ 3, numbersign, EuroSign ]};
        key <AE04> {[ 4, dollar ]};
        key <AE05> {[ 5, percent ]};
        key <AE06> {[ 6, asciicircum ]};
        key <AE07> {[ 7, ampersand ]};
        key <AE08> {[ 8, asterisk ]};
        key <AE09> {[ 9, parenleft ]};
        key <AE10> {[ 0, parenright ]};
        key <AE11> {type= "THREE_LEVEL", symbols= [ bracketleft, braceleft ]};
        key <AE12> {type= "THREE_LEVEL", symbols= [ bracketright, braceright ]};

        key <AD01> {[ b, B ]};
        key <AD02> {[ l, L ]};
        key <AD03> {type= "THREE_LEVEL", symbols= [ d, D, less ]};
        key <AD04> {type= "THREE_LEVEL", symbols= [ w, W, greater ]};
        key <AD05> {[ z, Z ]};
        key <AD06> {[ apostrophe, underscore ]};
        key <AD07> {type= "THREE_LEVEL", symbols= [ f, F, parenleft]};
        key <AD08> {type= "THREE_LEVEL", symbols= [ o, O, parenright ]};
        key <AD09> {[ u, U ]};
        key <AD10> {[ j, J ]};
        key <AD11> {[ semicolon, colon ]};
        key <AD12> {[ equal, plus ]};

        key <AC01> {type= "THREE_LEVEL", symbols= [ n, N, braceleft]};
        key <AC02> {type= "THREE_LEVEL", symbols= [ r, R, braceright]};
        key <AC03> {type= "THREE_LEVEL", symbols= [ t, T, bracketleft]};
        key <AC04> {type= "THREE_LEVEL", symbols= [ s, S, bracketright ]};
        key <AC05> {[ g, G ]};
        key <AC06> {type= "THREE_LEVEL", symbols= [ y, Y, Delete ]};
        key <AC07> {type= "THREE_LEVEL", symbols= [ h, H, Left ]};
        key <AC08> {type= "THREE_LEVEL", symbols= [ a, A, Down ]};
        key <AC09> {type= "THREE_LEVEL", symbols= [ e, E, Up ]};
        key <AC10> {type= "THREE_LEVEL", symbols= [ i, I, Right ]};
        key <AC11> {[ comma, question ]};

        key <AB01> {[ q, Q ]};
        key <AB02> {[ x, X ]};
        key <AB03> {[ m, M ]};
        key <AB04> {[ c, C ]};
        key <AB05> {[ v, V ]};
        key <AB06> {[ k, K ]};
        key <AB07> {type= "THREE_LEVEL", symbols= [ p, P, BackSpace ]};
        key <AB08> {[ period, greater ]};
        key <AB09> {[ minus, quotedbl ]};
        key <AB10> {[ slash, less ]};

        key.type = "ONE_LEVEL";
        key <ESC> { [ Escape ] };
        key <CAPS> { [ Escape ] };
      };
    '';
  };

  console.keyMap = pkgs.writeText "graphite.map" ''
    include "qwerty-layout"
    include "linux-with-alt-and-altgr"
    strings as usual

    keycode 41 = grave asciitilde
    keycode 2 = one exclam
    keycode 3 = two at
    keycode 4 = three numbersign euro
    keycode 5 = four dollar
    keycode 6 = five percent
    keycode 7 = six asciicircum
    keycode 8 = seven ampersand
    keycode 9 = eight asterisk
    keycode 10 = nine parenleft
    keycode 11 = zero parenright
    keycode 12 = bracketleft braceleft
    keycode 13 = bracketright braceright

    keycode 16 = b
    keycode 17 = l
    keycode 18 = +d +D less
    keycode 19 = +w +W greater
    keycode 20 = z
    keycode 21 = apostrophe underscore
    keycode 22 = +f +F parenleft
    keycode 23 = +o +O parenright
    keycode 24 = u
    keycode 25 = j
    keycode 26 = semicolon colon
    keycode 27 = equal plus

    keycode 30 = +n +N braceleft
    keycode 31 = +r +R braceright
    keycode 32 = +t +T bracketleft
    keycode 33 = +s +S bracketright
    keycode 34 = g
    keycode 35 = y
    keycode 36 = +h +H Left
    keycode 37 = +a +A Down
    keycode 38 = +e +E Up
    keycode 39 = +i +I Right
    keycode 40 = comma question

    keycode 44 = q
    keycode 45 = x
    keycode 46 = m
    keycode 47 = c
    keycode 48 = v
    keycode 49 = k
    keycode 50 = +p +P Delete
    keycode 51 = period greater
    keycode 52 = minus quotedbl
    keycode 53 = slash less

    keycode 58 = Escape

    keycode 1 = Escape
    keycode 14 = Delete
    keycode 15 = Tab
    keycode 28 = Return
     alt keycode 28 = Meta_Control_m
    keycode 29 = Control
    keycode 42 = Shift
    keycode 54 = Shift
    keycode 56 = Alt
    keycode 57 = space
    keycode 97 = Control
  '';
}
