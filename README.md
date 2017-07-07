# HF-radar-assim-caen


Required software:

* Julia available from https://julialang.org/downloads/
* Some julia packages, which can be installed with these commands once you started Julia:

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
;; Add local lisp folder to load-path
(setq load-path (append load-path (list "~/site-lisp")))
(require 'julia-mode)
(setq auto-mode-alist (append '(("\\.jl$" . julia-mode)) auto-mode-alist))

EOF
```


