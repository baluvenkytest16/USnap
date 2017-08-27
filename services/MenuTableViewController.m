//
//  MenuTableViewController.m
//  services
//
//  Created by Mac on 4/20/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "MenuTableViewController.h"
#import "MenuTableViewCell.h"
#import "UIViewController+LGSideMenuController.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import "MyWarrantysViewController.h"



@interface MenuTableViewController ()

    @property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *become_sp;
@property (weak, nonatomic) IBOutlet UILabel *user_name_txt;
@property (weak, nonatomic) IBOutlet UILabel *user_phone_txt;
@property (weak, nonatomic) IBOutlet UIImageView *user_image;

@end

@implementation MenuTableViewController
    
    {
        NSArray *tableData;
        NSArray *tableimages;

    }


- (void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"%@",@"will appear");
}// Called when the view is about to made visible. Default does nothing
- (void)viewDidAppear:(BOOL)animated{
    NSLog(@"%@",@"did appear");

}// Called when the view has been fully transitioned onto the screen. Default does nothing
- (void)viewWillDisappear:(BOOL)animated{
    NSLog(@"%@",@"will disappear");

}// Called when the view is dismissed, covered or otherwise hidden. Default does nothing
- (void)viewDidDisappear:(BOOL)animated{
    NSLog(@"%@",@"did disappear");

}// Called after the view was


- (void)updateUserDetails{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
        _user_name_txt.alpha=1;
        _user_phone_txt.alpha=1;
        _user_image.alpha=1;
        _user_name_txt.text = [defaults objectForKey:@"username"];
        _user_phone_txt.text = [defaults objectForKey:@"userphone"];
        
    }else{
        _user_name_txt.alpha=0;
        _user_phone_txt.alpha=0;
        _user_image.alpha=0;
    
    }
}

-(void)updateMenu{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
        
        if([[defaults valueForKey:@"role"] isEqualToString:@"user"]){
            
            _become_sp.text = @"Become a service provider";
            tableData = [NSArray arrayWithObjects:@"My Favorites", @"Order History", @"Notifications", @"Refer a Friend", @"Settings",@"Service Request", nil];
            
            tableimages = [NSArray arrayWithObjects:@"my-fav", @"order-history", @"notifications", @"refer-friend", @"settings",@"service_request", nil];
            
            
            [self.tableView reloadData];
            
            
        }else{
            _become_sp.text = @"Update service details";
            tableData = [NSArray arrayWithObjects:@"My Favorites", @"Order History", @"Notifications", @"Refer a Friend", @"Settings",@"Service Request",@"Available jobs", nil];
            
            tableimages = [NSArray arrayWithObjects:@"my-fav", @"order-history", @"notifications", @"refer-friend", @"settings",@"service_request",@"service_request", nil];
            
            
            [self.tableView reloadData];
            
        }

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    

   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserDetails) name:@"LeftOpen" object:nil];

    [self.tableView registerNib:[UINib nibWithNibName:@"MenuTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"MenuTableViewCell"];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.scrollEnabled = YES;
    
    [self updateMenu];
    
    _become_sp.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(gotospsignup)];
    [_become_sp addGestureRecognizer:tapGesture];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // check if user is alraidy Login
    if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
        _user_name_txt.alpha=1;
        _user_phone_txt.alpha=1;
        _user_image.alpha=1;
        
        _user_name_txt.text = [defaults objectForKey:@"username"];
        _user_phone_txt.text = [defaults objectForKey:@"userphone"];
        
        NSLog(@"role:%@",[defaults valueForKey:@"role"]);
        if([[defaults valueForKey:@"role"] isEqualToString:@"user"]){
         
         _become_sp.text = @"Become a service provider";
            
        }else{
            _become_sp.text = @"Update service details";

        }
    }else{
        _user_name_txt.alpha=0;
        _user_phone_txt.alpha=0;
        _user_image.alpha=0;

        
    }
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(profilePicSelected:) name:@"profilePic" object:nil];
    //serviceregistered
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(serviceUpdated:) name:@"serviceregistered" object:nil];
    
    
    self.user_image.layer.cornerRadius = self.user_image.frame.size.width/2;
    self.user_image.layer.borderWidth = 1.0f;
    self.user_image.layer.borderColor = [UIColor colorWithRed:38.0/255.0 green:174.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    self.user_image.clipsToBounds = YES;
    [self getImage];

}


-(void)profilePicSelected:(NSNotification *) notification
{
    
    NSDictionary *dict = notification.userInfo;
    UIImage *message = [dict valueForKey:@"image"];
    
    if (message != nil) {
        
        self.user_image.image=message;
    }
    
    
}

