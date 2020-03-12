import Base.BitSet

mutable struct HyperFace{C}
    bc::BitSet # sorted connectivity of the hyperface
    oc::C # original connectivity
    nref::Int64 # number of references to the face
end

const EMPTYHYPERFACE = HyperFace(BitSet([0]), [0], 0)

hyperfacecontainer() = Dict{Int64, Array{HyperFace}}();

function addhyperface!(container, hyperface)
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
        push!(C, HyperFace(bc, hyperface, 1));
    end
    container[anchor] = C; # set the contents at anchor
    return container
end

function havehyperface!(container, hyperface)
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
#
# """
#     linearspace(start::T, stop::T, N::Int)  where {T<:Number}
#
# Generate linear space.
#
# Generate a linear sequence of `N` numbers between  `start` and `stop` (i. e.
# sequence  of number with uniform intervals inbetween).
#
# # Example
# ```
# julia> linearspace(2.0, 3.0, 5)
# 2.0:0.25:3.0
# ```
# """
# function linearspace(start::T, stop::T, N::Int)  where {T<:Number}
#     return range(start, stop = stop, length = N)
# end
#
# """
#     gradedspace(start::T, stop::T, N::Int)  where {T<:Number}
#
# Generate quadratic space.
#
# Generate a quadratic sequence of `N` numbers between `start` and `stop`. This
# sequence corresponds to separation of adjacent numbers that increases linearly
# from start to finish.
#
# # Example
# ```
# julia> gradedspace(2.0, 3.0, 5)
# 5-element Array{Float64,1}:
#  2.0
#  2.0625
#  2.25
#  2.5625
#  3.0
# ```
# """
# function gradedspace(start::T, stop::T, N::Int, strength=2)  where {T<:Number}
#     x = range(0.0, stop = 1.0, length = N);
#     x = x.^strength
#     # for i = 1:strength
#     #     x = cumsum(x);
#     # end
#     x = x/maximum(x);
#     out = start .* (1.0 .- x) .+ stop .* x;
# end
