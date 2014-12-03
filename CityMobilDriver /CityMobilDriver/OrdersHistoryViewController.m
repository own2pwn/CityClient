//
//  OrdersHistoryViewController.m
//  CityMobilDriver
//
//  Created by Arusyak Mikayelyan on 11/6/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "OrdersHistoryViewController.h"
#import "CustomCellOrdersHistory.h"
#import "SingleDataProviderForEndDate.h"
#import "SingleDataProviderForStartDate.h"
#import "OrdersHistoryResponse.h"
#import "OrdersHistoryJson.h"
#import "LeftMenu.h"
@interface OrdersHistoryViewController ()
{
 LeftMenu*leftMenu;
 NSInteger flag;
}
@end
@implementation OrdersHistoryViewController
{
    //Design For self.View
    CAGradientLayer *gradLayer;
    CAGradientLayer *gradLayerForSelfView;
    UIView * transparentView;
    //
    UITableView * tableViewInterval;
    NSArray*intervalArray;
    //Interface For the Views that surrounds datePicker
    UILabel * labelSettingTheDate;
    UIDatePicker * datePicker;
    UILabel * designLabel1;
    UIButton *  buttonCancell;
    UIButton * buttonSetStartDate;
    //Objects For Date Formating and Request
    NSDateFormatter *df;
    NSString *stringEndDate;
    OrdersHistoryResponse * ordersHistoryResponseObject;
    //Other
    UIAlertView *alertForNoInternetCon;
    UIAlertView *alertWrongData;
    UIActivityIndicatorView* indicator;
    NSInteger  ratingArray[5];
    NSMutableArray * arrayRateImageViews;
    float height;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //Setting Labels and Buttons clearColor
    self.GreyView.backgroundColor =[UIColor clearColor];
    self.labelInterval.backgroundColor =[UIColor clearColor];
    self.labelSelectedDate.backgroundColor=[UIColor clearColor];
    self.labelC.backgroundColor =[UIColor clearColor];
    self.labelPo.backgroundColor =[UIColor clearColor];
    self.designLabel.backgroundColor = [UIColor clearColor];
    //DatePickerPart
    stringEndDate = nil;
    datePicker =[[UIDatePicker alloc]init];
    [datePicker setDate:[NSDate date] animated:YES];
    df = [[NSDateFormatter alloc] init];
    df.dateStyle =NSDateFormatterMediumStyle;
    [df setDateFormat:@"yyyy-MM-dd"];
    self.labelSelectedDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:datePicker.date]];
    intervalArray =[ [NSArray alloc]initWithObjects:@"один день",@"три дня",@"одна неделя",@"две недели",@"месяц", nil];
    self.tableViewOrdersHistory.hidden = YES;
    //FONTS VIEWDIDLOAD
    self.labelC.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.labelPo.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.labelSelectedDate.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.labelInterval.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.buttonFind.titleLabel.font =[UIFont fontWithName:@"Roboto-Regular" size:15];
    self.titleLabel.font =[UIFont fontWithName:@"Roboto-Regular" size:18];
    //
    for (int i=0; i<5; i++)
    {
        ratingArray[i]=0;
    }
}

-(void)viewDidAppear:(BOOL)animated

