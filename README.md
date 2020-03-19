[![Project Status: Active – The project has reached a stable, usable state and is being actively developed.](http://www.repostatus.org/badges/latest/active.svg)](http://www.repostatus.org/#active)
[![Build Status](https://img.shields.io/travis/PetrKryslUCSD/MeshCore.jl/master.svg?label=Linux+MacOSX+Windows)](https://travis-ci.org/PetrKryslUCSD/MeshCore.jl)
[![Coverage Status](https://coveralls.io/repos/github/PetrKryslUCSD/MeshCore.jl/badge.svg?branch=master)](https://coveralls.io/github/PetrKryslUCSD/MeshCore.jl?branch=master)
[![Latest documentation](https://img.shields.io/badge/docs-latest-blue.svg)](https://petrkryslucsd.github.io/MeshCore.jl/dev)

# MeshCore.jl

Small package for operating on the topology of meshes for the Finite Element Methods (FEM). All essential topological incidence relations are provided: see the guide. The library provides efficient storage in static arrays for speed of access.

## News

- 03/18/2020: The library was completely redesigned around incidence relations. Much simpler than before!
- 03/16/2020: Note: The coverage appears low, but that seems to be a bug in the computation of the coverage
  when applied to one-line functions defined for multiple types.
