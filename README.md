# FirePage

FirePage is an iOS application for managing the RA-on-call system at Duke University. The application can track emergency requests from residents, manage the RA-on-call calendar, and help users get in touch with first responders.

## Installation
1. Clone down `git@gitlab.oit.duke.edu:ECE564_F17/Gargs/Project.git` and `cd` into the repository
2. Run `pod install && pod update && pod repo update` in the root directory of the repository
3. _Note: You may encounter a warning in Xcode telling you to update project settings; this is caused by `pod install` and can be resolved by clicking the warning and clicking "Fix"_
4. Open the project in Xcode via the `FirePage.xcworkspace` file (**the project will not build if you open the xcodeproj file**)
5. The application should now build and run; it will work on any simulator, but designed with iPhone 5S
6. Log in via credentials below, separated according to role

**Important note:** To test the HelpLine calling functionality, you must run the application on an iPhone.

## Credentials

#### RA (access to HelpLine, HelpRequests, and Calendar)
Username: `ritwik@firepage.com`

Password: `firepage`

#### RC (access to HelpLine and Calendar with all on-call groups)
Username: `madison@firepage.com`

Password: `firepage`

#### Student (access to HelpLine)
Username: `teddytfranceschi@gmail.com`

Password: `99339Vcs`

## Known Bugs
1. After a call, selection of dorm buttons sometimes lags and may not highlight the correct dorm (only applies to physical device)
2. Log-in has a built-in delay of 2 seconds to allow authentication (technically not a bug)

## Roles
* Robert Steilberg: Calendar
* Teddy Franchesci: HelpLine
* Harshil Garg: HelpRequests
* Ritwik Heda: Database, navigation

## Release

Firepage can be built into a released application bundle via `xcodebuild -workspace FirePage.xcworkspace -scheme FirePage clean build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO`
