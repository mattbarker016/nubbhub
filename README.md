# nubbhub

Network utility to measure and track NUBB data usage at Cornell University

## First off...
I've tested the app very little on physical iPhones, in part to the iOS 9.3 Beta. Unfortunately, nubbhub doesn't run on either of my iPhones. However, the Simulator in Xcode works perfectly, both on my computer and a friend's. I am befuddled to say the least. If, for some even stranger reason, the online functionality of the app does not work in your Simulator, please use the offline guest mode. I am entirely at fault for not testing my code properly with the Simluator and my own iPhone, and am investiagting this puzzling issue. The app's logic, structure, site parser function and Javascript are sound; once this bug is fixed, the app will run smoothly and functionally on all devices.

The other important bit of information: security. I have tried installing numerous GitHub projects, frameworks, and pods to encrypt the user's NetID and password, but have had no luck in successfully doing so. Data is stored in NSUserDefaults, unencrypted. If you are uncomfortable with this, please do not enter your information; use the guest mode. However, your credientials will be erased upon signing out or deleting the application. The only way to acesss the information is to browse the file hieracrchy of your phone. I plan to explore more on crypto, as well as WKWebView certificates, to resolve this issue. 

Finally, on to the good stuff...

## Features
- Elegant graphical representation of user's total usage in the billing cycle
- Helpful usage statistics
	- Average: average data usage per day
	- Forecast: projected usage for month
	- Suggested: maximum daily data usage to stay under data limit
	- Cost: projected / actual cost due to over-usage
- Detailed information for each user's device
	- Total Usage
	- Download Amount
	- Upload Amount
- View past billing cycle data (from Aug. 2015 on)
- Eight colorful themes
- [BETA] Confirguable notifcations when user's have exceeded a certain amount of data
- Guest mode, to not leave non-Cornellians left out on the fun

## Little Touches
- Intelligent presentation of statistics based on context (past v. present, if there is no cost, etc.)
- Color changes across UI if the user is going to / has exceeded the data limit
 	- Color changes will default to bold if color contrasts with current theme
- Timeout errors that reload content (bad connection, too slow)
- Dynamic theming menu that provides color palette information in a fun way
- About screen with social media links and a hidden way to send feedback
- thorough parser functions
 	- Assign names to unnamed devices
 	- Site scraper accounts for no data usage
- Guest mode calendar shows last six current months
- Special layout adjustments for smaller devices

## Known Issues
- Security (see First Off..)
- Online connectivity failure (see First Off...)
- nubbhub pro, notification, and widget options are unfinished
	- Notifications should (theoretically) still fire when background fetch is run and 50%, 75%, or 90% of data is used
- Minor theming bugs
- Calendar button tap target is too small

## Roadmap
- Create Today Widget in Notification Center
- Security security security (or alternate security methods)
- Streamline OverviewCollectionView
- Create instructional graphic for sign-in screen
	- overlay main UI with labels, descriptions, units, etc.
- Theme Enhancements
	- squash bugs
	- gradient themes
- decide on nubbhub pro (IAP purchase)
	- multiple widgets, themes
	- remove ads
- publish on iOS App Store (screenshots, Dev License, etc.)

## Credits / Acknowledgements

Chopper "Choops" Weidman, Lucas Derraugh, Austin Astorga, Tom Chen, Ray Wenderlich

CUAppDev, Stack Overflow

Emily Morrison, Cheryl Barker, Cliff Barker

The poor Cornell IT guys who saw their site get bombarded with an infinite loop signing into CUWebLogin

Me (I worked damn hard on this)

