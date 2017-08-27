//
//  SPDetailViewController.m
//  services
//
//  Created by Mac on 4/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SPDetailViewController.h"
#import "DetailFirstTableViewCell.h"
#import "DetailsSecondTableViewCell.h"
#import "DetailThirdTableViewCell.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface SPDetailViewController (){
    UIImage *serviceProviderImage;
    NSString *mode;

}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SPDetailViewController
AppDelegate *appDelegateSp;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    appDelegateSp = (AppDelegate *)[[UIApplication sharedApplication] delegate];

    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailFirstTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailsSecondTableViewCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"DetailThirdTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailThirdTableViewCell"];


    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self getImage];
    
    
    
    
    
    if([self.serviceProvider.isfav isEqualToString:@"YES"]){
        mode = @"fav";
        UIBarButtonItem *flipButtonyes = [[UIBarButtonItem alloc]
                                          initWithImage:[UIImage imageNamed:@"my-fav-fill"]
                                          style:UIBarButtonItemStyleBordered
                                          target:self
                                          action:@selector(flipView)];
        self.navigationItem.rightBarButtonItem = flipButtonyes;

    }else{
        mode = @"nofav";
        UIBarButtonItem *flipButtonno = [[UIBarButtonItem alloc]
                                         initWithImage:[UIImage imageNamed:@"my-fav"]
                                         style:UIBarButtonItemStyleBordered
                                         target:self
                                         action:@selector(flipView)];
        self.navigationItem.rightBarButtonItem = flipButtonno;
    }

    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                            //      forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
   // self.navigationController.navigationBar.translucent = YES;
    //self.navigationController.view.backgroundColor = [UIColor clearColor];
    //self.navigationController.navigationBar.backgroundColor = [UIColor clearColor];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    //[self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 // forBarMetrics:UIBarMetricsDefault];
    //self.navigationController.navigationBar.shadowImage = [UIImage new];
    //self.navigationController.navigationBar.translucent = NO;
    //self.navigationController.view.backgroundColor = [UIColor whiteColor];
    //self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    
}

-(IBAction)flipView{
    
    if([mode isEqualToString:@"fav"]){
        
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"my-fav"];
        mode=@"nofav";
        [self removeFav];
        self.serviceProvider.isfav = @"NO";
        
    }else{
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"my-fav-fill"];
        mode=@"fav";
        [ self addFav];
        self.serviceProvider.isfav = @"YES";
    }
    
    
    
    
    
    
}


-(void)addFav{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@&favoriteUserId=%@",
                      [defaults objectForKey:@"sessionid"],_serviceProvider.user_id];
    NSLog(@"post->%@",post);
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/favorite/addToFavorite"]];
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
            
            NSLog(@"%@",json);
            
            if([[json objectForKey:@"error_code"]   isEqualToString: @"0"]){
                
                [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
            }
            else{
                [self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];
            }
            
        }
        
    }] resume];
    [SVProgressHUD show];
    
    
}


-(void)removeFav{
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@&favoriteUserId=%@",
                      [defaults objectForKey:@"sessionid"],_serviceProvider.user_id];
    NSLog(@"post->%@",post);

    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/favorite/removeFavorite"]];
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
            
            NSLog(@"%@",json);
            
            if([[json objectForKey:@"error_code"]   isEqualToString: @"0"]){
                
                [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
            }
            else{
                [self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];
            }
            
        }
        
    }] resume];
    [SVProgressHUD show];
    
    
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row==0){
        NSLog(@"data:%@",@"data reload");

        DetailFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailFirstTableViewCell"];
        cell.service_name.text = self.serviceProvider.service_name;
        cell.service_address.text = self.serviceProvider.service_address;
        
       // if(serviceProviderImage!=nil)
       // cell.service_image.image= serviceProviderImage;
        
        UIImage *image = serviceProviderImage;
        cell.sp_image.layer.cornerRadius = cell.sp_image.frame.size.width/2;
        cell.sp_image.layer.borderWidth = 1.0f;
        cell.sp_image.layer.borderColor = [UIColor colorWithRed:38.0/255.0 green:174.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
        cell.sp_image.clipsToBounds = YES;
        cell.sp_image.image = image;
        

        
        
        if(self.serviceProvider.userServices.count>0){
            
            id service = [self.serviceProvider.userServices firstObject];

            
           NSString *detail_url =  [appDelegateSp.banner_images valueForKey:[service valueForKey:@"serviceId"]];
            
            [cell.service_image sd_setImageWithURL:[NSURL URLWithString:detail_url]
                               placeholderImage:[UIImage imageNamed:@"placeholder.png"] ];
            NSLog(@"detail_url %@",detail_url);

            


        }

        
        return cell;
        
    }else if(indexPath.row==1){
        DetailsSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsSecondTableViewCell"];
        cell.service_description.text = self.serviceProvider.service_description;
        
        NSString *htmlString = @"<ul style='font-size:20px';>";
        
        
        for(int i=0;i<self.serviceProvider.userServices.count;i++){
            
            id service = [self.serviceProvider.userServices objectAtIndex:i];
            
            NSLog(@"service_name %@",[service valueForKey:@"subServiceName"]);
            
          htmlString =   [htmlString stringByAppendingString:@"<li>"];
          htmlString = [htmlString stringByAppendingString:[service valueForKey:@"subServiceName"]];
            
            htmlString = [htmlString stringByAppendingString:@" | "];

          htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"%@",[service valueForKey:@"chargePerHour"]]];
            
            htmlString = [htmlString stringByAppendingString:@"/Hour"];

            
            if([[service valueForKey:@"negotiable"] isEqualToString:@"YES"]){
                htmlString = [htmlString stringByAppendingString:@" | "];

            htmlString = [htmlString stringByAppendingString:@"Negotiable"];
            }
            
           htmlString = [htmlString stringByAppendingString:@"</li>"];
        }
        
        
        [htmlString stringByAppendingString:@"</ul>"];

        NSAttributedString *attributedString = [[NSAttributedString alloc]
                                                initWithData: [htmlString dataUsingEncoding:NSUnicodeStringEncoding]
                                                options: @{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType }
                                                documentAttributes: nil
                                                error: nil
                                                ];
        
        
        cell.service_description.attributedText = attributedString;
        
        return cell;

    }else{
        DetailThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailThirdTableViewCell"];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 370;
    }
    else if(indexPath.row == 1){
        return 200;
    }else{
        return 70;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)getImage{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@&userId=%@",
                      [defaults objectForKey:@"sessionid"],_serviceProvider.user_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/users/getUserProfilePicture"]];
    
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
            NSLog(@"data:%@",@"nodata");
            
        }
        else{
            
        
            UIImage *image = [UIImage imageWithData:data];
            
            
            if(image!=nil){
                NSLog(@"data:%@",@"data");

                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                    serviceProviderImage = image;
                    
                    [self.tableView reloadData];
                }];
            }
        }
        
        
    }] resume];
    
    [SVProgressHUD show];
    
    
    
    
}



-(void)showAlert:(NSString *)message withtittle:(NSString *)tittle{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        if ([UIAlertController class])
        {
            
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:tittle message:message preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action)
                                 {
//                                     if([tittle isEqualToString:@"Success"])
//                                         [self setupHome:@"nologin"];
//                                     
                                     
                                 }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else{
            //[self setupHome:@"nologin"];
        }
        
    });
}


- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
