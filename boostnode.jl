include("node.jl")

abstract type BoostNode <: Node end

"""
    evaluate(BoostRegNode, data)

Evaluate node.
"""
function evaluate(n::BoostNode, tree)
    return similarity(n, tree.G, tree.H)
end

function derivativevals(n::BoostNode, G, H)
    sz = length(n.datainds)
    Hs, Gs = 0, 0
    for j = 1:sz
        i = n.datainds[j]
        Gs += G[i]
        Hs += H[i]
    end
    return Gs, Hs
end
"""
    similarity(BoostNode, H, G)
"""
function similarity(n::BoostNode, G, H)
    Gs, Hs = derivativevals(n, G, H)
    return - 0.5 * Gs ^ 2 / (Hs + n.λ)
end

function calcprediction(n, tree)
    G, H = tree.G, tree.H
    Gs, Hs = derivativevals(n, G, H)
    return - Gs / (Hs + n.λ)
end