{
    //Karen  Changing colours of icons
    [self.cityButton setNeedsDisplay];
    [self.yandexButton setNeedsDisplay];
    //Adding Gradient For self.view
    gradLayerForSelfView =[CAGradientLayer layer];
    UIColor * gradColStartSelView =[UIColor colorWithRed:223/255.0f green:223/255.0f blue:223/255.0f alpha:1.0f];
    UIColor * gradColFinSelView =[UIColor colorWithRed:232/255.0f green:232/255.0f blue:232/255.0f alpha:1.0f];
    gradLayerForSelfView.frame =CGRectMake(0,65, self.view.frame.size.width,self.view.frame.size.height);
    [gradLayerForSelfView setColors:[NSArray arrayWithObjects:(id)(gradColStartSelView.CGColor), (id)(gradColFinSelView.CGColor),nil]];
    [self.view.layer insertSublayer:gradLayerForSelfView atIndex:0];
    //Adding Gradient For GreyView
    gradLayer=[CAGradientLayer layer];
    UIColor * graColStart = [UIColor colorWithRed:212/255.0f green:212/255.0f blue:212/255.0f alpha:1.0f];
    UIColor * graColFin =[UIColor colorWithRed:233/255.0f green:233/255.0f blue:233/255.0f alpha:1.0f];
    gradLayer.frame = self.GreyView.bounds;
    [gradLayer setColors:[NSArray arrayWithObjects:(id)(graColStart.CGColor), (id)(graColFin.CGColor),nil]];
    [self.GreyView.layer insertSublayer:gradLayer atIndex:0];
    [super viewDidAppear:YES];
    leftMenu=[LeftMenu getLeftMenu:self];

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView ==tableViewInterval )
    {
     return intervalArray.count;
    }
    else
    {
    if (ordersHistoryResponseObject.orders.count !=0)
    {
        self.tableViewOrdersHistory.hidden = NO;
    }
     return ordersHistoryResponseObject.orders.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    height =38;
    NSString * myString = @"jsdfjhfjhsfjkhsfj";
    if (tableView==tableViewInterval)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
        if (cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"];
        }
        cell.textLabel.text = [intervalArray objectAtIndex:indexPath.row];
        cell.textLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
        return cell;
    }
    if([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_rating] && [[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_rating]integerValue] != -1)
    {
       if([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_review] && [[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_review].length !=0)
        {
            UILabel * labelDefiningSize;
            CGSize  expectSize;
            //NSString * myString =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]yandex_review];
            labelDefiningSize  = [[UILabel alloc] init];
            labelDefiningSize.text =myString;
            labelDefiningSize.numberOfLines = 0;
            labelDefiningSize.lineBreakMode = NSLineBreakByWordWrapping;
            CGSize maximumLabelSize = CGSizeMake(252,100);
            expectSize = [labelDefiningSize sizeThatFits:maximumLabelSize];
            if (expectSize.height<=20)
            {
                height =height+20;
            }
            else
            {
                height =height+expectSize.height;
            }
        }
        else
        {
            height =height +20;
        }
    }
    else
    {
        height = height +2;
    }
    NSString *simpleTableIdentifierIphone = @"SimpleTableCellIdentifier";
    CustomCellOrdersHistory * cell = (CustomCellOrdersHistory *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
    if (cell == nil)
    {
        
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellOrdersHistory2" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    arrayRateImageViews = [[NSMutableArray alloc]initWithObjects:cell.rateImgView1,cell.rateImgView2,cell.rateImgView3,cell.rateImgView4,cell.rateImgView5, nil];
    cell.labelYandexReview.numberOfLines = 0;
    cell.labelYandexReview.font=[UIFont fontWithName:@"Roboto-Regular" size:12];
    cell.labelYandexReview.lineBreakMode =  NSLineBreakByWordWrapping;
    cell.labelYandexReview.text = myString;
    cell.labelCallMetroName.font =[UIFont fontWithName:@"Roboto-Regular" size:12];
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]CollMetroName])
    {
        cell.labelCallMetroName.text =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]CollMetroName];
    }
    else
    {
        cell.labelCallMetroName.text = @"";
    }
    cell.deliveryMetroName.font =[UIFont fontWithName:@"Roboto-Regular" size:12];
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]DeliveryMetroName])
    {
        cell.deliveryMetroName.text =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]DeliveryMetroName];
    }
    else
    {
        cell.deliveryMetroName.text= @"";
    }
    cell.labelDate.textColor =[UIColor whiteColor];
    cell.labelDate.font = [UIFont fontWithName:@"RobotoCondensed-Regular" size:12];
    cell.labelDate.numberOfLines =2;
    NSString * collDate =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]CollDate];
    if (collDate)
    {
    NSString *collDate1 =[collDate substringToIndex:16];
    NSString * collDate2 =[collDate1 substringFromIndex:2];
    NSString * collDateFirstRow=[collDate2 substringToIndex:8];
    NSString * collDateSecondRow =[collDate2 substringFromIndex:9];
    NSString * stringForDate = [NSString stringWithFormat:@"%@\n%@",collDateFirstRow,collDateSecondRow];
    cell.labelDate.text = stringForDate;
    }
    else
    {
        cell.labelDate.text= @"";
    }
    cell.labelShortName.font = [UIFont fontWithName:@"Roboto-Regular" size:30];
    cell.labelShortName.textColor  = [UIColor whiteColor];
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]shortname])
    {
        cell.labelShortName.text =[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]shortname];
    }
    else
    {
        cell.labelShortName.text =@"";
    }
    if ([[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]price])
    {
        cell.labelPrice.text =[NSString stringWithFormat:@"%@ b",[[ordersHistoryResponseObject.orders objectAtIndex:indexPath.row]price]];
    }
    else
    {
        cell.labelPrice.text =@"";
    }
    if (height ==40)
    {
        cell.labelYandexReview.text = @"";
        cell.rateImgView1.hidden =YES;
        cell.rateImgView2.hidden = YES;
        cell.rateImgView3.hidden = YES;
        cell.rateImgView4.hidden =YES;
        cell.rateImgView5.hidden = YES;
    }
    [self addYandexRate:3];
    return  cell;
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==tableViewInterval)
    {
         return 44;
    }
    else
    {
     return height;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
if (tableView == tableViewInterval)
{
    [transparentView removeFromSuperview];
    [tableViewInterval removeFromSuperview];
    self.labelInterval.text = [intervalArray objectAtIndex:indexPath.row];
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    switch (indexPath.row) {
            case 0:
                [dateComponents setDay:1];
                break;
            case 1:
                [dateComponents setDay:3];
                break;
            case 2:
                [dateComponents setDay:7];
                break;
            case 3:
                [dateComponents setDay:14];
                break;
            case 4:
                [dateComponents setMonth:1];
                break;
            default:
                break;
 }
   NSCalendar *calendar = [NSCalendar currentCalendar];
   NSDate *endDate = [calendar dateByAddingComponents:dateComponents toDate:datePicker.date options:0];
   stringEndDate = [df stringFromDate:endDate];
   self.buttonIntervalTableView.userInteractionEnabled = YES;
}
else
{
[tableView deselectRowAtIndexPath:indexPath animated:NO];
}
}

