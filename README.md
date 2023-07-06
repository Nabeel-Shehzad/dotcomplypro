# Business | User Requirements

## Product Description
DOTComplyPro is a comprehensive SaaS solution designed to streamline the process of managing compliance and purchasing services for transportation companies. The platform offers an iOS app, Android app, and web interface, allowing users to buy services, manage their compliance, and receive important notifications. Key features include BOC-3 filing, UCR registration, Drug Program management, Driver Qualification File management, and Electronic Logging Device (ELD) software.

## Platform Components
1. iOS App
2. Android App
3. Web Interface

## Core Features
### BOC-3 Filing
1. Purchase BOC-3 filing service.
2. Receive and store a digital copy of the BOC-3 form in the app.
3. Access the BOC-3 form anytime, anywhere.

### UCR Registration
1. Purchase UCR registration service.
2. Receive and store a digital copy of the UCR registration in the app.
3. Push notifications for UCR renewal reminders at the end of the calendar year.

### Drug Program Management
1. Enroll and renew drug programs based on the number of drivers.
2. Upload driver licenses.
3. Order drug tests.
4. Receive and store drug test results in the app.
5. Push notifications for renewal reminders two weeks in advance, with another reminder one week in advance if not.
6. Send and store Letter of Participation, company policy, and other relevant documents via the app.

### Driver Qualification File Management
1. Enter driver data through the app.
2. Receive a digital, professionally formatted Driver Qualification File for storage in the app.
3. Push notifications for yearly reminders to order Driving Records.
4. Purchase and receive Driving Records through the app, storing them in the app for easy access.

### Electronic Logging Device (ELD) Software
1. Compliant with DOT software requirements for interfacing with ELD devices.
2. Obtain DOT approval for the developed ELD software.
3. [DOT ELD Developer Handbook](https://www.fmcsa.dot.gov/regulations/hours-service/elds/electronic-logging-devices-and-hours-service-developer-handbook#_bookmark5)

## Push Notifications
- UCR renewal reminders
- Drug Program renewal reminders
- Yearly reminders to order Driving Records

## Functional Requirements

FR-01: System shall be able to submit driver files.

FR-02: System shall be able to submit driver using the following fields:
1. Add Driver name
2. Driver last name
3. Date hired
4. Home address
5. Date of birth
6. SSN
7. Email
8. Cell phone
9. License number
10. License state
11. License expiration date
12. Annual review of driving record
13. Next due date of annual review of driving record
14. Copy of driver lic/CDL
15. Subject to random drug testing
16. Date of pre-employment drug screen (if required)
17. Date of drug consortium renewal (if applicable)
18. Date of last random test (if applicable)
19. Drug screens
20. Medical exam
21. Medical exam expiration date
22. Employment Application
23. Personnel matters
24. Miscellaneous
25. Date terminated

FR-03: System shall be able to submit Vehicle input form using the following fields:
1. Unit Number
2. Vehicle year
3. Model
4. Make
5. Vehicle license
6. License state
7. VIN
8. GVWR
9. Date of the most recent Odometer reading
10. Odometer reading
11. Date of next inspection due
12. Annual inspection
13. Maintenance log
14. Miscellaneous information
15. Miscellaneous files

FR-04: System shall be able to submit drug program form using the following fields:
1. Letter of participation
2. Company policy
3. Program statistics
4. Pre-employment drug screens
5. Random drug screen
6. Random alcohol screens

FR-05: System shall be able to perform BOC-3 filing by adding the following information:
1. DOT number
2. Legal name
3. DBA name
4. State

FR-06: System shall be able to show the BOC-3 information on the admin side.

FR-07: System shall be able to send a document of BOC-3 back to the user app.

FR-08: System shall be able to perform UCR filing similar to the BOC-3 form.

FR-09: System shall be able to show admin driver-submitted forms.

FR-10: System shall be able to show admin vehicle-submitted forms.

FR-12: System shall be able to edit or delete driver's forms.

FR-13: System shall be able to edit or delete vehicle forms.

FR-14: System shall be able to edit or delete drug forms.

FR-15: System shall be able to push notifications for UCR renewal reminders at the end of the calendar year.

FR-16: System shall be able to push notifications for yearly reminders to order Driving Records.

FR-17: System shall be able to push notifications for renewal reminders two weeks in advance, with another reminder one week in advance if not.

FR-18: System shall be able to allow admin to log in to the system.
