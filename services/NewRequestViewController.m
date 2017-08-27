//
//  NewRequestViewController.m
//  services
//
//  Created by Mac on 7/25/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "NewRequestViewController.h"
#import "CZPickerView.h"
#import "SVProgressHUD.h"
#import "ImageCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@import YangMingShan;



@interface NewRequestViewController ()<UITextViewDelegate,CZPickerViewDelegate,CZPickerViewDataSource,UIImagePickerControllerDelegate,YMSPhotoPickerViewControllerDelegate>
{
    NSMutableArray *imgList;
    NSMutableArray *namesList;
    NSMutableArray *idList;
    
    NSMutableArray *imgListsub;
    NSMutableArray *namesListsub;
    NSMutableArray *idListsub;

    NSDictionary *image_path;
    NSDictionary *image_path1;
    NSDictionary *image_path2;
    NSMutableArray *pathList;
    NSNumber *number;
    int value;
    
}

@property (strong, nonatomic) IBOutlet UITextView *post_title;
@property (strong, nonatomic) IBOutlet UITextView *post_desc;
@property (strong, nonatomic) IBOutlet UILabel *select_cat;
@property (strong, nonatomic) IBOutlet UILabel *select_sub_cat;
@property (strong, nonatomic) IBOutlet UILabel *cat_hint;
@property (strong, nonatomic) IBOutlet UILabel *sub_cat_hint;
- (IBAction)request_btn:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *submit_btn;

- (IBAction)newImagePicker:(id)sender;
@property (strong, nonatomic) IBOutlet UICollectionView *imagesCollection;
@end

@implementation NewRequestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    pathList = [[NSMutableArray alloc] init];

    namesList=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    imgList=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    idList=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    
    namesListsub=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    imgListsub=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    idListsub=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    

    _post_title.delegate = self;
    _post_title.text = @"Title";
    _post_title.textColor = [UIColor lightGrayColor];
    
    //_post_title.layer.borderWidth=1;
    //_post_title.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_post_title.layer.cornerRadius=5;
    _post_title.tag=1;
    
    
    _post_desc.delegate = self;
    _post_desc.text = @"Description";
    _post_desc.textColor = [UIColor lightGrayColor];
    
    //_post_desc.layer.borderWidth=1;
    //_post_desc.layer.borderColor = [UIColor lightGrayColor].CGColor;
    //_post_desc.layer.cornerRadius=5;
    _post_desc.tag=2;
    
    
//    _select_cat.layer.borderWidth=1;
//    _select_cat.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _select_cat.layer.cornerRadius=5;
//    
//    _select_sub_cat.layer.borderWidth=1;
//    _select_sub_cat.layer.borderColor = [UIColor lightGrayColor].CGColor;
//    _select_sub_cat.layer.cornerRadius=5;
//    
    
    _select_cat.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturecat =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(selectCat)];
    [_select_cat addGestureRecognizer:tapGesturecat];
    
    _select_sub_cat.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesturesubcat =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(selectSubCat)];
    [_select_sub_cat addGestureRecognizer:tapGesturesubcat];
    _submit_btn.layer.cornerRadius=5;
    
    self.imagesCollection.dataSource = self;
    self.imagesCollection.delegate = self;
    [self callapi];
    
}

-(void)selectImagePicker{
    
    UIColor *customColor = [UIColor colorWithRed:64.0/255.0 green:0.0 blue:144.0/255.0 alpha:1.0];
    UIColor *customCameraColor = [UIColor colorWithRed:86.0/255.0 green:1.0/255.0 blue:236.0/255.0 alpha:1.0];
    YMSPhotoPickerViewController *pickerViewController = [[YMSPhotoPickerViewController alloc] init];
    pickerViewController.numberOfPhotoToSelect = 10;
    pickerViewController.theme.titleLabelTextColor = [UIColor whiteColor];
    pickerViewController.theme.navigationBarBackgroundColor = customColor;
    pickerViewController.theme.tintColor = [UIColor whiteColor];
    pickerViewController.theme.orderTintColor = customCameraColor;
    pickerViewController.theme.cameraVeilColor = customCameraColor;
    pickerViewController.theme.cameraIconColor = [UIColor whiteColor];
    pickerViewController.theme.statusBarStyle = UIStatusBarStyleLightContent;
    [self yms_presentCustomAlbumPhotoView:pickerViewController delegate:self];

}




