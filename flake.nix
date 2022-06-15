{
  inputs.nixpkgs.url = "github:NickCao/nixpkgs/riscv";

  nixConfig.extra-substituters = "https://cache.nichi.co";
  nixConfig.extra-trusted-public-keys = "hydra.nichi.co-0:P3nkYHhmcLR3eNJgOAnHDjmQLkfqheGyhZ6GLrUVHwk=";

  outputs = { self, nixpkgs }: {
    legacyPackages.x86_64-linux =
      import nixpkgs {
        system = "x86_64-linux";
        crossSystem.config = "riscv64-unknown-linux-gnu";
      };

    nixosConfigurations.quicksand =
      nixpkgs.lib.nixosSystem {
        system = "riscv64-linux";
        modules = [
          ./configuration.nix
          { nixpkgs.pkgs = self.legacyPackages.x86_64-linux; }
        ];
      };

    packages.x86_64-linux.default =
      self.nixosConfigurations.quicksand.config.system.build.minimal-vm;
  };
}
