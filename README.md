# nubbhub

Network utility to measure and track NUBB data usage at Cornell University

## First off...
I've tested the app very little on physical iPhones, in part to the iOS 9.3 Beta. Unfortunately, it doesn't run on either of my iPhones. However, the Simulator in Xcode works perfectly. I am befuddled to say the least. I am nearly certain the full functionality of the app will not work on your iPhone right now, just the guest mode. I am entirely at fault for not testing my code properly with the Simluator and my own iPhone. If in the worst possible case your own Simulators can't log in with your data, please stick with guest mode.

The other important bit of information: security. I have tried installing numerous GitHub projects, frameworks, and pods to encrypt the user's NetID and password, but have had no luck in successfully doing so. Data is stored in NSUserDefaults unencrypted. If you are uncomfortable with this, please do not enter your information. However, your credientials will be properly deleted upon signing out or deleting the application. The only to acesss the information is to browse the file hieracrchy of your phone. I plan to explore more on crypto, as well as WKWebView certificates, to resolve this issue. 

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
- Confirguable notifcations when user's have exceeded a certain amount of data
- Guest mode, to not leave non-Cornellians left out on the fun

## Little Touches
- Intelligent presentation of statistics based on context (past v. present, if there is no cost, etc.)
- Color changes across UI if the user is going to / has exceeded the data limit
- Timeout errors that reload content (bad connection, too slow)
- dynamic theming menu that provides color palette information in a fun way
- About screen with social media links and a hidden way to send feedback

## Known Issues
- 

## Roadmap
- Create widget
- Cryptography cryptopgrahy cryptography (or alternate security methods)
- Streamline OverviewCollectionView
- Create instructional graphic for sign-in screen
	- overlay main UI with labels, descriptions, units, etc.
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

