//
//  SPListViewController.m
//  services
//
//  Created by Mac on 4/21/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SPListViewController.h"
#import "SPTableViewCell.h"
#import "SVProgressHUD.h"
#import "ServiceProvider.h"
#import "SPDetailViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "JDFTooltips.h"
#import "CMPopTipView.h"
#import <SDWebImage/UIImageView+WebCache.h>


static NSString *const kMapStyle = @"["
@"  {"
@"    \"featureType\": \"all\","
@"    \"elementType\": \"all\","
@"    \"stylers\": ["
@"      {"
@"        \"visibility\": \"off\""
@"      }"
@"    ]"
@"  },"
@"  {"
@"    \"featureType\": \"road\","
@"    \"elementType\": \"all\","
@"    \"stylers\": ["
@"      {"
@"        \"visibility\": \"on\""
@"      }"
@"    ]"
@"  },"
@"  {"
@"    \"featureType\": \"administrative\","
@"    \"elementType\": \"all\","
@"    \"stylers\": ["
@"      {"
@"        \"visibility\": \"on\""
@"      }"
@"    ]"
@"  }"
@"]";

@interface SPListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet GMSMapView *map_view;



@end

@implementation SPListViewController
{
    NSMutableArray *tableData;
    NSString *mode;
    UIImage *mapIcon;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"SPTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"SPTableViewCell"];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   // self.tableView.separatorColor = [UIColor clearColor];
   // self.tableView.scrollEnabled = NO;
    tableData=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    [tableData removeAllObjects];

    
    self.map_view.myLocationEnabled = YES;
    self.map_view.settings.myLocationButton = YES;
    
    NSError *error;
    
    // Set the map style by passing a valid JSON string.
    GMSMapStyle *style = [GMSMapStyle styleWithJSONString:kMapStyle error:&error];
    
    if (!style) {
        NSLog(@"The style definition could not be loaded: %@", error);
    }
    
    self.map_view.mapStyle = style;

    
    mapIcon = [self getMapIcon:_serviceId];
    
    [self callapi];
    
    
    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithImage:[UIImage imageNamed:@"list_icon"]
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(flipView)];
    self.navigationItem.rightBarButtonItem = flipButton;
    
    mode = @"map";
    
    //[flipButton release];
    
    self.tableView.hidden = YES;

    

    
}

- (void)viewWillAppear:(BOOL)animated {
    [self.map_view addObserver:self forKeyPath:@"myLocation" options:0 context:nil];
}





- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"myLocation"]) {
        CLLocation *location = [object myLocation];
        //...
        NSLog(@"Location, %@,", location);
        
        CLLocationCoordinate2D target =
        CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude);
        
        [self.map_view animateToLocation:target];
        [self.map_view animateToZoom:17];
        
        [self.map_view removeObserver:self forKeyPath:@"myLocation"];

    }
}



-(void)viewDidAppear:(BOOL)animated{
    
    CMPopTipView *navBarLeftButtonPopTipView = [[CMPopTipView alloc] initWithMessage:@"Tap this button to toggle Map and List"];
    navBarLeftButtonPopTipView.delegate = self;
    navBarLeftButtonPopTipView.backgroundColor = [UIColor redColor];
    navBarLeftButtonPopTipView.bubblePaddingX = 20;
    navBarLeftButtonPopTipView.bubblePaddingY = 20;
    navBarLeftButtonPopTipView.dismissAlongWithUserInteraction = YES;
    
    [navBarLeftButtonPopTipView presentPointingAtBarButtonItem:self.navigationItem.rightBarButtonItem animated:YES];

    
}
- (void)popTipViewWasDismissedByUser:(CMPopTipView *)popTipView {
    // any code
}
-(IBAction)flipView{
    
    if([mode isEqualToString:@"map"]){
        
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"map_icon"];
        mode=@"list";
        
       // [self setView:_map_view hidden:YES];
        
        [UIView transitionFromView:_map_view
                            toView:_tableView
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews
                        completion:nil];
        
        
    }else{
        self.navigationItem.rightBarButtonItem.image = [UIImage imageNamed:@"list_icon"];
        mode=@"map";
       // [self setView:_map_view hidden:NO];
        
        [UIView transitionFromView:_tableView
                            toView:_map_view
                          duration:0.6
                           options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews
                        completion:nil];


    }
    
}

