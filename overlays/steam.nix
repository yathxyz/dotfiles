{
  steamOverlay = (final: prev: {
    steam = prev.steam.override {
      extraPkgs = pkgs:
        with pkgs; [
          ffmpeg-full
          cups
          fluidsynth
          gtk3
          pango
          cairo
          atk
          zlib
          glib
          gdk-pixbuf
        ];
      extraArgs = "-console";
      extraEnv.ROBUST_SOUNDFONT_OVERRIDE =
        "${prev.soundfont-fluid}/share/soundfonts/FluidR3_GM2-2.sf2";
    };

  });

}
