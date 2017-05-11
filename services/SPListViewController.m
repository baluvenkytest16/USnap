//
//  SPListViewController.m
//  services
//
//  Created by Mac on 4/21/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SPListViewController.h"
#import "SPTableViewCell.h"

@interface SPListViewController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SPListViewController
{
    NSArray *tableData;
    NSArray *tableimages;
    
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
    
    
    tableData = [NSArray arrayWithObjects:@"My Addresses",@"My Warrantys", @"Order History", @"Notifications", @"Refer a Friend", @"Log In", nil];
    
    tableimages = [NSArray arrayWithObjects:@"location-gray",@"my-warranty", @"order-history", @"notifications", @"refer-friend", @"settings", nil];
    
    
    [self.tableView reloadData];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 20;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SPTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SPTableViewCell" forIndexPath:indexPath];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UIViewController *viewController =[storyboard instantiateViewControllerWithIdentifier:@"SPDetailViewController"];
    
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

@end
