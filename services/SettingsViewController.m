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
#import "AppDelegate.h"





@interface SettingsViewController ()


@property (weak, nonatomic) IBOutlet UILabel *user_name_txt;
@property (weak, nonatomic) IBOutlet UILabel *mobile_number_txt;

@property (weak, nonatomic) IBOutlet UIImageView *user_pic;
@property (weak, nonatomic) IBOutlet UILabel *logout_btn;
- (IBAction)home_adr_btn:(UIButton *)sender;
- (IBAction)work_adr_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *home_adr_label;
@property (strong, nonatomic) IBOutlet UILabel *work_adr_label;
- (IBAction)changeImage:(id)sender;

@property (strong, nonatomic) IBOutlet UIImageView *edit_profile_img;
@property (strong, nonatomic) IBOutlet UILabel *devices_list_btn;
@end

@implementation SettingsViewController{
    GMSPlacePicker *placePicker;
    NSString *home_addressid;
    NSString *work_addressid;
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
    
    
    
    _devices_list_btn.userInteractionEnabled = YES;
    
    
    UITapGestureRecognizer *tapGestures =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(gotodevicesPage)];
    [_devices_list_btn addGestureRecognizer:tapGestures];
    
    
    
    
   // [GMSPlacesClient provideAPIKey:@"AIzaSyBvPYrrSZB4IpXt5gJpBqtG_pcOkEp406M"];
  //  [GMSServices provideAPIKey:@"AIzaSyBvPYrrSZB4IpXt5gJpBqtG_pcOkEp406M"];
    
    self.user_pic.layer.cornerRadius = self.user_pic.frame.size.width/2;
    self.user_pic.layer.borderWidth = 3.0f;
    self.user_pic.layer.borderColor = [UIColor colorWithRed:38.0/255.0 green:174.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    
    //38,174,238
    
    self.edit_profile_img.layer.cornerRadius = self.edit_profile_img.layer.frame.size.width/2;
    home_addressid=@"";
    work_addressid=@"";
    
    
    [self callapi:true];
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    if(appDelegate.image){
        self.user_pic.image = appDelegate.image;
    }else{
        [self getImage];
    }
    
    
    
    
    
}

-(void)labelTap{
    
    [self goback];
    
}


-(void)gotodevicesPage{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"DevicesViewController"];
    viewController.title = @"Devices List";
    
    [self.navigationController pushViewController:viewController animated:YES];
    
    
    
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




-(void)callapi:(Boolean *)show_progress{
    
    
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
        
        if(show_progress)
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
                        
                        
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                            
                            //Your code goes in here
                            NSLog(@"Main Thread Code");
                            _home_adr_label.text = [NSString stringWithFormat:@"%@",[address objectForKey:@"address1"]];
                            
                            home_addressid = [NSString stringWithFormat:@"%@",[address objectForKey:@"_id"]];
                            NSLog(@"home address %@",home_addressid);

                            
                        }];

                        
                        
                    }else{
                        
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                            
                            //Your code goes in here
                            NSLog(@"Main Thread Code");
                            _work_adr_label.text = [NSString stringWithFormat:@"%@",[address objectForKey:@"address1"]];
                            
                            work_addressid = [NSString stringWithFormat:@"%@",[address objectForKey:@"_id"]];
                            
                            NSLog(@"work address %@",work_addressid);

                            
                        }];
                        
                        
                        
                    }
                    
                }
                
                
            }
            else{
                           }
            
        }
        
    }] resume];
    
    if(show_progress)
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
                @"latitude":[NSString stringWithFormat:@"%f",place.coordinate.latitude],
                @"longitude":[NSString stringWithFormat:@"%f",place.coordinate.longitude],
                @"address1":[self getAddressLine:place]
                            };
            
            NSDictionary *parameters_up = @{
                                         @"sessionId": [defaults objectForKey:@"sessionid"],
                                         @"addressType":@"Home",
                                         @"city":[self getCity:place],
                                         @"state":[self getState:place],
                                         @"zipCode":[self getPincode:place],
                                         @"timeZone":@"IST",
                                         @"phone":@"phone",
                                         @"latitude":[NSString stringWithFormat:@"%f",place.coordinate.latitude],
                                         @"longitude":[NSString stringWithFormat:@"%f",place.coordinate.longitude],
                                         @"address1":[self getAddressLine:place],
                                         @"addressId":home_addressid

                                         };

            
            
            if(![home_addressid isEqualToString:@""]){
                [self updateAddress:parameters_up];
            }else{
                [self updateAddress:parameters];

            }
            
            


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
                                         @"latitude":[NSString stringWithFormat:@"%f",place.coordinate.latitude],
                                         @"longitude":[NSString stringWithFormat:@"%f",place.coordinate.longitude],
                                         @"address1":[self getAddressLine:place]
                                         };
            
            NSDictionary *parameters_up = @{
                                         
                                         @"sessionId": [defaults objectForKey:@"sessionid"],
                                         @"addressType":@"Work",
                                         @"city":[self getCity:place],
                                         @"state":[self getState:place],
                                         @"zipCode":[self getPincode:place],
                                         @"timeZone":@"IST",
                                         @"phone":@"phone",
                                         @"latitude":[NSString stringWithFormat:@"%f",place.coordinate.latitude],
                                         @"longitude":[NSString stringWithFormat:@"%f",place.coordinate.longitude],
                                         @"address1":[self getAddressLine:place],
                                         @"addressId":work_addressid

                                         };

            
            if(![work_addressid isEqualToString:@""]){
                [self updateAddress:parameters_up];
            }else{
                [self updateAddress:parameters];

            }
            


            
        } else {
            NSLog(@"No place selected");
        }
    }];


}


