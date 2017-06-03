//
//  SignUpViewController.m
//  services
//
//  Created by Mac on 4/19/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SignUpViewController.h"
#import "AFNetworking.h"
#import "SVProgressHUD.h"

@interface SignUpViewController ()
    @property (weak, nonatomic) IBOutlet UITextField *fullnameTF;
@property (weak, nonatomic) IBOutlet UITextField *lastnameTF;
    @property (weak, nonatomic) IBOutlet UITextField *mobileTF;
    @property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;
@property (weak, nonatomic) IBOutlet UITextField *conformPasswordTF;
    @property (weak, nonatomic) IBOutlet UIButton *signuobtn;
    @property (weak, nonatomic) IBOutlet UIButton *fbsignup;
    @property (weak, nonatomic) IBOutlet UILabel *loginhint;
- (IBAction)signupclick:(id)sender;

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //one
    CALayer *border1 = [CALayer new];
    CGFloat width1 = 2.0;
    border1.borderColor = [UIColor lightGrayColor].CGColor;
    border1.frame = CGRectMake( 0, _fullnameTF.frame.size.height - width1,  _fullnameTF.frame.size.width, _fullnameTF.frame.size.height);
    border1.borderWidth = width1;
    [self.fullnameTF.layer addSublayer:border1];
    self.fullnameTF.layer.masksToBounds = true;
    
    //two
    CALayer *border2 = [CALayer new];
    CGFloat widthtwo = 2.0;
    
    border2.borderColor = [UIColor lightGrayColor].CGColor;
    
    border2.frame = CGRectMake( 0, _mobileTF.frame.size.height - width1,  _mobileTF.frame.size.width, _mobileTF.frame.size.height);
    
    border2.borderWidth = widthtwo;
    
    [self.mobileTF.layer addSublayer:border2];
    self.mobileTF.layer.masksToBounds = true;
    
    //three
    CALayer *border3 = [CALayer new];
    CGFloat width3 = 2.0;
    
    border3.borderColor = [UIColor lightGrayColor].CGColor;
    border3.frame = CGRectMake( 0, _passwordTF.frame.size.height - width3,  _passwordTF.frame.size.width, _passwordTF.frame.size.height);
    border3.borderWidth = width3;
    
    [self.passwordTF.layer addSublayer:border3];
    self.passwordTF.layer.masksToBounds = true;
    
    
    //four
    CALayer *border4 = [CALayer new];
    CGFloat width4 = 2.0;
    
    border4.borderColor = [UIColor lightGrayColor].CGColor;
    border4.frame = CGRectMake( 0, _lastnameTF.frame.size.height - width4,  _lastnameTF.frame.size.width, _lastnameTF.frame.size.height);
    border4.borderWidth = width4;
    
    [self.lastnameTF.layer addSublayer:border4];
    self.lastnameTF.layer.masksToBounds = true;

    //five
    CALayer *border5 = [CALayer new];
    CGFloat width5 = 2.0;
    
    border5.borderColor = [UIColor lightGrayColor].CGColor;
    border5.frame = CGRectMake( 0, self.emailTF.frame.size.height - width5,  self.emailTF.frame.size.width, self.emailTF.frame.size.height);
    border5.borderWidth = width5;
    
    [self.emailTF.layer addSublayer:border5];
    self.emailTF.layer.masksToBounds = true;

    
    //six
    CALayer *border6 = [CALayer new];
    CGFloat width6 = 2.0;
    
    border6.borderColor = [UIColor lightGrayColor].CGColor;
    border6.frame = CGRectMake( 0, self.conformPasswordTF.frame.size.height - width6,  self.conformPasswordTF.frame.size.width, self.conformPasswordTF.frame.size.height);
    border6.borderWidth = width6;
    
    [self.conformPasswordTF.layer addSublayer:border6];
    self.conformPasswordTF.layer.masksToBounds = true;


    self.signuobtn.layer.cornerRadius = 10;
    
    self.fbsignup.layer.cornerRadius=10;
    
    
    NSString *myString = @"Already Registered ? Login Now";
    
    //Create mutable string from original one
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:myString];
    
    //Fing range of the string you want to change colour
    //If you need to change colour in more that one place just repeat it
    
    NSRange range = [myString rangeOfString:@"Login Now"];
    [attString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:(0/255.0) green:(0/255.0) blue:(255/255.0) alpha:1.0] range:range];
    
    //Add it to the label - notice its not text property but it's attributeText
    _loginhint.attributedText = attString;
    
    _loginhint.userInteractionEnabled = YES;
    

    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(labelTap)];
    [_loginhint addGestureRecognizer:tapGesture];
    
    
}

    -(void)labelTap{
        
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
       // [self.navigationController pushViewController:viewController animated:YES];
        [self presentViewController:viewController animated:YES completion:nil];
        
        
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

-(void)validateform{
    if(self.fullnameTF.text.length==0){
        [self showAlert:@"Please Enter First Name" withtittle:@"Error"];
    }else if(self.lastnameTF.text.length==0){
        [self showAlert:@"Please Enter Last Name" withtittle:@"Error"];
    }else if(self.mobileTF.text.length==0){
        [self showAlert:@"Please Enter Mobile Number" withtittle:@"Error"];
    }else if(self.passwordTF.text.length==0){
        [self showAlert:@"Please Enter Mail" withtittle:@"Error"];
    }else if(self.emailTF.text.length==0){
        [self showAlert:@"Please Enter Password" withtittle:@"Error"];
    }else if(![self.emailTF.text isEqualToString:self.conformPasswordTF.text]){
        [self showAlert:@"Please Confirm Password" withtittle:@"Error"];
    }else{
        [self callapi];
    }
    
}

-(void)callapi{
    


    NSString *post = [NSString stringWithFormat:
                      @"email=%@&password=%@&confirmPassword=%@&firstName=%@&lastName=%@&phone=%@",
                      self.passwordTF.text,
                      self.emailTF.text,
                      self.conformPasswordTF.text,
                      self.fullnameTF.text,
                      self.lastnameTF.text,
                      self.mobileTF.text];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/auth/register"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                [SVProgressHUD dismiss];
        if(data == nil){
            [self showAlert:error.localizedDescription withtittle:@"Error"];
        }
        else{
            
        
        id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"%@",[json objectForKey:@"error_code"]);
        
        if([json objectForKey:@"error_code"]!=NULL){ 
            
            [self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];
        }
        else{
            [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
        }

        }
        
        
        
    }] resume];
        [SVProgressHUD show];


    
    
}


-(void)showAlert:(NSString *)message withtittle:(NSString *)tittle{
    
    
    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tittle message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:tittle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}


- (IBAction)signupclick:(id)sender {
    
    [self validateform];
}
@end
