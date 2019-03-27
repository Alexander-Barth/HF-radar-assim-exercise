# HF-radar-assim-exercise


## Setting-up your work environment

Required software:

* Julia available from https://julialang.org/downloads/. The exercise is tested with the version 1.0 of Julia (on Linux).

* Some Julia packages, which can be installed with these commands once you started Julia:

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/Alexander-Barth/GeoMapping.jl", rev="master"))
Pkg.add("NCDatasets")
Pkg.add("PyPlot")
Pkg.add("Interpolations")
Pkg.add("DataAssim")
Pkg.add("IJulia")
```

* Editor with julia support is recommended, such as:
   * Juno (http://junolab.org/).
   * Notepadd++ (https://github.com/JuliaEditorSupport/julia-NotepadPlusPlus)
   * Emacs (https://github.com/JuliaEditorSupport/julia-emacs)
   * vim (https://github.com/JuliaEditorSupport/julia-vim).

For emacs on Linux, install the file `julia-mode.el` as follows:

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
git clone https://github.com/Alexander-Barth/HF-radar-assim-exercise.git
```

This create the folder `HF-radar-assim-exercise`

* The data for the exercise is in the NetCDF files in the folder https://dox.ulg.ac.be/index.php/s/iZXK0toRe4wvyKs. Download all the NetCDF files place them in the sub-directory `HF-radar-assim-exercise/data`.


* [Quick introduction to Julia](Julia.md)

* [Exercise questions](https://alexander-barth.github.io/HF-radar-assim-exercise/slides/)


<!--  LocalWords:  assim caen sudo julia NetCDF PyPlot IJulia el cd
 -->
<!--  LocalWords:  mkdir wget emacs EOF setq alist jl dir
 -->
