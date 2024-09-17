{ inputs, pkgs, lib, config, ... }:

{
  age.secrets.secret1 = {
    file = ./secret1.age;
    mode = "700";
    owner = "yanni";
  };

  age.secrets.ghtoken = {
    file = ./ghtoken.age;
    mode = "700";
    owner = "yanni";
  };

  age.secrets.awstoken = {
    file = ./awstoken.age;
    mode = "700";
    owner = "yanni";
  };

  age.secrets.openaitoken = {
    file = ./openaitoken.age;
    mode = "700";
    owner = "yanni";
  };

  age.secrets.hftoken = {
    file = ./hfacetoken.age;
    mode = "700";
    owner = "yanni";
  };

  age.secrets.gcptoken = {
    file = ./gcptoken.age;
    mode = "700";
    owner = "yanni";
  };

  age.secrets.cloudflaretoken = {
    file = ./cloudflaretoken.age;
    mode = "400";
    owner = "yanni";
  };

  age.secrets.anthropictoken = {
    file = ./anthropictoken.age;
    mode = "400";
    owner = "yanni";
  };

  age.secrets.openrouter = {
    file = ./openrouter.age;
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

    #HUGGINGFACE
    HF_TOKEN_PATH = config.age.secrets.hftoken.path;

    # GCP
    GOOGLE_APPLICATION_CREDENTIALS = config.age.secrets.gcptoken.path;

    #CLOUDFLARE
    CLOUDFLARE_API_TOKEN = "$(cat ${config.age.secrets.cloudflaretoken.path})";

    #ANTHROPIC
    ANTHROPIC_API_KEY = "$(cat ${config.age.secrets.anthropictoken.path})";

    #OPENROUTER
    OPENROUTER_API_KEY = "$(cat ${config.age.secrets.openrouter.path})";
  };
}

