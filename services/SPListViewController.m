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


@interface SPListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPListViewController
{
    NSMutableArray *tableData;
    
    
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
    SPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPTableViewCell" forIndexPath:indexPath];
    
    ServiceProvider *sp = [tableData objectAtIndex:indexPath.row];
    
    cell.sp_name.text = sp.service_name;
    cell.sp_address.text = sp.service_address;
    cell.sp_rate.text = [NSString stringWithFormat:@"%@/Hour",sp.service_price];
    
    
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
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [self.tableView reloadData];
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



@end
