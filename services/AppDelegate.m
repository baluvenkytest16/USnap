//
//  AppDelegate.m
//  services
//
//  Created by Mac on 4/18/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "AppDelegate.h"
#import "OnboardingViewController.h"
#import "OnboardingContentViewController.h"
#import "MenuTableViewController.h"
#import "HomeViewController.h"
#import "SignInViewController.h"

@import LGSideMenuController;



@interface AppDelegate ()
    
@end

@implementation AppDelegate
    
    OnboardingViewController *onboardingVC;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
//    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init]
//                                      forBarPosition:UIBarPositionAny
//                                          barMetrics:UIBarMetricsDefault];
//    
//    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
//    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    sleep(4);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"userlearned"]!=nil  && ![[defaults objectForKey:@"userlearned"] isEqualToString:@""]){
        
        [self handleOnboardingCompletion];

    }else{
       // self.window.rootViewController = [self generateStandardOnboardingVC];
        
        self.window.rootViewController = [self generateStandardOnboardingVC];


    }
    
    

    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

    
    - (OnboardingViewController *)generateStandardOnboardingVC {
        
        OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Want to complete your tasks?" body:@"Choose from over 50+ services & 10,000+ verified professionals, ready to serve you" image:[UIImage imageNamed:@"t2"] buttonText:nil action:nil];
        
        OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"Just tell us what you need" body:@"and get customized quotes from the best matched professional around you" image:[UIImage imageNamed:@"t3"] buttonText:nil action:nil];
        secondPage.movesToNextViewController = YES;
        
        OnboardingContentViewController *thirdPage = [OnboardingContentViewController contentWithTitle:@"Compare Profiles & Connect" body:@"with chosen professional via chat or call, finalize details & hire" image:[UIImage imageNamed:@"t4"] buttonText:nil action:nil];
        
        OnboardingContentViewController *fourthPage = [OnboardingContentViewController contentWithTitle:@"Relax, while your  task get done" body:@"& get enough time to do what you love. So lets get started now" image:[UIImage imageNamed:@"t5"] buttonText:nil action:nil];
        
        
         onboardingVC = [OnboardingViewController onboardWithBackgroundImage:[UIImage imageNamed:@"street"] contents:@[firstPage, secondPage, thirdPage,fourthPage                                                                                       ]];
        onboardingVC.shouldFadeTransitions = YES;
        onboardingVC.fadePageControlOnLastPage = NO;
        onboardingVC.fadeSkipButtonOnLastPage = NO;
        onboardingVC.allowSkipping=YES;
        
        // If you want to allow skipping the onboarding process, enable skipping and set a block to be executed
        // when the user hits the skip button.
        // onboardingVC.allowSkipping = YES;
        // onboardingVC.skipButton.
        onboardingVC.skipHandler = ^{
            [self handleOnboardingCompletion];
        };
        onboardingVC.btn1Handler = ^{
            [self handleOnePressed];
        };
        onboardingVC.btn2Handler = ^{
            [self handleTwoPressed];
        };
        
        
        
        return onboardingVC;
    }

    - (void)handleOnboardingCompletion {
        // set that we have completed onboarding so we only do it once... for demo
        // purposes we don't want to have to set this every time so I'll just leave
        // this here...
        //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
        
        // transition to the main application
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
            
            [self setupHome:@"nologin"];
            
        }else{
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
           // viewController.title=@"Login";
            
//            self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
//            
            self.window.rootViewController = viewController;
        }
    }

- (void)handleOnePressed {
    // set that we have completed onboarding so we only do it once... for demo
    // purposes we don't want to have to set this every time so I'll just leave
    // this here...
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
    
    // transition to the main application
    
    
   // [self setuplogin];
    
    [self handleOnboardingCompletion];
    
    
}

- (void)handleTwoPressed {
    // set that we have completed onboarding so we only do it once... for demo
    // purposes we don't want to have to set this every time so I'll just leave
    // this here...
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kUserHasOnboardedKey];
    
    // transition to the main application
   // [self setupHome];
    
    [onboardingVC moveNextPage];

    
}



    - (void)setupNormalRootViewController {
        // create whatever your root view controller is going to be, in this case just a simple view controller
        // wrapped in a navigation controller
        
      //  self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:mainVC];
   
            //self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
            
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        viewController.title=@"Home";
        
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
        
        
           // self.window.rootViewController = viewController;
           // [self.window makeKeyAndVisible];
        
        
        
    }

-(void)setuplogin{
    
        
    
    [self setupHome:@"login"];
    
}


    
-(void)setupHome:(NSString *)canlog{
    
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        HomeViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
        viewController.gotologin = canlog;

        MenuTableViewController *leftViewController =[storyboard instantiateViewControllerWithIdentifier:@"MenuTableViewController"];
        
        viewController.title=@"Home";
        
        
        
        UIViewController *rootViewController = viewController;
       // UITableViewController *rightViewController = [UITableViewController new];
        
        UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
        
         LGSideMenuController *sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:navigationController
                                                                                               leftViewController:leftViewController
                                                                                              rightViewController:nil];
        
        sideMenuController.leftViewWidth = 250.0;
        sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleScaleFromBig;
        
        sideMenuController.rightViewWidth = 100.0;
        sideMenuController.leftViewPresentationStyle = LGSideMenuPresentationStyleSlideBelow;
        
        
        self.window.rootViewController = sideMenuController;
    
    
    
        
}


    
    
    

@end
