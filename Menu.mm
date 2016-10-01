#include "Menu.h"
#include "Element.h"

#import "UIView+Facade.h"

const float element_padding = 20.0f;

Menu::Menu(std::string title)
: title_(title)
, mainWindow_(nil)
, buttonWindow_(nil)
, mainVewController_(nil)
, menu_wrapper_([MenuWrapper initWithMenuClass:this])
{
    buttonWindow_ = [[MenuWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    buttonWindow_.hidden = NO;
    buttonWindow_.layer.borderWidth = 1;
    buttonWindow_.layer.cornerRadius = 10;
    buttonWindow_.frame = CGRectMake(20, 20, 20, 20);
    buttonWindow_.clipsToBounds = NO;

    mainWindow_ = [[MenuWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    mainWindow_.hidden = YES;
    mainWindow_.windowLevel = 9999999;
    mainVewController_= [[UIViewController alloc] init];
    mainWindow_.rootViewController = mainVewController_;
    mainVewController_.view.backgroundColor  = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];

    toggleButton_ = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 20)];
    [toggleButton_ addTarget:menu_wrapper_ action:@selector(toggleMenu:) forControlEvents:UIControlEventTouchUpInside];
    [toggleButton_ setTitle:@"M" forState:UIControlStateNormal];
    [toggleButton_ addTarget:buttonWindow_ action:@selector(wasDragged:withEvent:) forControlEvents:UIControlEventTouchDragInside];
    [buttonWindow_ addSubview:toggleButton_];

    menu_toggle_listner_.AddListener([](bool toggled) {
        if (toggled) {
            NSLog(@"Menu is enabled");
        }
        else {
            NSLog(@"Menu is disabled");
        }
    });
}

void Menu::ToggleMenu()
{
    static bool menuEnabled = false;
    menuEnabled = !menuEnabled;
    if (menuEnabled) {
        mainWindow_.hidden = NO;
        NSLog(@"%@", [UIScreen mainScreen]);
        this->PaintMenu();
    }
    else {
        /* this needs more? */
        [[[mainVewController_.view subviews] lastObject] removeFromSuperview];
        mainWindow_.hidden = YES;
    }
    menu_toggle_listner_(menuEnabled);
}

void Menu::AddElement(Element *element)
{
    element->Setup();
    elements_.push_back(*element);
}

void Menu::RemoveElement(Element *element)
{
    for (auto it = elements_.begin(); it != elements_.end(); ++it) {
        if (it->hash_ == element->hash_) {
            elements_.erase(it);
        }
    }
}

void Menu::PaintMenu()
{
    UIVisualEffectView *mainView;
    float devicePadding = 0;
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        devicePadding = 80;
    else
        devicePadding = 30;

    if (NSClassFromString(@"UIBlurEffect")) {
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
        mainView = [[UIVisualEffectView alloc] initWithEffect:effect];
        mainView.frame = mainWindow_.frame;
    }
    else {
        mainView = (UIVisualEffectView *)[[UIView alloc] initWithFrame:mainWindow_.frame];
        mainView.backgroundColor = [UIColor grayColor];
    }
    mainView.layer.masksToBounds = YES;
    [mainVewController_.view addSubview:mainView];

    UIView *titleView = [UIView new];
    titleView.backgroundColor = [UIColor blackColor];
    [mainView addSubview:titleView];

    UILabel *titleText = [UILabel new];
    [titleText setText:[NSString stringWithUTF8String:title_.c_str()]];
    titleText.textAlignment = NSTextAlignmentCenter;
    titleText.font = [titleText.font fontWithSize:12];
    titleText.textColor = [UIColor whiteColor];
    [titleView addSubview:titleText];

    UIButton *closeButton = [UIButton new];
    [closeButton setTitle:@"X" forState:UIControlStateNormal];
    [closeButton addTarget:menu_wrapper_ action:@selector(menuButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [titleView addSubview:closeButton];

    UIScrollView *contentView = [UIScrollView new];
    [mainView addSubview:contentView];

    [mainView anchorInCenterFillingWidthAndHeightWithLeftAndRightPadding:40 topAndBottomPadding:80];
    [titleView anchorTopCenterFillingWidthWithLeftAndRightPadding:0 topPadding:0 height:40];
    [titleText anchorTopCenterFillingWidthWithLeftAndRightPadding:0 topPadding:0 height:40];
    [closeButton anchorTopRightWithRightPadding:20 topPadding:10 width:20 height:20];
    [contentView alignUnder:titleView centeredFillingWidthWithLeftAndRightPadding:0 topPadding:0 height:mainView.frame.size.height];

    float totalsize = titleView.frame.size.height;
    for (int i = 0; i < elements_.size(); i++) {
        id prevView;

        if (i == 0) prevView = titleView;
        else prevView = elements_.at(i-1).obj_;

        Element it = elements_.at(i);
        [contentView addSubview:it.obj_];
        [it.obj_ alignUnder:prevView centeredFillingWidthWithLeftAndRightPadding:devicePadding topPadding:element_padding height:it.height];
        totalsize += it.height;
        totalsize += element_padding;

        if ([[it.obj_ subviews] count] > 1) {
            UIView *switchl = [it.obj_ subviews][0];
            UIView *switchm = [it.obj_ subviews][1];
            [switchl anchorCenterLeftWithLeftPadding:0 width:100 height:20];
            [switchm anchorCenterRightWithRightPadding:25 width:20 height:20];
            totalsize += 20;
        }
    }
    contentView.contentSize = CGSizeMake(0, totalsize);
}

@implementation MenuWrapper
@synthesize buttonClass;

+ (id)initWithMenuClass:(Menu *)buttonClass {
    MenuWrapper *wrapper = [MenuWrapper new];
    wrapper.buttonClass = buttonClass;
    return wrapper;
}

- (void)menuButtonClickEvent {
    buttonClass->ToggleMenu();
}

- (void)toggleMenu:(UIButton *)sender {
    if (sender.tag == 0) {
        buttonClass->ToggleMenu();
    }
    sender.tag = 0;
}

@end

@implementation MenuWindow

- (void)wasDragged:(UIButton *)button withEvent:(UIEvent *)event {
    button.tag++;
    UITouch *touch = [[event touchesForView:button] anyObject];

    // get delta
    CGPoint previousLocation = [touch previousLocationInView:self];
    CGPoint location = [touch locationInView:self];
    CGFloat delta_x = location.x - previousLocation.x / 2;
    CGFloat delta_y = location.y - previousLocation.y / 2;

    // move button
    self.center = CGPointMake(self.center.x + delta_x,
                                self.center.y + delta_y);
}

@end
