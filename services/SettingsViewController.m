//
//  SettingsViewController.m
//  services
//
//  Created by Mac on 5/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SettingsViewController.h"
#import "SVProgressHUD.h"
#import <GoogleMaps/GoogleMaps.h>
#import <GooglePlaces/GooglePlaces.h>
#import <GooglePlacePicker/GooglePlacePicker.h>
#import "AFNetworking.h"





@interface SettingsViewController ()


@property (weak, nonatomic) IBOutlet UILabel *user_name_txt;
@property (weak, nonatomic) IBOutlet UILabel *mobile_number_txt;

@property (weak, nonatomic) IBOutlet UIImageView *user_pic;
@property (weak, nonatomic) IBOutlet UILabel *logout_btn;
- (IBAction)home_adr_btn:(UIButton *)sender;
- (IBAction)work_adr_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *home_adr_label;
@property (strong, nonatomic) IBOutlet UILabel *work_adr_label;

@end

@implementation SettingsViewController{
    GMSPlacePicker *placePicker;
}


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
    
    [GMSPlacesClient provideAPIKey:@"AIzaSyBvPYrrSZB4IpXt5gJpBqtG_pcOkEp406M"];
    [GMSServices provideAPIKey:@"AIzaSyBvPYrrSZB4IpXt5gJpBqtG_pcOkEp406M"];
    
    
    [self callapi];
    
}

-(void)labelTap{
    
    [self goback];
    
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
                      [defaults objectForKey:@"sessionid"]];
    
    NSLog(@"%@",post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/users/getAddresses"]];
    
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
            
            
            if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                
                NSMutableArray *user_json = [json objectForKey:@"userAddresses"];
                
                for(int i=0;i<user_json.count;i++){
                    
                    id address = [user_json objectAtIndex:i];
                    
                    NSLog(@"%@",address);

                    
                    if( [[address objectForKey:@"addressType"] isEqualToString:@"Home"]){
                        
                        NSLog(@"%@",[address objectForKey:@"address1"]);
                        
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                            
                            //Your code goes in here
                            NSLog(@"Main Thread Code");
                            _home_adr_label.text = [NSString stringWithFormat:@"%@",[address objectForKey:@"address1"]];
                            
                            
                        }];

                        
                        
                    }else{
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                            
                            //Your code goes in here
                            NSLog(@"Main Thread Code");
                            _work_adr_label.text = [NSString stringWithFormat:@"%@",[address objectForKey:@"address1"]];
                            
                            
                        }];
                        
                        
                        
                    }
                    
                }
                
                
            }
            else{
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
//                                     if([tittle isEqualToString:@"Success"])
//                                         [self goback];
//                                     
//                                     
                                 }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else{
          //  [self goback];
        }
        
    });
}


- (IBAction)home_adr_btn:(UIButton *)sender {
    
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    
    placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    
    [placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place attributions %@", place.attributions.string);
            
            
            
            
            if(place.formattedAddress.length != 0)
            self.home_adr_label.text = place.formattedAddress;
            else
            self.home_adr_label.text = place.name;
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

            NSDictionary *parameters = @{
               @"sessionId": [defaults objectForKey:@"sessionid"],
                @"addressType":@"Home",
                @"city":[self getCity:place],
                @"state":[self getState:place],
                @"zipCode":[self getPincode:place],
                @"timeZone":@"IST",
                @"phone":@"phone",
                @"latitude":[self getLatitude:place.name],
                @"longitude":[self getLongitude:place.name],
                @"address1":[self getAddressLine:place]
                            };
            
            [self updateAddress:parameters];
            


        } else {
            NSLog(@"No place selected");
        }
    }];

}

