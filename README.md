# FIT.jl

Julia wrapper around Garmin SDK to parse .fit files. See https://developer.garmin.com/fit/download/ for details.

Usage:

```julia

using FIT

data = fit2table("example.fit")

```

fit2table returns flex table with the data contained in the .fit file. Missing values are indicate with julia missing type. Timestamp is seconds since UTC 00:00 Dec 31 1989