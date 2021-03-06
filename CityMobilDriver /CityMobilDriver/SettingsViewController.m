//
//  SettingsViewController.m
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "SettingsViewController.h"
#import "SucceedResponse.h"
#import "yandexIcon.h"
#import "IconsColorSingltone.h"
#import "OpenMapButtonHandler.h"
@interface SettingsViewController ()
{
    LeftMenu*leftMenu;
    OpenMapButtonHandler*openMapButtonHandlerObject;
    
    UIView* backgroundView;
    UIView* fontSizeView;
    UIView* fontStileView;
    
    UITableView* fontSizeTableView;
    UITableView* StileIconTableView;
    UITableView* selectLanguageTableView;
    
    
    NSString* fontSizeText;
    NSString* fontStileText;
    NSString* languageText;

    CAGradientLayer* backgroundLayer;
    CAGradientLayer* gradientLayer;
}
@property(nonatomic,strong) UIColor* buttonTextColor;


@end

@implementation SettingsViewController




#pragma mark - lifecicle Object
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.balance.text =[self.balance.text stringByAppendingString:[NSString stringWithFormat:@"  %@",[UserInformationProvider sharedInformation].balance]];
    self.limit.text =[self.limit.text stringByAppendingString:[NSString stringWithFormat:@"  %@",[UserInformationProvider sharedInformation].credit_limit]];
    self.callsign.text =[self.callsign.text stringByAppendingString:[NSString stringWithFormat:@"  %@",[UserInformationProvider sharedInformation].bankid]];
    self.buttonTextColor = self.required.titleLabel.textColor;
    
    
    
    backgroundLayer = [self greyBackgroundGradient];
    backgroundLayer.frame = self.view.bounds;
    [self.view.layer insertSublayer:backgroundLayer atIndex:0];
    

    
    
    if([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait ||
       [[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown)
    {
        /// detect if iphone 4s ///
        if (CGRectGetHeight(self.view.frame) == 480) {
            self.bgViewHeight.constant = 248;
        }
        else{
            self.bgViewHeight.constant = CGRectGetHeight(self.view.frame) - 300;
        }
    }
    else{
        /// detect if ipad ///
        if (CGRectGetHeight(self.view.frame) == 768) {
            self.bgViewHeight.constant = CGRectGetHeight(self.view.frame) - 300;
        }
        else{
            self.bgViewHeight.constant = 248;
        }
    }
}

-(void)viewDidAppear:(BOOL)animated
{
    
    if([ApiAbilitiesSingleTon sharedApiAbilities].autoassignment_enabled)
    {
        self.yandexLabel.hidden=NO;
        self.cityLabel.hidden=NO;
        self.yandexView.hidden=NO;
        self.cityView.hidden=NO;
    }
    else
    {
        self.yandexLabel.hidden=YES;
        self.cityLabel.hidden=YES;
        self.yandexView.hidden=YES;
        self.cityView.hidden=YES;
    }
    
    if([ApiAbilitiesSingleTon sharedApiAbilities].yandex_enabled)
    {
        self.yandexLabel.hidden=NO;
        self.yandexView.hidden=NO;
        
        self.yandexIcon.hidden=NO;
    
    }
    else
    {
        self.yandexLabel.hidden=YES;
        self.yandexView.hidden=YES;
        
        self.yandexIcon.hidden=YES;

    }

    
    
    [GPSConection showGPSConection:self];
     [[SingleDataProvider sharedKey]setGpsButtonHandler:self.gpsButton];
    if ([SingleDataProvider sharedKey].isGPSEnabled)
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps_green.png"] forState:UIControlStateNormal];
        
    }
    else
    {
        [self.gpsButton setImage:[UIImage imageNamed:@"gps.png"] forState:UIControlStateNormal];
    }
    self.scrolView.userInteractionEnabled=YES;
    leftMenu=[LeftMenu getLeftMenu:self];
    
    //narek change
    
    CGPoint point;
    point.x=leftMenu.center.x-leftMenu.frame.size.width;
    point.y=leftMenu.center.y;
    leftMenu.center=point;
    leftMenu.flag=0;
    /////////////////
    
    [super viewDidAppear:animated];

    
    NSInteger fontNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"fontSize"];
    
    if (fontNubmer == 0) {
        [self replaceString:self.fontSize.titleLabel widthString:@"  Мелкий"];
    }
    if (fontNubmer == 1) {
        [self replaceString:self.fontSize.titleLabel widthString:@"  Обычный"];
    }
    if (fontNubmer == 2) {
        [self replaceString:self.fontSize.titleLabel widthString:@"  Крупный"];
    }
    
    
    NSInteger styleNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"stileIcon"];
    
    if (styleNubmer == 0) {
        [self replaceString:self.stileIcon.titleLabel widthString:@"  Радужный"];
    }
    if (styleNubmer == 1) {
        [self replaceString:self.stileIcon.titleLabel widthString:@"  Черный"];
    }
    
    
    NSInteger languageNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"language"];
    
    if (languageNubmer == 0) {
        [self replaceString:self.selectLanguage.titleLabel widthString:@"  Русский"];
    }
    if (languageNubmer == 1) {
        [self replaceString:self.selectLanguage.titleLabel widthString:@"  English"];
    }
    
    fontSizeText = [self replaceString:self.fontSize.titleLabel.text];
    fontStileText = [self replaceString:self.stileIcon.titleLabel.text];
    languageText = [self replaceString:self.selectLanguage.titleLabel.text];
    
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"isNightMode"] boolValue]) {
        [self.checkBox.imageView setImage:[UIImage imageNamed:@"box2.png"]];
        [self setAppMode];
    }
    
    
    
    if ([IconsColorSingltone sharedColor].cityMobilColor == 0) {
        [self.off setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.notRequired setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.required setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if ([IconsColorSingltone sharedColor].cityMobilColor == 1) {
        [self.required setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.notRequired setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [self.off setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    if ([IconsColorSingltone sharedColor].cityMobilColor == 2) {
        [self.off setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.notRequired setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.required setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    }
    
    
    if ([IconsColorSingltone sharedColor].yandexColor == 0) {
        [self.on setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [self.yandexOff setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    }
    
    if ([IconsColorSingltone sharedColor].yandexColor == 1) {
        [self.on setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.yandexOff setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
    }
    
    self.scrolView.showsHorizontalScrollIndicator = NO;
    self.scrolView.delegate = self;
    
    self.settingsView.backgroundColor = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1];
    gradientLayer = [self greyGradient];
    gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.settingsView.frame), CGRectGetHeight(self.settingsView.frame)*9.f/46);
    [self.settingsView.layer insertSublayer:gradientLayer atIndex:0];
    

}

#pragma mark - scrollView horizontal scroll

- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    
    if (sender.contentOffset.x != 0)
    {
        CGPoint offset = sender.contentOffset;
        offset.x = 0;
        sender.contentOffset = offset;
    }
}

-(void) replaceString:(UILabel*)label widthString:(NSString*) newString{
    NSRange range = [label.text rangeOfString:@":"];
    NSString* subString = [label.text substringFromIndex:range.location + 1];
    label.text = [label.text stringByReplacingOccurrencesOfString:subString withString:newString];
}

-(NSString*) replaceString:(NSString*)string{
    NSRange range = [string rangeOfString:@":"];
    return [string substringFromIndex:range.location + 1];
}



- (IBAction)offAction:(id)sender
{
    [self setAutoAssign:0];
}

- (IBAction)notRequiredAction:(id)sender
{
    [self setAutoAssign:1];
}

- (IBAction)requiredAction:(id)sender
{
    [self setAutoAssign:2];
}


#pragma mark - yandex Settings
- (IBAction)onAction:(id)sender
{
    [self setYandexAutoAssign:1];
}
- (IBAction)yandexOffAction:(id)sender
{
    [self setYandexAutoAssign:0];
}

#pragma mark - Requests
-(void)setAutoAssign:(NSInteger)state
{
    RequestSetAutoget* RequestObject=[[RequestSetAutoget alloc]init];
    RequestObject.state = state;
    NSDictionary* jsonDictionary = [RequestObject toDictionary];
    
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        SucceedResponse* responseObject = [[SucceedResponse alloc]initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:responseObject.text code:responseObject.code];
        
        if (responseObject.result == 1) {
            switch (state) {
                case 0:
                    [self.notRequired setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.required setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.off setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                    
                    [self.cityIcon setImage:[UIImage imageNamed:@"icon.png"] forState:UIControlStateNormal];
                    [IconsColorSingltone sharedColor].cityMobilColor = 0;
                    
                    break;
                    
                case 1:
                    [self.off setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.required setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.notRequired setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
                    
                    [self.cityIcon setImage:[UIImage imageNamed:@"set3_orange.png"] forState:UIControlStateNormal];
                    [IconsColorSingltone sharedColor].cityMobilColor = 1;
                    break;
                case 2:
                    [self.required setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                    [self.notRequired setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    [self.off setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
                    
                    [self.cityIcon setImage:[UIImage imageNamed:@"icon_green.png"] forState:UIControlStateNormal];
                    [IconsColorSingltone sharedColor].cityMobilColor = 2;
                    break;
                default:
                    break;
            }
        }

        
    }];
}

-(void)setYandexAutoAssign:(NSInteger)y_state
{
    RequestSetYandexAutoget* RequestObject=[[RequestSetYandexAutoget alloc]init];
    RequestObject.y_state = y_state;
    NSDictionary* jsonDictionary = [RequestObject toDictionary];
    
    NSURL* url = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] stringForKey:@"api_url"]];
    
    NSError* error;
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDictionary
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    
    NSString*jsons=[RequestObject toJSONString];
    NSLog(@"%@",jsons);
    
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
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@ "Ошибка сервера" message:@"Нет соединения с интернетом!" preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                           handler:^(UIAlertAction * action)
                                     {
                                         [alert dismissViewControllerAnimated:YES completion:nil];
                                         
                                     }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
            return ;
        }
        
        NSError* err;
        NSString* jsonString = [[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding];
        SucceedResponse* responseObject = [[SucceedResponse alloc]initWithString:jsonString error:&err];
        
        BadRequest* badRequest = [[BadRequest alloc]init];
        badRequest.delegate = self;
        [badRequest showErrorAlertMessage:responseObject.text code:responseObject.code];
        
        if (responseObject.result == 1) {
        switch (y_state) {
            case 0:
            {
                [self.yandexOff setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                [self.on setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
                [IconsColorSingltone sharedColor].yandexColor = 0;
                [self.yandexIcon setImage:[UIImage imageNamed:@"ya@2x"] forState:UIControlStateNormal];
                break;
            }
            case 1:
            {
                [self.on setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
                [self.yandexOff setTitleColor:self.buttonTextColor forState:UIControlStateNormal];
                [IconsColorSingltone sharedColor].yandexColor = 1;
                [self.yandexIcon setImage:[UIImage imageNamed:@"ya_green.png"] forState:UIControlStateNormal];
            }
                break;
            default:
                break;
        }
        }
    }];
}


#pragma mark - program settings

- (IBAction)fontSize:(id)sender{
    
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundView];
    
    
    fontSizeView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 250)];
    fontSizeView.center = self.view.center;
    [self.view addSubview:fontSizeView];

    
    fontSizeTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, fontSizeView.frame.size.width, 250)];
    fontSizeTableView.scrollEnabled = NO;
    fontSizeTableView.delegate = self;
    fontSizeTableView.dataSource = self;
//    [fontSizeTableView setSeparatorInset:UIEdgeInsetsZero];
    [fontSizeView addSubview:fontSizeTableView];
    
    
}


