# myResuma
A Resume Creator Application

# Introduction
This application will comfort users to create their first resume on their mobile device.

# Development
All in Swift. Support iOS 13.0+.
  
# Design Pattern
MVVM with Box<T> class for Data Binding, credit https://www.raywenderlich.com. 

# UI
I use UIKit, Storyboard.

# PDF Generator
I use PDFKit, a iOS Build-in library.

###Generate and display PDF Steps: 
  1. A user select a resume template.
  2. System read user's resuma information and call template layout generator, which response PDFData as Data.
  3. System convert PDFData to PDFDocument and show in preview via PDFKit's preview view.

# Share PDF File
To make sure that OS recognize this type of data, I convert PDF Data to PDF File and use it for share activity.
  
###Share PDF Steps: 
  1. System save PDFData as <title>.pdf in application's local storage, document diractory.
  2. System get file path, URL, and use UIActivityViewController to share file path to other application and PDF supported activities.


