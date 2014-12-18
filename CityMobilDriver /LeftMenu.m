//
//  LeftMenu.m
//  CityMobilDriver
//
//  Created by Intern on 10/10/14.
//  Copyright (c) 2014 Davit Baghdagyulyan. All rights reserved.
//

#import "LeftMenu.h"
#import "RootViewController.h"
@implementation LeftMenu

{
    Class myClass;
    NSString*identity;
    BOOL k;
    BOOL p;
    //UITouch *oldTouch;
    CGPoint oldTouchLocation;
//    UITouch *touch;
    CGPoint touchLocation;

}

+(LeftMenu*)getLeftMenu:(id)curentSelf
{
    static LeftMenu* leftMenu = nil;
    
    if (leftMenu == nil)
    {
        leftMenu = [LeftMenu alloc];
        leftMenu.curentViewController=curentSelf;
        leftMenu = [leftMenu init];
    }
    leftMenu.curentViewController=curentSelf;

    [leftMenu.curentViewController.view addSubview:leftMenu];
    return leftMenu;
}

-(instancetype)init
{
    self=[super init];
          if(self)
          {
             [self setSeparatorColor:[UIColor whiteColor]];
              self.flag=0;
              k=YES;
              p=YES;
              self.frame=CGRectMake(-1*self.curentViewController.view.frame.size.width*(CGFloat)5/6, 64, self.curentViewController.view.frame.size.width*(CGFloat)5/6, self.curentViewController.view.frame.size.height-64);
            
              self.delegate=self;
              self.dataSource=self;
              self.nameArray=[[NSMutableArray alloc]initWithObjects:@"Свабодные заказы",@"Мои заказы",@"Пополнение баланса",@"Сообщение",@"Настройка робота",@"Архив заказов",@"Архив платежей",@"Тарифы СитиМобил",@"Тарифы Яндекс",@"Обозначение иконок",@"Профиль",@"Статистика",@"Настройки",@"Выход", nil];

          }
          return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    

   
        return self.nameArray.count;
   
    
    
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    
   
        
        
        NSString* simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableViewCell_%ld" , (long)indexPath.row];
        
        UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        
        if( cell == nil )
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
        }
        
        
        cell.textLabel.text = [self.nameArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont fontWithName:@"Roboto-Regular" size:17];
    
        cell.backgroundColor=[UIColor colorWithRed:223.f/255 green:223.f/255 blue:223.f/255 alpha:1];
        cell.textLabel.textColor=[UIColor blackColor];
        tableView.backgroundColor=[UIColor colorWithRed:223.f/255 green:223.f/255 blue:223.f/255 alpha:1];
        
        return cell;
    }

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!k)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        oldTouchLocation.x=0;
        k=YES;
        p=YES;
        self.scrollEnabled=YES;
        [self animation];
        return;
    }
    NSLog(@"viewControllers:%@",self.curentViewController.navigationController.viewControllers) ;
    switch (indexPath.row) {
        case 0:
            myClass = NSClassFromString(@"RootViewController");
            identity =@"RootViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 1:
            myClass = NSClassFromString(@"MyOrdersViewController");
            identity =@"MyOrdersViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 2:
            myClass = NSClassFromString(@"ReplenishmentViewController");
            identity =@"ReplenishmentViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 4:
            myClass = NSClassFromString(@"RobotSettingsViewController");
            identity =@"RobotSettingsViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 5:
            myClass =NSClassFromString(@"OrdersHistoryViewController");
            identity =@"OrdersHistoryViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 6:
            myClass =NSClassFromString(@"PaymentHistoryViewController");
            identity =@"PaymentHistoryViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
 
        case 3:
        
            myClass = NSClassFromString(@"MessagesViewController");
            identity =@"MessagesViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 12:
            
            myClass = NSClassFromString(@"SettingsViewController");
            identity =@"SettingsViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
            
        case 10:
            myClass = NSClassFromString(@"ProfilViewController");
            identity =@"ProfilViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
            
        case 11:
        
            myClass = NSClassFromString(@"StatisticsViewController");
            identity =@"StatisticsViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 7:
            myClass = NSClassFromString(@"TariffsCityMobilViewController");
            identity =@"TariffsCityMobilViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
        case 9:
            myClass = NSClassFromString(@"DesignationIconsViewController");
            identity =@"DesignationIconsViewController";
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;

        case 13:
            //exit(0); //not recommended apple
            myClass = NSClassFromString(@"LoginViewController");
            identity =@"LoginViewController";
            [[SingleDataProvider sharedKey]stopTimer];
            [self pushOrPoptoViewContrller:myClass andIdentity:identity];
            break;
                    default:
            break;
            
            
    }
    
    
   
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    
    // Prevent the cell from inheriting the Table View's margin settings
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    
    // Explictly set your cell's layout margins
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
 

}

-(void)viewDidLayoutSubviews
{
    [self viewDidLayoutSubviews];
    
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        [self setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        [self setLayoutMargins:UIEdgeInsetsZero];
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return  44;
}

-(void)pushOrPoptoViewContrller:(Class)aClass andIdentity:(NSString*)identityString
{
    CGPoint point;
    point.x=self.center.x-self.frame.size.width;
    point.y=self.center.y;
    self.center=point;
    self.flag=0;
    if ([self.curentViewController isKindOfClass:[aClass class]])
    {
        if([self.curentViewController isKindOfClass:[RootViewController class]])
        {
            [(RootViewController*)self.curentViewController setSelectedRow];
        }
        [self.curentViewController viewDidAppear:NO];
        return;
    }

    BOOL isFirstloadViewController=YES;
   
    for (id controller in self.curentViewController.navigationController.viewControllers)
    {
        if ([controller isKindOfClass:[aClass class]])
        {
            [self.curentViewController.navigationController popToViewController:controller animated:NO];
            if ([controller isKindOfClass:[RootViewController class]])
            {
                [(RootViewController*)controller setSelectedRow];
            }
            isFirstloadViewController=NO;
            break;
            
        }
    }
    if (isFirstloadViewController)
    {
         id vc=[self.curentViewController.storyboard instantiateViewControllerWithIdentifier:identityString];
        [self.curentViewController.navigationController pushViewController:vc  animated:NO];
        
    }
 
}




- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    k=NO;
    if (p)
    {
        UITouch* touch1 = [[event allTouches] anyObject];
        oldTouchLocation = [touch1 locationInView:touch1.view];
    }
    self.scrollEnabled=NO;
    UITouch* touch = [[event allTouches] anyObject];
    touchLocation = [touch locationInView:touch.view];

    if (oldTouchLocation.x)
    {
        CGRect rect = self.frame;
        CGPoint point = self.frame.origin;
        point.x -= (oldTouchLocation.x-touchLocation.x);
        if (point.x>0)
        {
            p=NO;
            UITouch* touch1 = [[event allTouches] anyObject];
            oldTouchLocation = [touch1 locationInView:touch1.view];
            return;
        }
        rect.origin = point;
        self.frame = rect;
    }
    p=NO;
}


-(void)animation
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
                     animations:^(void)
     {
         CGPoint point;
        
         if (CGRectGetMaxX(self.frame)<=self.frame.size.width/2)
         {
             self.flag=0;
            
             point.x=(CGFloat)self.frame.size.width/2*(-1);
         }
         else if (CGRectGetMaxX(self.frame)>self.frame.size.width/2)
         {
             point.x=(CGFloat)self.frame.size.width/2;
             self.flag=1;
            
         }
         point.y=self.center.y;
         self.center=point;
         
         
     }
                     completion:nil
     ];

}


@end