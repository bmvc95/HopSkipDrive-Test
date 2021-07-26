# HopSkipDrive-Test
Take home test to gauge skill set

1) For this quick app demo, there was no need for third party libraries. No need for an extensive network library or image caching library
2) Improvements
    a. I added a function that will show the quickest route between pick up location and drop off locations. Depending on drop off order,
       a care driver might find this useful when navigating between drop offs
    b. I added customized pins on the map to help distinguish drop offs and pick up with a colored pulse.
       Also the pin will show a slideshow of passenger images. I feel as this adds a better UX because the care driver can visibily see
       quickly which passenger they are dropping off
    c. When a user selects a pin or address, the map will center in on that address for a better view
    d. The test api data gave the same coords for different drop off addresses, so I wrote the function to get the actual 
       coordinates for the drop of locations. This allowed for a better experience

NOTES
I checked the app for memory leaks using the Memory Graph Debugger and Instruments, there are no memory leaks or retained cycles 

*WHEN CANCELLING A TRIP, THE TRIP IN THE 2D ARRAY IS REMOVED BECAUSE IT CANCELS THE TRIP BASED ON TRIP ID,
 EACH TRIP IN THE TEST API HAS THE SAME TRIP ID, WHICH ISN'T THE BEST AND IM SURE IS UNINTENTIONAL. 
 A UNIQUE TRIP ID ALLOWS US TO KEEP TRACK OF UNIQUE TRIPS, WHICH IS A MUST WHEN DEALING WITH CHILDREN*
