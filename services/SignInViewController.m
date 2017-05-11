//
//  SignInViewController.m
//  services
//
//  Created by Mac on 4/19/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SignInViewController.h"
#import "SVProgressHUD.h"
#import "HomeViewController.h"
#import "MenuTableViewController.h"

@import LGSideMenuController;



@interface SignInViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *emailtf;
    @property (weak, nonatomic) IBOutlet UIButton *logbtn;
    @property (weak, nonatomic) IBOutlet UIButton *fb_btn;
    @property (weak, nonatomic) IBOutlet UILabel *signup_hint;
@property (weak, nonatomic) IBOutlet UITextField *password_txt;
- (IBAction)login_btn_action:(id)sender;
    
@end

@implementation SignInViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.emailtf.delegate = self;
    
    
    self.emailtf.borderStyle = 0;
    
    [self.emailtf layoutIfNeeded];
    
    
    CALayer *border = [CALayer new];
    
    CGFloat width = 2.0;
    
    
    border.borderColor = [UIColor lightGrayColor].CGColor;
    
   // print(firstTextField.frame)
    
    border.frame = CGRectMake( 0, _emailtf.frame.size.height - width,  _emailtf.frame.size.width, _emailtf.frame.size.height);
    
    
    border.borderWidth = width;
    
    [self.emailtf.layer addSublayer:border];
    
    self.emailtf.layer.masksToBounds = true;
    
    
    CALayer *border1 = [CALayer new];
    
    CGFloat width1 = 2.0;
    
    
    border1.borderColor = [UIColor lightGrayColor].CGColor;
    
    // print(firstTextField.frame)
    
    border1.frame = CGRectMake( 0, _password_txt.frame.size.height - width1,  _password_txt.frame.size.width, _password_txt.frame.size.height);
    
    
    border1.borderWidth = width1;
    
    [self.password_txt.layer addSublayer:border1];
    
    self.password_txt.layer.masksToBounds = true;
    
    
    
    self.logbtn.layer.cornerRadius = 10;
    
    self.fb_btn.layer.cornerRadius=10;
    
    
    NSString *myString = @"New here ? Sign Up";
    
    //Create mutable string from original one
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
    
    //Fing range of the string you want to change colour
    //If you need to change colour in more that one place just repeat it
    
    NSRange range = [myString rangeOfString:@"Sign Up"];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(255/255.0) alpha:1.0] range:range];
    
    //Add it to the label - notice its not text property but it's attributeText
    _signup_hint.attributedText = attString;
    
    _signup_hint.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(labelTap)];
    [_signup_hint addGestureRecognizer:tapGesture];
    
    
}
    
    -(void)labelTap{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
        
       // [self.navigationController pushViewController:viewController animated:YES];
        
        [self presentViewController:viewController animated:YES completion:nil];
        
        
        
        
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
    - (BOOL)textFieldShouldReturn:(UITextField *)textField
    {
        [textField resignFirstResponder];
        return YES;
    }



-(void)validateform{
    if(self.emailtf.text.length==0){
        [self showAlert:@"Please Enter Email ID" withtittle:@"Error"];
    }else if(self.password_txt.text.length==0){
        [self showAlert:@"Please Enter Password" withtittle:@"Error"];
    }else{
        [self callapi];
    }
    
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
    
    
    [self  presentViewController:sideMenuController animated:YES completion:Nil];
    
    
    
    
}


-(void)goback{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LoginChanged" object:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"HomeViewController"];
    viewController.title=@"Home";
    
   // self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    [self presentViewController:[[UINavigationController alloc] initWithRootViewController:viewController] animated:YES completion:nil];
    
    
}

-(void)showAlert:(NSString *)message withtittle:(NSString *)tittle{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
    
    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tittle message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 if([tittle isEqualToString:@"Success"])
                                 [self setupHome:@"nologin"];
                                 
                                 
                             }];
        
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];

    }
    else{
        [self setupHome:@"nologin"];
    }
        
        });
}



-(void)callapi{
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"email=%@&password=%@",
                      self.emailtf.text,
                      self.password_txt.text];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/auth/login"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"eror:%@",error);
        NSLog(@"response:%@",response.description);
        

        
        if(data == nil){
            [self showAlert:error.localizedDescription withtittle:@"Error"];
        }
        else{
         
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",[json objectForKey:@"error_code"]);
            
            if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                
                id user_json = [json objectForKey:@"userProfile"];
                
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                
                [defaults setObject:[user_json objectForKey:@"fullName"] forKey:@"username"];
                [defaults setObject:[user_json objectForKey:@"phone"] forKey:@"userphone"];

                [defaults setObject:[user_json objectForKey:@"userId"] forKey:@"userid"];
                [defaults setObject:[json objectForKey:@"sessionId"] forKey:@"sessionid"];

                
                [defaults synchronize];
                
                
                
                
                
                [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];

            }
            else{
                [self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];
            }
            
        }
        
    }] resume];
    [SVProgressHUD show];
    
    
    
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)login_btn_action:(id)sender {
    [self validateform];
}
@end
