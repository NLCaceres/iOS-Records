# iOS-Records aka "Infection Protection"
  - iOS App for Healthcare professionals to track important data related to Infection Prevention and Control.

## Future Implementations
  - Reorganize Networking to better separate concerns in the style of the Android app
  - Add caching via CoreData
  - Add data graphs via Swift UI Charts
  - More features coming to Report Making Process
    - Enhance user experience
      - Separate report process into 2-3 screens
        - Aside from the Employee Table View used on the 1st screen in the Create Report path
        - See increased data collection bullet point below
    - Increased data collection
      - Which step of a particular process did the violation occur?
  - More features coming to Settings Layout:
    - Decide how much normal users can control versus Administration.
      - Should admins control hospital-wide features on the app or just the website?
    - Improve Dark mode + stylings affected by iOS's system
  
## Related Apps
  - Android App: https://github.com/NLCaceres/Android-Records
    - Nearing feature parity again (still needs several views missing in iOS)
    - Targets Android 13 Tiramisu (Sdk 33) to 8 Oreo (Sdk 26)
    - Future Developments
      - Begin using Jetpack Compose to create views
      - Add Room Library for local caching 
  - Front-end website: https://github.com/NLCaceres/Ang-records
    - Running Angular 12 with major redesign coming soon
  - Backend App: https://github.com/NLCaceres/express-records
    - Likely to be updated to Gin (Golang) due to Express seemingly dying BUT Laravel or DotNet possibly more mature choices

### Couple Notes on XCode's Quirks
 - XCode's README editor is pretty bad, so probably best to use VSCode to edit this file
 - If adding, removing, or moving files, ALWAYS commit the "project.pbxproj" file since it's
 linked to the build of the whole project, tracking EVERY file that XCode is aware of