-(void)serviceUpdated:(NSNotification *) notification{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"provider" forKey:@"role"];
    [defaults synchronize];    
    _become_sp.text = @"Update service details";
    _become_sp.userInteractionEnabled = YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [tableData count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuTableViewCell" forIndexPath:indexPath];
    
    
//    if(indexPath.row == 5){
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *firstName = [defaults objectForKey:@"userid"];
//        if(firstName == NULL)
//            [cell.title setText:@"Log In"] ;
//        else
//            [cell.title setText:@"Log Out"] ;
//
//    }else
    
    [cell.title setText:[tableData objectAtIndex:indexPath.row]] ;
    
    cell.image.image= [UIImage imageNamed:[tableimages objectAtIndex:indexPath.row]];

    return cell;
}

    - (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
        
        if(indexPath.row == 5){
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            // check if user is alraidy Login
            if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
                // Redirected to Dashboard.
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                MyWarrantysViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"MyWarrantysViewController"];
                
                //viewController.title = @"My Warrantys";
                viewController.user_type=@"user";

                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
                
            }else{
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
            }

        }
        else if(indexPath.row == 0){
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            // check if user is alraidy Login
            if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
                // Redirected to Dashboard.
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"FavViewController"];
                viewController.title = @"My Favorites";
                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
                
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
            }
            
        }

        else if(indexPath.row == 1){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            // check if user is alraidy Login
            if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
                // Redirected to Dashboard.
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"OrderHistoryViewController"];
                viewController.title = @"Order History";

                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
                
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
            }

        }else if(indexPath.row == 2){
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            // check if user is alraidy Login
            if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
                // Redirected to Dashboard.
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"NotificationsViewController"];
                viewController.title = @"Notifications";

                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
                
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
            }

        }
        
       else if(indexPath.row == 3){
            
            NSString *textToShare = @"Servicess app";
            NSArray *array = [NSArray arrayWithObjects:textToShare, nil];
            UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:array applicationActivities:nil];
            
            activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll]; //Exclude whichever aren't relevant
            
            [self presentActivityController:activityVC];
            
        }
        else if(indexPath.row == 4){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            // check if user is alraidy Login
            if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
                // Redirected to Dashboard.
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
                
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];

            }
        }else if (indexPath.row==6){
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            // check if user is alraidy Login
            if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
                // Redirected to Dashboard.
                
                [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
                
                
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                MyWarrantysViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"MyWarrantysViewController"];
                viewController.user_type=@"sp";
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];

                
            }else{
                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                
                UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
                
                UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
                
                [navigationController pushViewController:viewController animated:YES];
                
            }
        }

        else{
            
    
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
        
        [navigationController pushViewController:viewController animated:YES];

        }
        
            }

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)presentActivityController:(UIActivityViewController *)controller {
    
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController:controller animated:YES completion:nil];
    
    UIPopoverPresentationController *popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString *activityType,
                                              BOOL completed,
                                              NSArray *returnedItems,
                                              NSError *error){
        // react to the completion
        if (completed) {
            // user shared an item
            NSLog(@"We used activity type%@", activityType);
        } else {
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }
        
        if (error) {
            NSLog(@"An Error occured: %@, %@", error.localizedDescription, error.localizedFailureReason);
        }
    };
}

-(void) showAlert{
    [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];

    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Thank you" message:@"Your request to become a service provider is registered with us. One of our executives will contact you with in 24 hours. Thank you." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Thank you" message:@"Your request to become a service provider is registered with us. One of our executives will contact you with in 24 hours. Thank you." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
    
    
    
    
}

-(void)gotospsignup{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if([[defaults valueForKey:@"role"] isEqualToString:@"user"]){
        
        [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"SPSignUpViewController"];
        viewController.title = @"Select Service";
        UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
        
        [navigationController pushViewController:viewController animated:YES];

    }else{
        
        [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
        
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MyWarrantysViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"MyWarrantysViewController"];
        viewController.user_type=@"sp";
        UINavigationController *navigationController = (UINavigationController *)self.sideMenuController.rootViewController;
        
        [navigationController pushViewController:viewController animated:YES];
        
    }

    
    
    
}


-(void)showAlertlogout{
    
    [self.sideMenuController hideLeftViewAnimated:YES completionHandler:nil];
    
    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Thank you" message:@"You have successfully loged out of this application." preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"Thank you" message:@"You have successfully loged out of this application." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}


-(void)getImage{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@",
                      [defaults objectForKey:@"sessionid"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/users/getProfilePicture"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        NSLog(@"eror:%@",error);
        NSLog(@"response:%@",response.description);
        
        if(data == nil){
           // [self showAlert:error.localizedDescription withtittle:@"Error"];
            NSLog(@"data:%@",@"nodata");

        }
        else{
            
            //NSLog(@"data:%@",data);
            
            
            AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

            UIImage *image = [UIImage imageWithData:data];
            appDelegate.image = image;
            
            
            if(image!=nil){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                    self.user_image.image = image;
                }];
            }
        }
        
        
    }] resume];
    
    
    
    
}





@end
