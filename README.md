[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Codecov](https://codecov.io/gh/PetrKryslUCSD/MeshCore.jl/branch/master/graph/badge.svg)](https://codecov.io/gh/PetrKryslUCSD/MeshCore.jl)
[![Build status](https://github.com/PetrKryslUCSD/MeshCore.jl/workflows/CI/badge.svg)](https://github.com/PetrKryslUCSD/MeshCore.jl/actions)
[![Latest documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://petrkryslucsd.github.io/MeshCore.jl/dev)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.4027970.svg)](https://doi.org/10.5281/zenodo.4027970)

# MeshCore.jl

Small package for operating on the topology of meshes for the Finite Element
Methods (FEM). All essential topological incidence relations are provided: see
the guide in [documentation](https://petrkryslucsd.github.io/MeshCore.jl/dev).
The library provides efficient storage in static arrays for speed of access.

## Usage

This release is for Julia 1.8.

The package is registered: doing
```
]add MeshCore
using MeshCore
```
is enough. 

The user can either use/import individual functions from `MeshCore` like so:
```
using MeshCore: nrelations, nentities
```

or all exported symbols maybe made available in the user's context as
```
using MeshCore.Exports
```
Using the library by itself is certainly possible.
If you wish for a more comprehensive mesh-handling package, check out
[MeshSteward.jl](https://github.com/PetrKryslUCSD/MeshSteward.jl).

## Learning

Please refer to the tutorials in the package
[`MeshTutor.jl`](https://github.com/PetrKryslUCSD/MeshTutor.jl).

## Publications

A paper was accepted to the Journal Advances in Engineering Software in April 2021. The paper is available in final draft form in the `docs/src/concepts` folder.

The package
[PaperMeshTopo](https://github.com/PetrKryslUCSD/PaperMeshTopo.jl.git) gives an
example of the construction of a complex (full one-level) topological
representation of a tetrahedral mesh.

## News

- 12/09/2022: Version 1.3 released for Julia 1.8.
- 04/23/2021: Added the final draft of the accepted paper.
- 03/11/2021: Released for Julia 1.6.
- 12/15/2020: Tested with Julia 1.6.
- 12/15/2020: Added "function" attributes.
- 07/10/2020: Naming of the symbols has been updated to reduce conflicts.
- 07/06/2020: Exports have been added to facilitate use of the library.
- 05/14/2020: Changed storage of attribute data.
- 05/07/2020: Simplified management of attributes.
- 04/17/2020: The paper describing the library has been submitted.
- 03/21/2020: The implementation of the topology operations has been improved in
  speed and simplicity.
- 03/18/2020: The library was completely redesigned around incidence relations.
  Much simpler than before!
- 03/16/2020: Note: The coverage appears low, but that seems to be a bug in the
  computation of the coverage when applied to one-line functions defined for
  multiple types.
