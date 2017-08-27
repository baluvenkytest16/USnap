//
//  FavViewController.m
//  services
//
//  Created by Mac on 7/6/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "FavViewController.h"
#import "SPDetailViewController.h"
#import "SPTableViewCell.h"
#import "SVProgressHUD.h"
#import "ServiceProvider.h"

@interface FavViewController ()
@property (strong, nonatomic) IBOutlet UITableView *table_view;

@end

@implementation FavViewController
{
    NSMutableArray *tableData;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.table_view registerNib:[UINib nibWithNibName:@"SPTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"SPTableViewCell"];
    
    self.table_view.delegate = self;
    self.table_view.dataSource = self;

    
    tableData=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    [tableData removeAllObjects];

    [self callapi];
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
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/favorite/myFavorites"]];
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
                    NSLog(@"%@",whateverNameYouWant);

                    
                }
                
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    
//                    [self.table_view reloadData];
//                });
//
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
                    
                    [self.table_view reloadData];
                    //[self addMarkers];
                });
                
            }
            
        }
        
        
    }] resume];
    
    [SVProgressHUD show];
    
    
}



@end
