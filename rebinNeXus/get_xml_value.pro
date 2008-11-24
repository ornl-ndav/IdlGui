PRO xml_object_recurse, oNode, match, return_value

;check to see if this node matches the one we're looking for
if oNode->GetNodeName() EQ match then begin
;case where we find a match
;now we have to get the first child of this node to get the value
;for this node
   		oSibling = oNode->GetFirstChild()
;now that we found the sibling, save the result and pass it all the way back
;to the top
		if OBJ_VALID(oSibling) then return_value = oSibling->GetNodeValue()
end
   ; Visit children - process of recursing deeper into the object tree
   oSibling = oNode->GetFirstChild()
   WHILE OBJ_VALID(oSibling) DO BEGIN
      xml_object_recurse, oSibling, match, return_value
      oSibling = oSibling->GetNextSibling()
   ENDWHILE
END

;function that creates the XML object
function get_xml_value, NodeName, filename
;create XML object and load file
   oDoc = OBJ_NEW('IDLffXMLDOMDocument',filename=filename)
;now load it with our xml file of interest
;   oDoc->Load, filename
;initiate the variable that will contain the data we're interested in
   return_value = ''
;recurse the object tree and find what we're looking for
   xml_object_recurse, oDoc, NodeName, return_value
;	print,'Return Value: ',return_value
;send the findings back to the calling program
	return, return_value
;cleanup memory and destroy the object
   OBJ_DESTROY, oDoc
END

;test program
;user needs to identify an xml filename
filename = "/Users/j35/IDL/XML/REF_L_97_runinfo.xml"
;and the nodename (xml key) for the data they want
NodeName = 'MaxScatPixelID'
NodeName1 = 'NumTimeChannels'
;call the function to get the value we're looking for from the xml file
xml_node_value = get_xml_value(NodeName,filename)
xml_node_value1 = get_xml_value(NodeName1,filename)
;show what we get
print,'**********************************'
print,'NodeName: ',NodeName
print,'Return Value: ',xml_node_value
print,''
print, 'NodeName1: ',NodeName1
print, 'Return Value: ',xml_node_value1
print, ''
end
