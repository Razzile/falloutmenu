#import <UIKit/UIKit.h>
#include <vector>
#include <string>
#include "Delegate.h"

class Element;
class Menu;

@interface MenuWrapper : NSObject
@property Menu *buttonClass;

+ (id)initWithMenuClass:(Menu *)menuClass;
- (void)menuButtonClickEvent;
@end

@interface MenuWindow : UIWindow
@end

class Menu {
    friend class Element;
public:
    Menu(std::string title);
    Menu(std::string title, float x, float y);
    void ToggleMenu();
    void AddElement(Element *element);
    void RemoveElement(Element *element);
protected:
    std::string title_;
    std::vector<Element> elements_;
    MenuWindow *mainWindow_;
    MenuWindow *buttonWindow_;
    UIViewController *mainVewController_;
    UIButton *toggleButton_;
    Delegate<bool> menu_toggle_listner_;
private:
    MenuWrapper *menu_wrapper_;
    void PaintMenu();
};