-(void)selectImage{
    _count = @"0";
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
-(void)selectImageone{
    _count = @"1";
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}
-(void)selectImagetwo{
    _count = @"2";
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
    
    //NSDictionary *dict = [NSDictionary dictionaryWithObject:image forKey:@"image"];
    
    
   // [[NSNotificationCenter defaultCenter] postNotificationName:@"profilePic" object:nil userInfo:dict];
    
    
    
    NSLog(@"path:%@",path.absoluteString);
    if([_count isEqualToString:@"0"]){
    image_path = info;
        //self.request_image.contentMode = UIViewContentModeScaleAspectFill;
        //self.request_image.image = image;
        
    }
    else if([_count isEqualToString:@"1"]){
        image_path1=info;
        //self.request_second_image.contentMode = UIViewContentModeScaleAspectFill;
        //self.request_second_image.image = image;
        
    }
    else if([_count isEqualToString:@"2"]){
        image_path2=info;
       // self.request_third_image.contentMode = UIViewContentModeScaleAspectFill;
        //self.request_third_image.image = image;
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    //[self uploadimagebasic:info];
}


-(void)selectCat{
    
    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Select Category"
                                                   cancelButtonTitle:@"Cancel"
                                                  confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView=true;
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:38.0/255.0 green:174.0/255.0 blue:238.0/255.0 alpha:1.0];
    picker.headerBackgroundColor = [UIColor colorWithRed:38.0/255.0 green:174.0/255.0 blue:238.0/255.0 alpha:1.0];
    picker.tag=0;
    [picker show];
    
    
    
}

- (NSInteger)numberOfRowsInPickerView:(CZPickerView *)pickerView{
 
    if(pickerView.tag==0)
    return namesList.count;
    else
        return namesListsub.count;

}

- (NSString *)czpickerView:(CZPickerView *)pickerView
               titleForRow:(NSInteger)row{
    if(pickerView.tag==0)
    return [namesList objectAtIndex:row];
    else
        return [namesListsub objectAtIndex:row];

}


- (void)czpickerView:(CZPickerView *)pickerView
didConfirmWithItemAtRow:(NSInteger)row{

    if(pickerView.tag==0)
    {
    _select_cat.text=[namesList objectAtIndex:row];
        _serviceName = [namesList objectAtIndex:row];
    self.serviceId = [idList objectAtIndex:row];
        [self callapisub];
    }else{
        _select_sub_cat.text=[namesListsub objectAtIndex:row];
        _subserviceName = [namesListsub objectAtIndex:row];
        self.subserviceId = [idListsub objectAtIndex:row];
        
    }
}

-(void)selectSubCat{

    CZPickerView *picker = [[CZPickerView alloc] initWithHeaderTitle:@"Select sub Category"
                                                   cancelButtonTitle:@"Cancel"
                                                  confirmButtonTitle:@"Confirm"];
    picker.delegate = self;
    picker.dataSource = self;
    picker.needFooterView=true;
    picker.confirmButtonBackgroundColor = [UIColor colorWithRed:38.0/255.0 green:174.0/255.0 blue:238.0/255.0 alpha:1.0];
    picker.headerBackgroundColor = [UIColor colorWithRed:38.0/255.0 green:174.0/255.0 blue:238.0/255.0 alpha:1.0];
    
    picker.tag=1;
    [picker show];
    
    
}





-(void)callapi{
    
    [namesList removeAllObjects];
    [imgList removeAllObjects];
    [idList removeAllObjects];
    
   // [namesList addObject:@""];
    //[imgList addObject:@""];
    //[idList addObject:@""];
    
    
    
    //[self.homeTable reloadData];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@",
                      [defaults objectForKey:@"sessionid"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/services/getServices"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"eror:%@",error);
        NSLog(@"response:%@",response.description);
        
        if(data == nil){
           // [self showAlert:error.localizedDescription withtittle:@"Error"];
        }
        else{
            
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"data:%@",json);
            
            NSLog(@"%@",[json objectForKey:@"error_code"]);
            
            [namesList removeAllObjects];
            [imgList removeAllObjects];
            
            
          //[namesList addObject:@""];
         //[imgList addObject:@""];
            
            
            if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                
                
                //  [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
                
                NSMutableArray *services = [json objectForKey:@"services"];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                    [namesList addObject:[whateverNameYouWant objectForKey:@"name"]];
                    [idList addObject:[whateverNameYouWant objectForKey:@"_id"]];
                    NSString *temp = [whateverNameYouWant objectForKey:@"serviceLogo"];
                    NSString *image_utl = @"https://u-snap.herokuapp.com/images/icons/";
                    NSLog(@"%@",[image_utl stringByAppendingString:temp]);
                    
                    [imgList addObject:[image_utl stringByAppendingString:temp]];
                    
                    
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                  //  [self.homeTable reloadData];
                    //self.login_to_see.alpha=0;
                    
                });
                
                
            }
            else{
                //self.login_to_see.alpha=1;
                //[self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];
            }
            
        }
        
    }] resume];
    [SVProgressHUD show];
}



