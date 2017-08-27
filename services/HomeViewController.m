//
//  HomeViewController.m
//  services
//
//  Created by Mac on 4/19/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "HomeViewController.h"
#import "ServicesCollectionViewCell.h"
#import "BannerCollectionViewCell.h"
#import "AppDelegate.h"
#import "UIViewController+LGSideMenuController.h"
#import "KIImagePager.h"
#import "SignInViewController.h"
#import "MenuTableViewController.h"
#import "SVProgressHUD.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "SPListViewController.h"


//@import LGSideMenuController;



@interface HomeViewController ()
    {
        NSMutableArray *imgList;
        NSMutableArray *namesList;
        NSMutableArray *idList;

    }



    
- (IBAction)showMenu:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *login_to_see;

- (IBAction)showSearch:(id)sender;
    
@end


@implementation HomeViewController

    AppDelegate *appDelegate;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
   // self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    
//    namesList=[NSMutableArray arrayWithObjects:@"PLUMBING",@"PLUMBING",@"AC REPAIR",@"MUSIC LESSONS",@"PHOTOGRAPHY",@"LAYWERS",@"TAX FILLING",nil];
//    imgList=[NSMutableArray arrayWithObjects:@"plumbing",@"plumbing",@"ac",@"music",@"photo",@"lawer",@"tax",nil];
//
    
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"1" forKey:@"userlearned"];
    [defaults synchronize];
    
    
    
    namesList=[NSMutableArray arrayWithObjects:@"PLUMBING",nil];
    imgList=[NSMutableArray arrayWithObjects:@"plumbing",nil];
    idList=[NSMutableArray arrayWithObjects:@"plumbing",nil];

    
    
    
    _homeTable.delegate=self;
    _homeTable.dataSource=self;
    
    
   
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    self.navigationController.navigationBar.translucent = NO;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];

//    if([self.gotologin isEqualToString:@"login"]){
//        
//        
//        
//                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//                SignInViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
//                UIViewController *rootViewController = viewController;
//        
//        [self.navigationController pushViewController:rootViewController animated:YES];
//        
//        self.login_to_see.alpha=1;
//
//
//    }else{
//        self.login_to_see.alpha=0;
//
//        [self callapi];
//
//    }
    
    
    
    
    
    [self callapi];
            self.login_to_see.alpha=0;


    
   // [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(callapi) name:@"LoginChanged" object:nil];

    
    
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
    {
        return 1;
    }
    
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
    {
                    return namesList.count;
           }
    
- (UICollectionViewCell *)collectionView:(UICollectionView* )collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        if(indexPath.row == 0){
            BannerCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BannerCollectionViewCell" forIndexPath:indexPath];
            //cell.imageView1.image=[UIImage imageNamed:[imgList objectAtIndex:indexPath.row]];
            
           // cell.title1.text=[namesList objectAtIndex:indexPath.row];
           // cell.layer.borderWidth = 0.5f;
           // cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
            
            KIImagePager *kiimagepager = [[KIImagePager alloc] initWithFrame:CGRectMake(0, 0, self.homeTable.frame.size.width, self.homeTable.frame.size.height/3)];
            
            kiimagepager.dataSource = self;
            kiimagepager.imageSource= self;
            kiimagepager.imageCounterDisabled = YES;
            
            //kiimagepager.pageControl.pageIndicatorTintColor = [UIColor orangeColor];
            
            kiimagepager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
            kiimagepager.pageControl.pageIndicatorTintColor = [UIColor blackColor];

            [[cell.imagepager subviews]
        makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [cell.imagepager addSubview:kiimagepager];
            cell.backgroundColor = [UIColor redColor];
            
            return cell;
            
        }else{
            
        
        ServicesCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ServicesCollectionViewCell" forIndexPath:indexPath];
            
            if([[imgList objectAtIndex:indexPath.row] hasPrefix:@"http"]){
                
            
                [cell.imageView1 sd_setImageWithURL:[NSURL URLWithString:[imgList objectAtIndex:indexPath.row]]
                             placeholderImage:[UIImage imageNamed:@"placeholder.png"] ];
            }else{
                cell.imageView1.image=[UIImage imageNamed:[imgList objectAtIndex:indexPath.row]];

            }
                
            
        cell.title1.text=[namesList objectAtIndex:indexPath.row];
        cell.layer.borderWidth = 0.5f;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;

        return cell;
        }
        
    }
    
