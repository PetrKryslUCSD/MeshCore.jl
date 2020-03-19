struct Mesh
    shapecolls::Dict{Symbol, ShapeColl}
    increls::Dict{Symbol, IncRel}
end

function Mesh()
    Mesh(Dict{Symbol, ShapeColl}(), Dict{Symbol, IncRel}())
end

shapecoll(m::Mesh, s::Symbol) = m.shapecolls[s]
increl(m::Mesh, s::Symbol) = m.increls[s]

insert!(m::Mesh, s::Symbol, shapes::ShapeColl) = (m.shapecolls[s] = shapes)
insert!(m::Mesh, s::Symbol, increl::IncRel) = (m.increls[s] = increl)