- (IBAction)stileIcon:(id)sender
{
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundView];
    
    
    fontStileView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 200)];
    fontStileView.center = self.view.center;
    [self.view addSubview:fontStileView];
    

    StileIconTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, fontStileView.frame.size.width, 200)];
    StileIconTableView.scrollEnabled = NO;
    StileIconTableView.delegate = self;
    StileIconTableView.dataSource = self;
    [fontStileView addSubview:StileIconTableView];

}


- (IBAction)selectLanguage:(id)sender{
    
    backgroundView = [[UIView alloc]initWithFrame:self.view.frame];
    backgroundView.alpha = 0.5;
    backgroundView.backgroundColor = [UIColor grayColor];
    backgroundView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view addSubview:backgroundView];
    
    
    fontStileView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 310, 200)];
    fontStileView.center = self.view.center;
    [self.view addSubview:fontStileView];

    selectLanguageTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, fontStileView.frame.size.width, 200)];
    selectLanguageTableView.scrollEnabled = NO;
    selectLanguageTableView.delegate = self;
    selectLanguageTableView.dataSource = self;
    [fontStileView addSubview:selectLanguageTableView];
}



- (IBAction)nightModeAction:(id)sender
{
    
//    NSNumber* isNightMode = nil;
//    if (![self.checkBox isSelected]) {
//        self.backgroundImage.image = [UIImage imageNamed:@"pages_background.png"];
//        self.settings.textColor = [UIColor orangeColor];
//        self.yandexSettings.textColor = [UIColor orangeColor];
//        isNightMode = [NSNumber numberWithBool:YES];
//        [self.checkBox setSelected:YES];
//    }
//    else{
//        self.backgroundImage.image = [UIImage imageNamed:@"notFoundImage.png"];
//        self.settings.textColor = [UIColor blackColor];
//        self.yandexSettings.textColor = [UIColor blackColor];
//        isNightMode = [NSNumber numberWithBool:NO];
//        [self.checkBox setSelected:NO];
//    }
    
//    [[NSUserDefaults standardUserDefaults] setObject:isNightMode forKey:@"isNightMode"];
//    [[NSUserDefaults standardUserDefaults] synchronize];
    
    if ([self.checkBox isSelected]) {
        [self.checkBox setSelected:NO];
    }
    else{
        [self.checkBox setSelected:YES];
    }
    
}

