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


    @show command = `java -jar $(d.command) --defn none --data record $(tmp_path)`


    #@show command = `java -jar /home/rzietal/git/FIT.jl/FitSDK/java/FitCSVTool.jar --defn none --data record /home/rzietal/git/FIT.jl/test/example.fit`
    run(command)
    
    @show csvfilename = splitext(filename)[1] * "_data.csv"
    @show isfile(csvfilename)
    csv_object = CSV.File(csvfilename)

    return csv_object
end

function fit2table(filename::AbstractString)::FlexTable

    fit2csv = FitCSVTool()
    @show csv_object = fit2csv(filename)

    data = FlexTable(id = collect(1:length(csv_object)))

    return data

end


end # module
