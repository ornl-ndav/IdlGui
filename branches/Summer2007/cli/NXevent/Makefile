#$Id$
CXX = g++ -g
ALL = rand2nxl event2nxl nxl2event nxl_diff

RAND_OBJS 	= 	rand2nxl.o

EVENT2NXL_OBJS  =	event2nxl.o nexus_util.o event_data.o 

NXL2EVENT_OBJS 	= 	nxl2event.o nexus_util.o

NXL_DIFF_OBJS   =   	nxl_diff.o

all: $(ALL)

nxl_diff: $(NXL_DIFF_OBJS)
	$(CXX) $(NXL_DIFF_OBJS) -o nxl_diff

nxl2event: $(NXL2EVENT_OBJS)
	$(CXX) $(NXL2EVENT_OBJS) -static-libgcc -L/usr/local/hdf5/lib -L/usr/local/hdf4/lib -Wl,-Bstatic `pkg-config nexus --libs-only-l` -ljpeg -o nxl2event

event2nxl: $(EVENT2NXL_OBJS)
	$(CXX) $(EVENT2NXL_OBJS) -static-libgcc -L/usr/local/hdf5/lib -L/usr/local/hdf4/lib -Wl,-Bstatic `pkg-config nexus --libs-only-l` -ljpeg -o event2nxl

rand2nxl: $(RAND_OBJS)
	$(CXX) $(RAND_OBJS) -static-libgcc -L/usr/local/hdf5/lib -L/usr/local/hdf4/lib -Wl,-Bstatic `pkg-config nexus --libs-only-l` -ljpeg -o rand2nxl	

nxl_diff.o: nxl_diff.cpp
	$(CXX) -c -I ../../inc nxl_diff.cpp

nxl2event.o: nxl2event.cpp nexus_util.hpp
	$(CXX) `pkg-config nexus --cflags` -c -I ../../inc nxl2event.cpp

event2nxl.o: event2nxl.cpp event2nxl.hpp nexus_util.hpp
	$(CXX) `pkg-config nexus --cflags` -c -I ../../inc event2nxl.cpp

rand2nxl.o: rand2nxl.cpp
	$(CXX) `pkg-config nexus --cflags` -c -I ../../inc rand2nxl.cpp

nexus_util.o: nexus_util.cpp nexus_util.hpp
	$(CXX) -c -I ../../inc nexus_util.cpp

event_data.o: event_data.cpp 
	$(CXX) -c -I ../../inc event_data.cpp

clean:
	rm -f $(ALL) *.o

