#$Id$
CXX = g++ -g
ALL = Event_to_Histo Map_Data Create_Tbin_File

all : $(ALL)

Event_to_Histo: bin_vector_utils.o utils.o Event_to_Histo.o
	$(CXX) -o Event_to_Histo bin_vector_utils.o utils.o Event_to_Histo.o

Create_Tbin_File: bin_vector_utils.o utils.o Create_Tbin_File.o
	$(CXX) -o Create_Tbin_File bin_vector_utils.o utils.o Create_Tbin_File.o

Map_Data : Map_Data.o utils.o
	$(CXX) -o Map_Data Map_Data.o utils.o

utils.o: utils.cpp utils.hpp

bin_vector_utils.o: bin_vector_utils.cpp bin_vector_utils.hpp utils.hpp

Event_to_Histo.o: Event_to_Histo.cpp Event_to_Histo.hpp
	$(CXX) -c -I ../inc Event_to_Histo.cpp

Create_Tbin_File.o: Create_Tbin_File.cpp Create_Tbin_File.hpp utils.hpp bin_vector_utils.hpp
	$(CXX) -c -I ../inc Create_Tbin_File.cpp

Map_Data.o: Map_Data.cpp Map_Data.hpp utils.hpp
	$(CXX) -c -I ../inc Map_Data.cpp


clean:
	rm -f $(ALL) *.o
