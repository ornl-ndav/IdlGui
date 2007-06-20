#$Id$
CXX = g++ -g
ALL = Event_to_Histo Map_Data Create_Tbin_File Event_to_Histo_Mapped rand2nxl event2nxl nxl2event

HMAP_OBJS	=	Event_to_Histo_Mapped.o \
				histo_utils.o bin_vector_utils.o map_utils.o utils.o

HISTO_OBJS	=	Event_to_Histo.o \
				histo_utils.o bin_vector_utils.o utils.o

TBIN_OBJS	=	Create_Tbin_File.o bin_vector_utils.o utils.o

MAP_OBJS	=	Map_Data.o map_utils.o utils.o

RAND_OBJS 	= 	rand2nxl.o

EVENT_OBJS      =	event2nxl.o NexusUtil.o 

NXL2EVENT_OBJS 	= 	nxl2event.o NexusUtil.o

all: $(ALL)

nxl2event: $(NXL2EVENT_OBJS)
	$(CXX) $(NXL2EVENT_OBJS) -static-libgcc -L/usr/local/hdf5/lib -L/usr/local/hdf4/lib -Wl,-Bstatic `pkg-config nexus --libs-only-l` -ljpeg -o nxl2event

event2nxl: $(EVENT_OBJS)
	$(CXX) $(EVENT_OBJS) -static-libgcc -L/usr/local/hdf5/lib -L/usr/local/hdf4/lib -Wl,-Bstatic `pkg-config nexus --libs-only-l` -ljpeg -o event2nxl

rand2nxl: $(RAND_OBJS)
	$(CXX) $(RAND_OBJS) -static-libgcc -L/usr/local/hdf5/lib -L/usr/local/hdf4/lib -Wl,-Bstatic `pkg-config nexus --libs-only-l` -ljpeg -o rand2nxl	

Event_to_Histo_Mapped: $(HMAP_OBJS)
	$(CXX) -o Event_to_Histo_Mapped $(HMAP_OBJS)

Event_to_Histo: $(HISTO_OBJS)
	$(CXX) -o Event_to_Histo $(HISTO_OBJS)

Create_Tbin_File: $(TBIN_OBJS)
	$(CXX) -o Create_Tbin_File $(TBIN_OBJS)

Map_Data: $(MAP_OBJS)
	$(CXX) -o Map_Data $(MAP_OBJS)

utils.o: utils.cpp utils.hpp

bin_vector_utils.o: bin_vector_utils.cpp bin_vector_utils.hpp utils.hpp

nxl2event.o: nxl2event.cpp NexusUtil.hpp
	$(CXX) `pkg-config nexus --cflags` -c -I ../inc nxl2event.cpp

event2nxl.o: event2nxl.cpp event2nxl.hpp NexusUtil.hpp
	$(CXX) `pkg-config nexus --cflags` -c -I ../inc event2nxl.cpp

rand2nxl.o: rand2nxl.cpp
	$(CXX) `pkg-config nexus --cflags` -c -I ../inc rand2nxl.cpp

Event_to_Histo_Mapped.o: Event_to_Histo_Mapped.cpp Event_to_Histo.hpp Map_Data.hpp utils.hpp
	$(CXX) -c -I ../inc Event_to_Histo_Mapped.cpp

Event_to_Histo.o: Event_to_Histo.cpp Event_to_Histo.hpp
	$(CXX) -c -I ../inc Event_to_Histo.cpp

histo_utils.o: histo_utils.cpp Event_to_Histo.hpp
	$(CXX) -c -I ../inc histo_utils.cpp

Create_Tbin_File.o: Create_Tbin_File.cpp Create_Tbin_File.hpp utils.hpp bin_vector_utils.hpp
	$(CXX) -c -I ../inc Create_Tbin_File.cpp

Map_Data.o: Map_Data.cpp Map_Data.hpp utils.hpp
	$(CXX) -c -I ../inc Map_Data.cpp

map_utils.o: map_utils.cpp Map_Data.hpp utils.hpp
	$(CXX) -c -I ../inc map_utils.cpp

NexusUtil.o: NexusUtil.cpp NexusUtil.hpp
	$(CXX) -c -I ../inc NexusUtil.cpp

clean:
	rm -f $(ALL) *.o

