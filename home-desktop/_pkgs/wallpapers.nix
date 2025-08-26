{ lib, pkgs }:
{
  metallica = {
    default = pkgs.fetchurl {
      url = "https://pb.ocfox.me/metallica.jpg";
      name = "metallica.jpg";
      hash = "sha256-W2zCjwU6DQR4rYKVwN1OKV54VUW58+awwemz4JAlCgQ=";
    };
    and-justice-for-all = pkgs.fetchurl {
      url = "https://pb.ocfox.me/and-justice-for-all.jpg";
      name = "and-justice-for-all.jpg";
      hash = "sha256-lkst81OfaYHnvfY/KRRZpqC0mjTGRdk0WBdkeDqI9JM=";
    };
  };
}
