pro remove_me

cd,'~/IDLWorkspace/SANSreduction/utilities/'
file = '~/results/EQSANS_geom_2009_09_10.xml'
iXML = OBJ_NEW('idlxmlparser',file)

text = iXML->getValue(tag=['instrumentgeometry',$
'math','definition','parameter'], ATTR='name=detZoffset')
help, text
print, text



cd,'~/IDLWorkspace/SANSreduction/'
end