- (IBAction)pickFromDate:(id)sender
{
    self.tableViewOrdersHistory.userInteractionEnabled = NO;
    self.buttonDatePicker.userInteractionEnabled = NO;
    transparentView = [[UIView alloc]initWithFrame:self.view.frame];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha =0.7;
    [self.view addSubview:transparentView];
    [self.view  addSubview:datePicker];
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePicker)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    [transparentView addGestureRecognizer:letterTapRecognizer];
    datePicker.datePickerMode = UIDatePickerModeDate;
    datePicker.hidden = NO;
    [datePicker addTarget:self action:@selector(changeDateInLabel:)forControlEvents:UIControlEventValueChanged];
    datePicker.backgroundColor = [UIColor whiteColor];
    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
        datePicker.frame =CGRectMake(self.tableViewOrdersHistory.frame.origin.x ,self.GreyView.frame.origin.y+50,self.tableViewOrdersHistory.frame.size.width,0);
    }
    else
    {
    datePicker.frame =CGRectMake(self.tableViewOrdersHistory.frame.origin.x+self.tableViewOrdersHistory.frame.size.width/4 ,self.GreyView.frame.origin.y+20,self.tableViewOrdersHistory.frame.size.width/2,0);
    }
    labelSettingTheDate = [[UILabel alloc]init];
    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
       [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
        labelSettingTheDate.frame  = CGRectMake(datePicker.frame.origin.x ,datePicker.frame.origin.y-50,datePicker.frame.size.width,50);
    }
    else
    {
        labelSettingTheDate.frame  = CGRectMake(datePicker.frame.origin.x ,datePicker.frame.origin.y-25,datePicker.frame.size.width,25);
    }
    labelSettingTheDate.font=[UIFont fontWithName:@"Roboto-Regular" size:15];
    labelSettingTheDate.textColor=[UIColor colorWithRed:44/255.0 green:203/255.0 blue:251/255.0 alpha:1];
    labelSettingTheDate.backgroundColor=[UIColor whiteColor];
    labelSettingTheDate.text=@"Настройка даты";
    labelSettingTheDate.textAlignment=NSTextAlignmentCenter;
    designLabel1=[[UILabel alloc]init];
    designLabel1.frame=CGRectMake(datePicker.frame.origin.x, labelSettingTheDate.frame.origin.y + labelSettingTheDate.frame.size.height, datePicker.frame.size.width,1);
    designLabel1.backgroundColor=[UIColor colorWithRed:44/255.0 green:203/255.0 blue:251/255.0 alpha:1];
    [self.view  addSubview:labelSettingTheDate];
    [self.view  addSubview:designLabel1];
    buttonCancell = [[UIButton alloc]init];
    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                        [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
        buttonCancell.frame =CGRectMake(datePicker.frame.origin.x,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,50);
    }
    else
    {
       buttonCancell.frame =CGRectMake(datePicker.frame.origin.x,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,25);
    }
    [[buttonCancell layer] setBorderWidth:1.0f];
    buttonCancell.layer.borderColor =[UIColor colorWithRed:44/255.0 green:203/255.0 blue:251/255.0 alpha:1].CGColor;
    buttonCancell.backgroundColor = [UIColor whiteColor];
    buttonCancell.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
    [buttonCancell setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonCancell  addTarget:self action:@selector(Cancell) forControlEvents:UIControlEventTouchUpInside];
    [buttonCancell setTitle:@"Отмена" forState:UIControlStateNormal];
    [self.view  addSubview:buttonCancell];
    buttonSetStartDate = [[UIButton alloc]init];
    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
                             [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
      buttonSetStartDate.frame =CGRectMake(datePicker.frame.origin.x+buttonCancell.frame.size.width,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,50);
    }
    else
    {
      buttonSetStartDate.frame =CGRectMake(datePicker.frame.origin.x+buttonCancell.frame.size.width,datePicker.frame.origin.y+datePicker.frame.size.height, datePicker.frame.size.width/2,25);
    }
    [[buttonSetStartDate layer] setBorderWidth:1.0f];
    buttonSetStartDate.layer.borderColor =[UIColor colorWithRed:44/255.0 green:203/255.0 blue:251/255.0 alpha:1].CGColor;
    buttonSetStartDate.backgroundColor = [UIColor whiteColor];
    buttonSetStartDate.titleLabel.font = [UIFont fontWithName:@"Roboto-Regular" size:15];
    [buttonSetStartDate setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [buttonSetStartDate addTarget:self action:@selector(setTime) forControlEvents:UIControlEventTouchUpInside];
    [buttonSetStartDate setTitle:@"Установить" forState:UIControlStateNormal];
    [self.view  addSubview:buttonSetStartDate];

}

