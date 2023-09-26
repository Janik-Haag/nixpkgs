{ lib
, php
, fetchFromGitHub
}:
php.buildComposerProject (finalAttrs: {
  pname = "php-app";
  version = "4.0.0";

  src = fetchFromGitHub {
    owner = "tchapi";
    repo = "davis";
    rev = "v${finalAttrs.version}";
    hash = "sha256-VLlCsMFLlX2fQKQ+xIusRysN93/ji7udAfMgrsggcbE=";
  };

  vendorHash = "sha256-6F4LtJSBOaCCrGmckSGvAlP15aPxBM2n/RkH55sJIDc=";

  meta = with lib; {
    description = "A simple, fully translatable admin interface for sabre/dav based on Symfony 5 and Bootstrap, initially inspired by Baïkal";
    homepage = "https://github.com/tchapi/davis";
    license = licenses.mit;
    maintainers = with maintainers; [ janik ];
  };
})
