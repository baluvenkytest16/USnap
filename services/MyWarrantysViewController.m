//
//  MyWarrantysViewController.m
//  services
//
//  Created by Mac on 5/5/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "MyWarrantysViewController.h"
#import "SVProgressHUD.h"
#import "FavServiceProvider.h"
#import "RequestTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "RequestDetailViewController.h"
#import "KIImagePager.h"




@interface MyWarrantysViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation MyWarrantysViewController{
    NSMutableArray *tableData;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableview registerNib:[UINib nibWithNibName:@"RequestTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"RequestTableViewCell"];
    
    self.tableview.delegate = self;
    self.tableview.dataSource = self;
    tableData=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    [tableData removeAllObjects];

    
    UIBarButtonItem *flipButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"New Request"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(cancel:)];
    
    if([self.user_type isEqualToString:@"user"])
        self.navigationItem.rightBarButtonItem = flipButton;
    
    }

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if([self.user_type isEqualToString:@"user"])
       [self callapi];
    else
        [self callapisp];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)cancel:(id)sender {
   // [_delegate PAPasscodeViewControllerDidCancel:self];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"NewRequestViewController"];
    
    
    [self.navigationController pushViewController:viewController animated:YES];

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
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/request/getMyRequests"]];
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
                
                
                  //[self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
                
                NSMutableArray *services = [json objectForKey:@"myRequests"];
                [tableData removeAllObjects];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                    [tableData addObject:[[FavServiceProvider alloc] initWithDictionaryfrom:whateverNameYouWant]];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.tableview reloadData];
                    
                 });
                
                
               // if(tableData.count>0)
                 //   [self getImage:0];
                
                
            }
            else{
                
                [self showAlert:[json objectForKey:@"message"] withtittle:@"Error"];
            }
            
        }
        
    }] resume];
    [SVProgressHUD show];
}



-(void)callapisp{
    
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@",
                      [defaults objectForKey:@"sessionid"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/request/getAvailableRequests"]];
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
                
                
                //[self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
                
                NSMutableArray *services = [json objectForKey:@"availableRequests"];
                [tableData removeAllObjects];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                    [tableData addObject:[[FavServiceProvider alloc] initWithDictionaryfrom:whateverNameYouWant]];
                    
                }
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableview reloadData];
                    
                });
                
                
                // if(tableData.count>0)
                //   [self getImage:0];
                
                
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
                                     if([tittle isEqualToString:@"Success"])
                                     [self callapi];
                                     
                                 }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else{
            // [self movetologin];
        }
        
    });
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return tableData.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    RequestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RequestTableViewCell" forIndexPath:indexPath];
    
    FavServiceProvider *sp = [tableData objectAtIndex:indexPath.row];
    
    cell.request_subject.text = sp.subject;
    cell.request_message.text = sp.message;
    
    if(sp.images.count>0){
        
        
        NSString *image_utl = @"https://u-snap.herokuapp.com";
        
        NSString *url = [[sp.images firstObject] valueForKey:@"secureFileUrl"];
        
        [cell.request_image sd_setImageWithURL:[NSURL URLWithString:url]
                           placeholderImage:[UIImage imageNamed:@"placeholder.png"] ];
        
        
        
    }
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    RequestDetailViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"RequestDetailViewController"];
    viewController.user_type= self.user_type;
    
    FavServiceProvider *sp = [tableData objectAtIndex:indexPath.row];
    viewController.serviceProvider = sp;
    
    
    [self.navigationController pushViewController:viewController animated:YES];

    
    
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return YES - we will be able to delete all rows
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Perform the real delete action here. Note: you may need to check editing style
    //   if you do not perform delete only.
    NSLog(@"Deleted row.");
    FavServiceProvider *sp = [tableData objectAtIndex:indexPath.row];
    [self deleteRequest:sp._id];
}


-(void)deleteRequest:(NSString *)requestId{
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@&requestId=%@",
                      [defaults objectForKey:@"sessionid"],requestId];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/request/removeMyRequest"]];
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

@end
