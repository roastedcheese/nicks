{pkgs, ...}: {
  services.xserver.xkb.extraLayouts.graphite-us = {
    description = "Graphite us keyboard layout";
    languages = ["eng"];
    symbolsFile = pkgs.writeText "graphite-us-symbols" ''
      default partial alphanumeric_keys modifier_keys
      xkb_symbols "graphite-us" {

         include "us(basic)"
         name[Group1]= "graphite";

         key <TLDE>     {[      grave,  asciitilde     ]};
         key <AE01>     {[      1,  exclam     ]};
         key <AE02>     {[      2,  at     ]};
         key <AE03>     {[      3,  numbersign     ]};
         key <AE04>     {[      4,  dollar     ]};
         key <AE05>     {[      5,  percent     ]};
         key <AE06>     {[      6,  asciicircum     ]};
         key <AE07>     {[      7,  ampersand     ]};
         key <AE08>     {[      8,  asterisk     ]};
         key <AE09>     {[      9,  parenleft     ]};
         key <AE10>     {[      0,  parenright     ]};
         key <AE11>     {[      minus,  underscore     ]};
         key <AE12>     {[      equal,  plus     ]};

         key <AD01>     {[      b,  B     ]};
         key <AD02>     {[      l,  L     ]};
         key <AD03>     {[      d,  D     ]};
         key <AD04>     {[      w,  W     ]};
         key <AD05>     {[      z,  Z     ]};
         key <AD06>     {[      apostrophe,  quotedbl     ]};
         key <AD07>     {[      f,  F     ]};
         key <AD08>     {[      o,  O     ]};
         key <AD09>     {[      u,  U     ]};
         key <AD10>     {[      j,  J     ]};
         key <AD11>     {[      semicolon,  colon     ]};
         key <AD12>     {[      equal,  plus     ]};

         key <AC01>     {[      n,  N     ]};
         key <AC02>     {[      r,  R     ]};
         key <AC03>     {[      t,  T     ]};
         key <AC04>     {[      s,  S     ]};
         key <AC05>     {[      g,  G     ]};
         key <AC06>     {[      y,  Y     ]};
         key <AC07>     {[      h,  H     ]};
         key <AC08>     {[      a,  A     ]};
         key <AC09>     {[      e,  E     ]};
         key <AC10>     {[      i,  I     ]};
         key <AC11>     {[      comma,  less     ]};

         key <AB01>     {[      q,  Q     ]};
         key <AB02>     {[      x,  X     ]};
         key <AB03>     {[      m,  M     ]};
         key <AB04>     {[      c,  C     ]};
         key <AB05>     {[      v,  V     ]};
         key <AB06>     {[      k,  K     ]};
         key <AB07>     {[      p,  P     ]};
         key <AB08>     {[      period,  greater     ]};
         key <AB09>     {[      minus,  underscore     ]};
         key <AB10>     {[      slash,  question     ]};

         key <AE11> {[  bracketleft, braceleft  ]};
         key <AE11> {[  bracketright, braceright  ]};
      };
    '';
  };
}
