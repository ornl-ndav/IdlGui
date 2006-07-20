#$Id$
CXX = g++

ALL : utils.o bin_vector_utils.o Event_to_Histo.o Map_Data
	$(CXX) -o Event_to_Histo utils.o bin_vector_utils.o Event_to_Histo.o

Map_Data : Map_Data.cpp
	$(CXX) -o Map_Data -I ../inc Map_Data.cpp

utils.o: utils.cpp
	$(CXX) -c utils.cpp

bin_vector_utils.o: bin_vector_utils.cpp
	$(CXX) -c bin_vector_utils.cpp

Event_to_Histo.o: Event_to_Histo.cpp
	$(CXX) -c -I ../inc Event_to_Histo.cpp

clean:
	rm Event_to_Histo event_to_Histo.o utils.o bin_vector_utils.o Map_Data