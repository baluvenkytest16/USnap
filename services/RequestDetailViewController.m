//
//  RequestDetailViewController.m
//  services
//
//  Created by Mac on 8/3/17.
//  Copyright © 2017 Mac. All rights reserved.
//

#import "RequestDetailViewController.h"
#import "KIImagePager.h"

@interface RequestDetailViewController ()
@property (strong, nonatomic) IBOutlet UIView *sliderView;
@property (strong, nonatomic) IBOutlet UITextView *subject;
@property (strong, nonatomic) IBOutlet UITextView *message;
@property (strong, nonatomic) IBOutlet UILabel *serviceId;
@property (strong, nonatomic) IBOutlet UITextView *titletxtview;
@property (strong, nonatomic) IBOutlet UIButton *accept_btn;
@property (strong, nonatomic) IBOutlet UITextView *messagetextview;
@property (strong, nonatomic) IBOutlet UITextView *categorytextview;
@property (strong, nonatomic) IBOutlet UIButton *acceptn_btn_new;
- (IBAction)accept_btn_action:(id)sender;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *accept_btn_height;

@property (strong, nonatomic) IBOutlet UILabel *subserviceId;
@end

@implementation RequestDetailViewController
- (void)textViewDidChange:(UITextView *)textView
{
    CGFloat fixedWidth = textView.frame.size.width;
    CGSize newSize = [textView sizeThatFits:CGSizeMake(fixedWidth, MAXFLOAT)];
    CGRect newFrame = textView.frame;
    newFrame.size = CGSizeMake(fmaxf(newSize.width, fixedWidth), newSize.height);
    textView.frame = newFrame;
    textView.scrollEnabled = NO;
    [textView layoutIfNeeded];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titletxtview.text = self.serviceProvider.subject;
    self.messagetextview.text = self.serviceProvider.message;
    //self.categorytextview.text = self.serviceProvider.serviceName;
    
    self.categorytextview.text = [NSString stringWithFormat:@"%@ > %@", self.serviceProvider.serviceName,self.serviceProvider.subServiceName];
    
    [self textViewDidChange:self.titletxtview];
    [self textViewDidChange:self.messagetextview];
    [self textViewDidChange:self.categorytextview];
    
    //self.titleConstraint.constant = self.titletxtview.contentSize.height;
    //[self.titletxtview sizeToFit];

    //self.messageConstraint.constant = self.messagetextview.contentSize.height;
   // [self.messagetextview sizeToFit];

    //self.categoryConstraint.constant = self.categorytextview.contentSize.height;
   // [self.categorytextview sizeToFit];

    
    
    KIImagePager *kiimagepager = [[KIImagePager alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.sliderView.frame.size.height)];
    
    kiimagepager.dataSource = self;
    kiimagepager.imageSource= self;
    kiimagepager.delegate = self;
    kiimagepager.imageCounterDisabled = YES;
    
    //kiimagepager.pageControl.pageIndicatorTintColor = [UIColor orangeColor];
    
    kiimagepager.pageControl.currentPageIndicatorTintColor = [UIColor lightGrayColor];
    kiimagepager.pageControl.pageIndicatorTintColor = [UIColor blackColor];
    
    [[self.sliderView subviews]
     makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.sliderView addSubview:kiimagepager];
    self.sliderView.backgroundColor = [UIColor darkGrayColor];
    
    if([self.user_type isEqualToString:@"user"])
    {
        self.acceptn_btn_new.hidden = YES;
        self.accept_btn_height.constant = 0;
    }else{
        self.acceptn_btn_new.hidden = NO;
        self.accept_btn_height.constant = 45;
    }
    
    self.acceptn_btn_new.layer.cornerRadius=5;
    
}


- (NSArray *) arrayWithImages:(KIImagePager*)pager
{
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    
    for(int i=0;i<_serviceProvider.images.count;i++){
        //NSString *image_utl = @"https://u-snap.herokuapp.com";

        NSString *imageObject = [[_serviceProvider.images objectAtIndex:i] valueForKey:@"secureFileUrl"];
        
       // [images addObject:[image_utl stringByAppendingString:imageObject]];
        //NSLog(@"%@",[image_utl stringByAppendingString:imageObject]);
        
        [images addObject:imageObject];

            }
    
    
    
    return [NSArray arrayWithArray:images];;
    
}

- (UIViewContentMode) contentModeForImage:(NSUInteger)image inPager:(KIImagePager*)pager
{
    return UIViewContentModeScaleAspectFill;
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

-(void) imageWithUrl:(NSURL*)url completion:(KIImagePagerImageRequestBlock)completion{
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        dispatch_sync(dispatch_get_main_queue(), ^{
            if(completion) completion([UIImage imageWithData:imageData],nil);
        });
    });

}



- (IBAction)accept_btn_action:(id)sender {
}
@end
