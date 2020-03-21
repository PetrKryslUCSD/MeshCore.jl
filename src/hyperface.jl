import Base.BitSet

mutable struct HyperFace{C}
    bc::BitSet # sorted connectivity of the hyperface
    oc::C # original connectivity
    nref::Int64 # number of references to the face
    store::Int64 # store this client number
end

const EMPTYHYPERFACE = HyperFace(BitSet([0]), [0], 0, 0)

hyperfacecontainer() = Dict{Int64, Array{HyperFace}}();

function addhyperface!(container, hyperface, store = 0)
    anchor = min(hyperface...)
    bc = BitSet(hyperface);
    C = get(container, anchor, HyperFace[]);
    fnd = false;
    for k in 1:length(C)
        if C[k].bc == bc
            C[k].nref += 1 # increment number of references
            fnd = true; break;
        end
    end
    if fnd != true
        push!(C, HyperFace(bc, deepcopy(hyperface), 1, store));
    end
    container[anchor] = C; # set the contents at anchor
    return container
end

function gethyperface(container, hyperface)
    anchor = min(hyperface...)
    bc = BitSet(hyperface);
    C = get(container, anchor, HyperFace[]);
    for k in 1:length(C)
        if C[k].bc == bc
            return C[k]
        end
    end
    return EMPTYHYPERFACE
end
