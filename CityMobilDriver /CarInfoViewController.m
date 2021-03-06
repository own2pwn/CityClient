//
//  CarInfoViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/29/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "CarInfoViewController.h"
#import "OpenMapButtonHandler.h"
#import "CardsViewController.h"

@interface CarInfoViewController ()
{
    LeftMenu*leftMenu;
    
    RequestGetCarInfo* getCarInfoObject;
    ResponseGetCarInfo* getCarInfoResponse;
    
    
    CAGradientLayer* gradientLayer1;
    CAGradientLayer* gradientLayer2;
    CAGradientLayer* gradientLayer3;
    OpenMapButtonHandler*openMapButtonHandlerObject;
}
@end

@implementation CarInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    getCarInfoResponse = [[ResponseGetCarInfo alloc]init];
    self.carInfoTable.delegate = self;
    self.carInfoTable.dataSource = self;
}


-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if([ApiAbilitiesSingleTon sharedApiAbilities].yandex_enabled)
    {
        self.yandexButton.hidden=NO;
    }
    else
    {
        self.yandexButton.hidden=YES;
    }
    
     [[SingleDataProvider sharedKey]setGpsButtonHandler:self.gpsButton];
    if ([SingleDataProvider sharedKey].isGPSEnabled)
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
    }
    self.segmentControll.selectedSegmentIndex = 1;
     [GPSConection showGPSConection:self];
    leftMenu=[LeftMenu getLeftMenu:self];
    self.scrollView.userInteractionEnabled=YES;
    self.segmentControll.userInteractionEnabled=YES;
    self.scrollView.userInteractionEnabled=YES;
    
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    
    gradientLayer1 = [self greyGradient:self.bgView widthFrame:CGRectMake(0, 0, CGRectGetWidth(self.bgView.frame), CGRectGetHeight(self.bgView.frame)*9.f/19)];
    [self.bgView.layer insertSublayer:gradientLayer1 atIndex:0];
    
    gradientLayer3 = [self greyGradient:self.backgroundView widthFrame:CGRectMake(CGRectGetMaxX(self.carInfoTable.frame), 0, CGRectGetWidth(self.backgroundView.frame) - CGRectGetWidth(self.carInfoTable.frame), 44)];
    [self.backgroundView.layer insertSublayer:gradientLayer3 atIndex:0];
    
    
    self.bgView.backgroundColor = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1];
    //self.backgroundView.backgroundColor = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1];
    

    [self getCarInfo];
}


-(void)getCarInfo
{
    UIActivityIndicatorView* indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    
    
    getCarInfoObject = [[RequestGetCarInfo alloc]init];
    getCarInfoObject.key = [SingleDataProvider sharedKey].key;
    NSLog(@"%@",getCarInfoObject.key);
    NSDictionary* jsonDictionary=[getCarInfoObject toDictionary];
    NSString* jsons=[getCarInfoObject toJSONString];
    NSLog(@"%@",jsons);
    
    
    NSURL* url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"api_url"]];
    
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
    request.timeoutInterval = 30;
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!data)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alert show];
            [indicator stopAnimating];
            return ;
        }
        NSString* jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"%@",jsonString);
        NSError*err;
        
        if (jsonString.length > 5) {
            getCarInfoResponse = [[ResponseGetCarInfo alloc] initWithString:jsonString error:&err];
            
            BadRequest* badRequest = [[BadRequest alloc]init];
            badRequest.delegate = self;
            [badRequest showErrorAlertMessage:getCarInfoResponse.text code:getCarInfoResponse.code];
        }
        
        [self.carInfoTable reloadData];
        [indicator stopAnimating];
    }];
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [[UITableViewCell alloc]init];
    cell.backgroundColor = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1];
    [cell.textLabel setFont:[UIFont fontWithName:@"Roboto-Regular" size:13]];
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"Марка ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.mark];
            cell.textLabel.backgroundColor = [UIColor clearColor];
            cell.tag = 100;
            gradientLayer2 = [self greyGradient:cell widthFrame:CGRectMake(0, 0, CGRectGetWidth(self.carInfoTable.frame), CGRectGetHeight(cell.frame))];
            [cell.layer insertSublayer:gradientLayer2 atIndex:0];
            
            break;
        case 1:
            cell.textLabel.text = @"Модель ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.model];
            break;
        case 2:
            cell.textLabel.text = @"Год производства ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.year];
            break;
        case 3:
            cell.textLabel.text = @"Цвет ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.color];
            break;
        case 4:
            cell.textLabel.text = @"Гос.номер ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.reg_num];
            break;
        case 5:
            cell.textLabel.text = @"Vin-код ";
            [self setAtributedString:cell.textLabel :getCarInfoResponse.VIN];
            break;
        case 6:
            cell.textLabel.text = @"Лицензия ";
            [self setAtributedString:cell.textLabel :[NSString stringWithFormat:@"%@ - %@",getCarInfoResponse.car_license_pref,getCarInfoResponse.car_license_number]];
            break;
            
        default:
            break;
    }
    
    
    
    return cell;
}


-(void)setAtributedString:(UILabel*)label  :(NSString*)appendingString
{
    NSString* labelText = label.text;
    label.text = [label.text stringByAppendingString:appendingString];//
    NSRange range1 = [label.text rangeOfString:appendingString];
    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:label.text];
    float spacing = 0.1f;
    [attributedText addAttribute:NSKernAttributeName value:@(spacing) range:NSMakeRange(0, [labelText length])];
    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Roboto-Bold" size:13]} range:range1];
    label.attributedText=attributedText;
}


