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
        key <AD09> {type= "THREE_LEVEL", symbols= [ u, U, plus ]};
        key <AD10> {type= "THREE_LEVEL", symbols= [ j, J, minus ]};
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
        key <AB06> {type= "THREE_LEVEL", symbols= [ k, K, BackSpace]};
        key <AB07> {[ p, P ]};
        key <AB08> {[ period, greater ]};
        key <AB09> {[ minus, quotedbl ]};
        key <AB10> {[ slash, less ]};

        key.type = "ONE_LEVEL";
        key <CAPS> { [ Escape ] };
        key <ESC> { [ Caps_Lock ] };
      };
    '';
  };
}
