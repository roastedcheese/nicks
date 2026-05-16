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
        key <AE11> {[ bracketleft, braceleft ]};
        key <AE12> {[ bracketright, braceright ]};

        key <AD01> {type= "THREE_LEVEL", symbols= [ b, B, exclam ]};
        key <AD02> {type= "THREE_LEVEL", symbols= [ l, L, at ]};
        key <AD03> {type= "THREE_LEVEL", symbols= [ d, D, numbersign ]};
        key <AD04> {type= "THREE_LEVEL", symbols= [ w, W, dollar ]};
        key <AD05> {type= "THREE_LEVEL", symbols= [ z, Z, percent ]};
        key <AD06> {type= "THREE_LEVEL", symbols= [ apostrophe, underscore, asciicircum ]};
        key <AD07> {type= "THREE_LEVEL", symbols= [ f, F, ampersand ]};
        key <AD08> {type= "THREE_LEVEL", symbols= [ o, O, asterisk ]};
        key <AD09> {type= "THREE_LEVEL", symbols= [ u, U, parenleft ]};
        key <AD10> {type= "THREE_LEVEL", symbols= [ j, J, parenright ]};
        key <AD11> {type= "THREE_LEVEL", symbols= [ semicolon, colon, asciitilde ]};
        key <AD12> {[ equal, plus ]};

        key <AC01> {type= "THREE_LEVEL", symbols= [ n, N, braceleft]};
        key <AC02> {type= "THREE_LEVEL", symbols= [ r, R, braceright]};
        key <AC03> {type= "THREE_LEVEL", symbols= [ t, T, bracketleft]};
        key <AC04> {type= "THREE_LEVEL", symbols= [ s, S, bracketright ]};
        key <AC05> {[ g, G ]};
        key <AC06> {[ y, Y]};
        key <AC07> {type= "THREE_LEVEL", symbols= [ h, H, Left ]};
        key <AC08> {type= "THREE_LEVEL", symbols= [ a, A, Down ]};
        key <AC09> {type= "THREE_LEVEL", symbols= [ e, E, Up ]};
        key <AC10> {type= "THREE_LEVEL", symbols= [ i, I, Right ]};
        key <AC11> {[ comma, question ]};

        key <AB01> {type= "THREE_LEVEL", symbols= [ q, Q, plus ]};
        key <AB02> {type= "THREE_LEVEL", symbols= [ x, X, minus ]};
        key <AB03> {type= "THREE_LEVEL", symbols= [ m, M, equal ]};
        key <AB04> {type= "FOUR_LEVEL", symbols= [ c, C, backslash, bar ]};
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

    keycode 16 = +b +B exclam
    keycode 17 = +l +L at
    keycode 18 = +d +D numbersign
    keycode 19 = +w +W dollar
    keycode 20 = +z +Z percent
    keycode 21 = +apostrophe +underscore asciicircum
    keycode 22 = +f +F ampersand
    keycode 23 = +o +O asterisk
    keycode 24 = +u +U parenleft
    keycode 25 = +j +J parenright
    keycode 26 = +semicolon +colon asciitilde
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

    keycode 44 = +q +Q plus
    keycode 45 = +x +X minus
    keycode 46 = +m +M equal
    keycode 47 = +c +C backslash bar
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