-(void)Cancell
{
    self.buttonDatePicker.userInteractionEnabled = YES;
    [transparentView removeFromSuperview];
    [datePicker removeFromSuperview];
    [buttonCancell removeFromSuperview];
    [buttonSetStartDate removeFromSuperview];
    [labelSettingTheDate removeFromSuperview];
    [designLabel1 removeFromSuperview];
    self.tableViewOrdersHistory.userInteractionEnabled = YES;
}

-(void)setTime
{
    self.buttonDatePicker.userInteractionEnabled = YES;
    [datePicker removeFromSuperview];
    [transparentView removeFromSuperview];
    [buttonSetStartDate removeFromSuperview];
    [buttonCancell removeFromSuperview];
    [labelSettingTheDate removeFromSuperview];
    [designLabel1 removeFromSuperview];
    self.labelSelectedDate.text = [NSString stringWithFormat:@"%@",
                                  [df stringFromDate:datePicker.date]];
    self.tableViewOrdersHistory.userInteractionEnabled = YES;
}


-(void)removeDatePicker
{
    [transparentView removeFromSuperview];
    [datePicker removeFromSuperview];
    [labelSettingTheDate removeFromSuperview];
    [buttonCancell removeFromSuperview];
    [buttonSetStartDate removeFromSuperview];
    [tableViewInterval removeFromSuperview];
    [designLabel1 removeFromSuperview];
    self.buttonDatePicker.userInteractionEnabled = YES;
    self.buttonIntervalTableView.userInteractionEnabled = YES;
    
}

- (void)changeDateInLabel:(id)sender{
    //Use NSDateFormatter to write out the date in a friendly format
  
    
    
}

- (IBAction)pickToDate:(id)sender
{
    transparentView = [[UIView alloc]initWithFrame:self.view.frame];
    transparentView.backgroundColor = [UIColor blackColor];
    transparentView.alpha =0.7;
    UITapGestureRecognizer *letterTapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeDatePicker)];
    letterTapRecognizer.numberOfTapsRequired = 1;
    [transparentView addGestureRecognizer:letterTapRecognizer];
    [self.view addSubview:transparentView];
    if([[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortrait ||
    [[UIDevice currentDevice] orientation]==UIInterfaceOrientationPortraitUpsideDown)
    {
        tableViewInterval = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViewOrdersHistory.frame.origin.x ,self.GreyView.frame.origin.y,self.tableViewOrdersHistory.frame.size.width,5*44)];
        self.buttonIntervalTableView.userInteractionEnabled = NO;
    }else
    {
     tableViewInterval = [[UITableView alloc]initWithFrame:CGRectMake(self.tableViewOrdersHistory.frame.origin.x +self.GreyView.frame.size.width/4,self.GreyView.frame.origin.y-10,self.tableViewOrdersHistory.frame.size.width/2,5*44)];
     self.buttonIntervalTableView.userInteractionEnabled = NO;
      }
    tableViewInterval.delegate = self;
    tableViewInterval.dataSource= self;
    [self.view addSubview:tableViewInterval];
}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(BOOL) shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}
- (IBAction)findOrdersFromInterval:(id)sender
{
    [SingleDataProviderForStartDate sharedStartDate].startDate = self.labelSelectedDate.text;
    [SingleDataProviderForEndDate sharedEndDate].endDate = stringEndDate;
    [self requestOrdersHistory];
}

