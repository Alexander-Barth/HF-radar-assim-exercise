
Julia and IJulia typically installs its own Conda installation (for Jupyter) however this fails if the user has a [special character in its user name](https://github.com/conda/conda/issues/10239) on Windows. As most OGCB students have already Anaconda installed we will use the following steps are described here.

# Anaconda

Install anaconda from https://www.anaconda.com/download. Select the default option during the installation. You can skip this step if you have it already installed.

![anaconda_install1](https://github.com/Alexander-Barth/HF-radar-assim-exercise/assets/9881475/94950f07-6bec-444a-afc7-271c38cdd96d)

![anaconda_install2](https://github.com/Alexander-Barth/HF-radar-assim-exercise/assets/9881475/c31aa234-49be-4c34-8f0e-08638e23b6bb)

> [!CAUTION]
> Do NOT add Anaconda3 to your PATH environement variable. You will likely run into conflicts with other programs with you do so.
 
* When the installation is finished, run the "Anaconda Prompt".

![image](https://github.com/Alexander-Barth/HF-radar-assim-exercise/assets/9881475/3c7ae522-9f43-4bc9-88d7-ac4231b267d8)

* Check that the terminal prompt starts with `(base)`, and run `jupyter --version` to check that jupyter is installed.
  
![anaconda_install4](https://github.com/Alexander-Barth/HF-radar-assim-exercise/assets/9881475/6c1b6b15-a489-4baf-b899-64010abe9841)

* Find out where jupyter is installed. On windows use the command `where jupyter` and on Linux/Mac OS X use `which jupyter`.

 ![anaconda_install5](https://github.com/Alexander-Barth/HF-radar-assim-exercise/assets/9881475/674260f4-27c4-44d9-9c83-e7a3443b7720)

* Copy the file path of jupyter, as we will need it later.

![image](https://github.com/Alexander-Barth/HF-radar-assim-exercise/assets/9881475/011b518c-8f1d-4cf2-8648-797bb92a4437)

* Install julia from https://julialang.org/downloads/ (select the 64-bit version of Julia).

* Start a julia terminal and run the following commands:

```julia
ENV["JUPYTER"] = raw"C:\Users\abarth\anaconda3\Scripts\jupyter.exe"
using Pkg
Pkg.add("IJulia")


using IJulia
jupyterlab()
```

where you replace `"C:\Users\abarth\anaconda3\Scripts\jupyter.exe"` by *your* file path of the jupyter program (see previous steps).


 
