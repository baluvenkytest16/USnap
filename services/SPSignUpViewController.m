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
#import "NSDictionary+JSON.h"
#import "AFNetworking.h"


@interface SPSignUpViewController ()
{
    NSMutableArray *imgList;
    NSMutableArray *namesList;
    NSMutableArray *idList;
    NSMutableArray *selected_services_info;
    NSMutableArray *selected_services_index;
    NSMutableArray *selected_subservices_info;
    NSMutableArray *selected_subservices_index;
    NSIndexPath *selected_index;
}

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *submit_btn;

@end

@implementation SPSignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    namesList=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    imgList=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    idList=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    selected_services_index=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    selected_services_info=[NSMutableArray arrayWithObjects:@"plumbing",nil];



    
    [namesList removeAllObjects];
    [imgList removeAllObjects];
    [idList removeAllObjects];
    [selected_services_index removeAllObjects];
    [selected_services_info removeAllObjects];



    [self.tableView registerNib:[UINib nibWithNibName:@"SelectSPTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"SelectSPTableViewCell"];
    

    [self.tableView setDelegate:self];
    [self.tableView setDataSource:self];
    
    [self.tableView reloadData];
    [self getServices];
    
    self.submit_btn.layer.masksToBounds = YES;

    self.submit_btn.layer.cornerRadius = 5;
    
    [[NSNotificationCenter defaultCenter]
     addObserver:self selector:@selector(serviceSelected:) name:@"serviceselected" object:nil];
    
    _submit_btn.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGesture =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(submit_clicked)];
    [_submit_btn addGestureRecognizer:tapGesture];
    

    
    
}
-(void)submit_clicked{
    
    if(selected_services_info.count == 0){
        [self showAlert:@"Select one or more services" withtittle:@"Error"];
        
    }else{
        
        
        [self callAF];
    }
    
    
}



-(void)serviceSelected:(NSNotification *) notification
{
    
    NSDictionary *dict = notification.userInfo;
    NSString *message = [dict valueForKey:@"id"];

    if (message != nil) {
        // do stuff here with your message data

        if([selected_services_index containsObject:message]){
            NSLog(@"%@ remove",message);
            
            [selected_services_info removeObjectAtIndex:[selected_services_index indexOfObject:message]];
            [selected_services_index removeObject:message];


        }else{
            NSLog(@"%@ add",message);
            [selected_services_index addObject:message];
            
            
            NSMutableDictionary *o1 = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                message, @"serviceId",
                                @(100), @"chargePerHour",
                                @"YES", @"nagotiable",
                                @[], @"selectedSubServices",
                                
                                nil];
            
            [selected_services_info addObject:o1];


        }
        

    }
    
}

-(void)subserviceSelected:(NSNotification *) notification
{
    
    NSDictionary *dict = notification.userInfo;
    NSString *message = [dict valueForKey:@"id"];
    
    if (message != nil) {
        // do stuff here with your message data
        
        if([selected_subservices_index containsObject:message]){
            NSLog(@"%@ remove",message);
            
            [selected_subservices_info removeObjectAtIndex:[selected_subservices_index indexOfObject:message]];
            [selected_subservices_index removeObject:message];
            
            [[selected_services_info objectAtIndex:selected_index.row] setObject:selected_subservices_info forKey:@"selectedSubServices"];
            
            
        }else{
            NSLog(@"%@ add",message);
            
            [selected_subservices_index addObject:message];
            [selected_subservices_info addObject:message];
            
            [[selected_services_info objectAtIndex:selected_index.row] setObject:selected_subservices_info forKey:@"selectedSubServices"];
            
            
            
        }
        
        
    }
    
}

//{"sessionId":"9bd02a40-41e0-11e7-8117-9980ec86cf72","selectedServices":[{"nagotiable":"YES","serviceId":"5906c467845347110002f583","chargePerHour":100},{"nagotiable":"YES","serviceId":"591a26da8f8a311100f85639","chargePerHour":100}]}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return namesList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectSPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SelectSPTableViewCell" forIndexPath:indexPath];
    [cell.spName setText:[namesList objectAtIndex:indexPath.row]] ;
    cell.main_checkbox.userInteractionEnabled = false;
    cell.main_checkbox.boxType = BEMBoxTypeSquare;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
    
}


- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[idList objectAtIndex:indexPath.row] forKey:@"id"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"serviceselected" object:nil userInfo:dict];
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSDictionary *dict = [NSDictionary dictionaryWithObject:[idList objectAtIndex:indexPath.row] forKey:@"id"];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"serviceselected" object:nil userInfo:dict];
    
    selected_index = indexPath;
    

   // [tableView deselectRowAtIndexPath:indexPath animated:YES];