-(void)callapisub{
    
    [namesListsub removeAllObjects];
    [imgListsub removeAllObjects];
    [idListsub removeAllObjects];
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@&serviceId=%@",
                      [defaults objectForKey:@"sessionid"],self.serviceId];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/services/getSubServices"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"eror:%@",error);
        NSLog(@"response:%@",response.description);
        
        if(data == nil){
            // [self showAlert:error.localizedDescription withtittle:@"Error"];
        }
        else{
            
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"data:%@",json);
            
            NSLog(@"%@",[json objectForKey:@"error_code"]);
            
            [namesListsub removeAllObjects];
            [imgListsub removeAllObjects];
            [idListsub removeAllObjects];

            
            //[namesList addObject:@""];
            //[imgList addObject:@""];
            
            
            if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                
                
                //  [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
                
                NSMutableArray *services = [json objectForKey:@"subServices"];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                    [namesListsub addObject:[whateverNameYouWant objectForKey:@"subServiceName"]];
                    NSString *temp = [whateverNameYouWant objectForKey:@"_id"];
                    
                    [imgListsub addObject:temp];
                    [idListsub addObject:temp];
                }

                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //  [self.homeTable reloadData];
                    //self.login_to_see.alpha=0;
                    
                });
                
                
            }
            else{
                //self.login_to_see.alpha=1;
                //[self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];
            }
            
        }
        
    }] resume];
    [SVProgressHUD show];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@"Title"] || [textView.text isEqualToString:@"Description"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        if(textView.tag == 1)
        textView.text = @"Title";
        else
            textView.text = @"Description";

        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)request_btn:(id)sender {
    
    [self validateform];
}
//[textView.text isEqualToString:@"Title"] || [textView.text isEqualToString:@"Description"]
-(void)validateform{
    
    
   // [pathList removeAllObjects];
    
    if(image_path!=nil){
        [pathList addObject:image_path];
    }
    if(image_path1!=nil){
        [pathList addObject:image_path1];
    }
    if(image_path2!=nil){
        [pathList addObject:image_path2];
    }
    
    
    if([self.post_title.text isEqualToString:@"Title"]){
        [self showAlert:@"Please Enter Post Title" withtittle:@"Error"];
        
    }else if([self.post_desc.text isEqualToString:@"Description"]){
        [self showAlert:@"Please Enter Post Description" withtittle:@"Error"];
        
    }else if(self.serviceId.length==0){
        [self showAlert:@"Please Select Service " withtittle:@"Error"];
        
    }else if(self.subserviceId.length==0){
        [self showAlert:@"Please Select SubService" withtittle:@"Error"];
        
    }else if(pathList.count==0){
        [self showAlert:@"Please Select Image" withtittle:@"Error"];
        
    }else{
        [self callNewRequest];
    }
    
}


-(void)showAlert:(NSString *)message withtittle:(NSString *)tittle{
    
    
    if ([UIAlertController class])
    {
        
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tittle message:message preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                             {
                                 
                             }];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
    }
    else
    {
        
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:tittle message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        
    }
}

-(void)callNewRequest{
    
   // AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    number = [NSNumber numberWithInt:0];
    value = [number intValue];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    NSString *post = [NSString stringWithFormat:@"sessionId=%@&subject=%@&message=%@&serviceId=%@&serviceName=%@&subServiceId=%@&subServiceName=%@",
                      [defaults objectForKey:@"sessionid"],
                      self.post_title.text,
                      self.post_desc.text,
                      _serviceId,
                      _serviceName,
                      _subserviceId,
                      _subserviceName
                      ];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/request/postRequest"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [SVProgressHUD dismiss];
        NSLog(@"post:%@",post);
        NSLog(@"eror:%@",error);
        NSLog(@"response:%@",response.description);
        if(data == nil){
            [self showAlert:error.localizedDescription withtittle:@"Error"];
        }
        else{
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",json);
            
            NSLog(@"error_code %@",[json objectForKey:@"error_code"]);
            
            if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                [self UploadImage:[json objectForKey:@"requestId"]];
                
            }else{
                
                [self showAlert:error.localizedDescription withtittle:@"Error"];

            }
        }
        
    }] resume];
    [SVProgressHUD show];
    
    
    
    
}


