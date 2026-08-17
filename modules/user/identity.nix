{ delib, ... }:
delib.module {
  name = "user.constants";

  options.user.constants = with delib; {
    username = readOnly (strOption "krozzzis");
    userfullname = readOnly (strOption "Nikita Shumov");
    useremail = readOnly (strOption "schumov.nn@gmail.com");
  };
}
