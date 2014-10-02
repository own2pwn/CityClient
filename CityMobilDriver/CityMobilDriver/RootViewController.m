

#import "RootViewController.h"
#import "CellObject.h"

@interface RootViewController ()
{
    NSInteger flag;
    UITableView*leftMenu;
    UISwipeGestureRecognizer*recognizerRight;
    bool dragging;
    CGFloat oldX;
    NSMutableArray*nameArray;
    NSArray * arrayForTableView;

}
@end

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    leftMenu=[[UITableView alloc]initWithFrame:CGRectMake(-1*self.view.frame.size.width*(CGFloat)5/6, self.navigationView.frame.origin.y+self.navigationView.frame.size.height, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-self.navigationView.frame.size.height) ];
    [self.view addSubview:leftMenu];
    
    flag=0;
    
    LoginViewController*log=[self.storyboard instantiateViewControllerWithIdentifier:@"View2"];
    [self.navigationController pushViewController:log animated:NO];
    
    leftMenu.delegate=self;
    LeftViewCellObject*obj1=[[LeftViewCellObject alloc]init];
    obj1.name=@"Harut";
    LeftViewCellObject*obj2=[[LeftViewCellObject alloc]init];
    obj2.name=@"Vazgen";
    LeftViewCellObject*obj3=[[LeftViewCellObject alloc]init];
    obj3.name=@"Karen";
    LeftViewCellObject*obj4=[[LeftViewCellObject alloc]init];
    obj4.name=@"Tarzan";
    LeftViewCellObject*obj5=[[LeftViewCellObject alloc]init];
    obj5.name=@"Armen";
    LeftViewCellObject*obj6=[[LeftViewCellObject alloc]init];
    obj6.name=@"Taron";
    LeftViewCellObject*obj7=[[LeftViewCellObject alloc]init];
    obj7.name=@"Miqael";
    LeftViewCellObject*obj8=[[LeftViewCellObject alloc]init];
    obj8.name=@"Manvel";
    
    nameArray=[[NSMutableArray alloc]initWithObjects:obj1,obj2,obj3,obj4,obj5,obj6,obj7,obj8, nil];
    
    leftMenu.delegate=self;
    leftMenu.dataSource=self;
    
    
   self.button1.titleLabel.textAlignment= NSTextAlignmentCenter;
   self.button1.titleLabel.textAlignment= NSTextAlignmentCenter;
    
    CellObject * object1 = [[CellObject alloc]init];
    object1.orderType = @"First Hour";
    object1.ordersNumber = 100;
    CellObject * object2 = [[CellObject alloc]init];
    object2.orderType = @"Nearest";
    object2.ordersNumber = 20;
    CellObject * object3 = [[CellObject alloc]init];
    object3.orderType = @"Far";
    object3.ordersNumber = 5;
    
    CellObject * object4 = [[CellObject alloc]init];
    object4.orderType = @"First Hour";
    object4.ordersNumber = 10;
    
    CellObject * object5 = [[CellObject alloc]init];
    object5.orderType = @"Nearest";
    object5.ordersNumber = 20;
    
    CellObject * object6 = [[CellObject alloc]init];
    object6.orderType = @"Far";
    object6.ordersNumber = 5;
    
    CellObject * object7 = [[CellObject alloc]init];
    object7.orderType = @"Nearest";
    object7.ordersNumber = 20;
    
    CellObject * object8 = [[CellObject alloc]init];
    object8.orderType = @"Far";
    object8.ordersNumber = 5;
    

    arrayForTableView = [[NSArray alloc]initWithObjects:object1,object2,
                         object3,object4,object5,object6,object7,object8,nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView ==  leftMenu) {
         return nameArray.count;
    }
    else if(tableView == self.tableViewOrdersPort)
    {
        return arrayForTableView.count;
    
    }
    else
    {
    return arrayForTableView.count;
    }
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath*)indexPath
{
    if (tableView == leftMenu)
    {
        
    NSString* simpleTableIdentifier = [NSString stringWithFormat:@"SimpleTableViewCell_%d" , indexPath.row];
    

    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];

    
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
        cell.textLabel.text = [[nameArray objectAtIndex:indexPath.row]name];

    
    cell.backgroundColor=[UIColor blueColor];
    cell.textLabel.textColor=[UIColor whiteColor];
        tableView.backgroundColor=[UIColor blueColor];
    
    return cell;
    }
    else
    {
    
        
        NSString *simpleTableIdentifierIphone = @"SimpleTableCellIphone";
        
        CustomCellIphone * cell = (CustomCellIphone *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifierIphone];
        if (cell == nil)
        {
            
            NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"CustomCellIphone" owner:self options:nil];
            cell = [nib objectAtIndex:0];
        }
        
        
        CellObject * currentObject = [arrayForTableView objectAtIndex:indexPath.row];
        cell.label1.text = [NSString stringWithFormat:@"   %@",currentObject.orderType];
        cell.label2.text =[NSString stringWithFormat:@"%d",currentObject.ordersNumber];
        
        return  cell;
        
     }
    
   
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView ==leftMenu) {
        return 44;
    }
    else if(tableView == self.tableViewOrdersPort)
    {
    return  self.view.frame.size.height/10;
    }
    else
    {
        return self.view.frame.size.height/10;
    }
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView==leftMenu)
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    
    else
    {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    }
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
         
         if (flag==0) flag=1;
         else flag=0;
         
     }
     
     
     ];
    
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
                          point.x=(CGFloat)leftMenu.frame.size.width/2*(-1);
                      }
                     
                     else if (touchLocation.x>leftMenu.frame.size.width/2)
                     {
                         point.x=(CGFloat)leftMenu.frame.size.width/2;
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
                 
                 
           
                 
             
      
    
    
             
             
             flag=1;
             
    
    


    
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    CGFloat x;
    if (fromInterfaceOrientation == UIInterfaceOrientationPortrait || fromInterfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        if(flag==0)
        {
            x=self.view.frame.size.width*(CGFloat)5/6*(-1);
        }
        else
        {
            x=0;
        }
      
        leftMenu.frame =CGRectMake(x, leftMenu.frame.origin.y, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-self.navigationView.frame.size.height);

        
       
        
    }
    else if (fromInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || fromInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        
        if(flag==0)
        {
            x=self.view.frame.size.width*(CGFloat)5/6*(-1);
        }
        else
        {
            x=0;
        }
        
        leftMenu.frame =CGRectMake(x, leftMenu.frame.origin.y, self.view.frame.size.width*(CGFloat)5/6, self.view.frame.size.height-self.navigationView.frame.size.height);
        
    }
    
    
}

@end