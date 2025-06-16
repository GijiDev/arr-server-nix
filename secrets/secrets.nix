# Should not be imported!
# Used by the CLI
let
  hashida-itaru = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFeVMoX4taNDWyeaPl/fmkulIS0oysI64or7oixO3BJV";
in
{
  "discord-music-bot.age".publicKeys = [ hashida-itaru ];
}
