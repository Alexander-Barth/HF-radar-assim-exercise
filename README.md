[![Build Status](https://github.com/Alexander-Barth/HF-radar-assim-exercise/workflows/CI/badge.svg)](https://github.com/Alexander-Barth/HF-radar-assim-exercise/actions)


# HF-radar-assim-exercise

## Setting-up your work environment

Required software:

* You need to install Julia available from https://julialang.org/downloads/. The exercise is tested with the versions 1.6 and 1.7 of Julia (on Linux and Windows 10) and Mac OS should work too. Windows 7
[is no longer support by Mircosoft](https://support.microsoft.com/en-us/help/4057281/windows-7-support-ended-on-january-14-2020) and is also no longer supported by Julia. 

* In addition, you need to install some Julia packages. Once you start julia, you need to type (or better copy-paste) these commands:

```julia
using Pkg
Pkg.add(PackageSpec(url="https://github.com/Alexander-Barth/GeoMapping.jl", rev="master"))
Pkg.add("NCDatasets")
Pkg.add("PyPlot")
Pkg.add("Interpolations")
Pkg.add("DataAssim")
Pkg.add("IJulia")
using PyPlot
using IJulia
notebook()
```

For Windows, please have a look here on how to use copy-paste in the [Windows terminal](https://bonkersabouttech.com/how-to-copy-and-paste-in-cmd/).
These commands will also install `matplotlib` and `jupyter`.
Confirm the installation of `jupyter` with conda. The installation can take a while and should be done before the lecture.
On some older laptops, some steps can take quite a long time. It is not adviced to interrupt the installation process.

If for some reason, the installation fails and the problem cannot be resolved, one can try to use Binder (see below) as an alternative.
More information about the installation is available [here](https://github.com/gher-ulg/Documentation/wiki/Installing-Julia).

## Using Binder

Click on the "launch binder" icon to start the notebooks. Setting-up the working environement on the binder service can take a couple of minutes. Binder will automatically shut down user sessions that have more than 10 minutes of inactivity. This will lead to the error message "Not Connected". If you use binder, you need to avoid any inactivity during a binder session.


[![Binder](https://mybinder.org/badge_logo.svg)](https://mybinder.org/v2/gh/Alexander-Barth/HF-radar-assim-exercise/nb?filepath=assim_exercise.ipynb)

## Exercise

* Get the code for the exercise by extract the [zip file](https://github.com/Alexander-Barth/HF-radar-assim-exercise/archive/master.zip) or by using git:

```bash
git clone https://github.com/Alexander-Barth/HF-radar-assim-exercise.git
```

This create the folder `HF-radar-assim-exercise`

* [Quick introduction to Julia](Julia.md)

* [Exercise questions](https://alexander-barth.github.io/HF-radar-assim-exercise/slides/)




<!--  LocalWords:  assim caen sudo julia NetCDF PyPlot IJulia el cd
 -->
<!--  LocalWords:  mkdir wget emacs EOF setq alist jl dir
 -->