-(void)pushOrPopViewController:(UIViewController*)controller
{
    NSArray *viewControlles = self.navigationController.viewControllers;
    
    for (UIViewController* currentController in viewControlles) {
        if ([controller isKindOfClass:currentController.class]) {
            [self.navigationController popToViewController:currentController animated:NO];
            return;
        }
    }
    [self.navigationController pushViewController:controller animated:NO];
}


- (IBAction)segmentControllAction:(UISegmentedControl*)sender
{
    if (sender.selectedSegmentIndex == 0)
    {
        ProfilViewController* profilViewController=[self.storyboard instantiateViewControllerWithIdentifier:@"ProfilViewController"];
        [self pushOrPopViewController:profilViewController];
    }
    if (sender.selectedSegmentIndex == 1)
    {
    }
    if (sender.selectedSegmentIndex == 2) {
        CardsViewController* cvc =[self.storyboard instantiateViewControllerWithIdentifier:@"CardsViewController"];
        [self pushOrPopViewController:cvc];
    }
}

- (IBAction)edit:(UIButton *)sender {
    EditCarInfoViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCarInfoViewController"];
    controller.carImage = self.carImage.image;
    
    
    controller.markString = getCarInfoResponse.mark;
    controller.modelString = getCarInfoResponse.model;
    controller.colorString = getCarInfoResponse.color;
    controller.yearString = getCarInfoResponse.year;
    controller.gosNumberString = getCarInfoResponse.reg_num;
    controller.vinCodeString = getCarInfoResponse.VIN;
    controller.firstLicenseString = getCarInfoResponse.car_license_pref;
    controller.lastLicenseString = getCarInfoResponse.car_license_number;
    
    
    [self pushOrPopViewController:controller];
}


#pragma mark - gradient
- (CAGradientLayer*) greyGradient:(UIView*)view widthFrame:(CGRect) rect{
    UIColor *colorOne = [UIColor colorWithRed:198.f/255 green:198.f/255 blue:198.f/255 alpha:1.f];
    UIColor *colorTwo = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    headerLayer.frame = rect;
    
    return headerLayer;
}


#pragma mark - rotation
- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         gradientLayer1.frame = CGRectMake(0, 0,
                                CGRectGetWidth(self.bgView.frame),
                                CGRectGetHeight(self.bgView.frame)*9.f/19);
         
         gradientLayer2.frame = CGRectMake(0, 0,
                                CGRectGetWidth([self.carInfoTable viewWithTag:100].frame),
                                CGRectGetHeight([self.carInfoTable viewWithTag:100].frame));
         
         
         gradientLayer3.frame = CGRectMake(CGRectGetMaxX(self.carInfoTable.frame),
                                           0, CGRectGetWidth(self.backgroundView.frame)
                                           - CGRectGetWidth(self.carInfoTable.frame), 44);
     }
     
                                 completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
                                     CGFloat xx;
                                     
                                     if(leftMenu.flag==0)
                                     {
                                         xx=320*(CGFloat)5/6*(-1);
                                     }
                                     else
                                     {
                                         xx=0;
                                     }
                                     leftMenu.frame =CGRectMake(xx, leftMenu.frame.origin.y, leftMenu.frame.size.width, self.view.frame.size.height-64);
                                 }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}


#pragma mark - left Menu

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
{
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         CGPoint point;
         if (leftMenu.flag==0)
             point.x=(CGFloat)leftMenu.frame.size.width/2;
         else
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         point.y=leftMenu.center.y;
         leftMenu.center=point;
         
     }
                     completion:^(BOOL finished)
     {
         
         if (leftMenu.flag==0)
         {
             leftMenu.flag=1;
             self.scrollView.userInteractionEnabled = NO;
             self.segmentControll.userInteractionEnabled = NO;
             
             self.scrollView.tag=1;
             self.segmentControll.tag=2;
             [leftMenu.disabledViewsArray removeAllObjects];
          
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.scrollView.tag]];
         
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.segmentControll.tag]];
         }
         else
         {
             leftMenu.flag=0;
             self.scrollView.userInteractionEnabled = YES;
             self.segmentControll.userInteractionEnabled = YES;
         }
         
     }
     ];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint touchLocation = [touch locationInView:touch.view];
    if (leftMenu.flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
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
             leftMenu.flag=0;
             self.scrollView.userInteractionEnabled = YES;
             self.segmentControll.userInteractionEnabled = YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             self.scrollView.userInteractionEnabled = NO;
             self.segmentControll.userInteractionEnabled = NO;
             leftMenu.flag=1;
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
    if (leftMenu.flag==0 && touchLocation.x>((float)1/16 *self.view.frame.size.width))
        return;
    CGPoint point;
    point.x= touchLocation.x- (CGFloat)leftMenu.frame.size.width/2;
    point.y=leftMenu.center.y;
    if (point.x>leftMenu.frame.size.width/2)
    {
        return;
    }
    leftMenu.center=point;
    self.scrollView.userInteractionEnabled = NO;
    self.segmentControll.userInteractionEnabled = NO;
    leftMenu.flag=1;
}

- (IBAction)back:(UIButton *)sender {
    if (leftMenu.flag)
    {
        CGPoint point;
        point.x=leftMenu.center.x-leftMenu.frame.size.width;
        point.y=leftMenu.center.y;
        leftMenu.center=point;
        leftMenu.flag=0;
    }
    [self.navigationController popToRootViewControllerAnimated:NO];
}

- (IBAction)openMap:(UIButton*)sender
{
    openMapButtonHandlerObject=[[OpenMapButtonHandler alloc]init];
    [openMapButtonHandlerObject setCurentSelf:self];
}



@end
