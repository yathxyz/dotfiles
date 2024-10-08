{ inputs, pkgs, lib, config, ... }:

{
  age.rekey = {

    masterIdentities = [
      "${inputs.self}/secrets/yubikey-843-personal.pub"
      "${inputs.self}/secrets/yubikey-837-personal.pub"
      "${inputs.self}/secrets/yubikey-408-personal.pub"
    ];

    storageMode = "local";
    localStorageDir = "${inputs.self}/secrets/rekeyed/${config.networking.hostName}";

    # NB public keys that are part of the rekeying process are actually stored in the configuration.nix
    # like so: `age.rekey.pubHostkey = "ssh-ed25519 ...";`
    # for each host. agenix rekey looks for this value on every host.

    # It doesn't exactly remove the labour associated with secrets.nix.
    # You are required to be explicit about the ssh public key for every host.
    # Regardless, the added benefit of using a hardware token to rekey cannot be stressed enough.
  };

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

  age.secrets.kagi = {
    rekeyFile = ./kagi.age;
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

    #KAGI
    KAGI_API_KEY = "$(cat ${config.age.secrets.kagi.path})";
  };
}

