# allumin8explore

## Setup Instructions
1. Iinstall [cocoapods](https://cocoapods.org/). 
2. Clone this repo
3. Run `pod install` in the folder
4. Open the project with the .xcworkspace file, not the .xcodeproj

## Login
### email: todd@gmail.com
### password: toddspass


## Product Description 

Every year, hospitals waste millions of dollars maintaing redundant systems and supply networks for surgery materials. Orthopedics, the branch of medicine that deals with muscoskeletal system, is one big reason why. Orthopedic surgeries often require instrument kits and implant kits that are expensive and specialized. Due to this, Hospitals have to go through a host middlemen companies just get an surgeon and their team the parts that they need. To tackle this problem, Alyssa Huffman founded Allumin8, a medical device startup that aims to simplify the whole pipeline between the manufacturer and hospital.  

Our pp is Allumin8 Explore, a interface for the Allumin8 system. It is a one stop shop to allow Orthopedic surgeons and surgery schedulers to both schedule and keep track of surgeries at a Hospital. 

Instead forcing medical professionals to bounce throughout 2 or 3 different systems, our platform allows them to do what they need to do so that they can get back to more important tasks. Surgeon schedulers can schedule surgeries and order the necessary equipment / implants in one pipeline. They can include...

     * Hospital location
     * Patient information, such as ID, sex, name, and weight
     * Date 
     * Instrument and Implant kits
     * Additional information 
 
 Then, surgeons can see the surgeries they've scheduled in their main feed. This feed can be viewed for linearly, to show all their surgeries, or in a calendar view to let them get a better sense of the timescale of their work. They can click on a surgery and see the detailed information about the case. Furthermore, the surgeon can also upload relevant scans, after the case has been completed. These scans can be opened fullscreen in an immersive image viewer that allows zooming and other key features. 
 
 All these features are backed by a Cloud Firestore database hosted on Firebase. We are working to get this HIPAA certified from Google, but were unable to complete that by the time the project was due. 
 
 
 ## Intended Use Case / Usage Instructions 
 * Login with the above login
 * Go to schedule talk and walk through pipeline to make a surgery
 * Go to my cases screen and view surgery
 * Add an image to the the surgeyr
 * View image by clicking on it 
