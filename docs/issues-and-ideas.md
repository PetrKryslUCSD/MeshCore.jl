# Issues

- Test skeleton and boundary.

- Documenter used to generate documentation:
using Pkg
pkg"add DocumenterTools"  
using DocumenterTools
DocumenterTools.genkeys(user="PetrKryslUCSD", repo="git@github.com:PetrKryslUCSD/MeshCore.jl.git")

and follow the instructions to install the keys.

- Vertices is not a topological data structure: pure geometry. Therefore
it might make sense to separate topology from geometry in the source files.

- Computing the incidence relations may require derived skeleton meshes.
Perhaps these should be computed and cached my `skeleton`?

- The vertices should also be stored as a shape collection. Of manifold dimension zero.

- Organization of meshes.

Mesh has a number of shape collections and a number of incidence relations.
Geometry is an attribute of the shape collection of vertices.

- Boundary faces: Should we use the skeleton and simply mark the boundary faces (creating an attribute) rather than extracting only the faces that are on the boundary?