-(void)UploadImage:(NSString *)requestId{
    

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    NSString *url = [NSString stringWithFormat:@"https://u-snap.herokuapp.com/api/request/postRequestFile/%@/%@",[defaults objectForKey:@"sessionid"],requestId];
    
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    

    UIImage *image = [pathList objectAtIndex:value];
    
    
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
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=%@; filename=imageName.jpg\r\n", @"image"] dataUsingEncoding:NSUTF8StringEncoding]];
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
                NSLog(@"response %@", response);
                
                id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                
                NSLog(@"data %@", json );
                
               // count_upload++;
                
                number = [NSNumber numberWithInt:value + 1];
                value = [number intValue];

                if(value<pathList.count){
                    
                    [self UploadImage:requestId];
                    
                }else{
                if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                    [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
                }else{
                    [self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];
                }
                }
            }
        }
    }];
    [SVProgressHUD show];
    
}


- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return pathList.count + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView* )collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{

        
        
        ImageCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ImageCollectionViewCell" forIndexPath:indexPath];
        
//        if([[pathList objectAtIndex:indexPath.row] hasPrefix:@"http"]){
//            
//            
//            [cell.image sd_setImageWithURL:[NSURL URLWithString:[pathList objectAtIndex:indexPath.row]]
//                               placeholderImage:[UIImage imageNamed:@"placeholder.png"] ];
//        }else{
//            cell.image.image=[UIImage imageNamed:[pathList objectAtIndex:indexPath.row]];
//            
//        }
    
    if(indexPath.row == pathList.count){
        cell.image.image = [UIImage imageNamed:@"camera_imge"];
        cell.image.contentMode = UIViewContentModeCenter;
        cell.image.layer.cornerRadius = 5.0f;
        cell.image.layer.borderWidth =  1.0f;
        
        cell.image.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        

    }else{
        cell.image.image = [pathList objectAtIndex:indexPath.row];
        cell.image.contentMode = UIViewContentModeScaleAspectFill;
        cell.image.layer.cornerRadius = 5.0f;
        cell.image.layer.borderWidth = 1.0f;
        
        cell.image.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        


    }
    
    
    
        return cell;
    
}

-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
        return  CGSizeMake(110,100) ;
    
}
-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    collectionViewLayout.minimumInteritemSpacing=0;
    collectionViewLayout.minimumLineSpacing =0;
    return UIEdgeInsetsMake(0, 0, 0, 0);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    //[self goToListView: [namesList objectAtIndex:indexPath.row]];
   
   // [self goToListView:[namesList objectAtIndex:indexPath.row] withid:[idList objectAtIndex:indexPath.row]];
    
    if(indexPath.row==pathList.count){
       [self selectImagePicker];
    }
    
}


- (void)photoPickerViewControllerDidReceivePhotoAlbumAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow photo album access?", nil) message:NSLocalizedString(@"Need your permission to access photo albums", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)photoPickerViewControllerDidReceiveCameraAccessDenied:(YMSPhotoPickerViewController *)picker
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Allow camera access?", nil) message:NSLocalizedString(@"Need your permission to take a photo", nil) preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *dismissAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", nil) style:UIAlertActionStyleCancel handler:nil];
    UIAlertAction *settingsAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Settings", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }];
    [alertController addAction:dismissAction];
    [alertController addAction:settingsAction];
    
    // The access denied of camera is always happened on picker, present alert on it to follow the view hierarchy
    [picker presentViewController:alertController animated:YES completion:nil];
}


- (void)photoPickerViewController:(YMSPhotoPickerViewController *)picker didFinishPickingImages:(NSArray *)photoAssets
{
    [picker dismissViewControllerAnimated:YES completion:^() {
        // Remember images you get here is PHAsset array, you need to implement PHImageManager to get UIImage data by yourself
        PHImageManager *imageManager = [[PHImageManager alloc] init];
        
        PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
        options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        options.networkAccessAllowed = YES;
        options.resizeMode = PHImageRequestOptionsResizeModeExact;
        options.synchronous = YES;
        
        NSMutableArray *mutableImages = [NSMutableArray array];
        
        for (PHAsset *asset in photoAssets) {
            CGSize targetSize = CGSizeMake(200,200);
            
            [imageManager requestImageForAsset:asset targetSize:targetSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage *image, NSDictionary *info) {
                [mutableImages addObject:image];
            }];
        }
        
        // Assign to Array with images
        pathList = [mutableImages copy];
        [self.imagesCollection  reloadData];
    }];
}

@end
