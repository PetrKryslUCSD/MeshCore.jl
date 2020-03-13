# Issues

- Test skeleton and boundary.

- Documenter used to generate documentation:
pkg"add DocumenterTools"  
using DocumenterTools
DocumenterTools.genkeys(user="PetrKryslUCSD", repo="git@github.com:PetrKryslUCSD/MeshCore.jl.git")

and follow the instructions to install the keys.

- Vertices is not a topological data structure: pure geometry. Therefore it might make sense to separate topology from geometry in the source files.
