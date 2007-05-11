#$Id$
CXX = g++ -g
ALL = Event_to_Histo Map_Data Create_Tbin_File

HISTO_OBJS	=	Event_to_Histo.o \
				histo_utils.o bin_vector_utils.o utils.o

TBIN_OBJS	=	Create_Tbin_File.o bin_vector_utils.o utils.o

MAP_OBJS	=	Map_Data.o map_utils.o utils.o

all : $(ALL)

Event_to_Histo: $(HISTO_OBJS)
	$(CXX) -o Event_to_Histo $(HISTO_OBJS)

Create_Tbin_File: $(TBIN_OBJS)
	$(CXX) -o Create_Tbin_File $(TBIN_OBJS)

Map_Data : $(MAP_OBJS)
	$(CXX) -o Map_Data $(MAP_OBJS)

utils.o: utils.cpp utils.hpp

bin_vector_utils.o: bin_vector_utils.cpp bin_vector_utils.hpp utils.hpp

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

clean:
	rm -f $(ALL) *.o