-(void)requestOrdersHistory
{
    indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    indicator.center = self.view.center;
    indicator.color=[UIColor blackColor];
    [indicator startAnimating];
    [self.view addSubview:indicator];
    OrdersHistoryJson * ordersHistoryJsonObject = [[OrdersHistoryJson alloc]init];
    NSDictionary*jsonDictionary=[ordersHistoryJsonObject  toDictionary];
    NSString*jsons=[ordersHistoryJsonObject  toJSONString];
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
            alertForNoInternetCon = [[UIAlertView alloc] initWithTitle:@"ERROR"
                                                            message:@"NO INTERNET CONECTION"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            
            
            [alertForNoInternetCon show];
            return ;
        }
        NSString* jsonString1 = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"selectedOrdersDetails =%@",jsonString1);
        NSError*err;
        ordersHistoryResponseObject  = [[OrdersHistoryResponse alloc] initWithString:jsonString1 error:&err];
        if(ordersHistoryResponseObject.code!=nil)
        {
            
            alertWrongData = [[UIAlertView alloc] initWithTitle:@"Ошибка"
                                                            message:nil
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alertWrongData show];
            return;
            
        }
        [indicator stopAnimating];
        [self.tableViewOrdersHistory reloadData];
        
    }];
}

- (IBAction)openAndCloseLeftMenu:(UIButton *)sender
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
             self.tableViewOrdersHistory.userInteractionEnabled=NO;
             
         }
         else
         {
             flag=0;
             self.tableViewOrdersHistory.userInteractionEnabled=YES;
             
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
             self.tableViewOrdersHistory.userInteractionEnabled=YES;
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.tableViewOrdersHistory.userInteractionEnabled=NO;
             
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
    self.tableViewOrdersHistory.userInteractionEnabled=NO;
    flag=1;
}

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{

    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        

        UIDeviceOrientation deviceOrientation   = [[UIDevice currentDevice] orientation];
        
        if (UIDeviceOrientationIsLandscape(deviceOrientation)) {
            NSLog(@"Will change to Landscape");
            self.buttonDatePicker.userInteractionEnabled = YES;
            self.buttonIntervalTableView.userInteractionEnabled = YES;
            [transparentView removeFromSuperview];
            [datePicker removeFromSuperview];
            [labelSettingTheDate removeFromSuperview];
            [buttonSetStartDate removeFromSuperview];
            [buttonCancell removeFromSuperview];
            [tableViewInterval removeFromSuperview];
            [designLabel1 removeFromSuperview];
            indicator.center = self.view.center;
            gradLayer.frame =CGRectMake(0, 0, self.GreyView.frame.size.width,self.GreyView.frame.size.height);
            gradLayerForSelfView.frame =CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);

}

        else {
            NSLog(@"Will change to Portrait");
            self.buttonDatePicker.userInteractionEnabled = YES;
            self.buttonIntervalTableView.userInteractionEnabled = YES;
            [transparentView removeFromSuperview];
            [datePicker removeFromSuperview];
            [labelSettingTheDate removeFromSuperview];
            [buttonCancell removeFromSuperview];
            [buttonSetStartDate removeFromSuperview];
            [tableViewInterval removeFromSuperview];
            [designLabel1 removeFromSuperview];
            gradLayer.frame = CGRectMake(0, 0, self.GreyView.frame.size.width,self.GreyView.frame.size.height);
            gradLayerForSelfView.frame =CGRectMake(0, 0, self.view.frame.size.width,self.view.frame.size.height);
            indicator.center = self.view.center;
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



-(void)addYandexRate:(NSInteger)k
{
 
    for (int i=0; i<k; i++)
    {
        ratingArray[i]=1;
    }

    for (int i =0; i<5; i++)
    {
        UIImageView * imgView = [arrayRateImageViews objectAtIndex:i];
       if (ratingArray[i]==1)
        {
            
            imgView.image =[UIImage imageNamed:@"star.png"];
        }
        else
        {
            imgView.image = [UIImage imageNamed:@"star_none.png"];
        }
        
        
    }

}

- (IBAction)actionGPS:(id)sender {
}

- (IBAction)refresh:(id)sender {
}
@end