- (void)setView:(UIView*)view hidden:(BOOL)hidden {
    
    
    [UIView transitionWithView:view duration:0.5 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^(void){
        [view setHidden:hidden];
        
    } completion:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPTableViewCell" forIndexPath:indexPath];
    
    ServiceProvider *sp = [tableData objectAtIndex:indexPath.row];
    
    cell.sp_name.text = sp.service_name;
    cell.sp_address.text = sp.service_address;
    cell.sp_rate.text = [NSString stringWithFormat:@"%@/Hour",sp.service_price];
    
//    [cell.sp_logo sd_setImageWithURL:[NSURL URLWithString:[imgList objectAtIndex:indexPath.row]]
//                       placeholderImage:[UIImage imageNamed:@"placeholder.png"] ];
//
//
    UIImage *image = [UIImage imageWithData:sp.image];
    cell.sp_logo.layer.cornerRadius = cell.sp_logo.frame.size.width/2;
    cell.sp_logo.layer.borderWidth = 1.0f;
    cell.sp_logo.layer.borderColor = [UIColor colorWithRed:38.0/255.0 green:174.0/255.0 blue:238.0/255.0 alpha:1.0].CGColor;
    cell.sp_logo.clipsToBounds = YES;
    cell.sp_logo.image = image;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SPDetailViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"SPDetailViewController"];
    ServiceProvider *sp = [tableData objectAtIndex:indexPath.row];

    viewController.serviceProvider = sp;
    
    [self.navigationController pushViewController:viewController animated:YES];

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
                      @"sessionId=%@&serviceId=%@",
                      [defaults objectForKey:@"sessionid"],self.serviceId];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/services/getProvidersByService"]];
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
            
            NSLog(@"data:%@",json);
            
            NSLog(@"%@",[json objectForKey:@"error_code"]);
            
            
            if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                
                
                //  [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
                
                NSMutableArray *services = [json objectForKey:@"providersInfo"];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                [tableData addObject:[[ServiceProvider alloc] initWithDictionaryfrom:whateverNameYouWant]];
                    
                }
                
                //dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //[self.tableView reloadData];
                    //[self addMarkers];
               // });
                if(tableData.count>0)
                [self getImage:0];
                
                
            }
            else{
                
                [self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];
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
                                     
                                     
                                 }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else{
           // [self movetologin];
        }
        
    });
}

-(void)addMarkers{
    
    NSMutableArray   *markers = [[NSMutableArray alloc] init];

    
    for(ServiceProvider *sp in tableData){
        
        GMSMarker *marker = [[GMSMarker alloc] init];
        marker.position = CLLocationCoordinate2DMake([sp.lat doubleValue], [sp.lon doubleValue]);
        marker.title = sp.service_name;
        marker.snippet = sp.service_address;
        marker.icon = mapIcon;
        marker.map = self.map_view;
        [markers addObject:marker];
        
    }
    
    
//    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] init];
//    
//    for (GMSMarker *marker in markers)
//        bounds = [bounds includingCoordinate:marker.position];
//    
//    [self.map_view animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:30.0f]];

}

-(UIImage *)getMapIcon:(NSString *)serviceId{
    
    if([self.serviceId isEqualToString:@"5906c467845347110002f583"]){
        return [UIImage imageNamed:@"plumber"];
    }else if([self.serviceId isEqualToString:@"5908e2911a8fc9940d7adbb4"]){
        return [UIImage imageNamed:@"acimage"];
    }else if([self.serviceId isEqualToString:@"591a26da8f8a311100f85639"]){
        return [UIImage imageNamed:@"law"];
    }else if([self.serviceId isEqualToString:@"591a38de8f8a311100f85652"]){
        return [UIImage imageNamed:@"camera"];
    }else if([self.serviceId isEqualToString:@"591a3cb68f8a311100f85663"]){
        return [UIImage imageNamed:@"musicicon"];
    }else if([self.serviceId isEqualToString:@"591a42718f8a311100f8566c"]){
        return [UIImage imageNamed:@"Fitness"];
    }
    else{
        return [UIImage imageNamed:@"repair"];
    }
}
    
    -(void)getImage:(long)indexPath{
        
        ServiceProvider *sp = [tableData objectAtIndex:indexPath];

        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        NSString *post = [NSString stringWithFormat:
                          @"sessionId=%@&userId=%@",
                          [defaults objectForKey:@"sessionid"],sp.user_id];
        
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
                
                
               // UIImage *image = [UIImage imageWithData:data];
                
                
                
                    NSLog(@"image_received");
                    sp.image = data;
                
                
                
                    if(indexPath+1<tableData.count){
                        
                        [self getImage:indexPath+1];
                        
                    }else{
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            [self.tableView reloadData];
                            [self addMarkers];
                        });

                    }
                
            }
            
            
        }] resume];
        
        [SVProgressHUD show];
        
        
    }



@end
