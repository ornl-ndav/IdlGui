PRO bss_selection_BrowseNexus, Event

;get global structure
id=widget_info(Event.top, FIND_BY_UNAME='MAIN_BASE')
widget_control,id,get_uvalue=global

;indicate initialization with hourglass icon
widget_control,/hourglass

DefaultPath = (*global).DefaultPath
Filter = (*global).DefaultFilter
Title = 'Select a NeXus file to load'

;open file
FullNexusFileName = dialog_pickfile(path              = DefaultPath,$
                                    get_path          = path,$
                                    title             = Title,$
                                    filter            = filter,$
                                    default_extension ='.nxs',$
                                    /fix_filter)

if (FullNexusFileName NE '') then begin
    
    message = 'Loading NeXus file selected:'
    PutLogBookMessage, Event, message

    (*global).DefaultPath = path
;nexus has been found and can be opened
    BSSselection_LoadNexus_step2, Event, FullNexusFileName
    (*global).NeXusFound = 1
    
endif else begin

;left browse box without doing anything

endelse

;turn off hourglass
widget_control,hourglass=0

END