-(void)setAppMode
{
    if ([self image:self.checkBox.imageView.image isEqualTo:[UIImage imageNamed:@"box2.png"]])
    {
        self.backgroundImage.image = [UIImage imageNamed:@"pages_background.png"];
        self.settings.textColor = [UIColor orangeColor];
        self.yandexSettings.textColor = [UIColor orangeColor];
    }
    else
    {
        self.backgroundImage.image = [UIImage imageNamed:@"notFoundImage.png"];
        self.settings.textColor = [UIColor blackColor];
        self.yandexSettings.textColor = [UIColor blackColor];
    }
}

- (BOOL)image:(UIImage *)image1 isEqualTo:(UIImage *)image2
{
    NSData *data1 = UIImagePNGRepresentation(image1);
    NSData *data2 = UIImagePNGRepresentation(image2);
    return [data1 isEqual:data2];
}


#pragma mark Table View settings

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 50;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView* titleView = [[UIView alloc]init];
    titleView.backgroundColor = [UIColor whiteColor];
    
    UILabel* titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 310, 48)];
    titleLabel.textColor = [UIColor colorWithRed:19.f/255 green:146.f/255 blue:200.f/255 alpha:1];
    if (tableView == fontSizeTableView) {
        titleLabel.text = @"   Размер шрифта";
    }
    if (tableView == StileIconTableView) {
        titleLabel.text = @"   Стиль иконок";
    }
    if (tableView == selectLanguageTableView) {
        titleLabel.text = @"   Выберите язык";
    }
    
    [titleView addSubview:titleLabel];
    
    UIView* lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 48, 310, 2)];
    lineView.backgroundColor = [UIColor colorWithRed:227/255 green:227/255 blue:229/255 alpha:0.1];
    [titleView addSubview:lineView];
    
    
    return titleView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == fontSizeTableView)
    {
        return 5;
    }
    if (tableView == StileIconTableView || tableView == selectLanguageTableView)
    {
        return 4;
    }
    return 0;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* okCell = [[UITableViewCell alloc]init];
    if (tableView == fontSizeTableView)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        CustomTableViewCell* cell = [nibArray objectAtIndex:0];

        [tableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        
        switch (indexPath.row)
        {
            case 0:
                cell.cellText.text = @"   Мелкий";
                break;
            case 1:
                cell.cellText.text = @"   Обычный";
                break;
            case 2:
                cell.cellText.text = @"   Крупный";
                break;
            case 3:
                okCell.textLabel.text = @"OK";
                okCell.tag = 150;
                [okCell.textLabel setTextAlignment:NSTextAlignmentCenter];
                return okCell;
                break;
            default:
                break;
        }
        
        NSInteger fontNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"fontSize"];
        
        if (fontNubmer == indexPath.row) {
            cell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
        }
        
        return cell;
    }
    
    if (tableView == StileIconTableView)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        CustomTableViewCell* cell = [nibArray objectAtIndex:0];
        
        switch (indexPath.row)
        {
            case 0:
                cell.cellText.text = @"   Радужный";
                break;
            case 1:
                cell.cellText.text = @"   Черный";
                break;
            case 2:
                okCell.textLabel.text = @"OK";
                okCell.tag = 151;
                [okCell.textLabel setTextAlignment:NSTextAlignmentCenter];
                return okCell;
            default:
                break;
        }
        NSInteger styleNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"stileIcon"];
        
        if (styleNubmer == indexPath.row) {
            cell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
        }
        return cell;
    }
    
    if (tableView == selectLanguageTableView)
    {
        NSArray *nibArray = [[NSBundle mainBundle] loadNibNamed:@"CustomTableViewCell" owner:self options:nil];
        CustomTableViewCell* cell = [nibArray objectAtIndex:0];
        
        switch (indexPath.row)
        {
            case 0:
                cell.cellText.text = @"   Русский";
                break;
            case 1:
                cell.cellText.text = @"   English";
                break;
            case 2:
                okCell.textLabel.text = @"OK";
                okCell.tag = 152;
                [okCell.textLabel setTextAlignment:NSTextAlignmentCenter];
                return okCell;
            default:
                break;
        }
        NSInteger languageNubmer = [[NSUserDefaults standardUserDefaults] integerForKey:@"language"];
        if (languageNubmer == indexPath.row) {
            cell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
        }
        return cell;
    }
    
    
    return nil;
}


