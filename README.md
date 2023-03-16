# Container Stowage Planning - Master Planning Benchmark
This benchmark set can be used to evaluate the performance of solution methods for the Master Planning Problem.

Master Planning is a sub-problem of container stowage planning where the aim is to assign containers to subsections of a vessel called blocks. The assingment must satify sea worthiness contraints and take into account multiple load and discharge ports. A decsription of how the instances have been genrated can be found in the following publication.

Literature Survey on the Container Stowage Planning Problem, Jaike van Twillera, Agnieszka Sivertsenb, Dario Pacinoc, Rune Møller Jensen, [under revision]

An instance reader written in the Julia programming language is provided.

## Instance format description

The first line of the file holds 5 values representing: the number of port visits, the number of bays in the vessel, the number of location/blocks in the vessel, the number of adjacent bays (or bins), and the number of container types.

The next line is a list of bay IDs (linear starting from 1) indicating all the on-deck locations. The successive line is an array with a value for each location in the vessel. For each on-deck location the value represents the corresponding location below-deck. For all below-deck locations the value is 0. 

Next there is a line for each bay. The line is a list of the on-deck locations in that bay.

The following line has a value for each location, indicating the bay it belows to.

The next four lines hold a value for each location indicating. The first line is the TEU capcity of the location. The second is the FEU capacity of the location. The third is the number of reefer plugs in the location, and the last is the weight capacity (in tons) of each location.

The next three lines indicate the center of gravity for each location, with the first line indicating the longitudinal center of gravity, the second the vertical center of gravity, and the third the transversal center of gravity (in meters).

Next there is a line for each visited port indicating the buoyancy at each bay (in tons). The last port is not included as stability calculation are not done for this port. 

Following there is a line for each set of adjacent bays. Each line indicates the two adjacent bays.

The next line indicated the contant weight (lightship) at each bay (in tons).

The next three lines indicate, for each bay, the longitudinal, vertical and transversal center of gravity (in meters).

The minimum shear at each bay is given in the next line, the maximum shear in the following one, and the maximum bending in the subsequent line (in tons for shear and tons/meters for bending).

The displacement at each port (except the last) is provided in the next line (in tons).

The next five lines indicate the limits of the center of gravity of the vessel at each port (except the last). The lines indicate the minimum longitutinal center of gravity, the maximum longitutudinal center of gravity, the maximum vertical center of gravity, the minimum transversal center of gravity, and the maximum transversal center of gravity, respectively (in meters).

Next there is a line for each of the container types used in the instance. Each line includes the length (in foot), the weight (in tons), and the type. The type can hold 4 values: DC = dry container, HC = high-cube container, RC = reefer container, HR = high-cube reefer container.

Next there is a line for each legs of the journey. The first two values of each line indicate the load and discharge port representing the leg, the rest of the values in the list represents the number of containers of each container type in that leg.

Finally there is a line for each location and each discharge port (so without the first port). The line indicates the containers already on board (also called release). The first two values of each line indicate the discharge port and the location. The next values represent the number of containers of each container type.

