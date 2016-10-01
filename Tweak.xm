#import <UIKit/UIKit.h>
#include "Menu.h"
#include "Button.h"
#include "Patch.h"

@interface FalloutMenu : NSObject
- (void)start;
- (void)initMenu;
@end

@implementation FalloutMenu

#ifdef __LP64__

#define colaOff 0x1002E7920
#define roomsOff 0x1003A0828
long long rushOff = 0x1002E32B4;
uint32_t rushData = 0x1F2003D5;

#else

#define colaOff (0x277BEC + 1)
#define roomsOff (0x317934 + 1)
uint32_t rushOff = 0x273E1A;
uint32_t rushData = 0xC046C046;

#endif
bool settings[3] = {0,0,0};

- (void)start {
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(initMenu)
		name:UIApplicationDidFinishLaunchingNotification object:nil];
}

- (void)initMenu {
	Menu *menu = new Menu("Fallout Cheats");

	Button *capsBut = new Button("Enable caps Hack");
	capsBut->AddEventHandler([](ButtonEvent event) {
		settings[0] = true;
	});
	menu->AddElement(capsBut);

	Button *roomsBut = new Button("Enable all rooms Unlocked");
	roomsBut->AddEventHandler([](ButtonEvent event) {
		settings[1] = true;
	});
	menu->AddElement(roomsBut);

	Button *incidentBut = new Button("Enable no rush Incident");
	incidentBut->AddEventHandler([](ButtonEvent event) {
		Patch p = Patch(rushOff, rushData);
		p.Apply();
	});
	menu->AddElement(incidentBut);
}

float (*old_GetLuckNukaCola)(void *);
float GetLuckNukaCola(void *self) {
	if (settings[0])
		return 99999999;
	return old_GetLuckNukaCola(self);
}

bool (*old_IsRoomAvailable)(void *, void *);
bool IsRoomAvailable(void *self, void *unk1) {
	if (settings[1])
		return true;
	return old_IsRoomAvailable(self, unk1);
}

__attribute__((constructor))
void init() {
	FalloutMenu *menu = [FalloutMenu new];
	[menu start];

	Hook *rooms = new Hook((void*)roomsOff, (void*)IsRoomAvailable, (void**)&old_IsRoomAvailable);
	rooms->Apply();
	Hook *cola = new Hook((void*)colaOff, (void*)GetLuckNukaCola, (void**)&old_GetLuckNukaCola);
	cola->Apply();
	//Hook *rush = new Hook((void*)successOff, (void*)SetAlwaysSuccess, (void**)&old_SetAlwaysSuccess);
	//rush->Apply();
}

@end