-(void)updateAddress:(NSDictionary *)info{
    
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
  //  NSURL *URL = [NSURL URLWithString:@"https://u-snap.herokuapp.com/api/providers/addAddress"];
    
    NSString *URLString = @"";
    
        if(![[info objectForKey:@"addressId"] isEqualToString:@""])
            URLString = @"https://u-snap.herokuapp.com/api/users/updateAddress";
        else
            URLString = @"https://u-snap.herokuapp.com/api/users/addAddress";

    
    //   [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:info error:nil];
    
    NSLog(@"parameters %@ ",info);
    NSLog(@"request %@ ",request);


    
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
                
                [self callapi:false];
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
    else
        return [NSString stringWithFormat:@"%@,%@",[self getLatitude:[NSString stringWithFormat:@"%f",place.coordinate.latitude]],[self getLongitude:[NSString stringWithFormat:@"%f",place.coordinate.longitude]]];
    
}

-(void)selectImage{
    
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    //You can retrieve the actual UIImage
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    
    //Or you can get the image url from AssetsLibrary
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    self.user_pic.contentMode = UIViewContentModeScaleAspectFill;
    self.user_pic.image = image;
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:image forKey:@"image"];

    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"profilePic" object:nil userInfo:dict];
    
    
    
    NSLog(@"path:%@",path.absoluteString);
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [self uploadimagebasic:info];
}

- (IBAction)changeImage:(id)sender {
    
    [self selectImage];
}



-(void)uploadpic:(NSDictionary *)info{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString *url = [NSString stringWithFormat:@"https://u-snap.herokuapp.com/api/users/uploadProfilePic/%@",[defaults objectForKey:@"sessionid"]];
    
    NSURL *path = [info valueForKey:UIImagePickerControllerReferenceURL];
    
    
    NSString *theFileName = [path.absoluteString lastPathComponent];
    NSLog(@"%@",theFileName);
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:url  parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:path
                                   name:@"profilePic"
                               fileName:theFileName
                               mimeType:@"image/jpeg"
                                  error:nil];
    } error:nil];
    
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask;

    uploadTask = [manager
                  uploadTaskWithStreamedRequest:request
                  progress:^(NSProgress * _Nonnull uploadProgress) {
                      // This is not called back on the main queue.
                      // You are responsible for dispatching to the main queue for UI updates
                      dispatch_async(dispatch_get_main_queue(), ^{
                          //Update the progress view
                          // [SVProgressHUD setProgress:uploadProgress.fractionCompleted];
                          
                          [SVProgressHUD showProgress:uploadProgress.fractionCompleted];
                          
                      });
                  }
                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                      [SVProgressHUD dismiss];
                      
                      if (error) {
                          NSLog(@"Error: %@", error);
                      } else {
                          NSLog(@"%@ %@", response, responseObject);
                      }
                  }];
    
    [uploadTask resume];
    [SVProgressHUD show];
}


-(void)uploadimagebasic:(NSDictionary *)info{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString *url = [NSString stringWithFormat:@"https://u-snap.herokuapp.com/api/users/uploadProfilePic/%@",[defaults objectForKey:@"sessionid"]];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];

    
    NSData *imageData = UIImageJPEGRepresentation(image, 1.0);
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    [request setHTTPShouldHandleCookies:NO];
    [request setTimeoutInterval:60];
    [request setHTTPMethod:@"POST"];
    
    NSString *boundary = @"unique-consistent-string";
    
    // set Content-Type in HTTP header
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // post body
    NSMutableData *body = [NSMutableData data];
    
    // add params (all params are strings)
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@\r\n\r\n", @"profilePic"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@\r\n", @"profilePic"] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add image data
    
    
    if (imageData) {
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"profilePic"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"Content-Type: image/jpeg\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:imageData];
        [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    }
    
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    // setting the body of the post to the reqeust
    [request setHTTPBody:body];
    
    // set the content-length
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[body length]];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue currentQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if(data.length > 0)
        {
            //success
            
            [SVProgressHUD dismiss];
            
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"response %@", response );
                
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"data %@", json );
                
                if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                    [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];

                    
                
                }else{
                    [self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];

                }
                

            }
            
            
        }
    }];
    [SVProgressHUD show];
    
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
        [SVProgressHUD dismiss];
        
        NSLog(@"eror:%@",error);
        NSLog(@"response:%@",response.description);
        
        if(data == nil){
            [self showAlert:error.localizedDescription withtittle:@"Error"];

        }
        else{
            
            NSLog(@"data:%@",data);
            
            UIImage *image = [UIImage imageWithData:data];
            
            if(image!=nil){
                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                    self.user_pic.image = image;
                }];
            }
            }
            
        
    }] resume];
    [SVProgressHUD show];
    
    

    
}


@end
