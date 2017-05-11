//
//  SPSignUpViewController.m
//  services
//
//  Created by Mac on 5/8/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SPSignUpViewController.h"
#import "SVProgressHUD.h"
#import "MenuTableViewCell.h"
#import "SelectSPTableViewCell.h"
#import "CustomizeViewController.h"

@interface SPSignUpViewController ()
{
    NSMutableArray *imgList;
    NSMutableArray *namesList;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    namesList=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    imgList=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    
    [namesList removeAllObjects];
    [imgList removeAllObjects];

    [self.tableView registerNib:[UINib nibWithNibName:@"SelectSPTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"SelectSPTableViewCell"];
    

    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView reloadData];
    [self getServices];
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return namesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SelectSPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectSPTableViewCell" forIndexPath:indexPath];
    

    [cell.spName setText:[namesList objectAtIndex:indexPath.row]] ;
    
    
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"CustomizeViewController"];
    viewController.title = @"Select sub service";
    
    
    [self.navigationController pushViewController:viewController animated:YES];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    
    return 62;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)getServices{
    
    [namesList removeAllObjects];
    [imgList removeAllObjects];
    
    
    //[namesList addObject:@""];
    //[imgList addObject:@""];
    
    
    [self.tableView reloadData];
    
    
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
            [self showAlert:error.localizedDescription withtittle:@"Error"];
        }
        else{
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            NSLog(@"%@",[json objectForKey:@"error_code"]);
            
            [namesList removeAllObjects];
            [imgList removeAllObjects];
            
            
           // [namesList addObject:@""];
          //  [imgList addObject:@""];
            
            
            if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                
                
                //  [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
                
                NSMutableArray *services = [json objectForKey:@"services"];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                    [namesList addObject:[whateverNameYouWant objectForKey:@"name"]];
                    NSString *temp = [whateverNameYouWant objectForKey:@"serviceLogo"];
                    NSString *image_utl = @"https://u-snap.herokuapp.com/images/icons/";
                    NSLog(@"%@",[image_utl stringByAppendingString:temp]);
                    
                    [imgList addObject:[image_utl stringByAppendingString:temp]];
                    
                    
                    
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





-(void)callapi{
    NSDictionary *o2 = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"12345678", @"subServiceId",
                        nil];
    
    NSArray *subarray = [NSArray arrayWithObjects:o2,o2, nil];
    
    NSDictionary *o1 = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"serviceId", @"serviceId",
                        @"chargePerHour", @"chargePerHour",
                        @"nagotiable", @"nagotiable",
                        subarray, @"selectedSubServices",
                        
                        nil];
    
    NSArray *array = [NSArray arrayWithObjects:o1, o1, nil];
    
    // NSString *jsonString = [array St];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"email=%@&password=%@&confirmPassword=%@&firstName=%@&lastName=%@&phone=%@&selectedServices=%@",
                      @"prudhvi2@yellowsoft.in",
                      @"123456",
                      @"123456",
                      @"prudhvi",
                      @"raj",
                      @"7382223117",
                      array];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/auth/providerRegistration"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [SVProgressHUD dismiss];
        
        NSLog(@"response:%@",response);
        
        if(data == nil){
            [self showAlert:error.localizedDescription withtittle:@"Error"];
        }
        else{
            NSLog(@"data:%@",data);
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"%@",[json objectForKey:@"success_code"]);
            
            if(![[json objectForKey:@"success_code"] isEqualToString:@"1"]){
                
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
