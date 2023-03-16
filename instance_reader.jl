# Struct describing a container type
struct ContainerType
    length::Int64
    weight::Float64
    cargo_type::String # Expected values: DC (Dry Container), HC (High-Cube container)
                       #                  RC (Reefer Container), HR (High-Cube Reefer Container)
    height::Float64
    is_reefer::Bool
    is_HC::Bool
end

#Struct describing a Master PLanning instance
struct MasterPlanInstance
    n_bays # Number of bays in the vessel
    n_ports # Number of ports to visit

    #Location/Block data
    n_locations # Number of locations/blocks
    locations_over # List of on-deck locations
    locations_under # List of locations under a given location (0 if the given location is under-deck)
    locations_over_in_bay # List of on-deck locations in a bay
    location_bay # List indicating the bay a location belogs to
    location_TEU_capacity # TEU capacity of each location
    location_FEU_capacity # FEU capacity of each location
    location_reefer_capacity # Number of reefer plugs in each location
    location_weight_capacity # Weight capacity of each location
    location_lcg # Logitudinal center of gravity of each location
    location_vcg # Vertical center of gravity of each location
    location_tcg # Transversal center of gravity of each location

    #Bay data
    bay_buoyancy # buoyancy at each bay for all ports but the last (no stability calculation in the last port)
    bay_bins # Set of adjacent bays
    bay_lightship_weight # Lightship (constant) weight of each bay
    bay_lcg # The longitudinal center of gravity of each bay
    bay_vcg # The vertical center of gravity of each bay
    bay_tcg # The transversal center of gravity of each bay
    bay_min_shear # The minimum shear at each bay
    bay_max_shear # The maximum shear at each bay
    bay_max_bending # The maximum bending at each bay

    #Ship data
    displacement # The total vessel displacement at each port (except the last)
    ship_min_lcg # the vessel minimum longitudinal center of gravity at each port (except the last)
    ship_max_lcg # the vessel maximum longitudinal center of gravity at each port (except the last)
    ship_max_vcg # the vessel maximum vertical center of gravity at each port (except the last)
    ship_min_tcg # the vessel minimum transversal center of gravity at each port (except the last)
    ship_max_tcg # the vessel maximum transversal center of gravity at each port (except the last)
    
    #Container data
    container_types # The list of container types
    containers # The number of container in each leg per container type
    release # The numner of container already on board at the first port. Given for each discharge port, location, and container type
end

# Constructor for the ContainerType struct
function ContainerType(length,weight,cargo_type)
    height = 2.62
    reefer = false
    is_HC = false
    if cargo_type == "HC" || cargo_type == "HR"
        height = 2.92
        is_HC = true
    end
    if cargo_type == "HR" || cargo_type == "RC"
        reefer = true
    end
    return ContainerType(length,weight,cargo_type,height,reefer,is_HC)
end

# Instance reader function. Fine an instance file redurns a MasterPlanInstance struct
function read_master_planning_instance(filename::String)
    file = open(filename)
    n_ports, n_bays, n_locations, n_bins, n_container_types = parse.(Int64,split(readline(file)))
    locations_over = parse.(Int64,split(readline(file)))
    locations_under = parse.(Int64,split(readline(file)))
    locations_over_in_bay = []
    for b in 1:n_bays
        vals = parse.(Int64,split(readline(file)))
        if lastindex(vals)>1
            push!(locations_over_in_bay,vals[2:end])
        else
            push!(locations_over_in_bay,Int64[])
        end
    end
    location_bay = parse.(Int64,split(readline(file)))
    location_TEU_capacity = parse.(Int64,split(readline(file)))
    location_FEU_capacity = parse.(Int64,split(readline(file)))
    location_reefer_capacity = parse.(Int64,split(readline(file)))
    location_weight_capacity = parse.(Float64,split(readline(file)))
    location_lcg = parse.(Float64,split(readline(file)))
    location_vcg = parse.(Float64,split(readline(file)))
    location_tcg = parse.(Float64,split(readline(file)))
    bay_buoyancy = [[] for p in 1:n_ports-1]
    for p in 1:n_ports-1
        bay_buoyancy[p] = parse.(Float64,split(readline(file)))
    end
    bay_bins = []
    for b in 1:n_bins
        push!(bay_bins,parse.(Int64,split(readline(file))))
    end
    bay_lightship_weight = parse.(Float64,split(readline(file)))
    bay_lcg = parse.(Float64,split(readline(file)))
    bay_vcg = parse.(Float64,split(readline(file)))
    bay_tcg = parse.(Float64,split(readline(file)))
    bay_min_shear = parse.(Float64,split(readline(file)))
    bay_max_shear = parse.(Float64,split(readline(file)))
    bay_max_bending = parse.(Float64,split(readline(file)))
    displacement  = parse.(Float64,split(readline(file)))
    ship_min_lcg  = parse.(Float64,split(readline(file)))
    ship_max_lcg  = parse.(Float64,split(readline(file)))
    ship_max_vcg  = parse.(Float64,split(readline(file)))
    ship_min_tcg  = parse.(Float64,split(readline(file)))
    ship_max_tcg  = parse.(Float64,split(readline(file)))

    container_types = []
    for c in 1:n_container_types
        vals = split(readline(file))
        push!(container_types, ContainerType(parse(Int64,vals[1]),
                                             parse(Float64,vals[2]),
                                             vals[3]))
    end

    containers = Dict()
    for o in 1:n_ports
        for d in 1:n_ports
            if (o<d)
                vals = parse.(Int64,split(readline(file)))
                containers[(vals[1],vals[2])] = vals[3:end]
            end
        end
    end

    release = zeros(Int64, n_ports, n_locations, n_container_types)
    for p in 2:n_ports
        for l in 1:n_locations
            vals = parse.(Int64,split(readline(file)))
            release[vals[1],vals[2],:]=vals[3:end]
        end
    end
    close(file)
    return MasterPlanInstance(n_bays,
                                n_ports,
                                n_locations,
                                locations_over,
                                locations_under,
                                locations_over_in_bay,
                                location_bay,
                                location_TEU_capacity,
                                location_FEU_capacity,
                                location_reefer_capacity,
                                location_weight_capacity,
                                location_lcg,
                                location_vcg,
                                location_tcg,
                                bay_buoyancy,
                                bay_bins,
                                bay_lightship_weight,
                                bay_lcg,
                                bay_vcg,
                                bay_tcg,
                                bay_min_shear,
                                bay_max_shear,
                                bay_max_bending,
                                displacement,
                                ship_min_lcg,
                                ship_max_lcg,
                                ship_max_vcg,
                                ship_min_tcg,
                                ship_max_tcg,
                                container_types,
                                containers,
                                release)
end