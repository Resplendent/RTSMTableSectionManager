//
//  RTSMViewController.m
//  RTSMTableSectionManager
//
//  Created by Benjamin Maer on 01/25/2016.
//  Copyright (c) 2016 Benjamin Maer. All rights reserved.
//

#import "RTSMViewController.h"
#import "RTSMTableSectionRangeManagerViewController.h"

#import <RTSMTableSectionManager/RTSMTableSectionManager.h>
#import <RTSMTableSectionManager/UITableView+RTSMEmptySpace.h>

#import "NSString+RUMacros.h"
#import "RUConditionalReturn.h"





typedef NS_ENUM(NSInteger, RTSMViewController_tableView_section) {
	RTSMViewController_tableView_section_top_possiblyToggled,
	RTSMViewController_tableView_section_top_toggle,
	RTSMViewController_tableView_section_red,
	RTSMViewController_tableView_section_green,
	RTSMViewController_tableView_section_blue,
	RTSMViewController_tableView_section_toggle,
	RTSMViewController_tableView_section_possiblyToggled,
	RTSMViewController_tableView_section_RTSMTableSectionRangeManagerViewController,
	RTSMViewController_tableView_section_alwaysBottom,

	RTSMViewController_tableView_section__first		= RTSMViewController_tableView_section_top_possiblyToggled,
	RTSMViewController_tableView_section__last		= RTSMViewController_tableView_section_alwaysBottom,
};





@interface RTSMViewController () <UITableViewDelegate,UITableViewDataSource,RTSMTableSectionManager_SectionDelegate>

#pragma mark - tableSectionManager
@property (nonatomic, readonly, nullable) RTSMTableSectionManager* tableSectionManager;
-(void)tableSectionManager_validate;

#pragma mark - top_toggled
@property (nonatomic, assign) BOOL top_toggled;

#pragma mark - toggled
@property (nonatomic, assign) BOOL toggled;

#pragma mark - tableView
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

	[self tableSectionManager_validate];

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
	switch ((RTSMViewController_tableView_section)section)
	{
		case RTSMViewController_tableView_section_top_possiblyToggled:
			return (self.top_toggled == TRUE);
			break;

		case RTSMViewController_tableView_section_top_toggle:
		case RTSMViewController_tableView_section_red:
		case RTSMViewController_tableView_section_green:
		case RTSMViewController_tableView_section_blue:
		case RTSMViewController_tableView_section_toggle:
		case RTSMViewController_tableView_section_RTSMTableSectionRangeManagerViewController:
		case RTSMViewController_tableView_section_alwaysBottom:
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
		case RTSMViewController_tableView_section_top_possiblyToggled:
		case RTSMViewController_tableView_section_red:
		case RTSMViewController_tableView_section_green:
		case RTSMViewController_tableView_section_blue:
		case RTSMViewController_tableView_section_possiblyToggled:
		case RTSMViewController_tableView_section_alwaysBottom:
			break;

		case RTSMViewController_tableView_section_top_toggle:
			[self setTop_toggled:(self.top_toggled == false)];
			break;

		case RTSMViewController_tableView_section_toggle:
			[self setToggled:!self.toggled];
			break;

		case RTSMViewController_tableView_section_RTSMTableSectionRangeManagerViewController:
			[self.navigationController pushViewController:[RTSMTableSectionRangeManagerViewController new] animated:YES];
			break;
	}
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	RTSMViewController_tableView_section tableView_section = [self.tableSectionManager sectionForIndexPathSection:section];
	switch (tableView_section)
	{
		case RTSMViewController_tableView_section_top_possiblyToggled:
		case RTSMViewController_tableView_section_top_toggle:
		case RTSMViewController_tableView_section_red:
		case RTSMViewController_tableView_section_green:
		case RTSMViewController_tableView_section_blue:
		case RTSMViewController_tableView_section_toggle:
		case RTSMViewController_tableView_section_possiblyToggled:
		case RTSMViewController_tableView_section_RTSMTableSectionRangeManagerViewController:
			return 0.0f;
			break;
			
		case RTSMViewController_tableView_section_alwaysBottom:
		{
			CGFloat emptySpace = [self.tableView rtsm_emptySpaceFromSection:RTSMViewController_tableView_section__first
																  toSection:RTSMViewController_tableView_section_alwaysBottom
														tableSectionManager:self.tableSectionManager
																 tableFrame:self.tableViewFrame];

			CGFloat rowHeight = [self tableView:self.tableView
						heightForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];

			return emptySpace - rowHeight;
		}
			break;
	}
	
	NSAssert(false, @"unhandled");
	return 0.0f;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
	UIView* view = [UIView new];
	[view setBackgroundColor:[UIColor clearColor]];
	[view setUserInteractionEnabled:NO];
	return view;
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
			
		case RTSMViewController_tableView_section_top_possiblyToggled:
		case RTSMViewController_tableView_section_top_toggle:
		case RTSMViewController_tableView_section_toggle:
		case RTSMViewController_tableView_section_possiblyToggled:
			return [UIColor whiteColor];
			break;

		case RTSMViewController_tableView_section_RTSMTableSectionRangeManagerViewController:
			return [UIColor grayColor];
			break;

		case RTSMViewController_tableView_section_alwaysBottom:
			return [UIColor lightGrayColor];
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
		case RTSMViewController_tableView_section_top_possiblyToggled:
			return @"I am alive!";
			break;
			
		case RTSMViewController_tableView_section_top_toggle:
			return @"Tap to toggle the section above this one";
			break;

		case RTSMViewController_tableView_section_red:
		case RTSMViewController_tableView_section_green:
		case RTSMViewController_tableView_section_blue:
			return nil;
			break;
			
		case RTSMViewController_tableView_section_toggle:
			return @"Tap to toggle the section below this one";
			break;

		case RTSMViewController_tableView_section_possiblyToggled:
			return @"You've brought me to life!";
			break;

		case RTSMViewController_tableView_section_RTSMTableSectionRangeManagerViewController:
			return @"Push for RTSMTableSectionRangeManagerViewController";
			break;

		case RTSMViewController_tableView_section_alwaysBottom:
			return @"Always bottom";
			break;
	}

	NSAssert(false, @"unhandled");
	return nil;
}

