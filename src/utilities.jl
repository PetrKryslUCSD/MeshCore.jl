# An assert might be disabled at various optimization levels. This macro will not be.
macro _check(ex, msgs...)
    msg = isempty(msgs) ? ex : msgs[1]
    if isa(msg, AbstractString)
        msg = msg # pass-through
    elseif !isempty(msgs) && (isa(msg, Expr) || isa(msg, Symbol))
        # message is an expression needing evaluating
        msg = :(Main.Base.string($(esc(msg))))
    elseif isdefined(Main, :Base) && isdefined(Main.Base, :string) && applicable(Main.Base.string, msg)
        msg = Main.Base.string(msg)
    else
        # string() might not be defined during bootstrap
        msg = quote
            msg = $(Expr(:quote,msg))
            isdefined(Main, :Base) ? Main.Base.string(msg) :
                (Core.println(msg); "Error during bootstrap. See stdout.")
        end
    end
    return :($(esc(ex)) ? $(nothing) : throw(AssertionError($msg)))
end


function _print(a)
    for i in 1:size(a, 1)
        println(a[i, :])
    end
end
