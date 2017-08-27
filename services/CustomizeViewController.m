//
//  CustomizeViewController.m
//  services
//
//  Created by Mac on 5/11/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "CustomizeViewController.h"
#import "CustomizeTableViewCell.h"
#import "HeaderTableViewCell.h"
#import "SVProgressHUD.h"


@interface CustomizeViewController ()
{
    NSMutableArray *imgList;
    NSMutableArray *namesList;
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

@implementation CustomizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUserDetails:) name:@"serviceselected" object:nil];

    
    namesList=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    imgList=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    
    
    [namesList removeAllObjects];
    [imgList removeAllObjects];

    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomizeTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"CustomizeTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"HeaderTableViewCell" bundle:nil]
         forCellReuseIdentifier:@"HeaderTableViewCell"];
    
    [self getServices];
    
    
    
}

-(void)updateUserDetails:(NSNotification *) notification{
    
    NSDictionary *dict = notification.userInfo;
    NSString *message = [dict valueForKey:@"id"];
    if (message != nil) {
        NSLog(@"%@",message);

    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return namesList.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row!=0){
        
    CustomizeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CustomizeTableViewCell" forIndexPath:indexPath];
        
        cell.sub_ser_check.userInteractionEnabled = false;
        cell.sub_ser_check.boxType = BEMBoxTypeCircle;
        cell.sub_sp_name.text = [namesList objectAtIndex:indexPath.row-1];

        cell.selectionStyle = UITableViewCellSelectionStyleNone;

        return cell;

    }else{
        HeaderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HeaderTableViewCell" forIndexPath:indexPath];
        
        cell.nego_chekc.boxType = BEMBoxTypeCircle;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.charge_rate.keyboardType = UIKeyboardTypeDecimalPad;

        return cell;

        
    }
    
    
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // [tableView deselectRowAtIndexPath:indexPath animated:YES];

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    if(indexPath.row==0)
    return 150;
    else return 44;
}




-(void)getServices{
    
    [namesList removeAllObjects];
    [imgList removeAllObjects];
    
    
    //[namesList addObject:@""];
    //[imgList addObject:@""];
    
    
    [self.tableView reloadData];
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    
    
    NSString *post = [NSString stringWithFormat:
                      @"sessionId=%@&serviceId=%@",
                      [defaults objectForKey:@"sessionid"],self.serviceId];
    
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    
   // NSLog(@"%@",post);
    
    NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:@"https://u-snap.herokuapp.com/api/services/getSubServices"]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:postData];
    
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        [SVProgressHUD dismiss];
        
       // NSLog(@"eror:%@",error);
        //NSLog(@"response:%@",response.description);
        
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
                
                NSMutableArray *services = [json objectForKey:@"subServices"];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                    [namesList addObject:[whateverNameYouWant objectForKey:@"subServiceName"]];
                    NSString *temp = [whateverNameYouWant objectForKey:@"_id"];
                    
                    [imgList addObject:temp];
                    
                    
                    
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

@end
