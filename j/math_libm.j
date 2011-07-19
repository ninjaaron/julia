libfdm = dlopen("libfdm")
libm = dlopen("libm")

macro libmfunc_1arg_float(f)
    quote
        ($f)(x::Float64) = ccall(dlsym(libm,$string(f)), Float64, (Float64,), x)
        ($f)(x::Float32) = ccall(dlsym(libm,$strcat(string(f),"f")), Float32, (Float32,), x)
        ($f)(x::Real) = ($f)(float(x))
        @vectorize_1arg Real $f
    end
end

macro libfdmfunc_1arg_float(f)
    quote
        ($f)(x::Float64) = ccall(dlsym(libfdm,$string(f)), Float64, (Float64,), x)
        ($f)(x::Float32) = ccall(dlsym(libfdm,$strcat(string(f),"f")), Float32, (Float32,), x)
        ($f)(x::Real) = ($f)(float(x))
        @vectorize_1arg Real $f
    end
end

macro libmfunc_1arg_int(f)
    quote
        ($f)(x::Float64) = ccall(dlsym(libm,$string(f)), Int32, (Float64,), x)
        ($f)(x::Float32) = ccall(dlsym(libm,$strcat(string(f),"f")), Int32, (Float32,), x)
        @vectorize_1arg Real $f
    end
end

macro libfdmfunc_2arg(f)
    quote
        ($f)(x::Float64, y::Float64) = ccall(dlsym(libfdm,$string(f)), Float64, (Float64, Float64,), x, y)
        ($f)(x::Float32, y::Float32) = ccall(dlsym(libfdm,$strcat(string(f),"f")), Float32, (Float32, Float32), x, y)
        ($f)(x::Real, y::Real) = ($f)(float(x),float(y))
        @vectorize_2arg Real $f
    end
end

@libfdmfunc_1arg_float cbrt
@libfdmfunc_1arg_float sin
@libfdmfunc_1arg_float cos
@libfdmfunc_1arg_float tan
@libfdmfunc_1arg_float sinh
@libfdmfunc_1arg_float cosh
@libfdmfunc_1arg_float tanh
@libfdmfunc_1arg_float asin
@libfdmfunc_1arg_float acos
@libfdmfunc_1arg_float atan
@libfdmfunc_1arg_float log
@libfdmfunc_1arg_float log2
@libfdmfunc_1arg_float log10
@libfdmfunc_1arg_float log1p
@libfdmfunc_1arg_float logb
@libfdmfunc_1arg_float exp
@libfdmfunc_1arg_float expm1
@libfdmfunc_1arg_float erf
@libfdmfunc_1arg_float erfc
@libfdmfunc_1arg_float ceil
@libfdmfunc_1arg_float floor
@libfdmfunc_1arg_float rint
@libfdmfunc_1arg_float lgamma

@libmfunc_1arg_float sqrt
@libmfunc_1arg_float exp2
@libmfunc_1arg_float nearbyint
@libmfunc_1arg_float trunc
@libmfunc_1arg_float round

@libmfunc_1arg_int lrint
@libmfunc_1arg_int lround
@libmfunc_1arg_int ilogb

@libfdmfunc_2arg atan2
@libfdmfunc_2arg copysign
@libfdmfunc_2arg hypot

ipart(x) = trunc(x)
fpart(x) = x - trunc(x)
@vectorize_1arg Real ipart
@vectorize_1arg Real fpart

abs(x::Float64) = ccall(dlsym(libfdm, :fabs),  Float64, (Float64,), x)
abs(x::Float32) = ccall(dlsym(libfdm, :fabsf), Float32, (Float32,), x)
@vectorize_1arg Real abs

gamma(x::Float64) = ccall(dlsym(libfdm, :tgamma),  Float64, (Float64,), x)
gamma(x::Float32) = float32(gamma(float64(x)))
gamma(x::Real) = gamma(float(x))
@vectorize_1arg Real gamma

max(x::Float64, y::Float64) = ccall(dlsym(libm, :fmax),  Float64, (Float64,Float64), x, y)
max(x::Float32, y::Float32) = ccall(dlsym(libm, :fmaxf), Float32, (Float32,Float32), x, y)
@vectorize_2arg Real max

min(x::Float64, y::Float64) = ccall(dlsym(libm, :fmin),  Float64, (Float64,Float64), x, y)
min(x::Float32, y::Float32) = ccall(dlsym(libm, :fminf), Float32, (Float32,Float32), x, y)
@vectorize_2arg Real min

ldexp(x::Float64,e::Int32) = ccall(dlsym(libfdm, :ldexp),  Float64, (Float64,Int32), x, e)
ldexp(x::Float32,e::Int32) = ccall(dlsym(libfdm, :ldexpf), Float32, (Float32,Int32), x, e)
@vectorize_2arg Real ldexp

function frexp(x::Float64)
    exp = zeros(Int32,1)
    s = ccall(dlsym(libfdm,:frexp), Float64, (Float64, Ptr{Int32}), x, exp)
    (s, exp[1])
end
function frexp(x::Float32)
    exp = zeros(Int32,1)
    s = ccall(dlsym(libfdm,:frexpf), Float32, (Float32, Ptr{Int32}), x, exp)
    (s, exp[1])
end
@vectorize_1arg Real frexp

^(x::Float64, y::Float64) = ccall(dlsym(libfdm, :pow),  Float64, (Float64,Float64), x, y)
^(x::Float32, y::Float32) = ccall(dlsym(libfdm, :powf), Float32, (Float32,Float32), x, y)
