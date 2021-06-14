module FIT

using TypedTables
using CSV

export FitCSVTool, fit2table

struct FitCSVTool
    command::String
end

function FitCSVTool()
    return FitCSVTool(joinpath(dirname(@__DIR__), "FitSDK", "java", "FitCSVTool.jar"))
end

function (d::FitCSVTool)(filename::AbstractString; exec::AbstractString="java -jar", options::AbstractString="--defn none --data record")::CSV.File

    if !isfile(filename)
        @error "File $(filename) not found!"
        return nothing
    end

    temp_dir = mktempdir(dirname(@__DIR__))
    tmp_path = joinpath(temp_dir, basename(filename))
    cp(filename, tmp_path; force=true)

    arguments = [split(exec)...]
    arguments = vcat(arguments, d.command)
    arguments = vcat(arguments, [split(options)...])
    arguments = vcat(arguments, tmp_path)
    command = Cmd(String.(arguments))

    run(command)
    
    csvfilename = splitext(tmp_path)[1] * "_data.csv"
    csv_object = CSV.File(csvfilename)

    return csv_object
end

function fit2table(filename::AbstractString)::FlexTable

    fit2csv = FitCSVTool()
    
    csv_object = fit2csv(filename)

    types = csv_object.types
    names = csv_object.names

    data = FlexTable(id = collect(1:length(csv_object)))

    i = 1
    for name in names
        value = getproperty(csv_object, name)
        @show type = types[i]

        if type !== Missing
            setproperty!(data, name, value)
        end
        i = i + 1
    end
 
    return data

end


end # module
