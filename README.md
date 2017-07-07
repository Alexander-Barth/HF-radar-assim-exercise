# HF-radar-assim-caen


## Setting-up your work environment

Required software:

* Julia available from https://julialang.org/downloads/. The exercise is tested with the version 0.6 of Julia.
* The version control tool git. Under Debian/Ubuntu this can be done by the following programs

```bash
sudo apt-get install git
```

* Some Julia packages, which can be installed with these commands once you started Julia:

```julia
Pkg.clone("https://github.com/gher-ulg/divand.jl")
Pkg.clone("https://github.com/Alexander-Barth/GeoMapping.jl")
Pkg.clone("https://github.com/Alexander-Barth/NCDatasets.jl")
Pkg.add("NetCDF")
Pkg.add("PyPlot")
Pkg.add("MAT")
Pkg.add("IJulia")
Pkg.add("Interpolations")
```

* Editor with julia support. For example, install emacs and the file `julia-mode.el` as follows:

```bash
mkdir ~/site-lisp
cd ~/site-lisp
wget https://raw.githubusercontent.com/JuliaLang/julia-emacs/master/julia-mode.el
cat >> ~/.emacs <<EOF
;; Add a local lisp folder to your load-path
(setq load-path (append load-path (list "~/site-lisp")))
(require 'julia-mode)
(setq auto-mode-alist (append '(("\\.jl$" . julia-mode)) auto-mode-alist))

EOF
```

### Optionally

* Install a desktop launcher and icon for julia

```bash
wget -O /tmp/julia.desktop https://raw.githubusercontent.com/JuliaLang/julia/e90f29db30f81f340d4f36669b27ac5a281e2a7f/contrib/julia.desktop
desktop-file-install --dir=$HOME/.local/share/applications /tmp/julia.desktop
mkdir -p ~/.local/share/icons/hicolor/scalable/apps/
cd ~/.local/share/icons/hicolor/scalable/apps/
wget https://raw.githubusercontent.com/JuliaLang/julia/30bf89f3d8e564b588b8e48993e92a551b384f2c/contrib/julia.svg
cd ~
```


## Exercise

* Get the code for the exercise:

```bash
git clone https://github.com/Alexander-Barth/HF-radar-assim-caen.git
```

This create the folder `HF-radar-assim-caen`

* The data for the exercise is in the folder `/home/invites/barth/HF-radar-assim-caen/data` on the host n304l-401001 and should be copied inside of the directory `HF-radar-assim-caen`.

<!--  LocalWords:  assim caen sudo julia NetCDF PyPlot IJulia el cd
 -->
<!--  LocalWords:  mkdir wget emacs EOF setq alist jl dir
 -->
