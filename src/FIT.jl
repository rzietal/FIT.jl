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


    @show readdir(temp_dir)
    
    @show isfile(tmp_path)
    @show isfile(d.command)
    arguments = [exec, d.command, options, tmp_path]
    @show command = Cmd(arguments)

    run(command)

    csvfilename = splitext(filename) * "_data.csv"
    csv_object = CSV.File(csvfilename)

    #rm(temp_dir, recursive = true)

    return csv_object
end

function fit2table(filename::AbstractString)::FlexTable

    fit2csv = FitCSVTool()
    csv_object = fit2csv(filename)

    data = FlexTable(id = collect(1:length(csv_object)))

    return data

end


end # module
