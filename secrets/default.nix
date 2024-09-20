{ inputs, pkgs, lib, config, ... }:

let
    ed25519Matches =  lib.filter (x: x.type == "ed25519") config.services.openssh.hostKeys;
    firstMatch = if lib.length ed25519Matches > 0 then lib.elemAt ed25519Matches 0 else null;
    firstMatchPathString = (builtins.toString firstMatch.path) + ".pub";
    in
{
  ## default.nix for the secrets module. Add to modules list
  # of the host attribute of nixosConfigurations

  ## Part of agenix-rekey extension for agenix
  # This is so that secrets.nix is not needed to be manually set up for rekeying
  # Unfortunately this makes my configuration compatible with flakes only
  age.rekey = {
    # Make sure to set up age.rekey.hostPubkey! on your host's configuration.nix!

    masterIdentities = [ "${inputs.self}/secrets/yubikey-843-personal.pub" ];

    # NB this is all actually evaluated by `agenix rekey` and makes changes to the repo
    storageMode = "local";
    localStorageDir = "${inputs.self}/secrets/rekeyed";
  };

  age.rekey.hostPubkey = firstMatchPathString;
  ## Secrets declarations

  age.secrets.ghtoken = {
    rekeyFile = ./ghtoken.age;
    mode = "700";
    owner = "yanni";
  };

  age.secrets.awstoken = {
    rekeyFile = ./awstoken.age;
    mode = "700";
    owner = "yanni";
  };

  age.secrets.openaitoken = {
    rekeyFile = ./openaitoken.age;
    mode = "700";
    owner = "yanni";
  };

  age.secrets.cloudflaretoken = {
    rekeyFile = ./cloudflaretoken.age;
    mode = "400";
    owner = "yanni";
  };

  age.secrets.anthropictoken = {
    rekeyFile = ./anthropictoken.age;
    mode = "400";
    owner = "yanni";
  };

  age.secrets.openrouter = {
    rekeyFile = ./openrouter.age;
    mode = "400";
    owner = "yanni";
  };

  # Here we deploy our secrets for our system using environment variables
  # Eventually I'll find something better for this

  # It looks dangerous but it isn't. I don't believe in quantum computing (yet).

  environment.sessionVariables = {

    # GITHUB
    GITHUB_TOKEN = "$(cat ${config.age.secrets.ghtoken.path})";

    # AWS
    AWS_ACCESS_KEY_ID = "AKIAXCKALGY4GSFAHS46";
    AWS_SECRET_ACCESS_KEY = "$(cat ${config.age.secrets.awstoken.path})";
    AWS_DEFAULT_REGION = "eu-west-1";

    #OPENAI
    OPENAI_API_KEY = "$(cat ${config.age.secrets.openaitoken.path})";

    #CLOUDFLARE
    CLOUDFLARE_API_TOKEN = "$(cat ${config.age.secrets.cloudflaretoken.path})";

    #ANTHROPIC
    ANTHROPIC_API_KEY = "$(cat ${config.age.secrets.anthropictoken.path})";

    #OPENROUTER
    OPENROUTER_API_KEY = "$(cat ${config.age.secrets.openrouter.path})";
  };
}