-(CGSize) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
    {
        
        if(indexPath.row == 0){
            return  CGSizeMake(collectionView.frame.size.width,collectionView.frame.size.height/3) ;
        }
        else
        return  CGSizeMake(collectionView.frame.size.width/2,150) ;
        
    }
-(UIEdgeInsets) collectionView:(UICollectionView *)collectionView layout:(UICollectionViewFlowLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
    {
        collectionViewLayout.minimumInteritemSpacing=0;
        collectionViewLayout.minimumLineSpacing =0;
        return UIEdgeInsetsMake(0, 0, 0, 0);
    }

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath  {
    
    //[self goToListView: [namesList objectAtIndex:indexPath.row]];
    
    [self goToListView:[namesList objectAtIndex:indexPath.row] withid:[idList objectAtIndex:indexPath.row]];
    
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

- (IBAction)showMenu:(id)sender {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftOpen" object:nil];

    [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
    
    }

- (IBAction)showSearch:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"SearchViewController"];
    viewController.title = @"Search";
    
    [self.navigationController pushViewController:viewController animated:YES];
    

}



- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    
    return @[
             [UIImage imageNamed:@"banner"],
             [UIImage imageNamed:@"banner"],
             [UIImage imageNamed:@"banner"],
             [UIImage imageNamed:@"banner"],
             [UIImage imageNamed:@"banner"]
             ];
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleAspectFill;
}


-(void)goToListView:(NSString *)title withid:(NSString *)serviceId{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    SPListViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"SPListViewController"];
    viewController.title = title;
    viewController.serviceId = serviceId;
    
    [self.navigationController pushViewController:viewController animated:YES];
}


-(void)callapi{
    
    [namesList removeAllObjects];
    [imgList removeAllObjects];
    [idList removeAllObjects];
    
    [namesList addObject:@""];
    [imgList addObject:@""];
    [idList addObject:@""];

    
    
    [self.homeTable reloadData];

    
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
            
            NSLog(@"data:%@",json);

            NSLog(@"%@",[json objectForKey:@"error_code"]);
            
            [namesList removeAllObjects];
            [imgList removeAllObjects];
            
            
            [namesList addObject:@""];
            [imgList addObject:@""];
            
            
            if([[json objectForKey:@"error_code"] isEqualToString:@"0"]){
                
                
              //  [self showAlert:[json objectForKey:@"message"] withtittle:@"Success"];
                
                NSMutableArray *services = [json objectForKey:@"services"];
                
                for (NSDictionary *whateverNameYouWant in services) {
                    
                    [namesList addObject:[whateverNameYouWant objectForKey:@"name"]];
                    [idList addObject:[whateverNameYouWant objectForKey:@"_id"]];
                    NSString *temp = [whateverNameYouWant objectForKey:@"serviceLogo"];
                    NSString *temp_dtl = [whateverNameYouWant objectForKey:@"serviceDtlsImage"];
                    
                    NSString *image_utl = @"https://u-snap.herokuapp.com/images/icons/";
                    
                    NSLog(@"%@",[image_utl stringByAppendingString:temp_dtl]);
                    
                    [imgList addObject:[image_utl stringByAppendingString:temp]];
                    
                    [appDelegate.banner_images setObject:[image_utl stringByAppendingString:temp_dtl] forKey:[whateverNameYouWant objectForKey:@"_id"]];
                    
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{

                [self.homeTable reloadData];
                    self.login_to_see.alpha=0;

                });
                
                
            }
            else{
                self.login_to_see.alpha=1;
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
                                     if([tittle isEqualToString:@"Error"])
                                         [self movetologin];
                                     
                                     
                                 }];
            
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
            
        }
        else{
            [self movetologin];
        }
        
    });
}

-(void)movetologin{
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SignInViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
    UIViewController *rootViewController = viewController;
    
    [self.navigationController pushViewController:rootViewController animated:YES];

}


@end
