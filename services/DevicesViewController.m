//
//  DevicesViewController.m
//  services
//
//  Created by Mac on 6/21/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "DevicesViewController.h"
#import "DevicesTableViewCell.h"
#import "DeviceDetail.h"
#import "SVProgressHUD.h"
#import "AppDelegate.h"



@interface DevicesViewController ()
@property (strong, nonatomic) IBOutlet UITableView *devices_table;

@end

@implementation DevicesViewController{
    NSMutableArray *tableData;
    NSString *device_id;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.devices_table registerNib:[UINib nibWithNibName:@"DevicesTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"DevicesTableViewCell"];
    
    
    self.devices_table.delegate = self;
    self.devices_table.dataSource = self;
    
    tableData=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    [tableData removeAllObjects];

    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    device_id = appDelegate.device_id;
    
    [self callapi];
    
    
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
    
    DevicesTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DevicesTableViewCell" forIndexPath:indexPath];
    
    DeviceDetail *sp = [tableData objectAtIndex:indexPath.row];
    
    cell.device_name.text = sp.deviceName;
    
    cell.unlink_btn.tag = indexPath.row;
    
    [cell.unlink_btn addTarget:self action:@selector(logout:) forControlEvents:UIControlEventTouchUpInside];


    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}


-(void)logout:(UIButton*)sender
{
    
    
    DeviceDetail *sp = [tableData objectAtIndex:sender.tag];

    NSLog(@"logout %@",sp.deviceName);
    
    [self unlinkdevice:sp.deviceId];
    
}


-(void)callapi{
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@",
                      [defaults objectForKey:@"sessionid"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/users/getUserDevices"]];
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
                
                
                
                NSMutableArray *services = [json objectForKey:@"userDevices"];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                    
                    [tableData addObject:[[DeviceDetail alloc] initWithDictionaryfrom:whateverNameYouWant]];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.devices_table reloadData];
                });
                
                
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




-(void)unlinkdevice:(NSString *)un_device_id{
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@&deviceId=%@",
                      [defaults objectForKey:@"sessionid"],un_device_id];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/users/unlinkUserDevice"]];
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
                
                
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self goback];
                    
                });
                
                
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
