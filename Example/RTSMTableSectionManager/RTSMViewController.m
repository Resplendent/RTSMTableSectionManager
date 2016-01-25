//
//  RTSMViewController.m
//  RTSMTableSectionManager
//
//  Created by Benjamin Maer on 01/25/2016.
//  Copyright (c) 2016 Benjamin Maer. All rights reserved.
//

#import "RTSMViewController.h"

#import "RTSMTableSectionManager.h"
#import "NSString+RUMacros.h"
#import "RUConditionalReturn.h"





typedef NS_ENUM(NSInteger, RTSMViewController_tableView_section) {
	RTSMViewController_tableView_section_red,
	RTSMViewController_tableView_section_green,
	RTSMViewController_tableView_section_blue,
	RTSMViewController_tableView_section_toggle,
	RTSMViewController_tableView_section_possiblyToggled,

	RTSMViewController_tableView_section__first		= RTSMViewController_tableView_section_red,
	RTSMViewController_tableView_section__last		= RTSMViewController_tableView_section_possiblyToggled,
};





@interface RTSMViewController () <UITableViewDelegate,UITableViewDataSource,RTSMTableSectionManager_SectionDelegate>

@property (nonatomic, readonly, nullable) RTSMTableSectionManager* tableSectionManager;

@property (nonatomic, assign) BOOL toggled;

@property (nonatomic, readonly, nullable) UITableView* tableView;
-(CGRect)tableViewFrame;

#pragma mark - Cell Background Color
-(nullable UIColor*)cellBackroundColorForTableViewSection:(RTSMViewController_tableView_section)tableViewSection;

#pragma mark - Cell Background Color
-(nullable NSString*)cellTextForTableViewSection:(RTSMViewController_tableView_section)tableViewSection;

@end





@implementation RTSMViewController

- (void)viewDidLoad
{
	[super viewDidLoad];

	[self.view setBackgroundColor:[UIColor whiteColor]];

	_tableSectionManager = [[RTSMTableSectionManager alloc]initWithFirstSection:RTSMViewController_tableView_section__first
																	lastSection:RTSMViewController_tableView_section__last];
	[self.tableSectionManager setSectionDelegate:self];

	_tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
	[self.tableView setBackgroundColor:[UIColor clearColor]];
	[self.tableView setDelegate:self];
	[self.tableView setDataSource:self];
	[self.view addSubview:self.tableView];
}

-(void)viewWillLayoutSubviews
{
	[super viewWillLayoutSubviews];

	[self.tableView setFrame:self.tableViewFrame];
}

#pragma mark - Frames
-(CGRect)tableViewFrame
{
	return self.view.bounds;
}

#pragma mark - RTSMTableSectionManager_SectionDelegate
-(BOOL)tableSectionManager:(RTSMTableSectionManager *)tableSectionManager sectionIsAvailable:(NSInteger)section
{
	RTSMViewController_tableView_section tableView_section = (RTSMViewController_tableView_section)section;
	switch (tableView_section)
	{
		case RTSMViewController_tableView_section_red:
		case RTSMViewController_tableView_section_green:
		case RTSMViewController_tableView_section_blue:
		case RTSMViewController_tableView_section_toggle:
			return YES;
			break;
			
		case RTSMViewController_tableView_section_possiblyToggled:
			return (self.toggled == TRUE);
			break;
	}

	NSAssert(false, @"unhandled");
	return NO;
}

#pragma mark - UITableViewDelegate,UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return self.tableSectionManager.numberOfSectionsAvailable;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	kRUDefineNSStringConstant(kRTSMViewController_tableView_deque);
	UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kRTSMViewController_tableView_deque];

	if (cell == nil)
	{
		cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kRTSMViewController_tableView_deque];
	}

	RTSMViewController_tableView_section tableView_section = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];

	[cell.contentView setBackgroundColor:[self cellBackroundColorForTableViewSection:tableView_section]];
	[cell.textLabel setTextColor:[UIColor blackColor]];
	[cell.textLabel setText:[self cellTextForTableViewSection:tableView_section]];

	return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 40.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	RTSMViewController_tableView_section tableView_section = [self.tableSectionManager sectionForIndexPathSection:indexPath.section];

	switch (tableView_section)
	{
		case RTSMViewController_tableView_section_red:
		case RTSMViewController_tableView_section_green:
		case RTSMViewController_tableView_section_blue:
			break;

		case RTSMViewController_tableView_section_toggle:
			[self setToggled:!self.toggled];
			break;

		case RTSMViewController_tableView_section_possiblyToggled:
			break;
	}
}

#pragma mark - Cell Background Color
-(nullable UIColor*)cellBackroundColorForTableViewSection:(RTSMViewController_tableView_section)tableViewSection
{
	switch (tableViewSection)
	{
		case RTSMViewController_tableView_section_red:
			return [UIColor redColor];
			break;
			
		case RTSMViewController_tableView_section_green:
			return [UIColor greenColor];
			break;
			
		case RTSMViewController_tableView_section_blue:
			return [UIColor blueColor];
			break;
			
		case RTSMViewController_tableView_section_toggle:
		case RTSMViewController_tableView_section_possiblyToggled:
			return [UIColor whiteColor];
			break;
	}

	NSAssert(false, @"unhandled");
	return nil;
}

#pragma mark - Cell Background Color
-(nullable NSString*)cellTextForTableViewSection:(RTSMViewController_tableView_section)tableViewSection
{
	switch (tableViewSection)
	{
		case RTSMViewController_tableView_section_red:
		case RTSMViewController_tableView_section_green:
		case RTSMViewController_tableView_section_blue:
			return nil;
			break;
			
		case RTSMViewController_tableView_section_toggle:
			return @"Tap to toggle section below this one";
			break;

		case RTSMViewController_tableView_section_possiblyToggled:
			return @"You've brought me to life!";
			break;
	}

	NSAssert(false, @"unhandled");
	return nil;
}

#pragma mark - toggled
-(void)setToggled:(BOOL)toggled
{
	kRUConditionalReturn(self.toggled == toggled, NO);

	NSInteger indexPathSection_old = (self.toggled ?
									  [self.tableSectionManager indexPathSectionForSection:RTSMViewController_tableView_section_possiblyToggled] :
									  NSNotFound);

	_toggled = toggled;

	if (self.toggled)
	{
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:[self.tableSectionManager indexPathSectionForSection:RTSMViewController_tableView_section_possiblyToggled]]
					  withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else
	{
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPathSection_old]
					  withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

@end
