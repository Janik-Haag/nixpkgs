{ lib
, fetchFromGitHub
, buildGoModule
}:

buildGoModule rec {
  pname = "upf";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "omec-project";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2qM/Re0d82RGfV0QFbfErWUM1eHG7Xbq3Z+mxoBHnyo=";
  };

  vendorSha256 = "sha256-UatONpP9eKXkPRM2l2Q8oRs68JxtlBbD1iDsh+MmhNA=";

  doCheck = false;

  meta = with lib; {
    homepage = "https://opennetworking.org/omec/";
    description = "A 4G/5G Mobile Core User Plane";
    license = licenses.asl20;
    maintainers = with maintainers; [ janik ];
  };
}
