//
//  SettingsViewController.m
//  services
//
//  Created by Mac on 5/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SettingsViewController.h"
#import "SVProgressHUD.h"

@interface SettingsViewController ()
@property (weak, nonatomic) IBOutlet UILabel *user_name_txt;
@property (weak, nonatomic) IBOutlet UILabel *mobile_number_txt;

@property (weak, nonatomic) IBOutlet UIImageView *user_pic;
@property (weak, nonatomic) IBOutlet UILabel *logout_btn;
@end

@implementation SettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    // check if user is alraidy Login
    if([defaults objectForKey:@"username"]!=nil  && ![[defaults objectForKey:@"username"] isEqualToString:@""]){
        // Redirected to Dashboard.
        _user_name_txt.text = [defaults objectForKey:@"username"];
        _mobile_number_txt.text = [defaults objectForKey:@"userphone"];

        
    }
    _logout_btn.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(labelTap)];
    [_logout_btn addGestureRecognizer:tapGesture];
    
}

-(void)labelTap{
    [self callapi];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/




-(void)callapi{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@",
                      [defaults objectForKey:@"sessionId"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/auth/logout"]];
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


-(void)goback{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults removeObjectForKey:@"username"];
    [defaults removeObjectForKey:@"userphone"];
    [defaults removeObjectForKey:@"userid"];
    [defaults removeObjectForKey:@"sessionid"];
    [defaults synchronize];
    
    //[[NSNotificationCenter defaultCenter] postNotificationName:@"LoginChanged" object:nil];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];

    [self presentViewController:viewController animated:YES completion:nil];
    
}

-(void)showAlert:(NSString *)message withtittle:(NSString *)tittle{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        if ([UIAlertController class])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tittle message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
                                     if([tittle isEqualToString:@"Success"])
                                         [self goback];
                                     
                                     
                                 }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else{
            [self goback];
        }
        
    });
}


@end