//    if([selectedList containsObject:[namesList objectAtIndex:indexPath.row]]){
//        
//        [selectedList removeObject:[namesList objectAtIndex:indexPath.row]];
//        
//    }else{
//        [selectedList addObject:[namesList objectAtIndex:indexPath.row]];
//
    
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CustomizeViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"CustomizeViewController"];
    viewController.title = @"Select sub service";
    viewController.serviceId = [idList objectAtIndex:indexPath.row];
    
    
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
    [idList removeAllObjects];
    
    
    //[namesList addObject:@""];
    //[imgList addObject:@""];
    
    
    [self.tableView reloadData];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@",
                      [defaults objectForKey:@"sessionid"]];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
   // NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/services/getServices"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [SVProgressHUD dismiss];
        
       // NSLog(@"eror:%@",error);
       //// NSLog(@"response:%@",response.description);
        
        if(data == nil){
            [self showAlert:error.localizedDescription withtittle:@"Error"];
        }
        else{
            
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
           // NSLog(@"%@",[json objectForKey:@"error_code"]);
            
            [namesList removeAllObjects];
            [imgList removeAllObjects];
            
            
           // [namesList addObject:@""];
          //  [imgList addObject:@""];
            
            
            if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                
                
                //  [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
                
                NSMutableArray *services = [json objectForKey:@"services"];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                    [namesList addObject:[whateverNameYouWant objectForKey:@"name"]];
                    [idList addObject:[whateverNameYouWant objectForKey:@"_id"]];
                    
                    
                    NSString *temp = [whateverNameYouWant objectForKey:@"serviceLogo"];
                    NSString *image_utl = @"https://u-snap.herokuapp.com/images/icons/";
                   // NSLog(@"%@",[image_utl stringByAppendingString:temp]);
                    
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
                        @"5906c4fa845347110002f585", @"subServiceId",
                        nil];
    
    NSArray *subarray = [NSArray arrayWithObjects:o2, nil];
    
    NSDictionary *o1 = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"5906c467845347110002f583", @"serviceId",
                        @(100), @"chargePerHour",
                        @"YES", @"nagotiable",
                        subarray, @"selectedSubServices",
                        
                        nil];
    

    NSError *error;
    
    //NSMutableArray * arr = [[NSMutableArray alloc] init];
    
    //[arr addObject:o1];
    
   // NSData *jsonData2 = [NSJSONSerialization dataWithJSONObject:arr options:NSJSONWritingPrettyPrinted error:&error];
    
    //NSString *jsonString = [[NSString alloc] initWithData:jsonData2 encoding:NSUTF8StringEncoding];
    
    //NSLog(@"jsonData as string:\n%@", jsonString);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    
    

//    NSString *post = [NSString stringWithFormat:
//                      @"sessionId=%@&selectedServices=%@",
//                      [defaults objectForKey:@"sessionid"],
//                      jsonData2];
//
    
    NSDictionary *requestInfo = @{@"sessionId": [defaults objectForKey:@"sessionid"],
                                  @"selectedServices":@[o1]};
    
  //  NSData *myData = [NSKeyedArchiver archivedDataWithRootObject:myDictionary];

    //NSData *postData = [NSKeyedArchiver archivedDataWithRootObject:requestInfo];
    //NSData *policyData = [requestInfo dataUsingEncoding:NSUTF8StringEncoding];
    //NSData *jsonData = [NSJSONSerialization dataWithJSONObject:requestInfo
                                                       //options:0 error:&error];
    NSData *data = [NSJSONSerialization dataWithJSONObject:requestInfo options:NSJSONWritingPrettyPrinted error:nil];
    NSString *json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSData *postData=[json dataUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"json: %@", json);
   // NSData *postData = [requestInfo toJsonWithOptions:NSJSONWritingPrettyPrinted];
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[json length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/providers/providerRegistration"]];
    
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
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

-(void)callAF{
    
    
    NSDictionary *o2 = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"5906c4fa845347110002f585", @"subServiceId",
                        nil];
    
    NSArray *subarray = [NSArray arrayWithObjects:o2, nil];
    
    NSDictionary *o1 = [NSDictionary dictionaryWithObjectsAndKeys:
                        @"5906c467845347110002f583", @"serviceId",
                        @(100), @"chargePerHour",
                        @"YES", @"nagotiable",
                        subarray, @"selectedSubServices",
                        
                        nil];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];


    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"https://u-snap.herokuapp.com/api/providers/providerRegistration"];
    
    NSString *URLString = @"https://u-snap.herokuapp.com/api/providers/providerRegistration";

    NSDictionary *parameters = @{@"sessionId": [defaults objectForKey:@"sessionid"], @"selectedServices": selected_services_info};

 //   [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];

    NSURLRequest *request = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:parameters error:nil];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        [SVProgressHUD dismiss];

        if (error) {
            [self showAlert:error.localizedDescription withtittle:@"Error"];
        } else {
            
            if(![[responseObject objectForKey:@"success_code"] isEqualToString:@"1"]){
                
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/@end