#pragma mark - top_toggled
-(void)setTop_toggled:(BOOL)top_toggled
{
	kRUConditionalReturn(self.top_toggled == top_toggled, NO);

	RTSMViewController_tableView_section const tableView_section = RTSMViewController_tableView_section_top_possiblyToggled;
	NSInteger indexPathSection_old = (self.top_toggled ?
									  [self.tableSectionManager indexPathSectionForSection:tableView_section] :
									  NSNotFound);
	
	_top_toggled = top_toggled;
	
	if (self.top_toggled)
	{
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:[self.tableSectionManager indexPathSectionForSection:tableView_section]]
					  withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else
	{
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPathSection_old]
					  withRowAnimation:UITableViewRowAnimationAutomatic];
	}

	[self tableSectionManager_validate];
}

#pragma mark - toggled
-(void)setToggled:(BOOL)toggled
{
	kRUConditionalReturn(self.toggled == toggled, NO);

	RTSMViewController_tableView_section const tableView_section = RTSMViewController_tableView_section_possiblyToggled;
	NSInteger indexPathSection_old = (self.toggled ?
									  [self.tableSectionManager indexPathSectionForSection:tableView_section] :
									  NSNotFound);

	_toggled = toggled;

	if (self.toggled)
	{
		[self.tableView insertSections:[NSIndexSet indexSetWithIndex:[self.tableSectionManager indexPathSectionForSection:tableView_section]]
					  withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	else
	{
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPathSection_old]
					  withRowAnimation:UITableViewRowAnimationAutomatic];
	}
}

#pragma mark - tableSectionManager
-(void)tableSectionManager_validate
{
	NSAssert(self.tableSectionManager.firstAvailableSection ==
			 (self.top_toggled ?
			  RTSMViewController_tableView_section_top_possiblyToggled :
			  RTSMViewController_tableView_section_top_toggle), @"unhandled");

	RTSMViewController_tableView_section firstAvailableSection = self.tableSectionManager.firstAvailableSection;
	RTSMViewController_tableView_section lastAvailableSection = self.tableSectionManager.lastAvailableSection;

	NSInteger indexPathSection = 0;
	for (RTSMViewController_tableView_section section = firstAvailableSection;
		 section <= lastAvailableSection;
		 section++)
	{
		if ([self.tableSectionManager sectionDelegate_sectionIsAvailable:section])
		{
			NSAssert([self.tableSectionManager indexPathSectionForSection:section] == indexPathSection, @"section %li should match indexPathSection %li",section,indexPathSection);
			indexPathSection++;
		}
	}
}

@end
