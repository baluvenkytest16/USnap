//
//  SPDetailViewController.m
//  services
//
//  Created by Mac on 4/23/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "SPDetailViewController.h"
#import "DetailFirstTableViewCell.h"
#import "DetailsSecondTableViewCell.h"
#import "DetailThirdTableViewCell.h"

@interface SPDetailViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SPDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailFirstTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailFirstTableViewCell"];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsSecondTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailsSecondTableViewCell"];

    [self.tableView registerNib:[UINib nibWithNibName:@"DetailThirdTableViewCell" bundle:nil] forCellReuseIdentifier:@"DetailThirdTableViewCell"];


    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if(indexPath.row==0){
        DetailFirstTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailFirstTableViewCell"];
        
        return cell;
        
    }else if(indexPath.row==1){
        DetailsSecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailsSecondTableViewCell"];
        return cell;

    }else{
        DetailThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DetailThirdTableViewCell"];
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 160;
    }
    else if(indexPath.row == 1){
        return 200;
    }else{
        return 70;

    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
