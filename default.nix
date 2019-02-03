with import <nixpkgs> {};
{
  orgdapp =
  let
    act_mode = stdenv.mkDerivation {
      name = "act-mode";
      src = fetchFromGitHub {
        owner  = "livnev";
        repo   = "act-mode";
        rev    = "ff65a89d9dbb40cb8e5c02c642b655ed5dbe4f50";
        sha256 = "138rpwppwyiaw7c2367ll3m2x9hqj03z8r5c60j6gzspp3ywqq8i";
      };
      installPhase = ''
        mkdir -p $out/share/emacs/site-lisp
        install *.el* $out/share/emacs/site-lisp
      '';
    };
    emacs = emacsWithPackages (epkgs: (with epkgs.melpaStablePackages; [
      act_mode
      htmlize
      projectile
      solarized-theme
      solidity-mode
    ]));
  in
    stdenv.mkDerivation {
    name = "orgdapp";
    nativeBuildInputs = [ makeWrapper ];
    buildInputs = [ emacs ];
    src = ./.;
    dontBuild = true;
    installPhase = ''
      mkdir -p $out/bin
      install bin/* $out/bin;
    '';
    postFixup = let path = lib.makeBinPath [ emacs ]; in ''
      for prog in "$out"/bin/orgdapp-*; do
        wrapProgram "$prog" --prefix PATH ":" "${path}"
      done
      '';
    };
}