- (IBAction)work_adr_btn:(id)sender {
    GMSPlacePickerConfig *config = [[GMSPlacePickerConfig alloc] initWithViewport:nil];
    
    placePicker = [[GMSPlacePicker alloc] initWithConfig:config];
    
    
    [placePicker pickPlaceWithCallback:^(GMSPlace *place, NSError *error) {
        if (error != nil) {
            NSLog(@"Pick Place error %@", [error localizedDescription]);
            return;
        }
        
        if (place != nil) {
            NSLog(@"Place name %@", place.name);
            
            NSLog(@"Place address %@", place.formattedAddress);
            NSLog(@"Place attributions %@", place.attributions.string);
            if(place.formattedAddress.length != 0)
                self.work_adr_label.text = place.formattedAddress;
            else
                self.work_adr_label.text = place.name;
            
            
            
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSDictionary *parameters = @{
                                         
                                         @"sessionId": [defaults objectForKey:@"sessionid"],
                                         @"addressType":@"Work",
                                         @"city":[self getCity:place],
                                         @"state":[self getState:place],
                                         @"zipCode":[self getPincode:place],
                                         @"timeZone":@"IST",
                                         @"phone":@"phone",
                                         @"latitude":[self getLatitude:place.name],
                                         @"longitude":[self getLongitude:place.name],
                                         @"address1":[self getAddressLine:place]
                                         };
            
            [self updateAddress:parameters];


            
        } else {
            NSLog(@"No place selected");
        }
    }];


}


-(void)updateAddress:(NSDictionary *)info{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
  //  NSURL *URL = [NSURL URLWithString:@"https://u-snap.herokuapp.com/api/providers/addAddress"];
    
    NSString *URLString = @"https://u-snap.herokuapp.com/api/users/addAddress";
    
    
    //   [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:info error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [SVProgressHUD dismiss];
        
        if (error) {
            [self showAlert:error.localizedDescription withtittle:@"Error"];
        } else {
            
            if(![[responseObject objectForKey:@"error_code"] isEqualToString:@"0"]){
                
                [self showAlert:[responseObject objectForKey:@"message"] withtittle:@"Error"];
            }
            else{
                [self showAlert:[responseObject objectForKey:@"message"] withtittle:@"Success"];
            }
            
            
            
            NSLog(@"%@ %@", response, responseObject);
        }
    }];
    [dataTask resume];
    [SVProgressHUD show];

    
}

-(NSString *)getLatitude:(NSString *) place{
    
    if ([place hasPrefix:@"("]) {
        place = [place substringFromIndex:1];
    }
    if ([place length] > 0) {
        place = [place substringToIndex:[place length] - 1];
    } else {
        //no characters to delete... attempting to do so will result in a crash
        return @"";

    }
    
    NSArray* foo = [place componentsSeparatedByString: @","];
    
    NSString* firstBit = [foo firstObject];
    
    return firstBit;
}


-(NSString *)getLongitude:(NSString *) place{
    
    if ([place hasPrefix:@"("]) {
        place = [place substringFromIndex:1];
    }
    if ([place length] > 0) {
        place = [place substringToIndex:[place length] - 1];
    } else {
        //no characters to delete... attempting to do so will result in a crash
        
        return @"";

    }
    
    NSArray* foo = [place componentsSeparatedByString: @","];
    NSString* lastbit = [foo lastObject];
    
    
    
    return lastbit;
}

-(NSString *)getCity:(GMSPlace *) place{
    
    
    NSArray* dic = [place valueForKey:@"addressComponents"];
    
    for (int i=0;i<[dic count];i++) {
        if ([[[dic objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"locality"]) {
            NSLog(@"street_number: %@",[[dic objectAtIndex:i] valueForKey:@"name"]);
            
            return [[dic objectAtIndex:i] valueForKey:@"name"];
        }
    }
    
    return @"";
}



-(NSString *)getState:(GMSPlace *) place{
    
    
    NSArray* dic = [place valueForKey:@"addressComponents"];
    
    for (int i=0;i<[dic count];i++) {
        if ([[[dic objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"administrative_area_level_1"]) {
            NSLog(@"street_number: %@",[[dic objectAtIndex:i] valueForKey:@"name"]);
            
            return [[dic objectAtIndex:i] valueForKey:@"name"];
        }
    }
    
    return @"";
}


-(NSString *)getPincode:(GMSPlace *) place{
    
    
    NSArray* dic = [place valueForKey:@"addressComponents"];
    
    for (int i=0;i<[dic count];i++) {
        if ([[[dic objectAtIndex:i] valueForKey:@"type"] isEqualToString:@"postal_code"]) {
            NSLog(@"street_number: %@",[[dic objectAtIndex:i] valueForKey:@"name"]);
            
            return [[dic objectAtIndex:i] valueForKey:@"name"];
        }
    }
    
    return @"";
}


-(NSString *)getAddressLine:(GMSPlace *) place{
    
    if(place.formattedAddress.length!=0)
        return place.formattedAddress;
    else if(place.name.length!=0)
        return place.name;
    else
        return @"";
}


@end
