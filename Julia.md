# Quick introduction to Julia

Assuming that you have already some programming experience, here is a quick introduction to Julia.

## Variables
Julia variables can be scalars

```julia
my_scalar = 3.14
```

or arrays, e.g.

```julia
my_array = [1 2 3; 4 5 6]  # a matrix with 2 rows and 3 columns
```

Indexing behaves like matlab except that square brackets are used. Indices start with 1. Thus the first row and second colmn of the previous array would be `my_array[1,2]` (here the value 2).

To simply show the content of a variable use `@show my_scalar`.

## Operators

Julia has all the usual operators:
* arithmetic: `+`, `-`, `*`, `/` as most programming languages have
* comparision: `==` (equal), `!=` (different), `<` (lesser than), `>` (greater than), `<=` (lesser or equal than), `>=` (greater or equal than)
* boolean: `!` (not), `&&` (and), `||` (or)

Element-wise operations: systematically with a dot (except for + and -)
* arithmetic: `.*`, `./` (similar to matlab)
* comparision: `.==` (equal), `.!=` (different), `.<` (lesser than), `.>` (greater than), `.<=` (lesser or equal than), `.>=` (greater or equal than)
* boolean: `.!` (not), `.&` (and), `.|` (or)

For example:

```julia
a = [1,2,3]
b = [0,2,3]
a == b   # returns false
a .== b  # returns [false,true,true]
```

More information is available at https://docs.julialang.org/en/stable/manual/mathematical-operations/

## Control flow

* conditions
```julia
if x < y
  # x is less than y
else
  # otherwise
end
```
* loops
```julia
for n = 1:10
    # show the values from 1 to 10
    @show n
end
```

## Functions

Function compute a value (or several values) based on their input arguments:

```julia
function myfun(input1,input2,input3)
  output1 = ...
  output2 = ...
  return output1,output2
end
```

This function can be called as:

```julia
out1,out2 = myfun(1,2,3)
```

If a function is defined for scalars, it can be applied element-wise on an array by adding a dot the the function name, e.g.:

```julia
sqroots = sqrt.([1,2,3,4,5])
```

## Modules

Functions can be grouped into a module. To access the functions inside a module one need to load the module with `using`. The following loads the module `PyPlot`:

```julia
using PyPlot
```

## Scripts

Julia code are save in files with the extensions `.jl`. To exercute all commands in a julia file use `include("file.jl")` where `file.jl` can be a relative file name (relative to the current directory) or an absolute file path.


## Plotting

* Plotting time series: `plot`
* Plotting map of scalars: `pcolor` or `contourf`
* Plotting map of vector: `quiver`

## Documentation

* Find documentation from the julia command line using "?", e.g. type "?mean" to find out about the `mean` function.
* Use the `apropos` command, e.g. `apropos("Pearson")`.
* Full document of the Julia language is available at https://docs.julialang.org/en/stable/





<!--  LocalWords:  julia matlab myfun sqroots sqrt PyPlot
 -->
