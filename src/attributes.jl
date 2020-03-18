abstract type AbsAttrib
end

struct Attrib{F}<:AbsAttrib
    val::F
end