-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    if ([fontSizeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [fontSizeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([fontSizeTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [fontSizeTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([StileIconTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [StileIconTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([StileIconTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [StileIconTableView setLayoutMargins:UIEdgeInsetsZero];
    }
    
    if ([fontSizeTableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [fontSizeTableView setSeparatorInset:UIEdgeInsetsZero];
    }
    
    if ([selectLanguageTableView respondsToSelector:@selector(setLayoutMargins:)]) {
        [selectLanguageTableView setLayoutMargins:UIEdgeInsetsZero];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([tableView cellForRowAtIndexPath:indexPath].tag == 150) {
        [fontSizeView removeFromSuperview];
        [backgroundView removeFromSuperview];
        
        NSString* fontText = self.fontSize.titleLabel.text;
        NSRange range = [fontText rangeOfString:@":"];
        NSString* subString = [fontText substringFromIndex:range.location + 1];
        
        fontText = [fontText stringByReplacingOccurrencesOfString:subString withString:fontSizeText];
        [self.fontSize setTitle:fontText forState:UIControlStateNormal];
        
        }
    else if ([tableView cellForRowAtIndexPath:indexPath].tag == 151) {
        [fontStileView removeFromSuperview];
        [backgroundView removeFromSuperview];
        
        
        NSString* fontText = self.stileIcon.titleLabel.text;
        NSRange range = [fontText rangeOfString:@":"];
        NSString* subString = [fontText substringFromIndex:range.location + 1];
        fontText = [fontText stringByReplacingOccurrencesOfString:subString withString:fontStileText];
        [self.stileIcon setTitle:fontText forState:UIControlStateNormal];
        
    }
    else if ([tableView cellForRowAtIndexPath:indexPath].tag == 152) {
        [fontStileView removeFromSuperview];
        [backgroundView removeFromSuperview];
        
        NSString* fontText = self.selectLanguage.titleLabel.text;
        NSRange range = [fontText rangeOfString:@":"];
        NSString* subString = [fontText substringFromIndex:range.location + 1];
        fontText = [fontText stringByReplacingOccurrencesOfString:subString withString:languageText];
        [self.selectLanguage setTitle:fontText forState:UIControlStateNormal];
    }
    
    else{
        if (tableView == fontSizeTableView)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithUnsignedInteger:indexPath.row] forKey:@"fontSize"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            CustomTableViewCell* cell = (CustomTableViewCell*)[fontSizeTableView cellForRowAtIndexPath:indexPath];
            
            fontSizeText = [NSString stringWithString:cell.cellText.text];
        }
        if (tableView == StileIconTableView)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"stileIcon"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            CustomTableViewCell* cell = (CustomTableViewCell*)[StileIconTableView cellForRowAtIndexPath:indexPath];
            
            fontStileText = [NSString stringWithString:cell.cellText.text];
        }
        
        if (tableView == selectLanguageTableView)
        {
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:indexPath.row] forKey:@"language"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            CustomTableViewCell* cell = (CustomTableViewCell*)[selectLanguageTableView cellForRowAtIndexPath:indexPath];
            languageText = [NSString stringWithString:cell.cellText.text];
        }
        
        
        
        CustomTableViewCell* selectedCell = (CustomTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
        selectedCell.selectedCell.image = [UIImage imageNamed:@"rb_2.png"];
        for (UIView *view in tableView.subviews) {
            for (UITableViewCell* cell in view.subviews) {
                if ( [cell isKindOfClass:[CustomTableViewCell class]] && cell != selectedCell) {
                    CustomTableViewCell* celll = (CustomTableViewCell*)cell;
                    celll.selectedCell.image = [UIImage imageNamed:@"rb.png"];
                }
            }
        }
    }
    
}


#pragma mark - gradient

- (CAGradientLayer*) greyBackgroundGradient {
    UIColor *colorOne = [UIColor colorWithRed:230.f/255 green:230.f/255 blue:230.f/255 alpha:1.f];
    UIColor *colorTwo = [UIColor colorWithRed:255.f/255 green:255.f/255 blue:255.f/255 alpha:1.f];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    return headerLayer;
}

- (CAGradientLayer*) greyGradient {
    UIColor *colorOne = [UIColor colorWithRed:198.f/255 green:198.f/255 blue:198.f/255 alpha:1.f];
    UIColor *colorTwo = [UIColor colorWithRed:229.f/255 green:229.f/255 blue:229.f/255 alpha:1.f];
    NSArray *colors =  [NSArray arrayWithObjects:(id)colorOne.CGColor, colorTwo.CGColor, nil];
    
    CAGradientLayer *headerLayer = [CAGradientLayer layer];
    headerLayer.colors = colors;
    return headerLayer;
}


#pragma mark - rotation Method

- (void) viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context)
     {
         fontSizeView.center = self.view.center;
         fontStileView.center = self.view.center;
         
         backgroundLayer.frame = self.view.bounds;
         gradientLayer.frame = CGRectMake(0, 0, CGRectGetWidth(self.settingsView.frame), CGRectGetHeight(self.settingsView.frame)*9.f/46);
         
         
         if([[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortrait ||
            [[UIApplication sharedApplication] statusBarOrientation]==UIDeviceOrientationPortraitUpsideDown)
         {
             /// detect if iphone 4s ///
             if (CGRectGetHeight(self.view.frame) == 480) {
                 self.bgViewHeight.constant = 248;
             }
             else{
                 self.bgViewHeight.constant = CGRectGetHeight(self.view.frame) - 300;
             }
         }
         else{
             /// detect if ipad ///
             if (CGRectGetHeight(self.view.frame) == 768) {
                 self.bgViewHeight.constant = CGRectGetHeight(self.view.frame) - 300;
             }
             else{
                 self.bgViewHeight.constant = 248;
             }
         }
         
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

/////////////////////////


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
             self.scrolView.userInteractionEnabled=NO;
             
             self.scrolView.tag=1;
             [leftMenu.disabledViewsArray removeAllObjects];
           
             [leftMenu.disabledViewsArray addObject:[[NSNumber alloc] initWithLong:self.scrolView.tag]];
          
         }
         else
         {
             leftMenu.flag=0;
             self.scrolView.userInteractionEnabled=YES;
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
             self.scrolView.userInteractionEnabled=YES;
           
             
             point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
         }
         else if (touchLocation.x>leftMenu.frame.size.width/2)
         {
             point.x=(CGFloat)leftMenu.frame.size.width/2;
             
             self.scrolView.userInteractionEnabled=NO;
            
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
    self.scrolView.userInteractionEnabled=NO;
    leftMenu.flag=1;
}


- (IBAction)back:(id)sender
{
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
