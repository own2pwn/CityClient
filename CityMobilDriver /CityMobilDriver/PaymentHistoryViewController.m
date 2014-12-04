//
//  PaymentHistoryViewController.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 12/3/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "PaymentHistoryViewController.h"
#import "PaymentHistoryCustomCell.h"
#import"GetPaymentsJson.h"
#import "GetPaymentsResponse.h"
#import "LeftMenu.h"
@interface PaymentHistoryViewController ()
{
    //NAREK
    LeftMenu*leftMenu;
    NSInteger flag;
    UISwipeGestureRecognizer*recognizerRight;
    UIAlertView *callDispetcherAlert;

}
@end

@implementation PaymentHistoryViewController
{
CAGradientLayer * gradLayerForSelfView;
GetPaymentsResponse * getPaymentsResponseObject;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    // Do any additional setup after loading the view
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    //Settings Buttons
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    //Left Menu
    flag=0;
    self.PaymentsHistoryTableView.userInteractionEnabled=YES;
    leftMenu=[LeftMenu getLeftMenu:self];
    //Payments
    [self requestGetPayments];
    gradLayerForSelfView =[CAGradientLayer layer];
    UIColor * gradColStartSelView =[UIColor colorWithRed:224/255.0f green:224/255.0f blue:224/255.0f alpha:1.0f];
    UIColor * gradColFinSelView =[UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:1.0f];
    gradLayerForSelfView.frame =self.viewForGradient.bounds;
    [gradLayerForSelfView setColors:[NSArray arrayWithObjects:(id)(gradColStartSelView.CGColor), (id)(gradColFinSelView.CGColor),nil]];
    [self.viewForGradient.layer insertSublayer:gradLayerForSelfView atIndex:0];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
 return  getPaymentsResponseObject.result.count;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
 PaymentHistoryCustomCell* cell = [[PaymentHistoryCustomCell alloc]init];
 NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PaymentHistoryCustomCell" owner:self options:nil];
 cell = [nib objectAtIndex:0];
 cell.oppDate=[[getPaymentsResponseObject.result objectAtIndex:indexPath.row]oppdate];
 cell.sum=[[getPaymentsResponseObject.result objectAtIndex:indexPath.row]sum];
 cell.comment=[[getPaymentsResponseObject.result objectAtIndex:indexPath.row]comment];
 [cell updateLabels];
 return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * labelCalculateHeightOfCell;
    CGSize  expectSizeForHeight;
    if ([[getPaymentsResponseObject.result objectAtIndex:indexPath.row]comment])
    {
        labelCalculateHeightOfCell =[[UILabel alloc]init];
        labelCalculateHeightOfCell.text=[[getPaymentsResponseObject.result objectAtIndex:indexPath.row]comment];
        labelCalculateHeightOfCell.font=[UIFont fontWithName:@"Roboto-Regular" size:14];
        labelCalculateHeightOfCell.numberOfLines=0;
        labelCalculateHeightOfCell.lineBreakMode=NSLineBreakByWordWrapping;
        CGSize maximumLabelSize = CGSizeMake(90,100);
        expectSizeForHeight = [labelCalculateHeightOfCell sizeThatFits:maximumLabelSize];
    }
    if (expectSizeForHeight.height<44)
    {
        return 44;
    }
    else
    {
    return expectSizeForHeight.height;
    }

}

-(void)requestGetPayments
{
    GetPaymentsJson* getPaymentJsonObject=[[GetPaymentsJson alloc]init];
    NSDictionary*jsonDictionary=[getPaymentJsonObject toDictionary];
    NSString*jsons=[getPaymentJsonObject toJSONString];
    NSLog(@"%@",jsons);
    NSURL* url = [NSURL URLWithString:@"https://driver-msk.city-mobil.ru/taxiserv/api/driver/"];
    NSError* error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setHTTPBody:jsonData];
    request.timeoutInterval = 10;
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            
            UIAlertController *alertNoCon = [UIAlertController alertControllerWithTitle:@ "Нет соединения с интернетом!" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertNoCon dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertNoCon addAction:cancel];
            [self presentViewController:alertNoCon animated:YES completion:nil];
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"First Json String %@",jsonString);
        NSError*err;
        getPaymentsResponseObject = [[GetPaymentsResponse alloc] initWithString:jsonString error:&err];
        if( getPaymentsResponseObject.code!=nil)
        {
            UIAlertController *alertServerErr = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:getPaymentsResponseObject.text preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction*cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                              [alertServerErr dismissViewControllerAnimated:YES completion:nil];
                                                          }];
            [alertServerErr addAction:cancel];
            [self presentViewController:alertServerErr animated:YES completion:nil];
        }
        [self.PaymentsHistoryTableView reloadData];
        
        
     
        
    }];
    
}


- (IBAction)openAndCloseLeftMenu:(id)sender
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         CGPoint point;
         if (flag==0)
             point.x=(CGFloat)leftMenu.frame.size.width/2;
         else
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         point.y=leftMenu.center.y;
         leftMenu.center=point;
         
     }
                     completion:^(BOOL finished)
     {
         
         if (flag==0)
         {
             flag=1;
             self.PaymentsHistoryTableView.userInteractionEnabled=NO;
         }
         else
         {
             flag=0;
             self.PaymentsHistoryTableView.userInteractionEnabled=YES;
             
         }
         
     }
     
     
     ];

}

- (IBAction)back:(id)sender
{
    if (flag)
    {
        CGPoint point;
        point.x=leftMenu.center.x-leftMenu.frame.size.width;
        point.y=leftMenu.center.y;
        leftMenu.center=point;
    }
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)refresh:(id)sender
{
    [self requestGetPayments];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if (flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
        return;
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         CGPoint point;
         NSLog(@"\n%f", 2*leftMenu.center.x);
         NSLog(@"\n%f",leftMenu.frame.size.width/2);
         if (touchLocation.x<=leftMenu.frame.size.width/2)
         {
             flag=0;
             self.PaymentsHistoryTableView.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             self.PaymentsHistoryTableView.userInteractionEnabled=NO;
             flag=1;
         }
         point.y=leftMenu.center.y;
         leftMenu.center=point;
         NSLog(@"\n%f",leftMenu.frame.size.width);
         
     }
                     completion:nil
     ];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if (flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
        return;
    CGPoint point;
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    self.PaymentsHistoryTableView.userInteractionEnabled=NO;
    flag=1;
    
}


- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        UIDeviceOrientation deviceOrientation   = [[UIDevice currentDevice] orientation];
        
        if (UIDeviceOrientationIsLandscape(deviceOrientation))
        {
            NSLog(@"Will change to Landscape");
            gradLayerForSelfView.frame=self.viewForGradient.bounds;
        }
        else
        {
            NSLog(@"Will change to Portrait");
            gradLayerForSelfView.frame=self.viewForGradient.bounds;
            
        }
        
        
    }
     completion:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         CGFloat xx;
         if(flag==0)
         {
             xx=self.view.frame.size.width*(CGFloat)5/6*(-1);
         }
         else
         {
             xx=0;
         }
         leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-64);
         
     }];
 [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
    
    
    
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
